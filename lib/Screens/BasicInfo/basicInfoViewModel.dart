import 'package:app_push_notifications/Helpers/importFiles.dart';


class BasicInfoViewModel with ChangeNotifier implements LoaderState{
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

  UserDetail _userDetail;
  var _context;
  List<String> _tempHeights;
  NavigationService _navigationService = NavigationService();
  SessionManager _sessionManager = SessionManager();
  ValidationModel _firstName = ValidationModel(value: "", error: null);
  ValidationModel _lastName = ValidationModel(value: "", error: null);
  ValidationModel _dateOfBirth = ValidationModel(value: "", error: null);
  ValidationModel _gender = ValidationModel(value: "", error: null);
  ValidationModel _height = ValidationModel(value: "", error: null);
  ValidationModel _address = ValidationModel(value: "", error: null);

  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _genderController = TextEditingController();
  TextEditingController _dateOfBirthController = TextEditingController();
  TextEditingController _heightController = TextEditingController();
  TextEditingController _addressController = TextEditingController();

  TextEditingController get firstNameController => _firstNameController;
  TextEditingController get lastNameController => _lastNameController;
  TextEditingController get genderController =>_genderController;
  TextEditingController get dateOfBirthController =>_dateOfBirthController;
  TextEditingController get heightController => _heightController;
  TextEditingController get addressController => _addressController;

  bool _firstNameEditing = false;
  bool _lastNameEditing = false;

  UserDetail get userDetails =>  _userDetail;
  ValidationModel get firstName => _firstName;
  ValidationModel get lastName => _lastName;
  ValidationModel get gender => _gender;
  ValidationModel get dateOfBirth => _dateOfBirth;
  ValidationModel get height => _height;
  ValidationModel get address => _address;

  bool get firstNameEditing => _firstNameEditing;
  bool get lastNameEditing => _lastNameEditing;

  BasicInfoViewModel(){
    _context = _navigationService.navigationKey.currentState.overlay.context;
    getUserDetailsFromSession();
  }

  getUserDetailsFromSession()async{

    _userDetail = await _sessionManager.getUserDetails();

    _tempHeights = await _sessionManager.getListOfHeights();
    var heightString = _tempHeights.firstWhere((height) => height.split('/')[0] == _userDetail.height.toDouble().toStringAsFixed(2), orElse: () => null);

    _firstName = ValidationModel(value: _userDetail.firstName, error: null);
    _lastName = ValidationModel(value: _userDetail.lastName, error: null);
    _gender = ValidationModel(value: _userDetail.gender == "1" ? 'Male' : 'Female', error: null);
    _dateOfBirth = ValidationModel(value: _userDetail.dob, error: null);
    _height = ValidationModel(value: heightString.split('/')[0], error: null);
    _address = ValidationModel(value: '${_userDetail.city}, ${_userDetail.state}', error: null);

    _firstNameController.text = _firstName.value;
    _lastNameController.text = _lastName.value;
    _genderController.text = _gender.value;
    _dateOfBirthController.text = _dateOfBirth.value.toDateTime(dateFormat: 'yyyy-MM-dd').toDateString(dateFormat: 'MMM dd, yyyy');
    _heightController.text = heightString.split('/')[1];
    _addressController.text = _address.value;
    notifyListeners();
  }

  onChangedFirstName(String value){
    _firstNameEditing = true;
    if(value == ""){
      _firstName = ValidationModel(value: "", error: null);
    }else{
      _firstName = ValidationModel(value: value, error: null);
    }
    notifyListeners();
  }

  onChangedLastName(String value){
    _lastNameEditing = true;
    if(value == ""){
      _lastName = ValidationModel(value: "", error: null);
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

  set setAddress(ValidationModel value) {
    _address = value;
  }

  bool get isValidate{
    if(_firstName.value == '' || _lastName.value == '' || _dateOfBirth.value == '' || _height.value == '' || _address.value == ''){
      return false;
    }else{
      return true;
    }
  }

  void updateBasicInfo() {

    Map<String, dynamic> body = {
      'first_name': _firstName.value,
      'last_name': _lastName.value,
      'address': {
        'city' : _userDetail.city,
        'state' :_userDetail.state ,
        'formatted_address':_userDetail.address,
        'lat':_userDetail.lat,
        'lng':_userDetail.lng
      },
      'dob': _dateOfBirth.value,
      'height': _height.value,
    };

      setSate(ViewState.Busy);
      ApiBaseHelper().post(authorization: true, url: WebService.updateProfile, body: body, isFormData: false).then(
        (response) async {
          setSate(ViewState.Idle);
          Map<String, dynamic> decodeJSON = jsonDecode(response);
          if(decodeJSON.containsKey('success')){
            _userDetail.firstName = _firstName.value;
            _userDetail.lastName = _lastName.value;
            _userDetail.dob = _dateOfBirth.value;
            _userDetail.height = _height.value;
            await _sessionManager.saveUsersDetails(userDetail: _userDetail);
            showToast('Successfully updated');
          }else {
            showToast('Something went wrong');
          }
      });
  }

  onDateOfBirthTap(){
    if (Platform.isIOS){
      showDialog(
          context: _context,
          builder: (BuildContext context){
            return IOSDateTimePicker();
          }
      ).then((value){
        if(value != null){
          if(value.toString().toDateTime(dateFormat: 'MMM dd, yyyy').toDateString(dateFormat: 'yyyy-mm-dd').calculateAge.toInt() > 17){
            _dateOfBirthController.text = value;
            setDateOfBirth(value);
          }else{
            showAlert();
          }
        }
      });
    }else{
      showDatePicker(
          context:_context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime(2050)
      ).then((value){
        if(value != null){
          if(value.toDateString(dateFormat: 'yyyy-mm-dd').calculateAge.toInt() > 17){
            String dateToString = value.toDateString(dateFormat: 'MMM dd, yyyy');
            _dateOfBirthController.text = dateToString;
            setDateOfBirth(dateToString);
          }else{
            showAlert();
          }
        }
      });
    }
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

  onHeightTap(){
    showDialog(
        barrierDismissible: true,
        context: _context,
        builder: (context) {
          return HeightDialogBoxView();
        }
    ).then((value){
      _heightController.text = value.toString().split('/')[1];
      setHeight(value.toString().split('/')[0]);
    });
  }



}