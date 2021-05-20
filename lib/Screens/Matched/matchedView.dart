import 'package:app_push_notifications/Helpers/importFiles.dart';
import 'package:flutter/cupertino.dart';

class MatchedView extends StatefulWidget {
  final bool fromRounds;
  MatchedView({this.fromRounds = false});
  @override
  _MatchedViewState createState() => _MatchedViewState();
}

class _MatchedViewState extends State<MatchedView> {

  NavigationService _navigationService = NavigationService();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        if(widget.fromRounds){
          Navigator.popUntil(context, ModalRoute.withName(TabBarControllerRoute));
        }
        return;
      },
      child: ChangeNotifierProvider(
        create: (_) => MatchedUserViewModel(),
        child: Scaffold(
          appBar: CustomAppBar(title: 'Matched Users'),
          body: Consumer<MatchedUserViewModel>(
            builder: (context, viewModel, child){
              return Stack(
                children: [
                  RefreshIndicator(onRefresh: () => viewModel.getMatchedUsers(),child:ListView(children: viewModel.listOfMatchedUser.map((matches){
                    return PreMatchesItem(matches: matches, onTap: (){
                      // _navigationService.navigateWithPush(OtherProfilesRoute, arguments: matches.prUserId.toString());
                      Navigator.push(context, CupertinoPageRoute(builder: (context) => OtherProfile(userId: matches.prUserId.toString(), catId: matches.cateId.toString(), convId: matches.convId.toString(),))).then((value) => viewModel.getMatchedUsers());
                    });
                  }).toList(),)),
                  viewModel.viewState == ViewState.Idle  && viewModel.listOfMatchedUser.length == 0 ? Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: InkWell(
                      onTap: () => viewModel.getMatchedUsers(),
                      child: Center(
                        child: Text(
                          'No Matched User Found\n\nTap To Refresh',
                          maxLines: null,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey.shade500
                          ),
                          textAlign: TextAlign.center,
                        ),),
                    ),
                  ) : Container(),
                  viewModel.viewState == ViewState.Busy ? Positioned.fill(child: Loading()) : Container()
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}




