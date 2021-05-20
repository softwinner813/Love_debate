import 'package:flutter/cupertino.dart';
import 'package:app_push_notifications/Helpers/importFiles.dart';

// ignore: must_be_immutable
class CategoriesView extends StatefulWidget {
  String toUserId, toUserName, toUserSocketId;
  CategoriesView({this.toUserId, this.toUserName, this.toUserSocketId});
  @override
  _CategoriesViewState createState() => _CategoriesViewState();
}

class _CategoriesViewState extends State<CategoriesView> {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CategoryViewModel>(
      create: (_) =>  CategoryViewModel(toUserId: widget.toUserId),
      child: Scaffold(
        appBar: CustomAppBar(title: "Categories"),
        body: Consumer<CategoryViewModel>(
          builder: (context, viewModel, child){
            return Stack(
              children: [
                ListView(
                  children: viewModel.listOfCategories.map((category) => CategoriesItem(category: category, toUserId: widget.toUserId, toUserName: widget.toUserName, toUserSocketId: widget.toUserSocketId)).toList(),
                ),
                viewModel.viewState == ViewState.Busy ? Positioned.fill(child: Loading()) : Container()
              ],
            );
          },
        ),
      ),
    );
  }
}

class CategoriesItem extends StatelessWidget {
  final CategoryModel category;
  final String toUserId, toUserName, toUserSocketId;
  CategoriesItem({this.toUserId, this.toUserName, this.category, this.toUserSocketId});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        NavigationService _navigationService = NavigationService();
        _navigationService.navigateWithPush(RoundsRoute, arguments: {'toUserId':toUserId.toString(), 'toUserName': toUserName, 'catId' : category.cId.toString(), 'toUserSocketId' : toUserSocketId, 'fromCategories' : "true"});
      },
      child: Card(
        elevation: 1,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(child: Text(category.cName, style: TextStyle(
                fontSize:18,
                fontWeight: FontWeight.w500,
                color: Colors.black,),)),
              Icon(Icons.navigate_next, size: 25, color: AppColors.firstColor,),
            ],
          ),
        ),
      ),
    );
  }
}
