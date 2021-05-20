import 'package:app_push_notifications/Helpers/importFiles.dart';



class ChatUsersListViewModel with ChangeNotifier implements LoaderState{

  List<ChatUserModel> _listOfChatUsers = List<ChatUserModel>();
  List<ChatUserModel> _searchListOfChatUsers = List<ChatUserModel>();

  List<ChatUserModel> get listOfChatUsers => _listOfChatUsers;
  List<ChatUserModel> get searchListOfChatUsers => _searchListOfChatUsers;

  //=======================================================================
  //================= LoaderState Abstract Implement ======================
  //=======================================================================

  @override
  ViewState _state;

  @override
  // TODO: implement viewState
  ViewState get viewState => _state;

  @override
  void setSate(ViewState state) {
    // TODO: implement setSate
    _state = state;
    notifyListeners();
  }

  ChatUsersListViewModel(){
    getChatUsers();
  }

  onChangeText(String value){
    _searchListOfChatUsers =_listOfChatUsers.where((user){
      return user.userName.toLowerCase().contains(value.toLowerCase());
    }).toList();
    notifyListeners();
  }

  Future<bool> getChatUsers() async {
    Map<String, dynamic> body= {};
    setSate(ViewState.Busy);
      ApiBaseHelper().post(authorization: true, url: WebService.chatUsersList,body: body,isFormData: true).then(
        (response) async{
          setSate(ViewState.Idle);
          Map<String, dynamic> decodeJSON = jsonDecode(response);
          if(decodeJSON.containsKey('success')){
            _listOfChatUsers.clear();
            decodeJSON["success"].forEach((v) {
              _listOfChatUsers.add(ChatUserModel.fromJson(v));
            });
            _searchListOfChatUsers = _listOfChatUsers;
            notifyListeners();
          }else{
            showToast(decodeJSON['error'].toString());
          }
    }, onError: (error){
          setSate(ViewState.Idle);
          showToast(error.toString());
      });
    return false;
  }
}