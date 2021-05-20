import 'package:app_push_notifications/Helpers/importFiles.dart';
class ChatUserModel {
  int cId;
  String socketId;
  int userId;
  String userName;
  String profilePic;
  String lastMsg;
  String lastMsgDate;
  int unReadMessages;

  ChatUserModel(
      {this.cId,
        this.socketId,
        this.userId,
        this.userName,
        this.profilePic,
        this.lastMsg,
        this.lastMsgDate, this.unReadMessages});

  ChatUserModel.fromJson(Map<String, dynamic> json) {
    cId = json['c_id'];
    socketId = json['socket_id'];
    userId = json['user_id'];
    userName = json['userName'];
    profilePic = json['profilePic'];
    lastMsg = json['last_msg'];
    lastMsgDate = json['last_msg_date'];
    unReadMessages = json['unreadMsgs'] != null ? json['unreadMsgs'].toString().toInt() : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['c_id'] = this.cId;
    data['socket_id'] = this.socketId;
    data['user_id'] = this.userId;
    data['userName'] = this.userName;
    data['profilePic'] = this.profilePic;
    data['last_msg'] = this.lastMsg;
    data['last_msg_date'] = this.lastMsgDate;
    data['unreadMsgs'] = this.unReadMessages;
    return data;
  }
}