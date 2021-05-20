import 'package:app_push_notifications/Helpers/importFiles.dart';

class MatchedUserViewModel with ChangeNotifier implements LoaderState{

  List<Matches> _listOfMatchedUser = List<Matches>();
  List<Matches> get listOfMatchedUser => _listOfMatchedUser;

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

  MatchedUserViewModel(){
    setSate(ViewState.Idle);
    getMatchedUsers();
  }

  Future<bool> getMatchedUsers()async{
    Map<String, dynamic> body= {};
    setSate(ViewState.Busy);
      ApiBaseHelper().get(authorization: true, url: WebService.matchesList,body: body,isFormData: true).then(
      (response) async{
        setSate(ViewState.Idle);
        Map<String, dynamic> decodedJSON = jsonDecode(response);
        if(decodedJSON.containsKey('success')){
          _listOfMatchedUser.clear();
          decodedJSON["success"].forEach((v) {
            _listOfMatchedUser.add(Matches.fromJson(v));
          });
          notifyListeners();
        }else{
          showToast('Something went wrong');
        }
      }, onError: (error){
        setSate(ViewState.Idle);
        showToast('Something went wrong');
      });
      return false;
  }

}