import 'package:app_push_notifications/Helpers/importFiles.dart';

class CategoryViewModel with ChangeNotifier implements LoaderState{

  SessionManager _sessionManager = SessionManager();
  List<CategoryModel> _listOfCategories = List<CategoryModel>();
  List<CategoryModel> get listOfCategories => _listOfCategories;
  String _toUserId;
  
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

  CategoryViewModel({String toUserId}){
    _toUserId = toUserId;
    getCategories();
  }

  // getCategoriesFromSession()async{
  //   var listOfQuestions = await _sessionManager.getAppData();
  //   _listOfCategories = listOfQuestions.listOfCategories;
  //   notifyListeners();
  // }

  getCategories(){
    Map<String, dynamic> body = {
      'user_id' : _toUserId
    };
    setSate(ViewState.Busy);
    ApiBaseHelper().post(authorization: true, url: WebService.roundCategories,body: body,isFormData: false).then(
            (response) async{
              setSate(ViewState.Idle);
              Map<String, dynamic> decodedJSON = jsonDecode(response);
              if(decodedJSON.containsKey('success')){
                decodedJSON["success"].forEach((v) {
                  _listOfCategories.add(CategoryModel.fromJson(v));
                });
                // await _sessionManager.saveCategories(listOfCategories: _listOfCategories);
                notifyListeners();
              }else{
                showToast('Something went wrong');
              }
        }, onError: (error){
      setSate(ViewState.Idle);
        showToast('Something went wrong');
    });
  }
  
}