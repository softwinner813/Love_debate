import 'package:app_push_notifications/Helpers/importFiles.dart';

String toUserId;

class ChatConversationViewModel with ChangeNotifier{

  final SessionManager session = SessionManager();
  final SocketService _socketService = SocketService();

  ScrollController _scrollController;
  ChatUserModel _chatUserModel;

  NavigationService _navigationService = NavigationService();
  LocalNotificationService _localNotificationService = LocalNotificationService();

  TextEditingController _textEditingController = TextEditingController();
  List<ChatConversationModel> _listOfMessages = List<ChatConversationModel>();

  TextEditingController get textEditingController => _textEditingController;
  List<ChatConversationModel> get listOfMessages => _listOfMessages;
  ScrollController get scrollController => _scrollController;
  ValidationModel _message = ValidationModel(value: '', error: null);

  Map<String, dynamic> _sendMsgData;

  ChatConversationViewModel({ChatUserModel chatUserModel}){
    _chatUserModel = chatUserModel;
    _scrollController = new ScrollController(                         // NEW
      initialScrollOffset: 0.0,
      keepScrollOffset: false,                                         // NEW
    );

    if(chatUserModel != null){
      getChatFromServer(chatUserModel.cId.toString(), chatUserModel.userId);
    }
  }

  onChangeMessage(String value){
    if(value == ''){
      _message = ValidationModel(value: '', error: null);
    }else{
      _message = ValidationModel(value: value, error: null);
    }
    notifyListeners();
  }

  void _toEnd() {                                                     // NEW
    Timer(Duration(milliseconds: 500), () => _scrollController.jumpTo(_scrollController.position.maxScrollExtent));
    notifyListeners();// NEW
  }

  sendMessage(){
    Map<String, dynamic> sendMessage ={
      'fromSocketUserId' : '',
      'toSocketUserId' : _chatUserModel.socketId,
      'sender_id' : '',
      'toUserId' : _chatUserModel.userId.toString(),
      'title': '',
      'conv_id' : _chatUserModel.cId.toString(),
      'message' : _message.value,
    };
    sendMessages(sendMsgData: sendMessage);
    _textEditingController.text = '';
  }

  sendMessages({Map<String, dynamic> sendMsgData})async{
    _sendMsgData = sendMsgData;
    notifyListeners();

    //Add to listOf Chat
    _listOfMessages.add(ChatConversationModel(message: _sendMsgData['message'], type: MessageType.Sender));
    _toEnd();
    
    //Save in DataBase
     insertChat();
  }

  getChatMessagesFromSocket({String message}){

    var decodeData = jsonDecode(message);
    if(toUserId == decodeData['sender_id'].toString()){
      _listOfMessages.add(ChatConversationModel(message: decodeData['message'], type: MessageType.Receiver));
      _toEnd();
      isReadMessages(decodeData['conv_id']);
    }else{
      generateLocalNotification(decodeData);
    }
  }

  getChatFromServer(String convId, int receiverId){

    _scrollController = new ScrollController(                         // NEW
      initialScrollOffset: 0.0,
      keepScrollOffset: false,                                         // NEW
    );

    toUserId = receiverId.toString();
    _listOfMessages.clear();
    Map<String, dynamic> body= {
      "conv_id" : convId,
      "offset" : "0",
      "limit" : "10000"
    };
    ApiBaseHelper().post(authorization: true, url: WebService.conversationList,body: body,isFormData: true).then(
            (response) async{
     Map<String, dynamic> decodeJSON = jsonDecode(response);
     if(decodeJSON.containsKey('success')){
       decodeJSON["success"].forEach((v) {
         _listOfMessages.add(ChatConversationModel.fromJson(v, receiverId.toString()));
       });
       notifyListeners();

       Future.delayed(Duration(milliseconds: 500), () {
         isReadMessages(convId);
         _toEnd();
       });
     }else{
       showToast(decodeJSON['error'].toString());
     }
    }, onError: (error){
       showToast(error.toString());
    });
  }

  insertChat()async{
    var fromSocketUserId = await session.socketId;
    _socketService.checkUser(fromSocketUserId: fromSocketUserId, toSocketUserId: _sendMsgData['toSocketUserId'], userData: _sendMsgData);
  }

  saveAndSendMessageChatWithSocket({Map<String, dynamic> userData})async{
    var fromSocketUserId = await session.socketId;
    var userInfo = await session.getUserInfo();

    var parseUserData = jsonDecode(userData['userData']);

    Map<String, dynamic> body= {
      "conv_id" : parseUserData['conv_id'],
      "user_id" : parseUserData['toUserId'],
      "message" : parseUserData['message'],
      "isOnline" : userData['isOnline'] ? "1" : "0"
    };

    ApiBaseHelper().post(authorization: true, url: WebService.insertChat, body: body,isFormData: true).then(
            (response) async{
          Map<String, dynamic> decodeJSON = jsonDecode(response);
          if(decodeJSON.containsKey('success')){
            InsertChat _insertChat = InsertChat.fromJson(decodeJSON['success']);
            parseUserData['fromSocketUserId'] = fromSocketUserId;
            parseUserData['sender_id'] = _insertChat.senderId;
            parseUserData['title'] = userInfo.name;
            _socketService.sendMessage(chatData: parseUserData);
          }else{
            showToast('Some thing went wrong');
          }
        }, onError: (error){
      showToast(error.toString());
    });
  }

  isReadMessages(String convId){
    Map<String, dynamic> body= {"conv_id" : convId};

    ApiBaseHelper().post(authorization: true, url: WebService.readAllMessage, body: body,isFormData: true).then(
            (response) async{
          Map<String, dynamic> decodeJSON = jsonDecode(response);
          if(decodeJSON.containsKey('success')){
            print('successfully read');
          }else{
            print('Something went wrong');
          }
        }, onError: (error){
      showToast(error.toString());
    });
  }

  generateLocalNotification(Map<String, dynamic> notificationData){
     notificationData['type'] = 'chat';
    _localNotificationService.showNotification(
      title: notificationData['title'],
      body: notificationData['message'],
      payload: notificationData,
    );
  }

  setValues(){
    toUserId = null;
    notifyListeners();
  }

  bool get isValidate{
    if(_message.value == ''){
      return false;
    }else{
      return true;
    }
  }
}

class InsertChat {
  int senderId;
  String receiverId;
  String message;
  String conversationId;
  String messageDatetime;

  InsertChat(
      {this.senderId,
        this.receiverId,
        this.message,
        this.conversationId,
        this.messageDatetime});

  InsertChat.fromJson(Map<String, dynamic> json) {
    senderId = json['sender_id'];
    receiverId = json['receiver_id'].toString();
    message = json['message'];
    conversationId = json['conversation_id'].toString();
    messageDatetime = json['message_datetime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sender_id'] = this.senderId;
    data['receiver_id'] = this.receiverId;
    data['message'] = this.message;
    data['conversation_id'] = this.conversationId;
    data['message_datetime'] = this.messageDatetime;
    return data;
  }
}

