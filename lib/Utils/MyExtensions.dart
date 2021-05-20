import 'package:intl/intl.dart';

extension StringExtensions on String {

  int toInt(){
    return int.parse(this);
  }

  double toDouble(){
    return double.parse(this);
  }

  bool toBool() {
    var value = this.toLowerCase();
    if(value == 'true') {
      return true;
    }else{
      return false;
    }
  }

  String toCapitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }

  DateTime toDateTime({String dateFormat = "yyyy-MM-dd HH:mm:ss"}){
    DateFormat _dateFormat = DateFormat(dateFormat);
    return _dateFormat.parse(this);
  }

  String get calculateAge{
    return (DateTime.now().difference(DateTime.parse(this)).inDays/365).floor().toString();
  }

  String get validateEmail {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if(this == ''){
      return 'Email is required';
    }
    else if (!regex.hasMatch(this))
      return 'Enter Valid Email';
    else
      return null;
  }

  String get validatePassword{
    String  pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = new RegExp(pattern);
    if(this == ''){
      return 'Password is required';
    }else{
      return null;
    }
  }
}


extension DateTimeExtension on DateTime{
  String toDateString({String dateFormat = 'MMM dd, yyyy hh:mm a'}){
    DateFormat _dateFormat = DateFormat(dateFormat);
    return _dateFormat.format(this);
  }


}

class ValidatorType {
  static final RegExp email = RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
  static final RegExp password = RegExp(r'^(?=.*)(.){8,15}$’');
}