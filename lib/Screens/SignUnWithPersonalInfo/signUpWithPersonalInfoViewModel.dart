import 'package:app_push_notifications/Helpers/importFiles.dart';

class SignUpWithPersonalInfoViewModel with ChangeNotifier implements LoaderState{

  SessionManager session = SessionManager();
  NavigationService _navigationService = NavigationService();
  bool _isSocialLogin = false;
  User _user;
  ValidationModel _firstName = ValidationModel(value: '', error: null);
  ValidationModel _lastName = ValidationModel(value: '', error: null);
  ValidationModel _dateOfBirth = ValidationModel(value: '', error: null);
  ValidationModel _height = ValidationModel(value: '', error: null);
  ValidationModel _gender = ValidationModel(value: '', error: null);

  bool get isSocialLogin => _isSocialLogin;
  ValidationModel get firstName => _firstName;
  ValidationModel get lastName => _lastName;
  ValidationModel get dateOfBirth => _dateOfBirth;
  ValidationModel get height => _height;
  ValidationModel get gender => _gender;

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

  SignUpWithPersonalInfoViewModel({User user, bool isSocialLogin}){
    _user = user;
    _isSocialLogin = isSocialLogin;
    setSate(ViewState.Idle);
    onGenderChange('1');
  }

  onChangedFirstName(String value){
    if(value == ''){
      _firstName = ValidationModel(value: '', error: null);
    }else{
      _firstName = ValidationModel(value: value, error: null);
    }
    notifyListeners();
  }

  onChangedLastName(String value){
    if(value == ''){
      _lastName = ValidationModel(value: '', error: null);
    }else{
      _lastName = ValidationModel(value: value, error: null);
    }
    notifyListeners();
  }

  setDateOfBirth(String value){
    String dateFormat =  value.toDateTime(dateFormat: 'MMM dd, yyyy').toDateString(dateFormat: 'yyyy-MM-dd');
    _dateOfBirth = ValidationModel(value: dateFormat, error: null);
    notifyListeners();
  }

  setHeight(String value) {
    _height = ValidationModel(value: value, error: null);;
    notifyListeners();
  }

  // onSelectedDateOfBirth(String value){
  //   if(value == ''){
  //     _dateOfBirth = ValidationModel(value: '', error: null);
  //   }else{
  //     _dateOfBirth = ValidationModel(value: value, error: null);
  //   }
  //   notifyListeners();
  // }
  //
  // onSelectedHeight(String value){
  //   if(value == ''){
  //     _height = ValidationModel(value: '', error: null);
  //   }else{
  //     _height = ValidationModel(value: value, error: null);
  //   }
  //   notifyListeners();
  // }

  onGenderChange(String value){
    if(value == ''){
      _gender = ValidationModel(value: '', error: null);
    }else{
      _gender = ValidationModel(value: value, error: null);
    }
    notifyListeners();
  }


  bool get isValidate{
    if(!_isSocialLogin){
      if(_firstName.value == '' || _lastName.value == '' || _dateOfBirth.value == '' || _height.value == ''){
        return false;
      }else{
        return true;
      }
    }else{
      if(_dateOfBirth.value == '' || _height.value == ''){
        return false;
      }else{
        return true;
      }
    }
  }



  updateProfile(){
    Map<String, dynamic> parameter = {
      'dob' : _dateOfBirth.value,
      'height' : _height.value.replaceAll("\'", ".").replaceAll('\"', ""),
      'gender' : _gender.value
    };
    setSate(ViewState.Busy);
    ApiBaseHelper().post(authorization: true, url: WebService.updateProfile,body: parameter,isFormData: false).then(
            (response) async{
              setSate(ViewState.Idle);
            Map<String, dynamic> parseJSON = jsonDecode(response);
            if(parseJSON.containsKey('success')){
              _user.dob = parameter['dob'];
              _user.height = parameter['height'].toString().toDouble();
              _user.gender = parameter['gender'].toString().toInt();
              await session.saveUserInfo(user: _user);
              goToOnBoarding();
            }else{
              showToast('Something went wrong');
            }
        }, onError: (error){
      showToast('Something went wrong');
    });
  }

  goToAccountInfo(){
    if(_isSocialLogin){
      updateProfile();
      return;
    }
    Map<String, dynamic> personalInfo = {
      'first_name' : _firstName.value,
      'last_name' : _lastName.value,
      'dob' : _dateOfBirth.value,
      'height' : _height.value.replaceAll('\"', "").replaceAll("\'","."),
      'gender' : _gender.value
    };
    _navigationService.navigateWithPush(SignUpAccountInfoRoute, arguments: personalInfo);
  }

  goToOnBoarding(){
    _navigationService.navigateWithOutBack(UserPreferencesViewRoute);
  }

  showAlert(){
    showDialog(
        context: _navigationService.navigationKey.currentState.context,
        builder: (BuildContext context) => AlertDialog(
          title: new Text("Alert"),
          content: new Text("Must be 18 years or older"),
          actions: <Widget>[
            FlatButton(
              child: Text("Ok", style: TextStyle(color: Colors.red, fontWeight: FontWeight.w400),),
              onPressed: () => _navigationService.pop(),
            ),
            // FlatButton(
            //   child: Text("Recover", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),),
            //   onPressed: () => onRecoverButton(loginUser),
            // ),
          ],
        )
    );
  }
}