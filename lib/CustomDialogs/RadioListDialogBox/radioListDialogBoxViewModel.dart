import 'package:app_push_notifications/Helpers/importFiles.dart';


class RadioListDialogBoxViewModel with ChangeNotifier{
  NavigationService  _navigationService = NavigationService();
  SessionManager _sessionManager = SessionManager();

  bool _onBoardingCompleted = false;
  Questions _question;
  String textChange = '';
  String _selectedRadioValue;
  UserDetail _userDetail;
  List<CheckBoxDataModel> _listOfQuestionsWithRadioButton = List<CheckBoxDataModel>();
  List<CheckBoxDataModel> _searchListOfQuestionsWithRadioButton = List<CheckBoxDataModel>();
  List<AnswersModel> _listOfAnswers = List<AnswersModel>();

  List<CheckBoxDataModel> get listOfQuestionsWithRadioButton => _listOfQuestionsWithRadioButton;
  List<CheckBoxDataModel> get searchListOfQuestionsWithRadioButton => _searchListOfQuestionsWithRadioButton;
  String get selectedRadioValue => _selectedRadioValue;

  RadioListDialogBoxViewModel({Questions question}){
    _question = question;
    checkOnBoardingCompleted();
  }

  checkOnBoardingCompleted()async{
    _userDetail = await _sessionManager.getUserDetails();
    var user = await _sessionManager.getUserInfo();
    _onBoardingCompleted = user.onboadingStatus == 1 ? true : false;
    getAnswerOptions();
  }

  onChangeText(String value){
    _searchListOfQuestionsWithRadioButton =_listOfQuestionsWithRadioButton.where((item){
      return item.title.toLowerCase().contains(value.toLowerCase());
    }).toList();
    notifyListeners();
  }

  onChangedValue(CheckBoxDataModel questionOption){
    _selectedRadioValue = questionOption.value;
    notifyListeners();
  }

  onDoneButton()async{

    if(_selectedRadioValue == null){
      showToast('Select at least single value');
      return;
    }
    var answer;
    var answerString = "";
    //TODO: If Average Income
    if(_question.qaId == 7){

      var index = _listOfQuestionsWithRadioButton.indexWhere((option) => option.value == _selectedRadioValue);
      if(index == 0){
        answerString = ' :'+_selectedRadioValue+':'+_listOfQuestionsWithRadioButton[index+1].value;
      }else if(index == _listOfQuestionsWithRadioButton.length-1){
        answerString = _listOfQuestionsWithRadioButton[index-1].value+':'+_selectedRadioValue+': ';
      }else{
        answerString = _listOfQuestionsWithRadioButton[index-1].value+':'+_selectedRadioValue+':'+_listOfQuestionsWithRadioButton[index+1].value;
      }
      answer = AnswersModel(qId: _question.qaId, qSlug: _question.qaSlug, answers: answerString.split(':'));
    }else{
      answer = AnswersModel(qId: _question.qaId, qSlug: _question.qaSlug, answers: _selectedRadioValue);
    }

    //TODO: Update UserDetails Session
    await updateUserDetails();


    //TODO: Store Answer To Session
    var listOfAnswersInSession = await _sessionManager.getAnswers();
    if(listOfAnswersInSession.length > 0){
      var isContainAnswer = listOfAnswersInSession.where((answer) => answer.qId == _question.qaId).isNotEmpty;
      if(isContainAnswer){
        listOfAnswersInSession.removeWhere((answer) => answer.qId == _question.qaId);
      }
    }

    if(_question.qaId == 7){
      listOfAnswersInSession.add(AnswersModel(qId: _question.qaId, qSlug: _question.qaSlug, answers: !_onBoardingCompleted ? answerString.split(':') : _selectedRadioValue));
    }else{
      listOfAnswersInSession.add(AnswersModel(qId: _question.qaId, qSlug: _question.qaSlug, answers: _selectedRadioValue));
    }

    await _sessionManager.saveAnswer(listOfAnswers: listOfAnswersInSession);

    //TODO: Hide dialog and call api
    _navigationService.pop();

    //TODO: Single Answer Save When Editing
    if(_onBoardingCompleted){
      _listOfAnswers.clear();
      _listOfAnswers.add(answer);
      Map<String, dynamic> body = {
        "answers" : _listOfAnswers,
        'profile_completion_status' : "1",
      };

      ApiBaseHelper().post(authorization: true, url: WebService.answers,body: body,isFormData: false).then(
              (response) async {
            Map<String, dynamic> decodeJSON = jsonDecode(response);
            if(decodeJSON.containsKey('success')){

            }else{
              showToast('Something went wrong');
            }
          }, onError: (error){
        showToast(error.toString());
      });
    }
  }

  onCancelButton(){
    _navigationService.pop();
  }


  getAnswerOptions()async{
    var questionsModel = await _sessionManager.getAppData();
    var decodeJSON = Autogenerated.fromJson(jsonDecode('{"MyKey" : ${_question.qaOptions}}'));
    var data = List<QaOptions>();
    switch(decodeJSON.myKey[0].value){
      case "data/children_preferences":
        questionsModel.listOfChildrenPreferences.forEach((childrenPreference){
          var itm = QaOptions(text: childrenPreference.cpText, value: '${childrenPreference.cpId}' );
          data.add(itm);
        });
        break;
      case "data/faith":
        questionsModel.listOfFaiths.forEach((faith){
          var itm = QaOptions(text: faith.fName, value: '${faith.fId}' );
          data.add(itm);
        });
        break;
      case "data/ethnicity":
        questionsModel.listOfEthnicity.forEach((ethnicity){
          var itm = QaOptions(text: ethnicity.eName, value: '${ethnicity.eId}' );
          data.add(itm);
        });
        break;
      default:
        decodeJSON.myKey..forEach((keyValues){
          var itm = QaOptions(text: keyValues.text, value: '${keyValues.value}' );
          data.add(itm);
        });
        break;
    }

    //TODO Get Answers when profiles completion complete
    var listOfAnswers = await _sessionManager.getAnswers();
    var answer = listOfAnswers.firstWhere((answer) => answer.qId == _question.qaId, orElse: () => null);
    if(answer != null){
      _selectedRadioValue = answer.answers;
    }

    data.forEach((item) {
      _listOfQuestionsWithRadioButton.add(
          CheckBoxDataModel(
              id: _question.qaId,
              title: item.text,
              value: item.value,
          )
      );
    });
    _searchListOfQuestionsWithRadioButton = _listOfQuestionsWithRadioButton;
    notifyListeners();
  }

  updateUserDetails()async{
    if (_question.qaSlug == "height_preference"){
      _userDetail.prHeight = _selectedRadioValue;
    }else if (_question.qaSlug == "serious"){
      _userDetail.prSerious = _selectedRadioValue;
    }else if (_question.qaSlug == "avg_income"){
      _userDetail.prAverageIncome = _selectedRadioValue;
    }else if (_question.qaSlug == "children_preference"){
      _userDetail.prKids = _selectedRadioValue;
    }else if (_question.qaSlug == "IE"){
      _userDetail.prIe = _selectedRadioValue;
    }else if (_question.qaSlug == "faith"){
      _userDetail.faith = _selectedRadioValue;
    }else if (_question.qaSlug == "religion_comp"){
      _userDetail.prReligious = _selectedRadioValue;
    }else if (_question.qaSlug == "ethnicity"){
      _userDetail.ethnicity = _selectedRadioValue;
    }else if (_question.qaSlug == "town"){
      _userDetail.prTownLikes = _selectedRadioValue;
    }else if (_question.qaSlug == "curse"){
      _userDetail.prCurse = _selectedRadioValue;
    }
    await _sessionManager.saveUsersDetails(userDetail: _userDetail);
  }

}