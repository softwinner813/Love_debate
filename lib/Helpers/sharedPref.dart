import 'package:app_push_notifications/Helpers/importFiles.dart';



class SessionManager {

  getBy(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return json.decode(prefs.getString(key));
  }

  set(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, json.encode(value));
  }

  remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }

  containKey(String key) async{
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(key);
  }

  //=======================================================================
  //===================== Save Keys with values ===========================
  //=======================================================================


  saveFcmToken({String token})async => await set(SessionKeys.firebaseToken, token);

  saveAuthenticationToken({String authToken})async => await set(SessionKeys.authToken, authToken);

  saveUserInfo({User user})async => await set(SessionKeys.usersInfo, user);

  saveUsersDetails({UserDetail userDetail}) async{

    if(await containKey(SessionKeys.heights)){
      remove(SessionKeys.usersDetails);
    }
    await set(SessionKeys.usersDetails, userDetail);
  }

  saveHeights({List<String> listOfHeights})async => await set(SessionKeys.heights, listOfHeights);

  saveQuestionsModel({AppData appData}) async => await set(SessionKeys.appData, appData);

  saveAnswer({List<AnswersModel> listOfAnswers})async{
    await set(SessionKeys.listOfAnswers, listOfAnswers.map<Map<String, dynamic>>((item) => item.toJson()).toList());
  }

  // saveCategories({List<CategoryModel> listOfCategories})async{
  //   await set(SessionKeys.listOfCategorise, listOfCategories.map<Map<String, dynamic>>((item) => item.toJson()).toList());
  // }


  //=======================================================================
  //======================== Get Keys with values =========================
  //=======================================================================

  Future<bool> get isLogin async{
    return await containKey(SessionKeys.usersInfo) ? true : false;
  }

  Future<String> get fcmToken async{
    return await getBy(SessionKeys.firebaseToken);
  }

  Future<String> get authToken async{
    return await getBy(SessionKeys.authToken);
  }

  Future<String> get socketId async{
    return User.fromJson(await getBy(SessionKeys.usersInfo)).socId;
  }

  Future<User> getUserInfo() async{
    return User.fromJson(await getBy(SessionKeys.usersInfo));
  }

  Future<UserDetail> getUserDetails()async{
    return UserDetail.fromJson(await getBy(SessionKeys.usersDetails));
  }

  Future<List<String>> getListOfHeights() async{
    var isContain= await containKey(SessionKeys.heights);
    if(isContain){
      List<dynamic> heights = await getBy(SessionKeys.heights);
      return heights.cast<String>().toList();
    }
    else {
      return List<String>();
    }
  }
  
  Future<AppData> getAppData() async{
    var isContain= await containKey(SessionKeys.appData);
    if(isContain){
      return AppData.fromJson(await getBy(SessionKeys.appData));
    }
    return AppData();
  }

  Future<List<AnswersModel>> getAnswers()async{
    var isContain= await containKey(SessionKeys.listOfAnswers);
    if(isContain){
      var decodedJSON=await getBy(SessionKeys.listOfAnswers);
      return (decodedJSON as List<dynamic>).map<AnswersModel>((item) => AnswersModel.fromJson(item)).toList();
    }
    else {
      return List<AnswersModel>();
    }
  }
  //
  // Future<List<CategoryModel>> getCategories()async{
  //   var isContain= await containKey(SessionKeys.listOfCategorise);
  //   if(isContain){
  //     var decodedJSON=await getBy(SessionKeys.listOfCategorise);
  //     return (decodedJSON as List<dynamic>).map<CategoryModel>((item) => CategoryModel.fromJson(item)).toList();
  //   }
  //   else {
  //     return List<CategoryModel>();
  //   }
  // }

  clear()async{
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    // remove(SessionKeys.authToken);
    // remove(SessionKeys.usersInfo);
    // remove(SessionKeys.listOfAnswers);
    // remove(SessionKeys.usersDetails);
  }

}

