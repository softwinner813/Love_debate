import 'package:app_push_notifications/Helpers/importFiles.dart';
class RoundsModel {
  Round rounds;
  int quesNo;
  String alreadyConnected;
  List<RoundsChat> roundsChat;

  RoundsModel({this.rounds, this.quesNo});

  RoundsModel.fromJson(Map<String, dynamic> json) {
    rounds =
    json['rounds'] != null ? new Round.fromJson(json['rounds']) : null;
    alreadyConnected = json['connected'];
    quesNo = json['ques_no'];
     if (json['rounds_chat'] != null) {
       roundsChat = new List<RoundsChat>();
       json['rounds_chat'].forEach((v) {
         roundsChat.add(new RoundsChat.fromJson(v));
       });
     }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.rounds != null) {
      data['rounds'] = this.rounds.toJson();
    }
    data['ques_no'] = this.quesNo;
     if (this.roundsChat != null) {
       data['rounds_chat'] = this.roundsChat.map((v) => v.toJson()).toList();
     }
    return data;
  }
}

class Round {
  int rId;
  int rCateId;
  int rUserId;
  int rPlayerId;
  int rQuesOneId;
  int rQuesTwoId;
  int rQuesThreeId;
  String rPlayerAnsOne;
  String rPlayerAnsTwo;
  String rPlayerAnsThree;
  String rUserAnsOne;
  String rUserAnsTwo;
  String rUserAnsThree;
  int rStatus;
  Null createdAt;
  String updatedAt;
  int rPlayerAnsOneStatus;
  int rPlayerAnsTwoStatus;
  int rPlayerAnsThreeStatus;
  int rUserAnsOneStatus;
  int rUserAnsTwoStatus;
  int rUserAnsThreeStatus;
  String questionOne;
  String questionTwo;
  String questionThree;

  Round(
      {this.rId,
        this.rCateId,
        this.rUserId,
        this.rPlayerId,
        this.rQuesOneId,
        this.rQuesTwoId,
        this.rQuesThreeId,
        this.rPlayerAnsOne,
        this.rPlayerAnsTwo,
        this.rPlayerAnsThree,
        this.rUserAnsOne,
        this.rUserAnsTwo,
        this.rUserAnsThree,
        this.rStatus,
        this.createdAt,
        this.updatedAt,
        this.rPlayerAnsOneStatus,
        this.rPlayerAnsTwoStatus,
        this.rPlayerAnsThreeStatus,
        this.rUserAnsOneStatus,
        this.rUserAnsTwoStatus,
        this.rUserAnsThreeStatus,
        this.questionOne,
        this.questionTwo,
        this.questionThree});

  Round.fromJson(Map<String, dynamic> json) {
    rId = json['r_id'];
    rCateId = json['r_cate_id'];
    rUserId = json['r_user_id'];
    rPlayerId = json['r_player_id'];
    rQuesOneId = json['r_ques_one_id'];
    rQuesTwoId = json['r_ques_two_id'];
    rQuesThreeId = json['r_ques_three_id'];
    rPlayerAnsOne = json['r_player_ans_one'];
    rPlayerAnsTwo = json['r_player_ans_two'];
    rPlayerAnsThree = json['r_player_ans_three'];
    rUserAnsOne = json['r_user_ans_one'];
    rUserAnsTwo = json['r_user_ans_two'];
    rUserAnsThree = json['r_user_ans_three'];
    rStatus = json['r_status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    rPlayerAnsOneStatus = json['r_player_ans_one_status'];
    rPlayerAnsTwoStatus = json['r_player_ans_two_status'];
    rPlayerAnsThreeStatus = json['r_player_ans_three_status'];
    rUserAnsOneStatus = json['r_user_ans_one_status'];
    rUserAnsTwoStatus = json['r_user_ans_two_status'];
    rUserAnsThreeStatus = json['r_user_ans_three_status'];
    questionOne = json['questionOne'];
    questionTwo = json['questionTwo'];
    questionThree = json['questionThree'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['r_id'] = this.rId;
    data['r_cate_id'] = this.rCateId;
    data['r_user_id'] = this.rUserId;
    data['r_player_id'] = this.rPlayerId;
    data['r_ques_one_id'] = this.rQuesOneId;
    data['r_ques_two_id'] = this.rQuesTwoId;
    data['r_ques_three_id'] = this.rQuesThreeId;
    data['r_player_ans_one'] = this.rPlayerAnsOne;
    data['r_player_ans_two'] = this.rPlayerAnsTwo;
    data['r_player_ans_three'] = this.rPlayerAnsThree;
    data['r_user_ans_one'] = this.rUserAnsOne;
    data['r_user_ans_two'] = this.rUserAnsTwo;
    data['r_user_ans_three'] = this.rUserAnsThree;
    data['r_status'] = this.rStatus;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['r_player_ans_one_status'] = this.rPlayerAnsOneStatus;
    data['r_player_ans_two_status'] = this.rPlayerAnsTwoStatus;
    data['r_player_ans_three_status'] = this.rPlayerAnsThreeStatus;
    data['r_user_ans_one_status'] = this.rUserAnsOneStatus;
    data['r_user_ans_two_status'] = this.rUserAnsTwoStatus;
    data['r_user_ans_three_status'] = this.rUserAnsThreeStatus;
    data['questionOne'] = this.questionOne;
    data['questionTwo'] = this.questionTwo;
    data['questionThree'] = this.questionThree;
    return data;
  }
}

class RoundsChat {
  int chatId;
  int senderId;
  int receiverId;
  int conversationId;
  String message;
  String messageDatetime;
  int isRead;
  String type;
  int quesNo;
  String updatedAt;

  RoundsChat(
      {this.chatId,
        this.senderId,
        this.receiverId,
        this.conversationId,
        this.message,
        this.messageDatetime,
        this.isRead,
        this.type,
        this.quesNo,
        this.updatedAt});

  RoundsChat.fromJson(Map<String, dynamic> json) {
    chatId = json['chat_id'];
    senderId = json['sender_id'];
    receiverId = json['receiver_id'];
    conversationId = json['conversation_id'];
    message = json['message'];
    messageDatetime = json['message_datetime'];
    isRead = json['is_read'];
    type = json['type'];
    quesNo = json['ques_no'];
    updatedAt = json['updated_at'];
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
    data['type'] = this.type;
    data['ques_no'] = this.quesNo;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}