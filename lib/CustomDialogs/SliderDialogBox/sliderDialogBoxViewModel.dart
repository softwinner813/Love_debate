import 'package:app_push_notifications/Helpers/importFiles.dart';


class SliderDialogBoxViewModel with ChangeNotifier{

  NavigationService _navigationService = NavigationService();
  SessionManager _sessionManager = SessionManager();

  UserDetail _userDetail;
  double _sliderValue = 2000.0;
  Questions _question;
  List<AnswersModel> _listOfAnswers = List<AnswersModel>();
  bool _onBoardingCompleted = false;

  double get sliderValue => _sliderValue;

  SliderDialogBoxViewModel({Questions question}){
    _question = question;
    checkOnBoardingCompleted();
  }

  checkOnBoardingCompleted()async{
    var user = await _sessionManager.getUserInfo();
    _onBoardingCompleted = user.onboadingStatus == 1 ? true : false;
    getAnswerOptions();
  }

  onChangeValue(double value){
    _sliderValue = value;
    notifyListeners();
  }

  onDoneButton()async{

    //TODO: Update UserDetails Session
    _userDetail = await _sessionManager.getUserDetails();
    _userDetail.prHeight = _sliderValue.toString();

    //TODO: Store Answer To Session
    var listOfAnswersInSession = await _sessionManager.getAnswers();
    if(listOfAnswersInSession.length > 0){
      var isContainAnswer = listOfAnswersInSession.where((answer) => answer.qId == _question.qaId).isNotEmpty;
      if(isContainAnswer != null){
        listOfAnswersInSession.removeWhere((answer) => answer.qId == _question.qaId);
      }
    }
    listOfAnswersInSession.add(AnswersModel(qId: _question.qaId, qSlug: _question.qaSlug, answers: _sliderValue.toString()));
    await _sessionManager.saveAnswer(listOfAnswers: listOfAnswersInSession);

    _navigationService.pop();

    //TODO: Single Answer Save When Editing
    if(_onBoardingCompleted){
      _listOfAnswers.clear();
      _listOfAnswers.add(AnswersModel(qId: _question.qaId, qSlug: _question.qaSlug, answers: _sliderValue.toString()));

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
    //TODO Get Answers when profiles completion complete
    var listOfAnswers = await _sessionManager.getAnswers();
    var answer = listOfAnswers.firstWhere((answer) => answer.qId == _question.qaId, orElse: () => null);
    if(answer != null){
      _sliderValue = answer.answers.toString().toDouble();
    }
    notifyListeners();
  }

}