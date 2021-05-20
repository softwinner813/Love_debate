import 'package:app_push_notifications/Helpers/importFiles.dart';

class SignInModel {
  bool alreadLogin;
  String token;
  User user;

  SignInModel({this.token, this.user});

  SignInModel.fromJson(Map<String, dynamic> json) {
    alreadLogin = json['already_exist'];
    token = json['token'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    return data;
  }
}

class User {
  String socId;
  String name;
  String email;
  String dob;
  double height;
  int gender;
  int status;
  int onboadingStatus;

  User(
      {this.socId,
        this.name,
        this.email,
        this.dob,
        this.height,
        this.gender,
        this.status,
        this.onboadingStatus});

  User.fromJson(Map<String, dynamic> json) {
    socId = json['soc_id'];
    name = json['name'];
    email = json['email'];
    dob = json['dob'];
    height = json['height'] != null ? json['height'].toString().toDouble() : null;
    gender = json['gender'] != null ?  json['gender'].toString().toInt() : null;
    status = json['status'] != null ?  json['status'].toString().toInt() : null;
    onboadingStatus = json['onboading_status'] != null ?  json['onboading_status'] : 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['soc_id'] = this.socId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['dob'] = this.dob;
    data['height'] = this.height;
    data['gender'] = this.gender;
    data['status'] = this.status;
    data['onboading_status'] = this.onboadingStatus;
    return data;
  }
}