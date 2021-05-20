import 'package:app_push_notifications/Helpers/importFiles.dart';
import 'package:app_push_notifications/Services/localNotificationService.dart';

bool isNotification = false;

class PushNotificationService {
  static final PushNotificationService _instance = PushNotificationService._internal();
  factory PushNotificationService() => _instance;
  PushNotificationService._internal();

  static FirebaseMessaging _fcm;

  final NavigationService _navigationService = NavigationService();
  final LocalNotificationService _localNotificationService =
      LocalNotificationService();
  SessionManager session = SessionManager();

  Future initPushNotification() async {
    if(_fcm == null){
      _fcm = FirebaseMessaging();
      if (Platform.isIOS) {
        // request permissions if we're on android
        iOSPermission();
      }

      _fcm.configure(
        // Called when the app is in the foreground and we receive a push notification
        onMessage: (Map<String, dynamic> message) async {
          isNotification = true;
          _serialiseAndNavigate(msg: message, onLaunch: false);
        },
        // Called when the app has been closed comlpetely and it's opened
        // from the push notification.
        onLaunch: (Map<String, dynamic> message) async {
          isNotification = true;
          _serialiseAndNavigate(msg: message);
        },
        // Called when the app is in the background and it's opened
        // from the push notification.
        onResume: (Map<String, dynamic> message) async {
          print('onResume: $message');
          isNotification = true;
          _serialiseAndNavigate(msg: message, onLaunch: false);
        },
      );
      _fcm.getToken().then((String token) {
        assert(token != null);
        print("Push Messaging token: $token");
        if (token != null) {
          session.saveFcmToken(token: token);
        }
      });
    }
  }

  void iOSPermission() {
    _fcm.requestNotificationPermissions(IosNotificationSettings(
        sound: true, badge: true, alert: true, provisional: false));
    _fcm.onIosSettingsRegistered.listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }

  void refreshToken() {
    _fcm.deleteInstanceID();
    _fcm.onTokenRefresh.listen((newToken) {
      print("New Token: $newToken");
      if (newToken != null) {
        session.saveFcmToken(token: newToken);
      }
    });
  }

  void _serialiseAndNavigate({Map<String, dynamic> msg, bool onLaunch = true}) {
    if (Platform.isIOS) {
      if (msg['type'] == 'chat') {
        //Chat Notifications Handling
        onLaunch ? iOSChatNotification(msg) : generateLocalNotification(msg);
      } else {
        //Rounds Notifications Handling
        onLaunch ? iOSRoundsNotification(msg) : generateLocalNotification(msg);
      }
    } else {
      if (msg['data']['type'] == 'chat') {
        //Chat Notifications Handling
        onLaunch ? androidChatNotification(msg) : generateLocalNotification(msg);
      } else {
        //Rounds Notifications Handling
        onLaunch ? androidRoundsNotification(msg) : generateLocalNotification(msg);
      }
    }
  }

  iOSChatNotification(Map<String, dynamic> message) {
    _navigationService.navigateWithOutBack(TabBarControllerRoute, arguments: {'tabIndex' : '1', 'notificationFor' : 'chat', 'data' : {
      'soc_id' : message['soc_id'],
      'conv_id' : message['conv_id'],
      'sender_id' : message['sender_id'],
      'sender_img' : message['sender_img'],
      'title' : message['aps']['alert']['title']
    }});
  }

  androidChatNotification(Map<String, dynamic> message) {
    _navigationService.navigateWithOutBack(TabBarControllerRoute, arguments: {'tabIndex' : '1', 'notificationFor' : 'chat', 'data' : {
      'soc_id' : message['data']['soc_id'],
      'conv_id' : message['data']['conv_id'],
      'sender_id' : message['data']['sender_id'],
      'sender_img' : message['data']['sender_img'],
      'title' : message['notification']['title']
    }});
  }

  iOSRoundsNotification(Map<String, dynamic> message) {
    _navigationService.navigateWithOutBack(TabBarControllerRoute, arguments: {'tabIndex' : '2', 'notificationFor' : 'rounds', 'data' : {
      'toUserId': message["id"],
      'toUserSocketId' : message['soc_id'],
      'toUserName': message['name'],
      'catId': message["cate"],
    }});
  }

  androidRoundsNotification(Map<String, dynamic> message) {
    _navigationService.navigateWithOutBack(TabBarControllerRoute, arguments: {'tabIndex' : '2', 'notificationFor' : 'chat', 'data' : {
      'toUserId': message['data']["id"],
      'toUserSocketId' : message['data']['soc_id'],
      'toUserName': message['data']['name'],
      'catId': message['data']["cate"],
    }});
  }

  generateLocalNotification(Map<String, dynamic> message) {
    String title, body, type, convId, senderId, senderImg;

    if (Platform.isIOS) {
      if (message['type'] == 'chat') {
        title = message['aps']['alert']['title'];
        body = message['aps']['alert']['body'];
        type = message['type'] ?? '';
        convId = message['conv_id'];
        senderId = message['sender_id'];
        senderImg = message['sender_img'] ?? '';
        _localNotificationService
            .showNotification(title: title, body: body, payload: {
          'title': title,
          'type': type,
          'conv_id': convId,
          'sender_id': senderId,
          'sender_img': senderImg
        });
      } else {
        //Roundes Local Notifications Handle
        _localNotificationService.showNotification(
            title: message['aps']['alert']['title'],
            body: message['aps']['alert']['body'],
            payload: {
              'id': message['id'],
              'cate': message['cate'],
              'name': message['name'],
              'socId' : message['soc_id']
            });
      }
    } else {
      if (message['data']['type'] == 'chat') {
        title = message['notification']['title'];
        body = message['notification']['body'];
        type = message['data']['type'] ?? '';
        convId = message['data']['conv_id'];
        senderId = message['data']['sender_id'];
        senderImg = message['data']['sender_img'] ?? '';
        _localNotificationService.showNotification(
            title: message['notification']['title'],
            body: message['notification']['body'],
            payload: {
              'title': title,
              'type': type,
              'conv_id': convId,
              'sender_id': senderId,
              'sender_img': senderImg
            });
      } else {
        _localNotificationService.showNotification(
            title: message['notification']['title'],
            body: message['notification']['body'],
            payload: {
              'id': message['data']['id'],
              'cate': message['data']['cate'],
              'name': message['data']['name'],
              'socId' : message['data']['soc_id']
            });
      }
    }
  }
}
