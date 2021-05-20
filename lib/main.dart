import 'package:app_push_notifications/Helpers/importFiles.dart';
import 'package:app_push_notifications/Screens/Rounds/roundsViewModel.dart';
import 'package:apple_sign_in/apple_sign_in.dart';

String CHANNEL_NAME = 'receivedMessage';


class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}

void main() async{
  HttpOverrides.global = new MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  final appleSignInAvailable = await AppleSignInAvailable.check();

  DartNotificationCenter.registerChannel(channel: ObserverChannelsKeys.isUserOnlineChat);
  DartNotificationCenter.registerChannel(channel: ObserverChannelsKeys.receivedChatMessage);
  DartNotificationCenter.registerChannel(channel: ObserverChannelsKeys.isUserOnlineRounds);
  DartNotificationCenter.registerChannel(channel: ObserverChannelsKeys.receivedRoundsMessage);

  runApp(Provider<AppleSignInAvailable>.value(
    value: appleSignInAvailable,
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<SplashViewModel>(create: (context) => SplashViewModel()),
        ChangeNotifierProvider<SignUpWithViewModel>(create: (context) => SignUpWithViewModel()),
        ChangeNotifierProvider<ChatUsersListViewModel>(create: (context) => ChatUsersListViewModel()),
        ChangeNotifierProvider<RoundsViewModel>(create: (context) => RoundsViewModel()),
        ChangeNotifierProvider<ChatConversationViewModel>(create: (context) => ChatConversationViewModel()),
      ],
      child: OKToast(
        textStyle: TextStyle(fontSize: 16.0, color: Colors.white),
        backgroundColor: AppColors.firstColor,
        radius: 10.0,
        position: ToastPosition.bottom,
        duration: Duration(seconds: 5),
        child: MaterialApp(
            title: 'Love Debate',
            debugShowCheckedModeBanner: false,
            navigatorKey: NavigationService().navigationKey,
            onGenerateRoute: generateRoute,
            home:  SplashScreen(),
            theme: ThemeData(
              primaryColor: AppColors.firstColor,
              accentColor: AppColors.firstColor,
              colorScheme: ColorScheme.light(primary: AppColors.firstColor),
              appBarTheme: AppBarTheme(
                elevation: 0.0,
                iconTheme: IconThemeData(color: AppColors.firstColor),
                color: Colors.white,
                centerTitle: true,
              )
            ),
        ),
      ),
    );
  }
}



class AppleSignInAvailable {
  AppleSignInAvailable(this.isAvailable);
  final bool isAvailable;

  static Future<AppleSignInAvailable> check() async {
    return AppleSignInAvailable(await AppleSignIn.isAvailable());
  }
}