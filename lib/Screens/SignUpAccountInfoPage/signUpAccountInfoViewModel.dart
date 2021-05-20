import 'package:app_push_notifications/Helpers/importFiles.dart';

class SignUpAccountInfoViewModel with ChangeNotifier implements LoaderState{

  Map<String, dynamic> _parameters;

  SessionManager _sessionManager = SessionManager();

  NavigationService _navigationService = NavigationService();

  var _context;
  bool _isAccepted = false;
  ValidationModel _email = ValidationModel(value: '', error: null);
  ValidationModel _password = ValidationModel(value: '', error: null);
  ValidationModel _confirmedPassword = ValidationModel(value: '', error: null);

  bool get isAccepted => _isAccepted;
  ValidationModel get email => _email;
  ValidationModel get password => _password;
  ValidationModel get confirmedPassword => _confirmedPassword;

  SignUpAccountInfoViewModel({Map<String, dynamic> parameters}){
    _context = _navigationService.navigationKey.currentState.overlay.context;
    _parameters = parameters;
    setSate(ViewState.Idle);
  }

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


  onChangedEmail(String value){
    if(value == ''){
      _email = ValidationModel(value: '', error: null);
    }else if(!ValidatorType.email.hasMatch(value)){
      _email = ValidationModel(value: '', error: 'Invalid Email');
    }else{
      _email = ValidationModel(value: value, error: null);
    }
    notifyListeners();
  }

  onChangedPassword(String value){
    if(value == ''){
      _password = ValidationModel(value: '', error: null);
    }else{
      _password = ValidationModel(value: value, error: null);
    }
    notifyListeners();
  }

  onChangedConfirmedPassword(String value){
    if(value == ''){
      _confirmedPassword = ValidationModel(value: '', error: null);
    }else if(value != _password.value){
      _confirmedPassword = ValidationModel(value: '', error: 'Passwords do not match');
    }else{
      _confirmedPassword = ValidationModel(value: value, error: null);
    }
    notifyListeners();
  }

  onChangeAccepted(bool accepted){
    _isAccepted = accepted;
    notifyListeners();
  }

  bool get isValidate{
    if(_email.value == '' || _password.value == '' || _confirmedPassword.value == '' || _isAccepted == false){
      return false;
    }else{
      return true;
    }
  }


  saveAccountInfo(){

    setSate(ViewState.Busy);
    _parameters['email'] = _email.value;
    _parameters['password'] = _password.value;
    _parameters['c_password'] = _password.value;

  ApiBaseHelper().post(url: WebService.registerUser,body: _parameters,isFormData: false).then(
          (response) async{
            setSate(ViewState.Idle);
            Map<String, dynamic> decodedJOSN = jsonDecode(response);
            if(decodedJOSN.containsKey('success')){
              var object = SignInModel.fromJson(decodedJOSN['success']);
              await _sessionManager.saveAuthenticationToken(authToken: object.token);
              await _sessionManager.saveUserInfo(user: object.user);

              // //TODO: Get and Save UserDetails
              // Provider.of<SplashViewModel>(_context, listen: false).getUserDetails();
              //
              getUserDetails(object);

            }else{
              showToast(decodedJOSN['error']['email'][0]);
            }
      }, onError: (error){showToast(error.toString());
    });
  }

  getUserDetails(var object){
    Map<String, dynamic> body = {};
    ApiBaseHelper().get(authorization: true, url: WebService.userDetails,body: body,isFormData: true).then(
            (response) async {
          Map<String, dynamic> decodedJSON = jsonDecode(response);
          if(decodedJSON.containsKey('success')){
            //Save UserDetails and Preferences to SharedPreferences
            var _userDetail = UserDetail.fromJson(decodedJSON['success']);
            await _sessionManager.saveUsersDetails(userDetail: _userDetail);
            if(object.user.onboadingStatus == null || object.user.onboadingStatus == 0){
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

  goToVerificationEmailVerification(){

  }

  goToTabBarController(){
    _navigationService.navigateWithOutBack(TabBarControllerRoute, arguments: {'tabIndex' : '2'});
  }

  goToOnBoarding(){
    _navigationService.navigateWithOutBack(UserPreferencesViewRoute);
  }

  onTapTermsAndConditions()async{
    var url = 'https://app.termly.io/document/terms-of-use-for-website/a9091d1e-5781-4eed-91e8-a74c500fb418';
    if (await canLaunch(url))
      await launch(url);
    else
      throw "Could not launch $url";
  }

  onTapPrivacy()async{
    var url = 'https://app.termly.io/document/privacy-policy/f014e3ec-7b6b-44a9-abed-ce53330e92fd';
    if (await canLaunch(url))
      await launch(url);
    else
      throw "Could not launch $url";
  }
}