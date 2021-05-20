import 'dart:convert';
import 'package:app_push_notifications/Helpers/importFiles.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:app_push_notifications/Helpers/webService.dart';
import 'dart:io';
import 'AppExceptions.dart';


class ApiBaseHelper {
  final String _baseUrl = WebService.baseURL;
  SessionManager session = SessionManager();
  Future<dynamic> fetchService({String method,String url,bool authorization = false, dynamic body, bool isFormData}) async {
    var _header;
    if (authorization){
      _header = {
        'Content-Type' : (isFormData) ? 'application/x-www-form-urlencoded' : 'application/json',
        'Authorization' : 'Bearer '+await session.authToken,
      };
    }else{
      _header = {
        'Content-Type' : (isFormData) ? 'application/x-www-form-urlencoded' : 'application/json',
      };
    }
    print("url : ${_baseUrl + url}");
    print(_header);
    if (method == HttpMethod.post){
      if(isFormData != true){
        body = json.encode(body);
      }
      print(body);
      var responseJson;
      try {
        final response = await http.post(_baseUrl + url, headers: _header, body: body);
        responseJson = _returnResponse2(response);
      } on SocketException {
        throw FetchDataException('No Internet connection');
      }
      return responseJson ;
    }else if (method == HttpMethod.get){
      var responseJson;
      try {
        final response = await http.get(_baseUrl + url, headers: _header);
        responseJson = _returnResponse2(response);
      } on SocketException {
        throw FetchDataException('No Internet connection');
      }
      return responseJson;
    }
  }

  Future<dynamic> post({String url, bool authorization = false, dynamic body, bool isFormData}) async {
    var _header = authorization ?
    {'Content-Type' : (isFormData) ? 'application/x-www-form-urlencoded' : 'application/json',
      'Authorization' : 'Bearer '+await session.authToken,} :
    {'Content-Type' : (isFormData) ? 'application/x-www-form-urlencoded' : 'application/json'};

    if(isFormData != true){
      body = json.encode(body);
    }

    var responseJson;
    try {
      final response = await http.post(_baseUrl + url, headers: _header, body: body);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> get({String url, bool authorization = false, dynamic body, bool isFormData}) async {
    var _header = authorization ?
    {'Content-Type' : (isFormData) ? 'application/x-www-form-urlencoded' : 'application/json',
      'Authorization' : 'Bearer '+await session.authToken,} :
    {'Content-Type' : (isFormData) ? 'application/x-www-form-urlencoded' : 'application/json'};

    if(isFormData != true){
      body = json.encode(body);
    }

    var responseJson;
    try {
      final response = await http.get(_baseUrl + url, headers: _header);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }



  /// front_user_id, trip_id, images
 Future<dynamic> uploadFile(File imageFile) async {
    print("1-${DateTime.now().toString()}-${imageFile.path.split('/').last}");
    var postUri = Uri.parse("http://demo.themlmglobal.com/project101/appguide/wizardstep_20");
    var request = new http.MultipartRequest("POST", postUri);
    request.fields['front_user_id'] = '195';
    request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));



    var res = await request.send();
    return res;
  }

 Future<dynamic> uploadFile1(File  imageFile) async{
    Response response;
    FormData formData = new FormData.fromMap({
      "front_user_id": "195",
      "image": await MultipartFile.fromFile(imageFile.path,filename: "1-${DateTime.now().toString()}-${imageFile.path.split('/').last}"),
    });
    response = await Dio().post("http://demo.themlmglobal.com/project101/appguide/wizardstep_3",
      data: formData,
      onSendProgress: (int send, int total){print("Send: ${send}, Total: ${total} ");},
    );



    print("The result is: ${response.statusCode}");
    print("The response is: ${response}");
//    print(jsonDecode(response["result"]["userdata"]));
  }

}

dynamic _returnResponse2(http.Response response) {
  switch (response.statusCode) {
    case 200:
      return response;
      break;
    case 400:
      throw BadRequestException(response.body.toString());
    case 401:
      return response;
    case 403:
      throw UnauthorisedException(response.body.toString());
    case 500:
    default:
      throw FetchDataException(
          ' ${response.reasonPhrase} with StatusCode : ${response.statusCode}');
  }
}

dynamic _returnResponse(http.Response response) {
  switch (response.statusCode) {
    case 200:
      return response.body.toString();
      break;
    case 400:
      throw BadRequestException(response.body.toString());
    case 401:
      return response.body.toString();
      break;
//      throw UnauthorisedException(response.body.toString());
    case 403:
      throw UnauthorisedException(response.body.toString());
    case 500:
    default:
      throw FetchDataException(
          ' ${response.reasonPhrase} with StatusCode : ${response.statusCode}');
  }
}