import 'package:app_push_notifications/Helpers/importFiles.dart';
import 'package:app_push_notifications/Models/UserDetailModel.dart';
import 'package:app_push_notifications/Screens/AccountSettings/accountSettingsView.dart';
import 'package:app_push_notifications/Screens/BasicInfo/basicInfoView.dart';
import 'package:app_push_notifications/Screens/EmailVerification/emailVerification.dart';
import 'package:app_push_notifications/Screens/ForgotPassword/forgotPasswordView.dart';
import 'package:app_push_notifications/Screens/Matched/matchedView.dart';
import 'package:app_push_notifications/Screens/Rounds/roundsView.dart';
import 'package:app_push_notifications/Screens/SignUpAccountInfoPage/signUpAccountInfoView.dart';
import 'package:app_push_notifications/Screens/UserPreferences/userPreferenceView.dart';

import 'package:flutter/foundation.dart';

const String SignInRoute = '/login';
const String SignUpRoute = '/signUp';
const String ForgotPasswordRoute = '/forgotPassword';
const String EmailVerificationRoute = '/emailVerification';
const String SignUpWithPersonalInfoRoute = '/signUpWithPersonalInfo';
const String SignUpAccountInfoRoute = '/signUpAccountInfo';
const String UserPreferencesViewRoute = '/userPreferences';
const String TabBarControllerRoute = '/tabBarController';
const String CategoryRoute = '/category';
const String RoundsRoute = '/rounds';
const String BasicInfoRoute = '/basicInfo';
const String AccountSettingsRoute = '/accountSetting';
const String OtherProfilesRoute = '/otherProfile';
const String ChatUserListRoute = '/chatUserList';
const String ChatConversationRoute = '/chatConversation';



Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case SignInRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: SignInView(),
      );
    case SignUpRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: SignUpWithView(),
      );
    case SignUpWithPersonalInfoRoute:
      var param = settings.arguments as Map ?? Map<String, dynamic>();
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: SignUpWithPersonalInfoView(
            user: param['user'] ?? null,
            isSocialLogin: param['isSocialLogin'] ?? false),
      );
    case SignUpAccountInfoRoute:
      var param = settings.arguments as Map;
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: SignUpAccountInfoView(parameter: param),
      );

    case ForgotPasswordRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: ForgotPasswordView(),
      );
    case EmailVerificationRoute:
      var parameter = settings.arguments as Map;
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: EmailVerification(
            email: parameter['email'], verificationCode: parameter['code']),
      );
    case TabBarControllerRoute:
      var param = settings.arguments as Map;
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: TabBarControllerPage(tabIndex: param['tabIndex'] ?? "2", notificationFor: param['notificationFor'] ?? "", param: param['data'] ?? null),
      );
    case CategoryRoute:
      var param = settings.arguments as Map;
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: CategoriesView(
            toUserId: param['toUserId'],
            toUserName: param['toUserName'],
            toUserSocketId: param['toUserSocketId']),
      );
    case RoundsRoute:
      var param = settings.arguments as Map;
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: RoundesView(
            toUserId: param['toUserId'],
            toUserName: param['toUserName'],
            catId: param['catId'],
            toUserSocketId: param['toUserSocketId'], fromCategories: param['fromCategories'].toString().toBool() ?? false),
      );

    case ChatUserListRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: ChatUsersListView(),
      );

    case ChatConversationRoute:
      var param = settings.arguments as ChatUserModel;
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: ChatDetails(chatUser: param),
      );

    case BasicInfoRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: BasicInfoView(),
      );

    case AccountSettingsRoute:
      var email  = settings.arguments as String;
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: AccountSettingsView(forgotEmail: email ?? '',),
      );

    case OtherProfilesRoute:
      var userId = settings.arguments as String;
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: OtherProfile(userId: userId),
      );


    case UserPreferencesViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: UserPreferencesView(),
      );


    default:
      return MaterialPageRoute(
          builder: (_) => Scaffold(
                body: Center(
                    child: Text('No route defined for ${settings.name}')),
              ));
  }
}

PageRoute _getPageRoute({String routeName, Widget viewToShow}) {
  return MaterialPageRoute(
      settings: RouteSettings(
        name: routeName,
      ),
      builder: (_) => viewToShow);
}
