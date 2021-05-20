import 'package:app_push_notifications/Helpers/importFiles.dart';


class UserPreferencesViewModel with ChangeNotifier implements LoaderState{
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

  AppData  _newQuestionsModel;
  String _formattedAddress;
  var _context;
  UserDetail _userDetail = UserDetail(prCompletionStatus: 0);
  NavigationService _navigationService = NavigationService();
  SessionManager _sessionManager  = SessionManager();

  List<Questions> _listOfQuestions = List<Questions>();

  String get formattedAddress => _formattedAddress;
  List<Questions> get listOfQuestions => _listOfQuestions;
  UserDetail get userDetail => _userDetail;

  UserPreferencesViewModel(){
    _context = _navigationService.navigationKey.currentState.overlay.context;
    getDataFromSession();
  }

  onTap(Questions question){
    if(question.qaFieldType == 'address'){
      showDialog(
          barrierDismissible: false,
          context: _context,
          builder: (context) {
            return GooglePlacesDialogBoxView(question: question, address: _formattedAddress,);
          }
      ).then((value) async => await questionStatus());
    }else if(question.qaFieldType == 'Slider'){
      showDialog(
          barrierDismissible: question.qaSkipable == 0 ? false : true,
          context: _context,
          builder: (context) {
            return SliderDialogBoxView(question: question);
          }
      ).then((value) async => await questionStatus());
    }else if(question.qaFieldType == 'Dropdown'){
      showDialog(
          barrierDismissible: question.qaSkipable == 0 ? false : true,
          context: _context,
          builder: (context) {
            return RadioListDialogBoxView(question: question);
          }
      ).then((value) async => await questionStatus());
    }else{
      showDialog(
          barrierDismissible: question.qaSkipable == 0 ? false : true,
          context: _context,
          builder: (context) {
            return CheckBoxListDialogBoxView(question: question);
          }
      ).then((value) async => await questionStatus());
    }
  }

  getDataFromSession()async{
    _userDetail = await _sessionManager.getUserDetails();
    _newQuestionsModel = await _sessionManager.getAppData();
    _listOfQuestions = _newQuestionsModel.listOfQuestions;
    notifyListeners();

    if(_userDetail.prCompletionStatus == 1){
      saveAnswersToLocal();
    }else{
      questionStatus();
    }
  }

  saveAnswersToLocal()async{

    List<AnswersModel> _listOfAnswers = List<AnswersModel>();

    _listOfQuestions.forEach((question) {
      var answer;
      if(question.qaSlug == "address"){
        Map<String, dynamic> address = {'city':_userDetail.city, 'state':_userDetail.state, "formattedAddress": _userDetail.address,"lat": _userDetail.lat, "lng":_userDetail.lng};
        answer = AnswersModel(qId: question.qaId, qSlug: question.qaSlug, answers: address);
      }else if (question.qaSlug == "match_area"){
        answer = AnswersModel(qId: question.qaId, qSlug: question.qaSlug, answers: _userDetail.prMatchArea);
      }else if (question.qaSlug == "height_preference"){
        answer = AnswersModel(qId: question.qaId, qSlug: question.qaSlug, answers: _userDetail.prHeight);
      }else if (question.qaSlug == "serious"){
        answer = AnswersModel(qId: question.qaId, qSlug: question.qaSlug, answers: _userDetail.prSerious);
      }else if (question.qaSlug == "profession"){
        answer = AnswersModel(qId: question.qaId, qSlug: question.qaSlug, answers: _userDetail.prProfession.split(','));
      }else if (question.qaSlug == "avg_income"){
        answer = AnswersModel(qId: question.qaId, qSlug: question.qaSlug, answers: _userDetail.prAverageIncome);
      }else if (question.qaSlug == "goal"){
        answer = AnswersModel(qId: question.qaId, qSlug: question.qaSlug, answers: _userDetail.prGoals.split(','));
      }else if (question.qaSlug == "children_preference"){
        answer = AnswersModel(qId: question.qaId, qSlug: question.qaSlug, answers: _userDetail.prKids);
      }else if (question.qaSlug == "partner_expectations"){
        answer = AnswersModel(qId: question.qaId, qSlug: question.qaSlug, answers: _userDetail.prExpectations.split(','));
      }else if (question.qaSlug == "characteristics"){
        answer = AnswersModel(qId: question.qaId, qSlug: question.qaSlug, answers: _userDetail.prCharacteristic.split(','));
      }else if (question.qaSlug == "IE"){
        answer = AnswersModel(qId: question.qaId, qSlug: question.qaSlug, answers: _userDetail.prIe);
      }else if (question.qaSlug == "single"){
        answer = AnswersModel(qId: question.qaId, qSlug: question.qaSlug, answers: _userDetail.prSingle.split(','));
      }else if (question.qaSlug == "single_dislikes"){
        answer = AnswersModel(qId: question.qaId, qSlug: question.qaSlug, answers: _userDetail.prSingleDislikes.split(','));
      }else if (question.qaSlug == "faith"){
        answer = AnswersModel(qId: question.qaId, qSlug: question.qaSlug, answers: _userDetail.faith);
      }else if (question.qaSlug == "faith_dislike"){
        answer = AnswersModel(qId: question.qaId, qSlug: question.qaSlug, answers: _userDetail.prFaithDislikes.split(','));
      }else if (question.qaSlug == "religion_comp"){
        answer = AnswersModel(qId: question.qaId, qSlug: question.qaSlug, answers: _userDetail.prReligious);
      }else if (question.qaSlug == "ethnicity"){
        answer = AnswersModel(qId: question.qaId, qSlug: question.qaSlug, answers: _userDetail.ethnicity);
      }else if (question.qaSlug == "ethnicity_dislike"){
        answer = AnswersModel(qId: question.qaId, qSlug: question.qaSlug, answers: _userDetail.prEthnicityDislikes.split(','));
      }else if (question.qaSlug == "most_dislikes"){
        answer = AnswersModel(qId: question.qaId, qSlug: question.qaSlug, answers: _userDetail.prOtherDislikes.split(','));
      }else if (question.qaSlug == "town" && _userDetail.prTownLikes != null){
        answer = AnswersModel(qId: question.qaId, qSlug: question.qaSlug, answers: _userDetail.prTownLikes);
      }else if (question.qaSlug == "vacation" &&  _userDetail.prVacations != null){
        answer = AnswersModel(qId: question.qaId, qSlug: question.qaSlug, answers: _userDetail.prVacations.split(','));
      }else if (question.qaSlug == "curse" && _userDetail.prCurse != null){
        answer = AnswersModel(qId: question.qaId, qSlug: question.qaSlug, answers: _userDetail.prCurse);
      }else if (question.qaSlug == "hobbies_outdoor" && _userDetail.prHobbiesOutdoor != null){
        answer = AnswersModel(qId: question.qaId, qSlug: question.qaSlug, answers: _userDetail.prHobbiesOutdoor.split(','));
      }else if (question.qaSlug == "hobbies_indoor" && _userDetail.prHobbiesIndoor != null){
        answer = AnswersModel(qId: question.qaId, qSlug: question.qaSlug, answers:  _userDetail.prHobbiesIndoor.split(','));
      }
      if(answer != null){
        _listOfAnswers.add(answer);
      }

    });
    await _sessionManager.saveAnswer(listOfAnswers: _listOfAnswers);
    questionStatus();
  }

  questionStatus()async{
    var listOfAnswersSession = await _sessionManager.getAnswers();
    if(listOfAnswersSession.length > 0){
      _listOfQuestions.forEach((question) {
        var isContain = listOfAnswersSession.where((answer) => answer.qId == question.qaId).isNotEmpty;
        if(isContain == true) {
          _listOfQuestions[_listOfQuestions.indexWhere((ques) => ques.qaId == question.qaId)].isSelected = true;
          if(question.qaSlug == 'address'){
            Map<String, dynamic> addressJSON = listOfAnswersSession.firstWhere((answer) => answer.qId == question.qaId).answers;
            _formattedAddress = '${addressJSON['city']}, ${addressJSON['state']}';
          }
        }
      });
    }
    notifyListeners();
  }

  saveAnswerOnServer()async{
    bool hasAllAnswers = true;
    var listOfAnswersSession = await _sessionManager.getAnswers();
    if(listOfAnswersSession.length > 0){
      _listOfQuestions.forEach((question) {
        if(question.qaSkipable == 0){
          var isContain = listOfAnswersSession.where((answer) => answer.qId == question.qaId).isNotEmpty;
          if(isContain == false) {
            hasAllAnswers = false;
          }
        }
      });

      if(hasAllAnswers){
        Map<String, dynamic> body = {
          "answers" : listOfAnswersSession,
          'profile_completion_status' : "1",
        };
        setSate(ViewState.Busy);
        ApiBaseHelper().post(authorization: true, url: WebService.answers,body: body,isFormData: false).then(
                (response) async {
                  setSate(ViewState.Idle);
              Map<String, dynamic> decodeJSON = jsonDecode(response);
              if(decodeJSON.containsKey('success')){
                // showToast('Update Successfully');
                var _user = await _sessionManager.getUserInfo();
                _user.onboadingStatus = 1;
                await _sessionManager.saveUserInfo(user: _user);
                Provider.of<SplashViewModel>(_context, listen: false).getUserDetails();
                _navigationService.navigateWithOutBack(TabBarControllerRoute, arguments: {'tabIndex' : '2'});
              }else{
                showToast('Something went wrong');
              }
            }, onError: (error){
          setSate(ViewState.Idle);
          showToast(error.toString());
        });
      }else{
        showDialog(
            context: _context,
            builder: (BuildContext context) => AlertDialog(
              title: new Text("Error"),
              content: new Text("Please answer all mandatory questions"),
              actions: <Widget>[
                FlatButton(
                  child: Text("Ok", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),),
                  onPressed: () => _navigationService.pop(),
                ),
              ],
            )
        );
      }
    }
  }
}


