import 'package:app_push_notifications/Helpers/importFiles.dart';
import 'package:flutter/cupertino.dart';
import 'package:dio/dio.dart';


enum AppState {
  free,
  picked,
  cropped,
}

class ProfileItem {
  final String title;
  final IconData prefixIcon;
  final IconData suffixIcon;
  final String routeName;
  ProfileItem({this.title, this.prefixIcon, this.routeName, this.suffixIcon});
}

class ProfileViewModel with ChangeNotifier implements LoaderState {
  //Setter
  NavigationService _navigationService = NavigationService();
  SessionManager _session = SessionManager();
  SocketService _socketService = SocketService();
  PushNotificationService _pushNotificationService = PushNotificationService();
  UserDetail _userDetail;
  AppState state;
  File _imageFile;
  bool _isUploading = false;
  String _uplodingProgress = '';
  List<ProfileItem> _profileItems = [
    ProfileItem(
        title: 'Basic',
        prefixIcon: Icons.info_outline,
        suffixIcon: Icons.arrow_forward_ios,
        routeName: BasicInfoRoute),
    // ProfileItem(
    //     title: 'Preferences',
    //     prefixIcon: Icons.filter_list,
    //     suffixIcon: Icons.arrow_forward_ios,
    //     routeName: UserPreferencesViewRoute),
    ProfileItem(
        title: 'Account Setting',
        prefixIcon: Icons.settings,
        suffixIcon: Icons.arrow_forward_ios,
        routeName: AccountSettingsRoute),
    ProfileItem(
        title: 'Verify your email',
        prefixIcon: Icons.email,
        suffixIcon: Icons.arrow_forward_ios),
    ProfileItem(
        title: 'Delete Account',
        prefixIcon: Icons.do_disturb_alt_outlined),
    ProfileItem(
        title: 'Log Out',
        prefixIcon: Icons.power_settings_new,
        routeName: BasicInfoRoute),
  ];

  set setImageFile(File imageFile) {
    _imageFile = imageFile;
    updateProfileImage();
  }

  //Getter
  List<ProfileItem> get profileItems => _profileItems;
  UserDetail get userDetail => _userDetail;
  File get imageFile => _imageFile;
  bool get isUploading => _isUploading;
  String get uploadingProgress => _uplodingProgress;

  //=======================================================================
  //================= LoaderState Abstract Implement ======================
  //=======================================================================

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

  ProfileViewModel() {
    setSate(ViewState.Idle);
    state = AppState.free;
    getUserDetailsFromSession();
  }
  
  getUserDetailsFromSession()async{
    _userDetail = await _session.getUserDetails();

    //If Email is not verified
    if(_userDetail.emailVerifiedAt != null){
      var profileItem = ProfileItem(
          title: 'Verify your email',
          prefixIcon: Icons.email,
          suffixIcon: Icons.verified);
      _profileItems.removeAt(2);
      _profileItems.insert(2, profileItem);
    }
    notifyListeners();
  }

  goTo(ProfileItem item) {
    var selectedIndex = _profileItems.indexOf(item);
    if(item.title == 'Verify your email'){
      _sendEmail();
    }else if(item.title == 'Delete Account'){
      if(Platform.isIOS){
        showDialog(
            context: _navigationService.navigationKey.currentState.context,
            builder: (BuildContext context) => CustomAlertDialogBox(
              title: 'Error',
              message: 'Test Error Alert',
              yesButtonText: 'Yes',
              yesButtonTap: (){},
              noButtonText: 'No',
              noButtonTap: (){},
            )
        );
        // showDialog(
        //     context: _navigationService.navigationKey.currentState.context,
        //     builder: (BuildContext context) => CupertinoAlertDialog(
        //       title: new Text("Confirmation"),
        //       content: new Text("Are you sure you want to delete your account?"),
        //       actions: <Widget>[
        //         CupertinoDialogAction(
        //           child: Text("No", style: TextStyle(color: Colors.red, fontWeight: FontWeight.w400)),
        //           onPressed: () => _navigationService.pop(),
        //         ),
        //         CupertinoDialogAction(
        //           child: Text("Yes", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),),
        //           onPressed: () => _deleteAccount(),
        //         ),
        //       ],
        //     )
        // );
      }else{
        showDialog(
            context: _navigationService.navigationKey.currentState.context,
            builder: (BuildContext context) => AlertDialog(
              title: new Text("Confirmation"),
              content: new Text("Are you sure you want to delete your account?"),
              actions: <Widget>[
                FlatButton(
                  child: Text("No", style: TextStyle(color: Colors.red, fontWeight: FontWeight.w400),),
                  onPressed: () => _navigationService.pop(),
                ),
                FlatButton(
                  child: Text("Yes", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),),
                  onPressed: () => _deleteAccount(),
                ),
              ],
            )
        );
      }
    }
    else if (item.title == 'Log Out') {
      _logoutAPI();
    } else {
      _navigationService.navigateWithPush(item.routeName);
    }
  }

  //send Email Code
  _sendEmail() {
    Map<String, dynamic> body = {};
    setSate(ViewState.Busy);
    ApiBaseHelper().post(authorization: true, url: WebService.sendVerificationCode,body: body,isFormData: true).then(
            (response) async {
              setSate(ViewState.Idle);
          Map<String, dynamic> decodedJSON = jsonDecode(response);
          if(decodedJSON.containsKey('success')){
            print(decodedJSON['success']['code'].toString());
            NavigationService _navigationService = NavigationService();
            _navigationService.navigateWithPush(EmailVerificationRoute, arguments: {'email':"null", 'code' : decodedJSON['success']['code'].toString()}).then((value) async {
                if(value != null){
                  _userDetail.emailVerifiedAt = '';
                  //If Email is not verified
                  if(_userDetail.emailVerifiedAt == ''){
                    _profileItems.removeAt(3);
                  }
                  await _session.saveUsersDetails(userDetail: _userDetail);
                  notifyListeners();
                }
              }
            );
          }else {
            showToast(decodedJSON['error'].toString());
          }
        }, onError: (error){
      showToast('Something went wrong');
    });
  }

  _logoutAPI() {
    Map<String, dynamic> body = {};
    setSate(ViewState.Busy);
    ApiBaseHelper().get(authorization: true, url: WebService.logout, body: body, isFormData: true).then((response) async {
      setSate(ViewState.Idle);
      Map<String, dynamic> decodedJSON = jsonDecode(response);
      if (decodedJSON.containsKey('success')) {
        clearAllSessionsAndLogout();
      } else {
        showToast(decodedJSON['error'].toString());
      }
    }, onError: (error) {
      showToast('Something went wrong');
    });
  }

  _deleteAccount() {
    _navigationService.pop();
    Map<String, dynamic> body = {};
    setSate(ViewState.Busy);
    ApiBaseHelper().post(authorization: true, url: WebService.deleteUser,body: body,isFormData: true).then(
            (response) async {
              setSate(ViewState.Idle);
          Map<String, dynamic> decodedJSON = jsonDecode(response);
          if(decodedJSON.containsKey('success')){
            clearAllSessionsAndLogout();
          }else {
            showToast(decodedJSON['error'].toString());
          }
        }, onError: (error){
      showToast('Something went wrong');
    });
  }

  clearAllSessionsAndLogout(){
    _session.clear();
    _socketService.socketDisconnect();
    _pushNotificationService.refreshToken();


    DartNotificationCenter.unregisterChannel(
        channel: ObserverChannelsKeys.isUserOnlineChat);
    DartNotificationCenter.unregisterChannel(
        channel: ObserverChannelsKeys.receivedChatMessage);
    DartNotificationCenter.unregisterChannel(
        channel: ObserverChannelsKeys.isUserOnlineRounds);
    DartNotificationCenter.unregisterChannel(
        channel: ObserverChannelsKeys.receivedRoundsMessage);

    _navigationService.navigateWithOutBack(SignInRoute);
  }

  updateProfileImage() async {
    _isUploading = true;
    Response response;
    FormData formData = new FormData.fromMap({
      "type": "profile",
      "image": await MultipartFile.fromFile(_imageFile.path,
          filename:
              "${DateTime.now().toString()}-${_imageFile.path.split('/').last}"),
    });

    Dio dio = new Dio();
    dio.options.headers["Authorization"] =
        'Bearer ' + await _session.authToken;
    response = await dio.post(
      WebService.baseURL + WebService.uploadProfileImage,
      data: formData,
      onSendProgress: (int send, int total) {
        print("${((send / total) * 100).toStringAsFixed(0)} %");
        _uplodingProgress = ((send / total) * 100).toStringAsFixed(0) + "%";
        if (send == total) {
          _isUploading = false;
        }
        notifyListeners();
      },
    );
    if (response.statusCode == 200) {
      _userDetail.profilePic = response.data['success'];
      await _session.saveUsersDetails(userDetail: _userDetail);
      notifyListeners();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}

class CustomAlertDialogBox extends StatefulWidget {
  final String title, message, yesButtonText, noButtonText;
  final VoidCallback yesButtonTap, noButtonTap;
  CustomAlertDialogBox({this.title, this.message, this.yesButtonText, this.noButtonText, this.yesButtonTap, this.noButtonTap});
  @override
  _CustomAlertDialogBoxState createState() => _CustomAlertDialogBoxState();
}

class _CustomAlertDialogBoxState extends State<CustomAlertDialogBox> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0))
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(widget.title,style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600),),
                SizedBox(height: 12),
                Text(widget.message,style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),textAlign: TextAlign.center,maxLines: null),
                SizedBox(height: 16,)
              ],
            ),
            bottomButtons()
          ],
        ),
      ),
    );
  }

  Widget bottomButtons() {
    return Column(
      children: [
        Divider(),
        Row(
          children: [
            widget.yesButtonText != null ? Expanded(
              child: SizedBox(
                height: 45,
                child: CustomRaisedButton(
                  buttonText: widget.yesButtonText,
                  // cornerRadius: 22.5,
                  textColor: Colors.white,
                  backgroundColor: Colors.grey,
                  action: widget.yesButtonTap,
                ),
              ),
            ) : Container(),
            widget.noButtonText != null ? SizedBox(width: 8) : Container(),
            widget.noButtonText != null ? Expanded(
              child: SizedBox(
                height: 45,
                child: CustomRaisedButton(
                  buttonText: widget.noButtonText,
                  // cornerRadius: 22.5,
                  textColor: Colors.white,
                  backgroundColor: Colors.transparent,
                  action: widget.noButtonTap,
                ),
              ),
            ) : Container()
          ],
        ),
      ],
    );
  }
}

