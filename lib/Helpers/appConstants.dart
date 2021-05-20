import 'package:app_push_notifications/Helpers/importFiles.dart';

class AppColors{
  static var firstColor =  Color(0xFFFB6D6C);
  static var secondColor = Color(0xFF666F80);
}

class AppFonts{
  static var textFontSize = 17.0 ;
  static var navFontSize = 24.0 ;
}

class AppServices{
  
  static var baseURL = "https://lovedebate.co/public/api/";
  static var registerUser = "register";
  ///Login without Token
  static var login = "login";
  static var onboardingApi = "questions/1";
  static var data = "data";
  static var answers = "answers";
  static var test = "test";
  static var prematches = "prematches";
  static var userAnswers = "userDetail";

  static var socialLogin = "social_login";
  static var updateProfile = "update_profile";
  static var updatePassword = "update_password";
  static var logout = "logout";
  static var roundCategories = "categories/1";

  ///Rounds Module Api's
  static var updateStatusDecline = "update_status"; ///parameters Should be { status : 1 , round_id : r_id.....}
  static var answerRound = "question_answer";  ///{cate_id' => 'required','id','question_id','answer','q1' 'q2','q3'};
//  static var rounds = "questions/2";
  static var makeConnection = "make_connection";
  static var rounds = "rounds";

  static var chatUsersList = 'conv_list';
  static var conversationList = 'user_chat';
  static  var forgotPassword = 'forgot_password';
  static var insertChat = 'send_message';

  static var uploadProfileImage = "image_upload";

}

class SessionKeys{
  static String firebaseToken = 'firebaseToken';
  static String authToken = 'authToken';
  static String usersInfo = 'userInfo';
  static String heights = 'heights';
  static String appData = 'questionsModel';
  static String listOfQuestion = 'listOfQuestion';
  static String listOfAnswers = 'listOfAnswers';
  static String listOfCategorise = 'listOfCategories';

  static String usersDetails = 'userDetails';
  static String notifications = "notifications";


  static String question = "question";
  static String answers = "answers";
}

class ObserverChannelsKeys{
  static String isUserOnlineChat = 'isUserOnlineChat';
  static String isUserOnlineRounds = 'isUserOnlineRounds';
  static String receivedChatMessage = 'receivedChatMessage';
  static String receivedRoundsMessage = 'receivedRoundsMessage';
}

class SocketKeys{
  static String addUser = 'adduser_ld';
  static String checkUser = 'check_user_ld';
  static String checkUserResponse = 'msg_user_found_ld';
  static String sendMessage = 'msg_user_ld';
  static String receivedMessage = 'msg_user_handle_ld';
  static String sendRoundsMessage = 'msg_rounds_user_ld';
  static String receivedRoundsMessage = 'msg_rounds_user_handle_ld';
}