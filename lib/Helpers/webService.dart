class WebService{

//  static var baseURL = "https://lovedebate.co/api/";
  static var baseURL = "https://lovedebate.co/public/api/";
  static var imageBaseURL = 'https://lovedebate.co/public/assets/images/profile/';
  static var registerUser = "register";
  ///Login without Token
  
  static var data = "data";
  static var answers = "answers";
  static var test = "test";
  static var prematches = "prematches";
  
  static var sendVerificationCode = "send_verification_code";
  static var verifyEmail = "email_verified";
  static var deleteUser = "delete_user";

  static var socialLogin = "social_login";
  static var updateProfile = "update_profile";
  static var updatePassword = "update_password";
  static var logout = "logout";
  static var roundCategories = "get_round_categories";

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
  static var readAllMessage = 'read_all_message';
  static var getNotifications = 'get_notification';
  static var matchesList = 'matches';

  static var uploadProfileImage = "image_upload";
  
  
  //My Changes
  static var login = "login";
  static var listOfQuestions = "questions/1";
  static var userDetails = "userDetail";
}

class HttpMethod{
  static String post = "post";
  static String get = 'get';
}
