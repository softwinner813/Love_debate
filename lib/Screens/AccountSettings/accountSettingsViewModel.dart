import 'package:app_push_notifications/Helpers/importFiles.dart';
import 'package:app_push_notifications/Utils/MyExtensions.dart';


class AccountSettingsViewModel with ChangeNotifier implements LoaderState{
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

  SessionManager _sessionManager = SessionManager();
  NavigationService _navigationService = NavigationService();
  bool _isResetPassword = false;
  
  ValidationModel _email = ValidationModel(value: "", error: null);
  ValidationModel _oldPassword = ValidationModel(value: "", error: null);
  ValidationModel _newPassword = ValidationModel(value: "", error: null);
  ValidationModel _confirmedPassword = ValidationModel(value: "", error: null);

  bool get isResetPassword => _isResetPassword;
  ValidationModel get email => _email;
  ValidationModel get oldPassword => _oldPassword;
  ValidationModel get newPassword => _newPassword;
  ValidationModel get confirmedPassword => _confirmedPassword;

  AccountSettingsViewModel({String forgotPassword}){
    if(forgotPassword != ''){
      _email  = ValidationModel(value: forgotPassword, error: null);
      _isResetPassword = true;
      notifyListeners();
    }else{
      _isResetPassword = false;
      getUserEmailFromSession();
    }
  }

  getUserEmailFromSession()async{
    var user = await _sessionManager.getUserInfo();
    _email = ValidationModel(value: user.email, error: null);
    notifyListeners();
  }

  onChangedOldPassword(String value){
    if(value == ''){
      _oldPassword = ValidationModel(value: "", error: null);
    }else{
      _oldPassword = ValidationModel(value: value, error: null);
    }
    notifyListeners();
  }

  onChangedNewPassword(String value){
    if(value == ''){
      _newPassword = ValidationModel(value: "", error: null);
    }else{
      _newPassword = ValidationModel(value: value, error: null);
    }
    notifyListeners();
  }

  onChangedConfirmPassword(String value){
    if(value == ''){
      _confirmedPassword = ValidationModel(value: "", error: null);
    }else if(value != _newPassword.value){
      _confirmedPassword = ValidationModel(value: "", error: "Passwords do not match");
    }else{
      _confirmedPassword = ValidationModel(value: value, error: null);
    }
    notifyListeners();
  }

  bool get isValidate{
    if(_isResetPassword){
      if(_newPassword.value == '' || _confirmedPassword.value == ''){
        return false;
      }else{
        return true;
      }
    }else{
      if(_oldPassword.value == '' || _newPassword.value == '' || _confirmedPassword.value == ''){
        return false;
      }else{
        return true;
      }
    }
  }

  updateResetPassword(){

    if(_newPassword.value.length < 8){
      showToast('The password must be at least 8 characters');
      return;
    }

    Map<String, dynamic> body = {
      "from" : _isResetPassword ? "reset_pass" : "update_pass",
      "current_password": _isResetPassword ? '' : _oldPassword.value,
      "password" : _newPassword.value,
      "c_password" : _confirmedPassword.value,
      "email" : _email.value,
    };

      setSate(ViewState.Busy);
      ApiBaseHelper().post(authorization: !_isResetPassword, url: WebService.updatePassword,body: body,isFormData: true).then(
              (response) async {
            setSate(ViewState.Idle);
            Map<String, dynamic> decodedJSON = jsonDecode(response);
            if(decodedJSON.containsKey('success')){
              if(isResetPassword){
                Future.delayed(Duration(seconds: 3), () {
                  _navigationService.popUntil(SignInRoute);
                });
              }
              showToast("Password successfully updated");
            }else{
              showToast(decodedJSON['error']);
            }
      });
  }
}