//TODO: Internal Libraries
export 'package:flutter/material.dart';
export 'package:flutter/gestures.dart';
export 'dart:async';
export 'dart:convert';
export 'dart:io';
export 'dart:math';

//TODO: Routes
export 'package:app_push_notifications/PageRouting/router.dart';

//TODO: External Third Party Libraries
export 'package:url_launcher/url_launcher.dart';
export 'package:get_it/get_it.dart';
export 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
export 'package:material_segmented_control/material_segmented_control.dart';
export 'package:google_maps_webservice/geocoding.dart';
export 'package:image_cropper/image_cropper.dart';
export 'package:image_picker/image_picker.dart';
export 'package:oktoast/oktoast.dart';
export 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
export 'package:dart_notification_center/dart_notification_center.dart';
export 'package:transparent_image/transparent_image.dart';
export 'package:provider/provider.dart';
export 'package:firebase_messaging/firebase_messaging.dart';
export 'package:shared_preferences/shared_preferences.dart';
export 'package:flutter_facebook_login/flutter_facebook_login.dart';
export 'package:google_sign_in/google_sign_in.dart';
export 'package:pin_code_text_field/pin_code_text_field.dart';
export 'package:file_picker/file_picker.dart';
export 'package:flutter_google_places/flutter_google_places.dart';
export 'package:flutter_password_strength/flutter_password_strength.dart';
export 'package:image_picker/image_picker.dart';


//TODO: App Screens
//Splash Screen
export 'package:app_push_notifications/Screens/SplashPage/splashPageView.dart';
export 'package:app_push_notifications/Screens/SplashPage/splashViewModel.dart';
//SignIn
export 'package:app_push_notifications/Screens/SignInPage/signInModel.dart';
export 'package:app_push_notifications/Screens/SignInPage/signInView.dart';
export 'package:app_push_notifications/Screens/SignInPage/signInViewModel.dart';
//SignUp
export 'package:app_push_notifications/Screens/SignUpWithPage/SignUpWithView.dart';
export 'package:app_push_notifications/Screens/SignUpWithPage/signUpWithViewModel.dart';
//SignIn With Personal Info
export 'package:app_push_notifications/Screens/SignUnWithPersonalInfo/signUpWithPersonalInfoView.dart';
export 'package:app_push_notifications/Screens/SignUnWithPersonalInfo/signUpWithPersonalInfoViewModel.dart';
//SignIn Account Info
export 'package:app_push_notifications/Screens/SignUpAccountInfoPage/signUpAccountInfoView.dart';
export 'package:app_push_notifications/Screens/SignUpAccountInfoPage/signUpAccountInfoViewModel.dart';
//Forgot Password
export 'package:app_push_notifications/Screens/ForgotPassword/forgotPasswordView.dart';
export 'package:app_push_notifications/Screens/ForgotPassword/forgotPasswordViewModel.dart';
//Email Verification
export 'package:app_push_notifications/Screens/EmailVerification/emailVerification.dart';
//TabBarController
export 'package:app_push_notifications/Screens/tabBarcontroller.dart';
//PreMatches
export 'package:app_push_notifications/Screens/PreMatches/preMatchesModel.dart';
export 'package:app_push_notifications/Screens/PreMatches/preMatchesView.dart';
export 'package:app_push_notifications/Screens/PreMatches/preMatchesViewModel.dart';
//Matched Users
export 'package:app_push_notifications/Screens/Matched/matchedView.dart';
export 'package:app_push_notifications/Screens/Matched/matchedViewModel.dart';
//Chat User List
export 'package:app_push_notifications/Screens/Chat/ChatUsers/chatUsersModel.dart';
export 'package:app_push_notifications/Screens/Chat/ChatUsers/chatUsersListView.dart';
export 'package:app_push_notifications/Screens/Chat/ChatUsers/chatUsersListViewModel.dart';
//Chat Conversation
export 'package:app_push_notifications/Screens/Chat/ChatConversation/chatConversationModel.dart';
export 'package:app_push_notifications/Screens/Chat/ChatConversation/chatConversationView.dart';
export 'package:app_push_notifications/Screens/Chat/ChatConversation/chatConversationViewModel.dart';
//ProfileViewModel
export 'package:app_push_notifications/Screens/Profile/profileView.dart';
export 'package:app_push_notifications/Screens/Profile/profileViewModel.dart';
//Categories
export 'package:app_push_notifications/Screens/Categories/categoriesView.dart';
export 'package:app_push_notifications/Screens/Categories/categoryModel.dart';
export 'package:app_push_notifications/Screens/Categories/categoriesViewModel.dart';
//Rounds
export 'package:app_push_notifications/Screens/Rounds/roundsModel.dart';
export 'package:app_push_notifications/Screens/Rounds/roundsView.dart';
export 'package:app_push_notifications/Screens/Rounds/roundsViewModel.dart';
//BasicInfo
export 'package:app_push_notifications/Screens/BasicInfo/basicInfoViewModel.dart';
export 'package:app_push_notifications/Screens/BasicInfo/basicInfoView.dart';
//Account Settings
export 'package:app_push_notifications/Screens/AccountSettings/accountSettingsView.dart';
export 'package:app_push_notifications/Screens/AccountSettings/accountSettingsViewModel.dart';
//Other Profile
export 'package:app_push_notifications/Screens/OtherProfile/OtherProfile.dart';


//TODO: Model
export 'package:app_push_notifications/Models/AnswersModel.dart';
export 'package:app_push_notifications/Models/NewQuestionModel.dart';
export 'package:app_push_notifications/Models/UserDetailModel.dart';
export 'package:app_push_notifications/Models/QaOptions.dart';
export 'package:app_push_notifications/Models/CheckBoxDataModel.dart';


//TODO: Components
export 'package:app_push_notifications/Components/chat.dart';
export 'package:app_push_notifications/Components/chat_bubble.dart';
export 'package:app_push_notifications/Components/chat_detail_page_appbar.dart';


//TODO: CustomDialogs
//CheckBoxList Dialog
export 'package:app_push_notifications/CustomDialogs/CheckBoxDialogBox/checkBoxListDialogBoxView.dart';
export 'package:app_push_notifications/CustomDialogs/CheckBoxDialogBox/checkBoxListDialogBoxViewModel.dart';
//Google Places Dialog
export 'package:app_push_notifications/CustomDialogs/GooglePlacesDialogBox/googlePlacesDialogBoxView.dart';
export 'package:app_push_notifications/CustomDialogs/GooglePlacesDialogBox/googlePlacesDialogBoxViewModel.dart';
export 'package:app_push_notifications/CustomDialogs/GooglePlacesDialogBox/googlePlacesDialogBoxModels.dart';
//RadioList Dialog
export 'package:app_push_notifications/CustomDialogs/RadioListDialogBox/radioListDialogBoxView.dart';
export 'package:app_push_notifications/CustomDialogs/RadioListDialogBox/radioListDialogBoxViewModel.dart';
//Slider Dialog
export 'package:app_push_notifications/CustomDialogs/SliderDialogBox/SliderDialogBoxView.dart';
export 'package:app_push_notifications/CustomDialogs/SliderDialogBox/sliderDialogBoxViewModel.dart';
//Height Dialog
export 'package:app_push_notifications/CustomDialogs/HeightDialogBox/heightDialogBoxViewModel.dart';
export 'package:app_push_notifications/CustomDialogs/HeightDialogBox/heightDialogBoxView.dart';
//Date Picker
export 'package:app_push_notifications/CustomDialogs/IOSDatePicker/iOSDatePicker.dart';
export 'package:app_push_notifications/CustomDialogs/IOSDatePicker/iOSDatePicker.dart';
//Camera Dialog
export 'package:app_push_notifications/CustomDialogs/CameraDialog/galleryDialogBoxView.dart';



//TODO: Helpers Classes
export 'package:app_push_notifications/Helpers/appConstants.dart';
export 'package:app_push_notifications/Helpers/sharedPref.dart';
export 'package:app_push_notifications/Helpers/webService.dart';

//TODO: Utils
export 'package:app_push_notifications/Utils/Controllers/ApiBaseHelper.dart';
export 'package:app_push_notifications/Utils/GlobalModels.dart';
export 'package:app_push_notifications/Utils/MyExtensions.dart';
export 'package:app_push_notifications/Utils/Designables/CustomButtons.dart';
export 'package:app_push_notifications/Utils/Designables/CustomTextFeilds.dart';
export 'package:app_push_notifications/Utils/Designables/CustomRadioButtons.dart';
export 'package:app_push_notifications/Utils/Controllers/Loader.dart';
export 'package:app_push_notifications/Utils/Designables/CustomAppBar.dart';
export 'package:app_push_notifications/Utils/Designables/Toast.dart';
export 'package:app_push_notifications/Utils/Controllers/AppExceptions.dart';
export 'package:app_push_notifications/Utils/Controllers/AppExceptions.dart';




//Services
export 'package:app_push_notifications/Services/navigationService.dart';
export 'package:app_push_notifications/Services/socketService.dart';
export 'package:app_push_notifications/Services/pushNotificationService.dart';
export 'package:app_push_notifications/Services/localNotificationService.dart';