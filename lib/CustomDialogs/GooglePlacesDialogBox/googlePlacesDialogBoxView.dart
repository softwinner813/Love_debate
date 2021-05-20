import 'package:app_push_notifications/Helpers/importFiles.dart';

class GooglePlacesDialogBoxView extends StatefulWidget {
  final Questions question;
  final String address;
  GooglePlacesDialogBoxView({@required this.question, @required this.address});
  @override
  _GooglePlacesDialogBoxViewState createState() => _GooglePlacesDialogBoxViewState();
}

class _GooglePlacesDialogBoxViewState extends State<GooglePlacesDialogBoxView> {


  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GooglePlacesDialogBoxViewModel>(
      create: (_) => GooglePlacesDialogBoxViewModel(widget.question, widget.address),
      child: Consumer<GooglePlacesDialogBoxViewModel>(
        builder: (context, viewModel, child){
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5))
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 40,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search Address',
                        contentPadding: EdgeInsets.symmetric(vertical: 1, horizontal: 16),
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide(
                              width: 1,
                              style: BorderStyle.solid,
                            )
                        ),
                      ),
                      onChanged: (value) => viewModel.onChangeText(value),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  height: 5*50.0,
                  child: ListView(
                   children: viewModel.listOfPredictedPlaces.map((places){
                     return InkWell(
                       onTap: () => viewModel.onSelectedItem(places.placeId),
                       child: Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           Padding(
                             padding: const EdgeInsets.only(left: 8, right: 8),
                             child: Text(places.description, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),),
                           ),
                           Divider(thickness: 1.5,)
                         ],
                       ),
                     );
                   }).toList(),
                  ),
                ),
                SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }
}
