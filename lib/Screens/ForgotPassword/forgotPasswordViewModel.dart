import 'package:app_push_notifications/Helpers/importFiles.dart';

class ForgotPasswordViewModel with ChangeNotifier implements LoaderState{

  NavigationService _navigationService = NavigationService();

  ValidationModel _email = ValidationModel(value: '', error: null);

  bool _isValidate = false;

  ValidationModel get email => _email;

  bool get isValidate => _isValidate;

  onChangedEmail(String value){
    if(value == ''){
      _email = ValidationModel(value: '', error: null);
    }else if(!ValidatorType.email.hasMatch(value)){
      _email = ValidationModel(value: '', error: 'Invalid email');
    }else{
      _email = ValidationModel(value: value, error: null);
      _isValidate = true;
    }
    notifyListeners();
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

  ForgotPasswordViewModel(){
    setSate(ViewState.Idle);
  }

  sendVerificationCode(){
    Map<String, dynamic> body = {
      'email': _email.value,
    };

    setSate(ViewState.Busy);
    ApiBaseHelper().post(authorization: false, url: WebService.forgotPassword, body: body,isFormData: false).then(
            (response) async {
              setSate(ViewState.Idle);
              Map<String, dynamic> decodedJSON = jsonDecode(response);
              if(decodedJSON.containsKey('success')){
                print(decodedJSON['success']['code']);
                _navigationService.navigateWithPush(EmailVerificationRoute, arguments: {'email' : _email.value, 'code' : decodedJSON['success']['code'].toString()});
              }else{
                showToast(decodedJSON['error'].toString());
              }
        }, onError: (error){
              showToast(error.toString());
    });
  }
}