
enum MessageType{
  Sender,
  Receiver,
}

class ChatConversationModel {
  int chatId;
  int senderId;
  int receiverId;
  int conversationId;
  String message;
  String messageDatetime;
  int isRead;
  MessageType type;

  ChatConversationModel(
      {this.chatId,
        this.senderId,
        this.receiverId,
        this.conversationId,
        this.message,
        this.messageDatetime,
        this.isRead, this.type});

  ChatConversationModel.fromJson(Map<String, dynamic> json, String rec_Id) {
    chatId = json['chat_id'];
    senderId = json['sender_id'];
    receiverId = json['receiver_id'];
    conversationId = json['conversation_id'];
    message = json['message'];
    messageDatetime = json['message_datetime'];
    isRead = json['is_read'];

    if(senderId.toString() == rec_Id){
      this.type = MessageType.Receiver;
    }

    if(receiverId.toString() == rec_Id){
      this.type = MessageType.Sender;
    }


//    this.type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['chat_id'] = this.chatId;
    data['sender_id'] = this.senderId;
    data['receiver_id'] = this.receiverId;
    data['conversation_id'] = this.conversationId;
    data['message'] = this.message;
    data['message_datetime'] = this.messageDatetime;
    data['is_read'] = this.isRead;
    return data;
  }
}