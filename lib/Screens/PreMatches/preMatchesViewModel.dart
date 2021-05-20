import 'package:app_push_notifications/Helpers/importFiles.dart';

class PrematchesViewModel with ChangeNotifier implements LoaderState{

  List<Matches> _listOfMatches = List<Matches>();
  List<Matches> _listOfRejectedMatches = List<Matches>();

  List<Matches> get listOfMatches => _listOfMatches;
  List<Matches> get listOfRejectedMatches => _listOfRejectedMatches;

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

  PrematchesViewModel(){
    getPreMatches();
  }

  Future<bool> getPreMatches() async {
    Map<String, dynamic> body = {};
    setSate(ViewState.Busy);
    ApiBaseHelper().get(authorization: true, url: WebService.prematches,body: body,isFormData: false).then(
            (response){
              setSate(ViewState.Idle);
              Map<String, dynamic> decodeJSON = jsonDecode(response);
              if(decodeJSON.containsKey('success')){
                _listOfMatches.clear();
                _listOfRejectedMatches.clear();

                PreMatchesModel preMatches = PreMatchesModel.fromJson(decodeJSON["success"]);
                _listOfMatches = preMatches.active;
                _listOfRejectedMatches =preMatches.rejected;
                // decodeJSON["success"].forEach((decodedUser) {
                //   var user = Matches.fromJson(decodedUser);
                //   if(user.rStatus == 0){
                //     _listOfRejectedMatches.add(user);
                //   }else{
                //     _listOfMatches.add(user);
                //   }
                // });
                notifyListeners();
              }else{
                showToast('Something went wrong');
              }
        }, onError: (error){
      setSate(ViewState.Idle);
      showToast(error.toString());
    });
    return false;
  }
}