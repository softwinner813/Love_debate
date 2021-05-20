import 'package:app_push_notifications/Helpers/importFiles.dart';
import 'package:app_push_notifications/Models/AnswersModel.dart';
import 'package:app_push_notifications/Models/NewQuestionModel.dart';
import 'package:app_push_notifications/Models/QaOptions.dart';
import 'package:app_push_notifications/Models/CheckBoxDataModel.dart';

class CheckBoxListDialogBoxViewModel with ChangeNotifier{

  NavigationService  _navigationService = NavigationService();
  SessionManager _sessionManager = SessionManager();

  bool _onBoardingCompleted = false;
  UserDetail _userDetail;
  Questions _question;
  String textChange = '';
  List<CheckBoxDataModel> _listOfQuestionsWithCheckBox = List<CheckBoxDataModel>();
  List<CheckBoxDataModel> _searchListOfQuestionsWithCheckBox = List<CheckBoxDataModel>();
  List<AnswersModel> _listOfAnswers = List<AnswersModel>();

  List<CheckBoxDataModel> get listOfQuestionsWithCheckBox => _listOfQuestionsWithCheckBox;
  List<CheckBoxDataModel> get searchListOfQuestionsWithCheckBox => _searchListOfQuestionsWithCheckBox;

  CheckBoxListDialogBoxViewModel({Questions question}){
    _question = question;
    checkOnBoardingCompleted();
  }

  checkOnBoardingCompleted()async{
    _userDetail = await _sessionManager.getUserDetails();
    var user = await _sessionManager.getUserInfo();
    _onBoardingCompleted = user.onboadingStatus == 1 ? true : false;
    getAnswerOptions();
  }

  RegExp regExp = new RegExp(
    r"(?<![\w\d])abc(?![\w\d])",
    caseSensitive: false,
    multiLine: false,
  );


  onChangeText(String value){
    _searchListOfQuestionsWithCheckBox =_listOfQuestionsWithCheckBox.where((item){
          return item.title.toLowerCase().contains(value.toLowerCase());
        }).toList();
    notifyListeners();
  }

  onChangedValue(CheckBoxDataModel questionOption){
    if(questionOption.title == 'Select All' ){
      _listOfQuestionsWithCheckBox = _listOfQuestionsWithCheckBox.map((item){
        return CheckBoxDataModel(
          id: item.id,
          value: item.value,
          title: item.title,
          checkedValue: !questionOption.checkedValue
        );
      }).toList();
    }else{
      if(_listOfQuestionsWithCheckBox[0].checkedValue == true){
        _listOfQuestionsWithCheckBox[0].checkedValue = false;
      }
      var index = _listOfQuestionsWithCheckBox.indexWhere((options) => options.title == questionOption.title);
      _listOfQuestionsWithCheckBox[index].checkedValue = !questionOption.checkedValue;
    }

    _searchListOfQuestionsWithCheckBox =_listOfQuestionsWithCheckBox.where((item){
      return item.title.toLowerCase().contains(textChange);
    }).toList();

    notifyListeners();
  }

  onDoneButton()async{
    //TODO: Get Selected Items
    var selectedOptions = _listOfQuestionsWithCheckBox.where((option) => option.checkedValue == true);

    //TODO: Get Selected Items Values
    var lisOfSelectedOptionsValues = selectedOptions.map((e) => e.value).toList();

    if(lisOfSelectedOptionsValues.length == 0){
      showToast('Select at least single value');
      return;
    }

    lisOfSelectedOptionsValues.removeWhere((element) => element == 'All');

    //TODO: Update UserDetails Session
    await updateUserDetails(selectedValues: lisOfSelectedOptionsValues.join(','));

    //TODO: Store Answer To Session
    var listOfAnswersInSession = await _sessionManager.getAnswers();
    if(listOfAnswersInSession.length > 0){
      var isContainAnswer = listOfAnswersInSession.where((answer) => answer.qId == _question.qaId).isNotEmpty;
      if(isContainAnswer != null){
        listOfAnswersInSession.removeWhere((answer) => answer.qId == _question.qaId);
      }
    }
    listOfAnswersInSession.add(AnswersModel(qId: _question.qaId, qSlug: _question.qaSlug, answers: lisOfSelectedOptionsValues));
    await _sessionManager.saveAnswer(listOfAnswers: listOfAnswersInSession);

    _navigationService.pop();

    //TODO: Single Answer Save When Editing
    if(_onBoardingCompleted){
      _listOfAnswers.clear();
      _listOfAnswers.add(AnswersModel(qId: _question.qaId, qSlug: _question.qaSlug, answers: lisOfSelectedOptionsValues));

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

  onCancelButton(){
    _navigationService.pop();
  }

  getAnswerOptions()async{

    //Todo: Get questions options from session and decoded
    var isAllSelected = false;
    var questionsModel = await _sessionManager.getAppData();
    var decodeJSON = Autogenerated.fromJson(jsonDecode('{"MyKey" : ${_question.qaOptions}}'));
    var data = List<QaOptions>();
    switch(decodeJSON.myKey[0].value){
      case "data/professions":
        questionsModel.listOfProfessions.forEach((profession){
          var itm = QaOptions(text: profession.proName, value: '${profession.proId}' );
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
      case "data/vacation_types":
        questionsModel.listOfVocationsType.forEach((vacation){
          var itm = QaOptions(text: vacation.vtName, value: '${vacation.vtId}' );
          data.add(itm);
        });
        break;
      case "data/hobbies":
        if(_question.qaName == 'Hobbies Outdoor'){
          questionsModel.listOfHobbies.forEach((hobby){
            if(hobby.hbType == 1){
              var itm = QaOptions(text: hobby.hbName, value: '${hobby.hbId}' );
              data.add(itm);
            }
          });
        }else{
          questionsModel.listOfHobbies.forEach((hobby){
            if(hobby.hbType == 2){
              var itm = QaOptions(text: hobby.hbName, value: '${hobby.hbId}' );
              data.add(itm);
            }
          });
        }
        break;
      default:
        decodeJSON.myKey..forEach((keyValues){
          var itm = QaOptions(text: keyValues.text, value: '${keyValues.value}' );
          data.add(itm);
        });
        break;
    }



    //TODO Get Answers when profiles completion complete
    List<dynamic> previousSelectedValues;
    // if(_userDetail.prCompletionStatus == 1){
      var listOfAnswers = await _sessionManager.getAnswers();
      var answer = listOfAnswers.firstWhere((answer) => answer.qId == _question.qaId, orElse: () => null);
      if(answer != null){
        previousSelectedValues = answer.answers;
      }
    // }

    //TODO: Add data in to list with selected values
    data.forEach((item) {
      var isContain = false;
      if(previousSelectedValues != null){
        isContain = previousSelectedValues.contains(item.value);
      }

      _listOfQuestionsWithCheckBox.add(
          CheckBoxDataModel(
              id: _question.qaId,
              title: item.text,
              checkedValue: isContain,
              value: item.value
          )
      );
    });

      isAllSelected = _listOfQuestionsWithCheckBox.where((element) => element.checkedValue == false).length > 0 ? false : true;

    //TODO: Add All Selected Option
    _listOfQuestionsWithCheckBox.insert(0, CheckBoxDataModel(
        id: _question.qaId,
        title: "Select All",
        checkedValue: isAllSelected,
        value: "All"
    ));



      _searchListOfQuestionsWithCheckBox = _listOfQuestionsWithCheckBox;
    notifyListeners();
  }

  updateUserDetails({String selectedValues})async{
    if (_question.qaSlug == "profession"){
      _userDetail.prProfession = selectedValues;
    }else if (_question.qaSlug == "goal"){
      _userDetail.prGoals = selectedValues;
    }else if (_question.qaSlug == "partner_expectations"){
      _userDetail.prExpectations = selectedValues;
    }else if (_question.qaSlug == "characteristics"){
      _userDetail.prCharacteristic = selectedValues;
    }else if (_question.qaSlug == "single"){
      _userDetail.prSingle = selectedValues;
    }else if (_question.qaSlug == "single_dislikes"){
      _userDetail.prSingleDislikes = selectedValues;
    }else if (_question.qaSlug == "faith_dislike"){
      _userDetail.faithDislikeStr = selectedValues;
    }else if (_question.qaSlug == "ethnicity_dislike"){
      _userDetail.prEthnicityDislikes = selectedValues;
    }else if (_question.qaSlug == "most_dislikes"){
      _userDetail.prOtherDislikes = selectedValues;
    }else if (_question.qaSlug == "vacation"){
      _userDetail.prVacations = selectedValues;
    }else if (_question.qaSlug == "hobbies_outdoor"){
      _userDetail.prHobbiesOutdoor = selectedValues;
    }else if (_question.qaSlug == "hobbies_indoor"){
      _userDetail.prHobbiesIndoor = selectedValues;
    }
    await _sessionManager.saveUsersDetails(userDetail: _userDetail);
  }
}


class Autogenerated {
  List<QaOptions> myKey;

  Autogenerated({this.myKey});

  Autogenerated.fromJson(Map<String, dynamic> json) {
    if (json['MyKey'] != null) {
      myKey = new List<QaOptions>();
      json['MyKey'].forEach((v) {
        myKey.add(new QaOptions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.myKey != null) {
      data['MyKey'] = this.myKey.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
