import 'package:app_push_notifications/Helpers/appConstants.dart';
import 'package:app_push_notifications/Helpers/importFiles.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../main.dart';

class SocketService{

  //Singleton Define
  static final SocketService _instance = SocketService._internal();
  static final NavigationService _navigationService = NavigationService();
  factory SocketService() => _instance;
  SocketService._internal();

  static String _socketUrl = 'https://api.lovedebate.co:3001/';
  static IO.Socket _socket;

  SessionManager session = SessionManager();

  createSocketConnection(){

      if(_socket == null){
        _socket = IO.io(_socketUrl, <String, dynamic>{
          'transports': ['websocket'],
          'autoConnect': false,
        });

      _socket.connect();

      _socket.on("connect", (_) async {
        print('Socket Connect');
        registerUser();
      });
      _socket.on("connect_error", (_){
        print('connect_error');
      });

      _socket.on("disconnect", (_){
        print('disconnect');
      });
      _socket.on("error", (_){
        print('error');
      });
    }
  }

  socketDisconnect(){
   _socket.disconnect();
   _socket = null;
  }

  //=======================================================================
  //========================== Register User ==============================
  //=======================================================================

  registerUser()async{
    var userId = await session.socketId;
    _socket.emit(SocketKeys.addUser, userId);
    print('register User $userId');
    getChatMessages();
    getRoundsMessage();
  }

  //=======================================================================
  //================= Check User isOnline or Offline ======================
  //=======================================================================

  checkUser({String fromSocketUserId, String toSocketUserId, bool checkFromChat = true, @required Map<String, dynamic> userData})async{
    _socket.emit(SocketKeys.checkUser, [fromSocketUserId, toSocketUserId, userData]);
    _socket.once(SocketKeys.checkUserResponse, (data){
      var context = _navigationService.navigationKey.currentState.overlay.context;
      if(checkFromChat){
        Provider.of<ChatConversationViewModel>(context, listen: false).saveAndSendMessageChatWithSocket(userData: {'isOnline': data[0] != '-1' ? true : false , 'userData' : data[1]});
      }else{

      }
    });
  }


  //=======================================================================
  //================= Send/Received Chat Message  =========================
  //=======================================================================

  sendMessage({Map<String, dynamic> chatData}){
    _socket.emit(SocketKeys.checkUser, [chatData['fromSocketUserId'], chatData['toSocketUserId']]);
    _socket.once(SocketKeys.checkUserResponse, (data){
      if(data != '-1'){
        _socket.emit(SocketKeys.sendMessage, [chatData]);
      }
    });
  }

  getChatMessages(){
    _socket.on(SocketKeys.receivedMessage, (data){
      var context = _navigationService.navigationKey.currentState.overlay.context;
      Provider.of<ChatConversationViewModel>(context, listen: false).getChatMessagesFromSocket(message: data);
    });
  }


  //=======================================================================
  //================= Send/Received Rounds Message ========================
  //=======================================================================

  sendRoundsMessage({Map<String, dynamic> roundsData}){
    _socket.emit(SocketKeys.checkUser, [roundsData['fromSocketUserId'], roundsData['toSocketUserId']]);
    _socket.once(SocketKeys.checkUserResponse, (data){
      if(data[0] != '-1'){
        _socket.emit(SocketKeys.sendRoundsMessage, [roundsData]);
      }
    });
  }

  getRoundsMessage(){
    _socket.on(SocketKeys.receivedRoundsMessage, (data){
      DartNotificationCenter.post(channel: ObserverChannelsKeys.receivedRoundsMessage, options: data);
    });
  }

}