import 'package:app_push_notifications/Helpers/importFiles.dart';


class HeightDialogBoxViewModel with ChangeNotifier{

  String _selectedValue;
  List<dynamic> _tempHeight;

  NavigationService _navigationService = NavigationService();
  SessionManager _sessionManager = SessionManager();
  List<CheckBoxDataModel> _listOfHeights = List<CheckBoxDataModel>();

  List<CheckBoxDataModel> get listOfHeights => _listOfHeights;
  String get selectedValue => _selectedValue;
  
  HeightDialogBoxViewModel(){
    loadHeightsFromSession();
  }

  onChangedValue(CheckBoxDataModel height){
    _selectedValue = _listOfHeights.firstWhere((item) => item.title == height.title).value;
    notifyListeners();
  }

  onDoneButton(){
    var index = _listOfHeights.indexWhere((item) => item.title == _selectedValue);
    _navigationService.pop(data: _tempHeight[index]);
  }
  
  loadHeightsFromSession()async{
    _tempHeight = await _sessionManager.getListOfHeights();
    _tempHeight.forEach((height) {
      _listOfHeights.add(CheckBoxDataModel(title: height.split('/')[1], value: height.split('/')[1]));
    });
    notifyListeners();
  }
}

class HeightsArray {
  List<String> array;
  HeightsArray({this.array});
  HeightsArray.fromJson(Map<String, dynamic> json) {
    array = json["heightArray"].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['heightArray'] = this.array;
    return data;
  }
}