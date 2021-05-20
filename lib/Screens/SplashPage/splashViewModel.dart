import 'package:app_push_notifications/Helpers/importFiles.dart';



PushNotificationService pushNotificationService = PushNotificationService();

class SplashViewModel with ChangeNotifier{

  SessionManager _sessionManager = SessionManager();
  var duration;

  // PushNotificationService _pushNotificationService = PushNotificationService();
  LocalNotificationService _localNotificationService = LocalNotificationService();
  NavigationService _navigationService = NavigationService();

  SplashViewModel(){
    pushNotificationService.initPushNotification();
    _localNotificationService.initLocalNotification();
    loadHeightsFromJSON();

  }

  startTime() async {
    var _duration = new Duration(seconds: 3);
    return new Timer(_duration, navigationPage);
  }


  navigationPage() async{
    if(isNotification == false){
      if (!await _sessionManager.isLogin){
        getQuestions();
        _navigationService.navigateWithOutBack(SignInRoute);
      }else{
        getQuestions();
        getUserDetails();
        var user = await _sessionManager.getUserInfo();
        if(user.onboadingStatus == 0){
          _navigationService.navigateWithOutBack(UserPreferencesViewRoute);
        }else{
          _navigationService.navigateWithOutBack(TabBarControllerRoute, arguments: {'tabIndex' : '2'});
        }
      }
    }
  }

  getQuestions(){
    Map<String, dynamic> body = {};
    ApiBaseHelper().get(authorization: false, url: WebService.listOfQuestions,body: body,isFormData: true).then(
            (response) async {
          Map<String, dynamic> decodedJSON = jsonDecode(response);
          if(decodedJSON.containsKey('success')){
            //Save Questions Model to SharedPreferences
            var questionsModel = AppData.fromJson(decodedJSON['success']);
            await _sessionManager.saveQuestionsModel(appData: questionsModel);
          }else{
            showToast(decodedJSON['error'].toString());
          }
        }, onError: (error){
      showToast('Something went wrong');
    });
  }

  getUserDetails(){
    Map<String, dynamic> body = {};
    ApiBaseHelper().get(authorization: true, url: WebService.userDetails,body: body,isFormData: true).then(
            (response) async {
          Map<String, dynamic> decodedJSON = jsonDecode(response);
          if(decodedJSON.containsKey('success')){
            //Save UserDetails and Preferences to SharedPreferences
            var _userDetail = UserDetail.fromJson(decodedJSON['success']);
            await _sessionManager.saveUsersDetails(userDetail: _userDetail);
          }else{
            showToast(decodedJSON['error'].toString());
          }
        }, onError: (error){
      showToast('Something went wrong');
    });
  }

  loadHeightsFromJSON()async{
    var context = _navigationService.navigationKey.currentState.overlay.context;
    var jsonString = await DefaultAssetBundle.of(context).loadString('files/HeightList.json');
    Map<String, dynamic> decodedJSON = jsonDecode(jsonString);
    List<String> listOfHeights = decodedJSON["heightArray"].cast<String>();
    await _sessionManager.saveHeights(listOfHeights: listOfHeights);
    startTime();
  }
}