import 'package:app_push_notifications/Helpers/importFiles.dart';
import 'package:flutter/cupertino.dart';


class SignInViewModel with ChangeNotifier implements LoaderState{

  SessionManager _sessionManager = SessionManager();
  var _context;
  NavigationService _navigationService = NavigationService();
  PushNotificationService _pushNotificationService = PushNotificationService();

  ValidationModel _email = ValidationModel(value: '', error: null);
  ValidationModel _password = ValidationModel(value: '', error: null);

  ValidationModel get email => _email;
  ValidationModel get password => _password;

  //=======================================================================
  //================= LoaderState Abstract Implement ======================
  //=======================================================================

  @override
  ViewState _state;

  @override
  // TODO: implement viewState
  ViewState get viewState => _state;

  @override
  void setSate(ViewState state) {
    // TODO: implement setSate
    _state = state;
    notifyListeners();
  }

  SignInViewModel(){
    _context = _navigationService.navigationKey.currentState.context;
    _pushNotificationService.initPushNotification();
    DartNotificationCenter.registerChannel(channel: ObserverChannelsKeys.isUserOnlineChat);
    DartNotificationCenter.registerChannel(channel: ObserverChannelsKeys.receivedChatMessage);
    DartNotificationCenter.registerChannel(channel: ObserverChannelsKeys.isUserOnlineRounds);
    DartNotificationCenter.registerChannel(channel: ObserverChannelsKeys.receivedRoundsMessage);
  }

  onEmailChanged(String value){
    if(value.isEmpty){
      _email = ValidationModel(value: '', error: null);
    }else if(ValidatorType.email.hasMatch(value)){
      _email = ValidationModel(value: value, error: null);
    }else{
      _email = ValidationModel(value: '', error: 'Invalid Email');
    }
    notifyListeners();
  }

  onPasswordChange(String value){
    if(value.isEmpty){
      _password = ValidationModel(value: '', error: null);
    }else{
      _password = ValidationModel(value: value, error: null);
    }
    notifyListeners();
  }

  bool get isValidated{
    if(_email.value == '' || _password.value == ''){
      return false;
    }else{
      return true;
    }
  }


  loginUser()async{

    Map<String, dynamic> body = {
      'email': _email.value,
      'password' : _password.value,
      "device_token": await _sessionManager.fcmToken,
    };
    setSate(ViewState.Busy);
    ApiBaseHelper().post(url: WebService.login, authorization: false, body: body,isFormData: false).then((responseJson) async {
      Map<String, dynamic> parsedJSON = jsonDecode(responseJson);
      if(parsedJSON.containsKey('success')){
        var loginUser = SignInModel.fromJson(parsedJSON['success']);
        if(loginUser.user.status == 1){
          //TODO: Save UserInfo and Auth Token
          await _sessionManager.saveUserInfo(user: loginUser.user);
          await _sessionManager.saveAuthenticationToken(authToken: loginUser.token);

          //TODO: Get and Save UserDetails
          // Provider.of<SplashViewModel>(_context, listen: false).getUserDetails();
          getUserDetails(loginUser);

        }else{
          if(loginUser.user.status == 2){
            if(Platform.isIOS){
              showDialog(
                  context: _context,
                  builder: (BuildContext context) => CupertinoAlertDialog(
                    title: new Text("Alert"),
                    content: new Text("Account is blocked. Please Contact Lovedebate.co for further details."),
                    actions: <Widget>[
                      CupertinoDialogAction(
                        child: Text("Ok", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),),
                        onPressed: () => goToContact(),
                      ),
                    ],
                  )
              );
            }else{
              showDialog(
                  context: _navigationService.navigationKey.currentState.context,
                  builder: (BuildContext context) => AlertDialog(
                    title: new Text("Alert"),
                    content: new Text("Account is blocked. Please Contact Lovedebate.co for further details."),
                    actions: <Widget>[
                      FlatButton(
                        child: Text("Ok", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),),
                        onPressed: () => goToContact(),
                      ),
                    ],
                  )
              );
            }
          }else if(loginUser.user.status == 3){
            if(Platform.isIOS){
              showDialog(
                  context: _navigationService.navigationKey.currentState.context,
                  builder: (BuildContext context) => CupertinoAlertDialog(
                    title: new Text("Alert"),
                    content: new Text("Account has been deleted by user. Tap to recover your account."),
                    actions: <Widget>[
                      CupertinoDialogAction(
                        child: Text("Cancel", style: TextStyle(color: Colors.red, fontWeight: FontWeight.w400)),
                        onPressed: () => _navigationService.pop(),
                      ),
                      CupertinoDialogAction(
                        child: Text("Recover", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),),
                        onPressed: () => onRecoverButton(loginUser),
                      ),
                    ],
                  )
              );
            }else{
              showDialog(
                  context: _navigationService.navigationKey.currentState.context,
                  builder: (BuildContext context) => AlertDialog(
                    title: new Text("Alert"),
                    content: new Text("Account has been deleted by user. Tap to recover your account."),
                    actions: <Widget>[
                      FlatButton(
                        child: Text("Cancel", style: TextStyle(color: Colors.red, fontWeight: FontWeight.w400),),
                        onPressed: () => _navigationService.pop(),
                      ),
                      FlatButton(
                        child: Text("Recover", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),),
                        onPressed: () => onRecoverButton(loginUser),
                      ),
                    ],
                  )
              );
            }
          }
        }
      }else{
        setSate(ViewState.Idle);
        showToast(parsedJSON['error']);
      }
    }, onError: (error){
      setSate(ViewState.Idle);
      showToast(error.toString());
    });
  }

  onRecoverButton(SignInModel loginUser)async{
    await _sessionManager.saveUserInfo(user: loginUser.user);
    await _sessionManager.saveAuthenticationToken(authToken: loginUser.token);
    Map<String, dynamic> body = {};
    setSate(ViewState.Busy);
    ApiBaseHelper().post(authorization: true, url: WebService.sendVerificationCode,body: body,isFormData: true).then(
            (response) async {
          setSate(ViewState.Idle);
          Map<String, dynamic> decodedJSON = jsonDecode(response);
          if(decodedJSON.containsKey('success')){
            print(decodedJSON['success']['code']);
            NavigationService _navigationService = NavigationService();
            _navigationService.navigateWithPush(EmailVerificationRoute, arguments: {'email':"recoverEmail", 'code' : decodedJSON['success']['code'].toString()});
          }else {
            showToast(decodedJSON['error'].toString());
          }
        }, onError: (error){
      showToast('Something went wrong');
    });
  }

  getUserDetails(SignInModel loginUser){
    Map<String, dynamic> body = {};
    ApiBaseHelper().get(authorization: true, url: WebService.userDetails,body: body,isFormData: true).then(
            (response) async {
          Map<String, dynamic> decodedJSON = jsonDecode(response);
          if(decodedJSON.containsKey('success')){
            //Save UserDetails and Preferences to SharedPreferences
            var _userDetail = UserDetail.fromJson(decodedJSON['success']);
            await _sessionManager.saveUsersDetails(userDetail: _userDetail);
            if(loginUser.user.onboadingStatus == 0){
              goToOnBoarding();
            }else{
              goToTabBarController();
            }
          }else{
            showToast(decodedJSON['error'].toString());
          }
        }, onError: (error){
      showToast('Something went wrong');
    });
  }

  goToTabBarController(){
    _navigationService.navigateWithOutBack(TabBarControllerRoute, arguments: {'tabIndex' : '2'});
  }

  goToOnBoarding(){
    _navigationService.navigateWithOutBack(UserPreferencesViewRoute);
  }

  goToSignUp(){
    _navigationService.navigateWithPush(SignUpRoute);
  }

  goToForgotPassword(){
    _navigationService.navigateWithPush(ForgotPasswordRoute);
  }


  goToContact(){
    //Go To Contact WebView

  }
}