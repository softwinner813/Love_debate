import 'package:app_push_notifications/Helpers/importFiles.dart';

class ChatUsersListItem extends StatefulWidget{
  ChatUserModel chatUser;
  VoidCallback onTap;
  ChatUsersListItem({@required this.chatUser, this.onTap});
  @override
  _ChatUsersListItemState createState() => _ChatUsersListItemState();
}

class _ChatUsersListItemState extends State<ChatUsersListItem> {

  var bgColor;
  var foregroundColor;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bgColor = Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
    foregroundColor = Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding: EdgeInsets.only(left: 16,right: 16,top: 10,bottom: 10),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  Container(
                    padding:
                    EdgeInsets.all(1.0), // Add 1.0 point padding to create border
                    height: 60,
                    width: 60,// ProfileImageSize = 50.0;
                    child: (widget.chatUser.profilePic != null && widget.chatUser.profilePic != 'null') ? ClipOval(
                      child: Image.network(
                          "https://lovedebate.co/public/assets/images/profile/thumb_${widget.chatUser.profilePic}",
                          fit: BoxFit.fill,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                valueColor: new AlwaysStoppedAnimation<Color>(
                                    Theme.of(context).primaryColor),
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes
                                    : null,
                              ),
                            );
                          }),
                    ) : CircleAvatar(
                        child: Text(widget.chatUser.userName[0], style: TextStyle(fontSize: 22, color: foregroundColor, fontWeight: FontWeight.bold)),
                        backgroundColor: bgColor,
                        radius: 30,
                      ),
                  ),
                  // CircleAvatar(
                  //   backgroundImage: NetworkImage("https://lovedebate.co/public/assets/images/profile/thumb_${widget.chatUser.profilePic}"),
                  //   radius: 30,
                  // ):CircleAvatar(
                  //   child: Text(widget.chatUser.userName[0], style: TextStyle(fontSize: 22, color: foregroundColor, fontWeight: FontWeight.bold)),
                  //   backgroundColor: bgColor,
                  //   radius: 30,
                  // ),
                  SizedBox(width: 16,),
                  Expanded(
                    child: Container(
                      color: Colors.transparent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(widget.chatUser.userName, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                          widget.chatUser.lastMsg != null ?Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(widget.chatUser.lastMsg,style: TextStyle(fontSize: 14,color: Colors.grey.shade500),),
                          ) : Container(),
                        ],
                      ),
                    ),
                  ),
                  widget.chatUser.unReadMessages != null && widget.chatUser.unReadMessages > 0 ?
                      CircleAvatar(
                        radius: 12,
                        backgroundColor: AppColors.firstColor,
                        child: Text("${widget.chatUser.unReadMessages}", style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w400),),
                  ): Container()
                ],
              ),
            ),
//            Text(widget.chatUser.lastMsgDate,style: TextStyle(fontSize: 12,color: widget.chatUsers.isMessageRead?Colors.pink:Colors.grey.shade500),),
          ],
        ),
      ),
    );
  }
}