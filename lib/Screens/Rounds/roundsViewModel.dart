import 'package:app_push_notifications/Helpers/importFiles.dart';

class Answers{
//  String message;
//  MessageType type;
//  Answers({this.message, this.type});

  String message;
  String type;

  Answers({this.message, this.type});

  Answers.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['type'] = this.type;
    return data;
  }
}

class RoundsInnerModel{
  String txtQuestion;
  List<Answers> usersAnswers;

  bool showAcceptButton;
  bool showContinueButton;
  bool showTextField;
  bool completedRoundSet;
  RoundsInnerModel({this.txtQuestion, this.usersAnswers, this.showAcceptButton = false, this.showContinueButton = false, this.showTextField = true, this.completedRoundSet = false});
}

class RoundsViewModel with ChangeNotifier implements LoaderState{

  SocketService _socketService = SocketService();
  NavigationService _navigationService =  NavigationService();
  SessionManager _session = SessionManager();
  ValidationModel _answer = ValidationModel(value: '', error: null);

  ScrollController _scrollController;
  String _toUserId, _toUserName, _toUserSocketId, _catId, _catName, _fromUserName;
  TextEditingController _textEditingController = TextEditingController();
  RoundsInnerModel _roundsInnerModel = RoundsInnerModel();
  RoundsModel _roundsModel;
  Round _roundsQuestions;
  bool isChatEnable = false;
  int _stepperIndex = 0;
  bool _iAmGameOwner = false;
  bool isDeclined = false;
  bool isWaited = false;
  bool isCompleted = false;
  bool _fromCategories = false;
  bool _isComplete = false;
  bool _alreadyConnected = false;

  ScrollController get scrollController => _scrollController;
  TextEditingController get textEditingController => _textEditingController;

  RoundsInnerModel get roundModel => _roundsInnerModel;
  Round get roundsQuestions => _roundsQuestions;
  ValidationModel get answer => _answer;
  String get toUserId => _toUserId;
  String get toUserName => _toUserName;
  String get toUserSocketId => _toUserSocketId;
  String get catId => _catId;
  String get catName => _catName;
  String get fromUserName => _fromUserName;
  int get stepperIndex => _stepperIndex;
  bool get iAmGameOwner => _iAmGameOwner;
  bool get fromCategories =>  _fromCategories;
  bool get alreadyConnected => _alreadyConnected;

  //=======================================================================
  //================= LoaderState Abstract Implement ======================
  //=======================================================================

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

  RoundsViewModel({String toUserId, String toUserName, String catId, String toUserSocketId, bool fromCategories}) {
    
    _toUserId = toUserId;
    _toUserName = toUserName;
    _catId = catId;
    _stepperIndex = 0;
    _toUserSocketId = toUserSocketId;
    _fromCategories = fromCategories;
    getDataFromSession();
    if(_catId!=null){
      getRoundsQuestion();
      receiveMessageFromSocket();
    }
    _scrollController = ScrollController(                         // NEW
      initialScrollOffset: 0.0,
      keepScrollOffset: false,                                         // NEW
    );
  }

 void _toEnd() {                                                     // NEW
     _scrollController.animateTo(                                      // NEW
       _scrollController.position.maxScrollExtent*5,                     // NEW
       duration: const Duration(seconds: 10),                    // NEW
       curve: Curves.ease,                                             // NEW
     );
   // Timer(Duration(milliseconds: 3000), () => _scrollController.jumpTo(_scrollController.position.maxScrollExtent));
   notifyListeners();// NEW
 }

  getDataFromSession()async{
    await _session.getUserInfo().then((value) => _fromUserName = value.name);
    var _appData = await _session.getAppData();
    List<CategoryModel> listOfCategories = _appData.listOfCategories;
    _catName = listOfCategories.firstWhere((category) => category.cId.toString() == _catId).cName;
    notifyListeners();
  }

  onChangeAnswer(String value){
    if(value == ''){
      _answer = ValidationModel(value: '', error: null);
    }else{
      _answer = ValidationModel(value: value, error: null);
    }
    notifyListeners();
  }

  bool get isValidate{
    if(_answer.value != ''){
      return true;
    }else{
      return false;
    }
  }

  getRoundsQuestion(){
    Map<String, dynamic> body = {
      "cate_id": _catId,
      "id" :  _toUserId  //player_id
    };
    setSate(ViewState.Busy);
    ApiBaseHelper().post(authorization: true, url: WebService.rounds,body: body,isFormData: true).then(
        (response) async{
          setSate(ViewState.Idle);
          Map<String, dynamic> decodedJSON = jsonDecode(response);
          if(decodedJSON.containsKey('success')){
            _roundsModel = RoundsModel.fromJson(decodedJSON['success']);
            _roundsQuestions = _roundsModel.rounds;
            _alreadyConnected = _roundsModel.alreadyConnected == 'yes' ? true : false;
            findWhoOwner();
          }else{
            showToast('Something went wrong');
          }
    }, onError: (error){
      setSate(ViewState.Idle);
      showToast('Somethings went wrong');
    });
  }

  ///Status 0 ->  Reject, 1-> active, 2 -> complete
  btnDeclineOrOtherRoundsService({int status}){

    Map<String, dynamic> body = {
      "status": status.toString(),
      "round_id": _roundsQuestions.rId.toString(),
      "id": _toUserId.toString(),
      "cate_id":_catId.toString()
    };

    setSate(ViewState.Busy);
    ApiBaseHelper().post(authorization: true, url: WebService.updateStatusDecline,body: body,isFormData: true).then(
            (response) async{
          setSate(ViewState.Idle);
          Map<String, dynamic> decodeJSON = jsonDecode(response);
          if(decodeJSON.containsKey('success')){
            if(status == 0){

              // Send message from Socket
              var fromUserSocketId = await _session.socketId;
              Map<String, dynamic> roundsData = {
                'fromSocketUserId' : fromUserSocketId,
                'toSocketUserId' : _toUserSocketId,
                'roundId' : _roundsQuestions.rId.toString(),
                'questionServiceData' : _roundsQuestions.toJson(),
                'stepperIndex' : _stepperIndex.toString(),
                'answer' : _answer.value,
                'isOwner' : _iAmGameOwner.toString(),
                'status' : '0',
                'toUserId' : decodeJSON['success'].toString(),
                'isAnswer' : 'true'
              };
              sendAnswerThroughSocket(data: roundsData);

              showToast('Rounds declined successfully');
              _navigationService.pop();
            }
          }else{
            showToast('Something went wrong');
          }
        }, onError: (error){
      setSate(ViewState.Idle);
      showToast('Something went wrong');
    });
  }
  
  btnMakeConnectionService(){
    Map<String, dynamic> body = {
      'user_id' : _toUserId.toString(),
      'round_id' : _roundsQuestions.rId.toString(),
    };
    setSate(ViewState.Busy);
    ApiBaseHelper().post(authorization: true, url: WebService.makeConnection,body: body,isFormData: true).then(
        (response) async{
          setSate(ViewState.Idle);
          Map<String, dynamic> decodeJSON = jsonDecode(response);
          if(decodeJSON.containsKey('success')){
            // Send message from Socket
            var fromUserSocketId = await _session.socketId;
            Map<String, dynamic> roundsData = {
              'fromSocketUserId' : fromUserSocketId,
              'toSocketUserId' : _toUserSocketId,
              'roundId' : _roundsQuestions.rId.toString(),
              'questionServiceData' : _roundsQuestions.toJson(),
              'stepperIndex' : _stepperIndex.toString(),
              'answer' : _answer.value,
              'isOwner' : _iAmGameOwner.toString(),
              'status' : '2',
              'toUserId' : decodeJSON['success'].toString().split('_')[1],
              'isAnswer' : 'true'
            };
            sendAnswerThroughSocket(data: roundsData);

            _navigationService.navigateWithOutBack(TabBarControllerRoute, arguments: {'tabIndex' : '0'});
          }else{
            showToast('Something went wrong');
          }
    }, onError: (error){
      setSate(ViewState.Idle);
          showToast('Something went Wrong');
    });
  }

  findWhoOwner(){
    if(_toUserId.toString() == _roundsQuestions.rUserId.toString()){
      _iAmGameOwner = false;
    }else if (toUserId.toString() == _roundsQuestions.rPlayerId.toString()){
      _iAmGameOwner = true;
    }else{
      _iAmGameOwner = true;
    }
    findRoundNumber();
  }

  findRoundNumber(){
    if (_roundsQuestions.rStatus != 0) {
      if (_roundsQuestions.rUserAnsThree != null || _roundsQuestions.rPlayerAnsThree != null) {
        _stepperIndex = 2;
      } else if(_roundsQuestions.rUserAnsTwo != null || _roundsQuestions.rPlayerAnsTwo != null) {
        _stepperIndex = 1;
      }else if (_roundsQuestions.rUserAnsOne != null || _roundsQuestions.rPlayerAnsOne != null) {
        _stepperIndex = 0;
      } else {
        _stepperIndex = 0;
      }
    }
    setQuestions();
  }
  
  setQuestions(){
    if(_stepperIndex == 0) _roundsInnerModel.txtQuestion = _roundsQuestions.questionOne;
    if(_stepperIndex == 1) _roundsInnerModel.txtQuestion = _roundsQuestions.questionTwo;
    if(_stepperIndex == 2) _roundsInnerModel.txtQuestion = _roundsQuestions.questionThree;
    getUsersAnswers();
  }

  getUsersAnswers(){
   if(_stepperIndex == 0 && !isChatEnable){
     roundModel.usersAnswers = List<Answers>();
     if(_roundsQuestions.rUserAnsOne != null){
       _roundsInnerModel.usersAnswers.add(Answers(message: _roundsQuestions.rUserAnsOne, type: iAmGameOwner ? 'Sender' : 'Receiver'));
     }if(_roundsQuestions.rPlayerAnsOne != null){
       _roundsInnerModel.usersAnswers.add(Answers(message: _roundsQuestions.rPlayerAnsOne, type: !iAmGameOwner ? 'Sender' : 'Receiver'));
     }if(_roundsQuestions.rUserAnsOne != null && _roundsQuestions.rPlayerAnsOne != null){
       isChatEnable = true;
     }
   }else if(_stepperIndex == 1){
     roundModel.usersAnswers = List<Answers>();
     if(_roundsQuestions.rUserAnsTwo != null){
       _roundsInnerModel.usersAnswers.add(Answers(message: _roundsQuestions.rUserAnsTwo, type: iAmGameOwner ? 'Sender' : 'Receiver'));
     }if(_roundsQuestions.rPlayerAnsTwo != null){
       _roundsInnerModel.usersAnswers.add(Answers(message: _roundsQuestions.rPlayerAnsTwo, type: !iAmGameOwner ? 'Sender' : 'Receiver'));
     }if(_roundsQuestions.rUserAnsTwo != null && _roundsQuestions.rPlayerAnsTwo != null){
       isChatEnable = true;
     }
   }else if(_stepperIndex == 2){
     roundModel.usersAnswers = List<Answers>();
     if(_roundsQuestions.rUserAnsThree != null){
       _roundsInnerModel.usersAnswers.add(Answers(message: _roundsQuestions.rUserAnsThree, type: iAmGameOwner ? 'Sender' : 'Receiver'));
     }if(_roundsQuestions.rPlayerAnsThree != null){
       _roundsInnerModel.usersAnswers.add(Answers(message: _roundsQuestions.rPlayerAnsThree, type: !iAmGameOwner ? 'Sender' : 'Receiver'));
     }if(_roundsQuestions.rUserAnsThree != null && _roundsQuestions.rPlayerAnsThree != null){
       isChatEnable = true;
     }
   }
    loadChat();
  }

  loadChat(){
    if(isChatEnable && _roundsModel.roundsChat.length > 0){
      _roundsModel.roundsChat.forEach((chat) {
        if(chat.senderId == _roundsQuestions.rUserId){
          _roundsInnerModel.usersAnswers.add(Answers(message: chat.message, type: iAmGameOwner ? 'Sender' : 'Receiver'));
        }else{
          _roundsInnerModel.usersAnswers.add(Answers(message: chat.message, type: !iAmGameOwner ? 'Sender' : 'Receiver'));
        }
      });
    }

    showAcceptButtons();
  }


  showAcceptButtons(){
    goToNextRound();
    _roundsInnerModel.showAcceptButton = false;
    if(_roundsQuestions.rStatus != 0 && _roundsQuestions.rStatus != 2) {
      if (_stepperIndex == 0 && _roundsQuestions.rUserAnsOne != null && _roundsQuestions.rPlayerAnsOne != null) {
        _roundsInnerModel.showAcceptButton = true;
      } else if (_stepperIndex == 1 && _roundsQuestions.rUserAnsTwo != null && _roundsQuestions.rPlayerAnsTwo != null) {
        _roundsInnerModel.showAcceptButton = true;
      } else if (_stepperIndex == 2 && _roundsQuestions.rUserAnsThree != null && _roundsQuestions.rPlayerAnsThree != null) {
        _roundsInnerModel.showAcceptButton = true;
      }

      if(_isComplete){
        _roundsInnerModel.showTextField = false;
        _roundsInnerModel.showAcceptButton = false;
        notifyListeners();
      }else{
        showTexFieldAndSendButton();
      }

    }else if(_roundsQuestions.rStatus == 2){
      if(_toUserSocketId != null){
        _navigationService.navigateWithOutBack(TabBarControllerRoute, arguments: {'tabIndex' : '0'});
      }else{

        if(_isComplete){
          _roundsInnerModel.showTextField = false;
          _roundsInnerModel.showAcceptButton = false;
          notifyListeners();
        }else{
          showTexFieldAndSendButton();
        }
      }
    }else{
      isDeclined = true;
      _roundsInnerModel.showTextField = false;
      _roundsInnerModel.showAcceptButton = false;
      notifyListeners();
    }
    _toEnd();

  }
  
  showTexFieldAndSendButton(){
    _answer = ValidationModel(value: '', error: null);
    _textEditingController.text = _answer.value;
    _roundsInnerModel.showTextField = true;
    if(_iAmGameOwner){
      if (_stepperIndex == 0 && _roundsQuestions.rUserAnsOne != null && _roundsQuestions.rPlayerAnsOne != null) {
        _roundsInnerModel.showTextField = true;
      } else if (_stepperIndex == 1 && _roundsQuestions.rUserAnsTwo != null && _roundsQuestions.rPlayerAnsTwo != null) {
        _roundsInnerModel.showTextField = true;
      } else if (_stepperIndex == 2 && _roundsQuestions.rUserAnsThree != null && _roundsQuestions.rPlayerAnsThree != null) {
        _roundsInnerModel.showTextField = true;
      }else if (_stepperIndex == 0 && _roundsQuestions.rUserAnsOne != null) {
        _roundsInnerModel.showTextField = false;
      } else if (_stepperIndex == 1 && _roundsQuestions.rUserAnsTwo != null) {
        _roundsInnerModel.showTextField = false;
      } else if (_stepperIndex == 2 && _roundsQuestions.rUserAnsThree != null) {
        _roundsInnerModel.showTextField = false;
      }
    }else{
      if (_stepperIndex == 0 && _roundsQuestions.rPlayerAnsOne != null && _roundsQuestions.rUserAnsOne != null) {
        _roundsInnerModel.showTextField = true;
      } else if (_stepperIndex == 1 && _roundsQuestions.rPlayerAnsTwo != null && _roundsQuestions.rUserAnsTwo != null) {
        _roundsInnerModel.showTextField = true;
      } else if (_stepperIndex == 2 && _roundsQuestions.rPlayerAnsThree != null && _roundsQuestions.rUserAnsThree != null) {
        _roundsInnerModel.showTextField = true;
      }else if (_stepperIndex == 0 &&  _roundsQuestions.rPlayerAnsOne != null) {
        _roundsInnerModel.showTextField = false;
      } else if (_stepperIndex == 1 && _roundsQuestions.rPlayerAnsTwo != null) {
        _roundsInnerModel.showTextField = false;
      } else if (_stepperIndex == 2 && _roundsQuestions.rPlayerAnsThree != null) {
        _roundsInnerModel.showTextField = false;
      }
    }

    if(_stepperIndex == 0){
      if(_roundsQuestions.rUserAnsOne != null && _roundsQuestions.rPlayerAnsOne == null && _iAmGameOwner){
        isWaited = true;
      }else if(_roundsQuestions.rUserAnsOne == null && _roundsQuestions.rPlayerAnsOne != null && !_iAmGameOwner){
        isWaited = true;
      }else{
        isWaited = false;
      }
    }else if(_stepperIndex == 1){
      if(_roundsQuestions.rUserAnsTwo != null && _roundsQuestions.rPlayerAnsTwo == null && _iAmGameOwner){
        isWaited = true;
      }else if(_roundsQuestions.rUserAnsTwo == null && _roundsQuestions.rPlayerAnsTwo != null && !_iAmGameOwner){
        isWaited = true;
      }else{
        isWaited = false;
      }
    }else{
      if(_roundsQuestions.rUserAnsThree != null && _roundsQuestions.rPlayerAnsThree == null && _iAmGameOwner){
        isWaited = true;
      }else if(_roundsQuestions.rUserAnsThree == null && _roundsQuestions.rPlayerAnsThree != null && !_iAmGameOwner){
        isWaited = true;
      }else{
        isWaited = false;
      }
    }
  }

  showConnectionsAndAnOtherButtons(){
    isWaited = false;
    if(_roundsQuestions.rUserAnsThree != null && _roundsQuestions.rPlayerAnsThree != null){
      _roundsInnerModel.showAcceptButton = false;
      _roundsInnerModel.showTextField = false;
      _roundsInnerModel.completedRoundSet = true;
    }

    if(_roundsQuestions.rStatus == 2){
      isCompleted = true;
    }else{
      isCompleted = false;
    }
    _isComplete = true;
    notifyListeners();
  }

  updateModelAfterSaveAnswer(){
    if(_iAmGameOwner){
      if(_stepperIndex == 0 && _roundsQuestions.rUserAnsOne == null){
        _roundsQuestions.rUserAnsOne = _answer.value;
        _roundsQuestions.rUserId = _toUserId.toInt();
      }else if(_stepperIndex == 1 && _roundsQuestions.rUserAnsTwo == null){
        _roundsQuestions.rUserAnsTwo = _answer.value;
      }else if(_stepperIndex == 2 && _roundsQuestions.rUserAnsThree == null){
        _roundsQuestions.rUserAnsThree = _answer.value;
      }
    }else{
      if(_stepperIndex == 0 && _roundsQuestions.rPlayerAnsOne == null){
        _roundsQuestions.rPlayerAnsOne = _answer.value;
      }else if(_stepperIndex == 1 && _roundsQuestions.rPlayerAnsTwo == null){
        _roundsQuestions.rPlayerAnsTwo = _answer.value;
      }else if(_stepperIndex == 2 && _roundsQuestions.rPlayerAnsThree == null){
        _roundsQuestions.rPlayerAnsThree = _answer.value;
      }
    }
    getUsersAnswers();
  }

  btnNextRound(){

    var columnName;
    if(_stepperIndex == 0){
      if(_iAmGameOwner){
        _roundsQuestions.rUserAnsOneStatus = 1;
        columnName = 'r_user_ans_one_status';
      }else{
        _roundsQuestions.rPlayerAnsOneStatus = 1;
        columnName = 'r_player_ans_one_status';
      }
    }else if(_stepperIndex == 1){
      if(_iAmGameOwner){
        _roundsQuestions.rUserAnsTwoStatus = 1;
        columnName = 'r_user_ans_two_status';
      }else{
        _roundsQuestions.rPlayerAnsTwoStatus = 1;
        columnName = 'r_player_ans_two_status';
      }
    }else{
      if(_iAmGameOwner){
        _roundsQuestions.rUserAnsThreeStatus = 1;
        columnName = 'r_user_ans_three_status';
      }else{
        _roundsQuestions.rPlayerAnsThreeStatus = 1;
        columnName = 'r_player_ans_three_status';
      }
    }

    saveAnswerStatus(columnName);

  }

  goToNextRound(){
    bool goto = false;
    if(_stepperIndex == 0){
      if(_roundsQuestions.rUserAnsOneStatus == 1 && _roundsQuestions.rPlayerAnsOneStatus == 1){
        goto = true;
      }else if(_roundsQuestions.rUserAnsOneStatus == 1 && _roundsQuestions.rPlayerAnsOneStatus == 0){
        isWaited = true;
        _roundsInnerModel.showAcceptButton = false;
        _roundsInnerModel.showTextField = false;
      }else if(_roundsQuestions.rUserAnsOneStatus == 0 && _roundsQuestions.rPlayerAnsOneStatus == 1){
        isWaited = true;
        _roundsInnerModel.showAcceptButton = false;
        _roundsInnerModel.showTextField = false;
      }else {
        isWaited = false;
        _roundsInnerModel.showAcceptButton = true;
        _roundsInnerModel.showTextField = true;
      }
    }else if(_stepperIndex == 1){
      if(_roundsQuestions.rUserAnsTwoStatus == 1 && _roundsQuestions.rPlayerAnsTwoStatus == 1){
        goto = true;
      }else if(_roundsQuestions.rUserAnsTwoStatus == 1 && _roundsQuestions.rPlayerAnsTwoStatus == 0){
        isWaited = true;
        _roundsInnerModel.showAcceptButton = false;
        _roundsInnerModel.showTextField = false;
      }else if(_roundsQuestions.rUserAnsTwoStatus == 0 && _roundsQuestions.rPlayerAnsTwoStatus == 1){
        isWaited = true;
        _roundsInnerModel.showAcceptButton = false;
        _roundsInnerModel.showTextField = false;
      }else{
        isWaited = false;
        _roundsInnerModel.showAcceptButton = true;
        _roundsInnerModel.showTextField = true;
      }
    }else{
      if(_roundsQuestions.rUserAnsThreeStatus == 1 && _roundsQuestions.rPlayerAnsThreeStatus == 1){
        goto = true;
      }else if(_roundsQuestions.rUserAnsThreeStatus == 1 && _roundsQuestions.rPlayerAnsThreeStatus == 0){
        isWaited = true;
        _roundsInnerModel.showAcceptButton = false;
        _roundsInnerModel.showTextField = false;
      }else if(_roundsQuestions.rUserAnsThreeStatus == 0 && _roundsQuestions.rPlayerAnsThreeStatus == 1){
        isWaited = true;
        _roundsInnerModel.showAcceptButton = false;
        _roundsInnerModel.showTextField = false;
      }else{
        isWaited = false;
        _roundsInnerModel.showAcceptButton = true;
        _roundsInnerModel.showTextField = true;
      }
    }
    notifyListeners();
    if(goto){
      if(_stepperIndex == 2){
        showConnectionsAndAnOtherButtons();
        notifyListeners();
      }else{
        _stepperIndex = _stepperIndex + 1;
        _roundsInnerModel.showTextField = true;
        _roundsInnerModel.showAcceptButton = false;

        if(_toUserId.toString() == _roundsQuestions.rUserId.toString()){
          _iAmGameOwner = false;
        }else if (toUserId.toString() == _roundsQuestions.rPlayerId.toString()){
          _iAmGameOwner = true;
        }else{
          _iAmGameOwner = true;
        }
        _roundsModel.roundsChat.clear();
        _roundsInnerModel.usersAnswers.clear();
        notifyListeners();
        setQuestions();
      }
    }
  }

  //Socket Function
  checkUsersOnline()async{
    if(_stepperIndex == 0){
      if(_roundsQuestions.rUserAnsOne != null && _roundsQuestions.rPlayerAnsOne != null){
        saveAndSendMessageChatWithSocket();
      }else{
        saveAndSendMessageRoundsWithSocket();
      }
    }else if(_stepperIndex == 1){
      if(_roundsQuestions.rUserAnsTwo != null && _roundsQuestions.rPlayerAnsTwo != null){
        saveAndSendMessageChatWithSocket();
      }else{
        saveAndSendMessageRoundsWithSocket();
      }
    }else{
      if(_roundsQuestions.rUserAnsThree != null && _roundsQuestions.rPlayerAnsThree != null){
        saveAndSendMessageChatWithSocket();
      }else{
        saveAndSendMessageRoundsWithSocket();
      }
    }
  }

  //Save to Rounds Table
  saveAndSendMessageRoundsWithSocket(){
      var questionId;
      if(_stepperIndex == 0) questionId = _roundsQuestions.rQuesOneId;
      if(_stepperIndex == 1) questionId = _roundsQuestions.rQuesTwoId;
      if(_stepperIndex == 2) questionId = _roundsQuestions.rQuesThreeId;

      Map<String, dynamic> body = {
        'cate_id' : _catId.toString(),
        'id' : _toUserId.toString(),//player_id
        'answer': _answer.value,
        'question_id' : questionId.toString(),
        'q1' : _roundsQuestions.rQuesOneId.toString(),
        'q2' : _roundsQuestions.rQuesTwoId.toString(),
        'q3' : _roundsQuestions.rQuesThreeId.toString(),
      };

      setSate(ViewState.Busy);
      ApiBaseHelper().post(authorization: true, url: WebService.answerRound,body: body,isFormData: true).then(
              (response) async{
            setSate(ViewState.Idle);
            Map<String, dynamic> decodeJSON = jsonDecode(response);
            if(decodeJSON.containsKey('success')){

              // Send message from Socket
              var fromUserSocketId = await _session.socketId;
              Map<String, dynamic> roundsData = {
                'fromSocketUserId' : fromUserSocketId,
                'toSocketUserId' : _toUserSocketId,
                'roundId' : _roundsQuestions.rId.toString(),
                'questionServiceData' : _roundsQuestions.toJson(),
                'stepperIndex' : _stepperIndex.toString(),
                'answer' : _answer.value,
                'isOwner' : _iAmGameOwner.toString(),
                'status' : _roundsQuestions.rStatus.toString(),
                'toUserId' : decodeJSON['success'].toString(),
                'isAnswer' : 'true'
              };
              sendAnswerThroughSocket(data: roundsData);
              updateModelAfterSaveAnswer();

            }else{
              showToast('Some thing went wrong');
            }
          }, onError: (error){
        setSate(ViewState.Idle);
        showToast('Something went wrong');
      }).catchError((onError){
        print(onError.toString());
      });
  }

  //Save to Chat Table
  saveAndSendMessageChatWithSocket(){
    isChatEnable = true;

    if(_toUserId.toString() == _roundsQuestions.rUserId.toString()){
      _iAmGameOwner = false;
    }else if (toUserId.toString() == _roundsQuestions.rPlayerId.toString()){
      _iAmGameOwner = true;
    }else{
      _iAmGameOwner = true;
    }

    if(_iAmGameOwner){
      _roundsInnerModel.usersAnswers.add(Answers(message: _answer.value, type: iAmGameOwner ? 'Sender' : 'Receiver'));
    }else{
      _roundsInnerModel.usersAnswers.add(Answers(message: _answer.value, type: !iAmGameOwner ? 'Sender' : 'Receiver'));
    }


    Map<String, dynamic> body= {
      "conv_id" : _roundsQuestions.rId.toString(),
      "user_id" : _iAmGameOwner ? '0' : '1',
      "message" : _answer.value,
      "isOnline": "0",
      "type" : 'round',
      "ques_no" : '${_stepperIndex+1}'
    };
    setSate(ViewState.Busy);
    ApiBaseHelper().post(authorization: true, url: WebService.insertChat, body: body,isFormData: true).then(
            (response) async{
              setSate(ViewState.Idle);
          Map<String, dynamic> decodeJSON = jsonDecode(response);
          if(decodeJSON.containsKey('success')){
            InsertChat _insertChat = InsertChat.fromJson(decodeJSON['success']);

            if(_stepperIndex == 0){
                _roundsQuestions.rUserAnsOneStatus = 0;
                _roundsQuestions.rPlayerAnsOneStatus = 0;
            }else if(_stepperIndex == 1){
                _roundsQuestions.rUserAnsTwoStatus = 0;
                _roundsQuestions.rPlayerAnsTwoStatus = 0;
            }else{
                _roundsQuestions.rUserAnsThreeStatus = 0;
                _roundsQuestions.rPlayerAnsThreeStatus = 0;
            }

            var fromUserSocketId = await _session.socketId;
            Map<String, dynamic> roundsData = {
              'fromSocketUserId' : fromUserSocketId,
              'toSocketUserId' : _toUserSocketId,
              'roundId' : _roundsQuestions.rId.toString(),
              'questionServiceData' : _roundsQuestions.toJson(),
              'stepperIndex' : _stepperIndex.toString(),
              'answer' : _answer.value,
              "type" : 'chat',
              'isOwner' : _iAmGameOwner.toString(),
              'status' : _roundsQuestions.rStatus.toString(),
              'toUserId' : _insertChat.senderId.toString(),
              'isAnswer' : 'true'
            };
            sendAnswerThroughSocket(data: roundsData);
            _answer = ValidationModel(value: '', error: null);
            textEditingController.text = '';
            notifyListeners();
          }else{
            showToast('Some thing went wrong');
          }
        }, onError: (error){
      showToast(error.toString());
    });
  }

  //saveAnswerStatue
  saveAnswerStatus(String updateColumn){
    Map<String, dynamic> body= {
      "round_id" : _roundsQuestions.rId.toString(),
      "column" : updateColumn,
    };

    ApiBaseHelper().post(authorization: true, url: 'update_answer_status', body: body,isFormData: true).then(
            (response) async{
          Map<String, dynamic> decodeJSON = jsonDecode(response);
          if(decodeJSON.containsKey('success')){
            var fromUserSocketId = await _session.socketId;
            Map<String, dynamic> roundsData = {
              'fromSocketUserId' : fromUserSocketId,
              'toSocketUserId' : _toUserSocketId,
              'roundId' : _roundsQuestions.rId.toString(),
              'questionServiceData' : _roundsQuestions.toJson(),
              'chat' : _roundsInnerModel.usersAnswers.map<Map<String, dynamic>>((item) => item.toJson()).toList(),
              'stepperIndex' : _stepperIndex.toString(),
              'isOwner' : _iAmGameOwner.toString(),
              'status' : _roundsQuestions.rStatus.toString(),
              'toUserId' : decodeJSON['success'].toString(),
              'isAnswer' : 'false'
            };
            sendAnswerThroughSocket(data: roundsData);

            goToNextRound();
          }else{
            showToast('Some thing went wrong');
          }
        }, onError: (error){
      showToast(error.toString());
    });
  }

  sendAnswerThroughSocket({Map<String, dynamic> data}){
    _socketService.sendRoundsMessage(roundsData: data);
  }

  //NotificationCenter
  receiveMessageFromSocket(){
    DartNotificationCenter.subscribe(channel: ObserverChannelsKeys.receivedRoundsMessage, observer: this, onNotification: (roundsData)async {

        var decodedJSON = jsonDecode(roundsData);
        if(_toUserId == decodedJSON['toUserId'].toString()){
          if(decodedJSON['isAnswer'].toString() == 'true'){
            _stepperIndex = decodedJSON['stepperIndex'].toString().toInt();
            _roundsQuestions = Round.fromJson(decodedJSON['questionServiceData']);
            _iAmGameOwner = decodedJSON['isOwner'].toString().toBool();
            _toUserId = decodedJSON['toUserId'].toString();
            _roundsQuestions.rStatus = decodedJSON['status'].toString().toInt();

            if(decodedJSON['type'].toString() == 'chat'){
                isChatEnable = true;
                if(!_iAmGameOwner){
                  _roundsInnerModel.usersAnswers.add(Answers(message: decodedJSON['answer'], type: iAmGameOwner ? 'Sender' : 'Receiver'));
                }else{
                  _roundsInnerModel.usersAnswers.add(Answers(message: decodedJSON['answer'], type: !iAmGameOwner ? 'Sender' : 'Receiver'));
                }
                goToNextRound();
                notifyListeners();
            }
            else{
              _answer = ValidationModel(value: decodedJSON['answer'], error: null);
              if(_stepperIndex == 0){
                if(_iAmGameOwner && _roundsQuestions.rUserAnsOne == null){
                  _roundsQuestions.rUserAnsOne = answer.value;
                }
                if(!_iAmGameOwner && _roundsQuestions.rPlayerAnsOne == null){
                  _roundsQuestions.rPlayerAnsOne =  answer.value;
                }
              }else if(_stepperIndex == 1){
                if(_iAmGameOwner && _roundsQuestions.rUserAnsTwo == null){
                  _roundsQuestions.rUserAnsTwo =  answer.value;
                }
                if(!_iAmGameOwner && _roundsQuestions.rPlayerAnsTwo == null){
                  _roundsQuestions.rPlayerAnsTwo =  answer.value;
                }
              }else {
                if (_iAmGameOwner && _roundsQuestions.rUserAnsThree == null) {
                  _roundsQuestions.rUserAnsThree = answer.value;
                }
                if (!_iAmGameOwner && _roundsQuestions.rPlayerAnsThree == null) {
                  _roundsQuestions.rPlayerAnsThree = answer.value;
                }
              }
              findWhoOwner();
            }
          }else{
            _stepperIndex = decodedJSON['stepperIndex'].toString().toInt();
            _roundsQuestions = Round.fromJson(decodedJSON['questionServiceData']);
//            _roundsInnerModel.usersAnswers = (decodedJSON['chat'] as List<dynamic>).map<Answers>((item) => Answers.fromJson(item)).toList();
            _iAmGameOwner = !decodedJSON['isOwner'].toString().toBool();
            _toUserId = decodedJSON['toUserId'].toString();
            _roundsQuestions.rStatus = decodedJSON['status'].toString().toInt();
            showAcceptButtons();
          }
        }
        _toEnd();
      }
    );
  }
}