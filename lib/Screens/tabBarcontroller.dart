import 'package:app_push_notifications/Helpers/importFiles.dart';
import 'package:app_push_notifications/Screens/UserPreferences/userPreferenceView.dart';


class TabBarControllerPage extends StatefulWidget {

  String tabIndex;
  String notificationFor;
  Map<String, dynamic> param;
  TabBarControllerPage({this.tabIndex, this.notificationFor = "", this.param});

  @override
  _TabBarControllerPageState createState() => _TabBarControllerPageState();
}

class _TabBarControllerPageState extends State<TabBarControllerPage> {

  SocketService _socketService = SocketService();
  NavigationService _navigationService = NavigationService();

  var _curIndex = 2;
  var tabBarChildren = [
    MatchedView(),
    ChatUsersListView(),
    PreMatchesView(),
    UserPreferencesView(),
    // Notifications(),

    ProfileView(),
  ];

  Color FloatingbtnSelected=AppColors.firstColor;

  var bloc;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _socketService.createSocketConnection();

    DartNotificationCenter.unregisterChannel(channel: ObserverChannelsKeys.isUserOnlineChat);
    DartNotificationCenter.unregisterChannel(channel: ObserverChannelsKeys.receivedChatMessage);
    DartNotificationCenter.unregisterChannel(channel: ObserverChannelsKeys.isUserOnlineRounds);
    DartNotificationCenter.unregisterChannel(channel: ObserverChannelsKeys.receivedRoundsMessage);

    DartNotificationCenter.registerChannel(channel: ObserverChannelsKeys.isUserOnlineChat);
    DartNotificationCenter.registerChannel(channel: ObserverChannelsKeys.receivedChatMessage);
    DartNotificationCenter.registerChannel(channel: ObserverChannelsKeys.isUserOnlineRounds);
    DartNotificationCenter.registerChannel(channel: ObserverChannelsKeys.receivedRoundsMessage);

    if(widget.tabIndex != null){
      setState(() {
        _curIndex = widget.tabIndex.toInt();
      });
    }

    //Notification Handling
    Future.delayed(Duration(seconds: 3), () {
      if(widget.notificationFor == 'rounds'){
          _navigationService.navigateWithPush(RoundsRoute, arguments: {
            'toUserId': widget.param["id"],
            'toUserSocketId' : widget.param['soc_id'],
            'toUserName': widget.param['name'],
            'catId': widget.param["cate"],
          });
      }else if(widget.notificationFor == 'chat'){
        widget.notificationFor = "";
        ChatUserModel _chatUserModel = ChatUserModel();
        _chatUserModel.socketId = widget.param['soc_id'];
        _chatUserModel.cId = widget.param['conv_id'].toString().toInt();
        _chatUserModel.userId = widget.param['sender_id'].toString().toInt();
        _chatUserModel.profilePic = widget.param['sender_img'];
        _chatUserModel.userName = widget.param['title'];
          _navigationService.navigateWithPush(ChatConversationRoute, arguments: _chatUserModel);
      }
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.favorite,size: 30, color: Colors.white,),
        backgroundColor: FloatingbtnSelected,
        onPressed: (){
          setState(() {
            _curIndex = 2;
            if(_curIndex==2){
              FloatingbtnSelected=AppColors.firstColor;
              _curIndex=2;
            }
            else{
              FloatingbtnSelected=Colors.blueGrey;
            }
          });
        },

      ),

      body:Center(
        child:tabBarChildren[_curIndex],
      ),
      bottomNavigationBar: bottomNavigationBar(),
    );
  }


  Widget bottomNavigationBar() => BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      //backgroundColor: Colors.white,
      currentIndex: _curIndex,
      unselectedItemColor: Colors.blueGrey,
      selectedItemColor: AppColors.firstColor,

      onTap: (index){
        setState(() {
          _curIndex = index;
          if(_curIndex==2){
            FloatingbtnSelected=AppColors.firstColor;
          }
          else{
            FloatingbtnSelected=Colors.blueGrey;
          }
        });
      },
      items:[

        barItem(icon:Icons.person_outline,title: 'Matched'),
        barItem(icon:Icons.chat,title: 'Chat'),
        barItem( title: ""),
        barItem(icon: Icons.room_preferences, title:'Preferences', ),
        barItem(icon:Icons.menu, title:'More'),
      ]
  );

  BottomNavigationBarItem barItem({IconData icon , String title}){
    return BottomNavigationBarItem(
      icon: Icon(icon, size: 25,),
      title: Text(title, style: TextStyle(fontSize: 12),),
    );
  }


}