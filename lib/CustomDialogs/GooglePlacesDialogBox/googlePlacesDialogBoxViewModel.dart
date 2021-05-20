import 'package:app_push_notifications/Helpers/importFiles.dart';
import 'package:http/http.dart' as http;
class GooglePlacesDialogBoxViewModel with ChangeNotifier{

  String placesAPIKey = "AIzaSyDkrmNt7yLpSO4JA9k7JdzVmX3KQrvvyzg";
  String baseURL = 'https://maps.googleapis.com/maps/api/place/autocomplete/json';

  bool _onBoardingCompleted = false;
  UserDetail _userDetail;
  Questions _question;
  NavigationService _navigationService = NavigationService();
  SessionManager _sessionManager = SessionManager();
  List<Predictions> _listOfPredictedPlaces = List<Predictions>();
  List<AnswersModel> _listOfAnswers = List<AnswersModel>();
  Map<String, dynamic> _addressJSON;
  String _formattedAddress, _latitude, _longitude, _locality, _administrativeArea = "";

  List<Predictions> get listOfPredictedPlaces => _listOfPredictedPlaces;

  GooglePlacesDialogBoxViewModel(Questions question, String address){
    _question = question;
    if(address != null){

      onChangeText(address);
    }
    checkOnBoardingCompleted();
  }

  checkOnBoardingCompleted()async{
    _userDetail = await _sessionManager.getUserDetails();
    var user = await _sessionManager.getUserInfo();
    _onBoardingCompleted = user.onboadingStatus == 1 ? true : false;
  }

  onChangeText(String input) async {
    if (input.isEmpty) {
      return;
    }

    // TODO Add session token
    String requestURL = '$baseURL?input=$input&key=$placesAPIKey';
    try {
      final response = await http.get(requestURL);
      switch (response.statusCode) {
        case 200:
          Map<String, dynamic> decodedJSON = jsonDecode(response.body.toString());
          var predictedData = GooglePlacesModel.fromJson(decodedJSON);
          _listOfPredictedPlaces = predictedData.predictions;
          notifyListeners();
          break;
        case 400:
          showToast(response.body.toString());
          break;
        case 401:
          showToast(response.reasonPhrase.toString());
          break;
        case 403:
          showToast(response.body.toString());
          break;
        case 500:
        default:
        showToast('Something went wrong');
      }
    } on SocketException {
      showToast('No Internet connection');
    }
  }

  onSelectedItem(String placeId)async{

    final geocoding = GoogleMapsGeocoding(apiKey: 'AIzaSyDVZlUzXRvgH9qkqG5RYHmf-qdZJhodohw');
    final response = await geocoding.searchByPlaceId(placeId);

    _formattedAddress = response.results[0].formattedAddress;
    _latitude = response.results[0].geometry.location.lat.toString();
    _longitude = response.results[0].geometry.location.lng.toString();
    response.results[0].addressComponents.forEach((place) {
      if(place.types[0] == 'locality'){
        _locality = place.longName;
      }
      if(place.types[0] == 'administrative_area_level_1'){
        _administrativeArea = place.longName;
      }
    });

    if(_locality == '' || _administrativeArea == '' || _locality == null || _administrativeArea == null){
      showDialog(
          barrierDismissible: false,
          context: _navigationService.navigationKey.currentState.overlay.context,
          builder: (context) {
            return PlacesDialogBoxView();
          }
      ).then((value)async{
        _addressJSON = {'city': value['city'], 'state' : value['state'], "formattedAddress": _formattedAddress,"lat": _latitude, "lng":_longitude};
        saveAddress();
      });
    }else{
      _addressJSON = {'city': _locality, 'state' : _administrativeArea, "formattedAddress": _formattedAddress,"lat": _latitude, "lng":_longitude};
      saveAddress();
    }
  }

  saveAddress()async{
    //TODO: Update address in userdetails session
    _userDetail.address = _formattedAddress;
    _userDetail.city = _addressJSON['city'];
    _userDetail.state = _addressJSON['state'];
    _userDetail.lat = _latitude;
    _userDetail.lng = _longitude;
    await _sessionManager.saveUsersDetails(userDetail: _userDetail);

    //TODO: Save address in answer session
    var listOfAnswersInSession = await _sessionManager.getAnswers();
    if(listOfAnswersInSession.length > 0){
      var isContainAnswer = listOfAnswersInSession.where((answer) => answer.qId == _question.qaId).isNotEmpty;
      if(isContainAnswer != null){
        listOfAnswersInSession.removeWhere((answer) => answer.qId == _question.qaId);
      }
    }
    listOfAnswersInSession.add(AnswersModel(qId: _question.qaId, qSlug: _question.qaSlug, answers: _addressJSON));
    await _sessionManager.saveAnswer(listOfAnswers: listOfAnswersInSession);

    _navigationService.pop();

    //TODO: Single Answer Save When Editing
    if(_onBoardingCompleted){
      _listOfAnswers.clear();
      _listOfAnswers.add(AnswersModel(qId: _question.qaId, qSlug: _question.qaSlug, answers: _addressJSON));

      Map<String, dynamic> body = {
        "answers" : _listOfAnswers,
        'profile_completion_status' : "1",
      };

      ApiBaseHelper().post(authorization: true, url: WebService.answers,body: body,isFormData: false).then(
              (response) async {
            Map<String, dynamic> decodeJSON = jsonDecode(response);
            if(decodeJSON.containsKey('success')){
              // showToast('Update Successfully');
            }else{
              showToast('Something went wrong');
            }
          }, onError: (error){
        showToast(error.toString());
      });
    }
  }
}

class PlacesDialogBoxView extends StatefulWidget {
  @override
  _PlacesDialogBoxViewState createState() => _PlacesDialogBoxViewState();
}

class _PlacesDialogBoxViewState extends State<PlacesDialogBoxView> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PlacesDialogBoxViewModel>(
      create: (_) => PlacesDialogBoxViewModel(),
      child: Consumer<PlacesDialogBoxViewModel>(
        builder: (context, viewModel, child){
          return Dialog(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text("Enter City and State",style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),
                    txtCity(viewModel),
                    SizedBox(height: 8),
                    txtState(viewModel),
                    SizedBox(height: 16),
                    SizedBox(
                      height: 45,
                      width: double.infinity,
                      child: CustomRaisedButton(
                        buttonText: 'Done',
                        cornerRadius: 22.5,
                        textColor: Colors.white,
                        backgroundColor: AppColors.firstColor,
                        action: viewModel.isValidate ? () => viewModel.onDoneButton() : null,
                      ),
                    ),
                  ],
                ),
              )
          );
        },
      ),
    );
  }

  Widget txtCity(PlacesDialogBoxViewModel viewModel) {
    return FormTextField(
      txtHint: "City",
      txtIsSecure: false,
      keyboardType: TextInputType.emailAddress,
      enableBorderColor: Colors.white,
      focusBorderColor: Colors.white,
      textColor: Colors.white,
      onChanged: (value) => viewModel.onCityChanged(value),
    );
  }

  Widget txtState(PlacesDialogBoxViewModel viewModel) {
    return FormTextField(
      txtHint: "State",
      txtIsSecure: false,
      keyboardType: TextInputType.text,
      enableBorderColor: Colors.white,
      focusBorderColor: Colors.white,
      textColor: Colors.white,
      onChanged: (value) => viewModel.onStateChanged(value),
    );
  }
}

class PlacesDialogBoxViewModel with ChangeNotifier{

  NavigationService _navigationService = NavigationService();
  ValidationModel _city = ValidationModel(value: '', error: null);
  ValidationModel _state = ValidationModel(value: '', error: null);

  ValidationModel get city => _city;
  ValidationModel get state => _state;

  onCityChanged(String value){
    if(value == ''){
      _city = ValidationModel(value: '', error: null);
    }else{
      _city = ValidationModel(value: value, error: null);
    }
    notifyListeners();
  }

  onStateChanged(String value){
    if(value == ''){
      _state = ValidationModel(value: '', error: null);
    }else{
      _state = ValidationModel(value: value, error: null);
    }
    notifyListeners();
  }

  bool get isValidate{
    if(_city.value == '' || _state.value == ''){
      return false;
    }else{
      return true;
    }
  }

  onDoneButton(){
    Navigator.pop(_navigationService.navigationKey.currentState.overlay.context, {'city' : _city.value, 'state' : _state.value});
  }
  
}
