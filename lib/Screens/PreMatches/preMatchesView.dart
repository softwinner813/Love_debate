import 'package:app_push_notifications/Helpers/importFiles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PreMatchesView extends StatefulWidget {
  @override
  _PreMatchesViewState createState() => _PreMatchesViewState();
}

class _PreMatchesViewState extends State<PreMatchesView> {
  int _currentSelection = 0;
  Map<int, Widget> _children = {
    0: Text('Active'),
    1: Text('Rejected'),
  };
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PrematchesViewModel>(
      create: (_) => PrematchesViewModel(),
      child: Consumer<PrematchesViewModel>(
        builder: (context, viewModel, child){
          return Scaffold(
            appBar: AppBar(
              title: Text('Pre-Matches', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600,color:  Colors.black)),
              bottom:  viewModel.listOfRejectedMatches.length > 0 ? PreferredSize(
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 48,
                          // color: Colors.lightGreenAccent,
                          child: CupertinoSegmentedControl(
                              children: _children,
                              groupValue: this._currentSelection,
                              onValueChanged: (value) {
                                this.setState(() => this._currentSelection = value);
                              }),
                        ),
                      )
                    ],
                  ),
                  preferredSize: Size(double.infinity, 48)) : null,
            ),
            body: Stack(
              children: [
                RefreshIndicator(
                  onRefresh: () => viewModel.getPreMatches(),
                  color: AppColors.firstColor,

                  child: ListView(
                      children: _currentSelection == 0 ? viewModel.listOfMatches.map((preMatch){
                        return PreMatchesItem(matches: preMatch, onTap: (){
                          NavigationService _navigationService = NavigationService();
                          var _completedRoundes = preMatch.completedRounds != null ? 'Sets Completed: ${preMatch.completedRounds}' : "";
                          if(_completedRoundes == '') {
                            if (preMatch.roundNo == null && preMatch.cateId == null) {
                              _navigationService.navigateWithPush(CategoryRoute, arguments: {
                                'toUserId': preMatch.prUserId.toString(),
                                'toUserName': preMatch.firstName,
                                'toUserSocketId' : preMatch.socId
                              }).then((value) => viewModel.getPreMatches());
                            } else {
                              _navigationService.navigateWithPush(RoundsRoute, arguments: {
                                'catId': preMatch.cateId.toString(),
                                'toUserId': preMatch.prUserId.toString(),
                                'toUserName': preMatch.firstName,
                                'toUserSocketId' : preMatch.socId
                              }).then((value) => viewModel.getPreMatches());
                            }
                          }else{
                            _navigationService.navigateWithPush(OtherProfilesRoute, arguments: preMatch.prUserId.toString());
                          }
                        });
                      }).toList():
                      viewModel.listOfRejectedMatches.map((preMatch){
                        return PreMatchesItem(matches: preMatch, onTap: (){
                          NavigationService _navigationService = NavigationService();
                          var _completedRoundes = preMatch.completedRounds != null ? 'Sets Completed: ${preMatch.completedRounds}' : "";
                          // if(_completedRoundes == '') {
                          //   if (preMatch.roundNo == null && preMatch.cateId == null) {
                          //     _navigationService.navigateWithPush(CategoryRoute, arguments: {
                          //       'toUserId': preMatch.prUserId.toString(),
                          //       'toUserName': preMatch.firstName,
                          //       'toUserSocketId' : preMatch.socId
                          //     }).then((value) => viewModel.getPreMatches());
                          //   } else {
                          //     _navigationService.navigateWithPush(RoundsRoute, arguments: {
                          //       'catId': preMatch.cateId.toString(),
                          //       'toUserId': preMatch.prUserId.toString(),
                          //       'toUserName': preMatch.firstName,
                          //       'toUserSocketId' : preMatch.socId
                          //     }).then((value) => viewModel.getPreMatches());
                          //   }
                          // }else{
                          //   _navigationService.navigateWithPush(OtherProfilesRoute, arguments: preMatch.prUserId.toString());
                          // }
                        });
                      }).toList()
                  ),
                ),
                viewModel.viewState == ViewState.Idle  && viewModel.listOfMatches.length == 0 ? Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Text(
                      'No Pre-Matches Found... \n \n Please change your preferences to see if you can find a pre-match',
                      maxLines: null,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey.shade500
                      ),
                      textAlign: TextAlign.center,
                    ),),
                ) : Container(),
                viewModel.viewState == ViewState.Busy ? Positioned.fill(child: Loading()) : Container()
              ],
            ),
          );
        },
      ),
    );
  }
}




class PreMatchesItem extends StatefulWidget {
  final Matches matches;
  final VoidCallback onTap;
  PreMatchesItem({@required this.matches, this.onTap});

  @override
  _PreMatchesItemState createState() => _PreMatchesItemState();
}

class _PreMatchesItemState extends State<PreMatchesItem> {

  var heightString = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getHeight();
  }

  getHeight()async{
    SessionManager _sessionManager = SessionManager();
    var _tempHeights = await _sessionManager.getListOfHeights();
    heightString = _tempHeights.firstWhere((height) => height.split('/')[0] == widget.matches.height.toStringAsFixed(2).toString(), orElse: () => null);
    heightString = heightString.split('/')[1];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    //Partner response awaited...
    var _completedRoundes = widget.matches.completedRounds != null ? 'Sets Completed: ${widget.matches.completedRounds}' : "";
    var _roundStart = widget.matches.roundNo != null ? 'Playing Round: ${widget.matches.roundNo}' : "Start Round";
    var _title = _completedRoundes != '' ?  widget.matches.firstName+' '+widget.matches.lastName : _roundStart;
    var _gender = widget.matches.gender == 1 ? 'Male' : 'Female';
    var _age  = widget.matches.dob.calculateAge +' years';
    var _height =  heightString;
    var _city = widget.matches.city ?? "";
    var _state = widget.matches.state ?? "";
    var _address  = _city != '' && _state != '' ? _city +' '+_state : 'No Address Found';

    return InkWell(
      onTap: widget.onTap,
      child: Card(
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              profileAvatar(),
              SizedBox(width: 12),
              profilesDetails(_title, _gender, _age, _height, _address, _completedRoundes),
              SizedBox(width: 8,),
              Icon(Icons.navigate_next,size: 35,color: AppColors.firstColor),
            ],
          ),
        ),

      ),
    );
  }

  Widget profilesDetails(String _title, String _gender, String _age, String _heigth, String _address, String _completedRoundes) {
    return Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ///Completed Rounds....
                  Text(_title, maxLines: 1,style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700 ,color:Color(0xff2E3032)),),
                  SizedBox(height: 4),

                  ///age, gender, Height....
                  Text("$_gender,  $_age,  $_heigth",style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color:Color(0xff2E3022))),
                  SizedBox(height: 4),
                  ///addresss
                  Text(_address,style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color:Color(0xff2E3022)), overflow: TextOverflow.ellipsis,),
                  SizedBox(height: 4),
                  _completedRoundes != '' ? Text(_completedRoundes, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color:Colors.grey), overflow: TextOverflow.ellipsis,) : Container(),

                ],
              ),
            );
  }

  Widget profileAvatar() {
    return Stack(
              children: <Widget>[
                Container(
                  padding:
                  EdgeInsets.all(1.0), // Add 1.0 point padding to create border
                  height: 70, // ProfileImageSize = 50.0;
                  width: 70,
                  child: (widget.matches.completedRounds != null && widget.matches.profilePic != null) ? ClipOval(
                    child: Image.network(
                        "https://lovedebate.co/public/assets/images/profile/thumb_${widget.matches.profilePic}",
                        fit: BoxFit.fill,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              valueColor: new AlwaysStoppedAnimation<Color>(
                                  Theme.of(context).primaryColor),
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes
                                  : null,
                            ),
                          );
                        }),
                  ) : CircleAvatar(
                    child: Text(widget.matches.firstName[0] ?? '', style: TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold)),
                    backgroundColor: widget.matches.backgroundColor,
                    radius: 30,
                  ),
                ),
                // CircleAvatar(
                //   backgroundImage: NetworkImage("https://lovedebate.co/public/assets/images/profile/thumb_${widget.matches.profilePic}"),
                //   radius: 30,
                // ):CircleAvatar(
                //   child: Text(widget.matches.firstName[0] ?? '', style: TextStyle(fontSize: 26, color: Colors.white, fontWeight: FontWeight.bold)),
                //   backgroundColor: widget.matches.backgroundColor,
                //   radius: 30,
                // )
              ],
            );
  }
}




