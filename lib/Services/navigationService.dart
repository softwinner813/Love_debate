import 'package:flutter/material.dart';

class NavigationService {

  static final NavigationService _instance = NavigationService._internal();

  factory NavigationService() => _instance;

  NavigationService._internal();

  GlobalKey<NavigatorState> _navigationKey = GlobalKey<NavigatorState>();

  GlobalKey<NavigatorState> get navigationKey => _navigationKey;


  navigateWithPush(String routeName, {dynamic arguments}) {
    return _navigationKey.currentState.pushNamed(routeName, arguments: arguments);
  }

  navigateWithOutBack(String routeName, {dynamic arguments}) {
    return _navigationKey.currentState.pushNamedAndRemoveUntil(routeName,(Route<dynamic> route) => false, arguments: arguments);
  }

  pop({var data}) {
    return _navigationKey.currentState.pop(data);
  }

  popUntil(String routeName, {dynamic arguments}) {
    return _navigationKey.currentState.popUntil((Route<dynamic> route){
      bool shouldPop = false;
      if(route.settings.name == routeName){
        shouldPop = true;
      }
      return shouldPop;
    });
  }
}
