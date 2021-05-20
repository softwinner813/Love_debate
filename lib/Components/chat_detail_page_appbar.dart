
import 'package:flutter/cupertino.dart';
import 'package:app_push_notifications/Helpers/importFiles.dart';

class ChatDetailPageAppBar extends StatelessWidget implements PreferredSizeWidget{
  ChatUserModel user;
  ChatDetailPageAppBar({this.user});
  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      flexibleSpace: SafeArea(
        child: Container(
          padding: EdgeInsets.only(right: 16),
          child: Row(
            children: <Widget>[
              IconButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back,color: Colors.black,),
              ),
              SizedBox(width: 2,),
              Container(
                padding:
                EdgeInsets.all(1.0), // Add 1.0 point padding to create border
                height: 60, // ProfileImageSize = 50.0;
                width: 60,
                child: (user.profilePic != null && user.profilePic != 'null') ? ClipOval(
                  child: Image.network(
                      "https://lovedebate.co/public/assets/images/profile/thumb_${user.profilePic}",
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
                  child: Text(user.userName[0], style: TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold)),
                  backgroundColor: AppColors.firstColor,
                  radius: 30,
                ),
              ),
              // user.profilePic != "null" && user.profilePic != null ? CircleAvatar(
              //   backgroundImage: NetworkImage("https://lovedebate.co/public/assets/images/profile/thumb_${user.profilePic}"),
              //   maxRadius: 20,
              // ) :
              // CircleAvatar(maxRadius: 20, child: Text(user.userName[0], style: TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold),), backgroundColor: AppColors.firstColor),
              SizedBox(width: 12,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(user.userName,style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
//                    SizedBox(height: 6,),
//                    Text("Online",style: TextStyle(color: Colors.green,fontSize: 12),),
                  ],
                ),
              ),
              // Icon(Icons.more_vert,color: Colors.grey.shade700,),
            ],
          ),
        ),
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}