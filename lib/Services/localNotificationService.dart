import 'package:app_push_notifications/Helpers/importFiles.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService{

  static final LocalNotificationService _instance = LocalNotificationService._internal();

  factory LocalNotificationService() => _instance;

  LocalNotificationService._internal();

  final NavigationService _navigationService = NavigationService();

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  initLocalNotification(){
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var initializeSettingForAndroid = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializeSettingForIOS = new IOSInitializationSettings(onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    var initializeSettings = new InitializationSettings(initializeSettingForAndroid, initializeSettingForIOS);
    flutterLocalNotificationsPlugin.initialize(initializeSettings,onSelectNotification: selectNotification);
  }

  showNotification({String title, String body, Map<String, dynamic> payload}) async{
    var androidChannelSpecifics =  AndroidNotificationDetails(
        'channel_ID', 'channel name', 'channel description',
        importance:  Importance.Max ,
        priority: Priority.High ,
        ticker: 'test ticker' );
    var iosChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(androidChannelSpecifics,iosChannelSpecifics);
    await  flutterLocalNotificationsPlugin.show(0, title, body, platformChannelSpecifics, payload: jsonEncode(payload));
  }

  Future selectNotification(String payload) async{
    Map<String, dynamic> mapPayload = jsonDecode(payload);

    if (mapPayload['type'] == 'chat'){
     ChatUserModel _userModel = ChatUserModel();
     _userModel.cId = mapPayload['conv_id'].toString().toInt();
     _userModel.userName = mapPayload['title'];
     _userModel.userId = mapPayload['sender_id'].toString().toInt();
     _navigationService.navigateWithPush(ChatConversationRoute, arguments: _userModel);
    }else{
      Map<String, dynamic> param = jsonDecode(payload);
      _navigationService.navigateWithPush(RoundsRoute, arguments:{'toUserId' : param['id'], 'catId' : param['cate'], 'catName' : param['cateName'],'toUserName' : param['name'], 'toUserSocketId' : param['socId'],});
    }
  }

  //Used in the case of IOS....
  Future onDidReceiveLocalNotification(int id, String title, String body, String payload)async{
    Map<String, dynamic> mapPayload = jsonDecode(payload);
    if(mapPayload.containsKey('type')){

    }else{

    }
    //push to any view
    print("Payloadssss"+payload);
    print("Receiveddd heerrreee");
  }
}