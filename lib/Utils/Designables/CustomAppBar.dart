import 'package:app_push_notifications/Helpers/importFiles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'dart:io' show Platform;

//class CustomAppbars{
//
//
//  static AppBar setNavigation(String title){
//     return AppBar(
//      centerTitle: true,
//      title: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600,color:  Colors.black),) ,
//      elevation: 0.0,
//      iconTheme: IconThemeData(color: Colors.black,),
//      backgroundColor: Colors.white,
//      automaticallyImplyLeading: true,
//    );
//  }
//
//
//  static AppBar setNavigationWithOutBack(String title){
//    return AppBar(
//      centerTitle: true,
//      automaticallyImplyLeading: false,
//      title: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600,color:  Colors.black),) ,
//      elevation: 0.0,
//      iconTheme: IconThemeData(color: Colors.black,),
//      backgroundColor: Colors.white,
//      leading: Platform.isIOS ? BackButton(color: AppColors.firstColor) : null,
//    );
//  }
//}

class CustomAppBar extends StatelessWidget with PreferredSizeWidget{
  final String title;
  CustomAppBar({this.title = ''});
  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(100),
      child: AppBar(
        title: Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600,color:  Colors.black),)
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
