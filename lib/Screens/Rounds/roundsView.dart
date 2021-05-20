import 'package:app_push_notifications/Helpers/importFiles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';

class RoundesView extends StatefulWidget {
  String toUserId, toUserName, catId, toUserSocketId;
  bool fromCategories;
  RoundesView({this.toUserId, this.toUserName, this.catId, this.toUserSocketId, this.fromCategories = false});
  @override
  _RoundesViewState createState() => _RoundesViewState();
}

class _RoundesViewState extends State<RoundesView> {

  ScrollController _scrollController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//    SchedulerBinding.instance.addPostFrameCallback((_) =>
//        _scrollController.jumpTo(_scrollController.position.maxScrollExtent));
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RoundsViewModel>(
      create: (_) => RoundsViewModel(toUserId: widget.toUserId, toUserName: widget.toUserName, catId: widget.catId, toUserSocketId: widget.toUserSocketId, fromCategories: widget.fromCategories),
      child: WillPopScope(
        onWillPop: (){
          if(widget.fromCategories){
            Navigator.popUntil(
              context,
              ModalRoute.withName(TabBarControllerRoute),
            );
          }else{
            Navigator.pop(context);
          }
          return;
        },
        child: SafeArea(
          bottom: true,
          child: Scaffold(
            appBar:  CustomAppBar(title: "Rounds"),
            body: Consumer<RoundsViewModel>(
              builder: (context, viewModel, child){
                return Stack(
                  children: [
                  viewModel.roundsQuestions != null ? (viewModel.isCompleted) ?
                alreadyCompleted() : Stepper(
                  type: StepperType.horizontal,
//                physics: NeverScrollableScrollPhysics(),
                  steps: [
                    Step(
                        isActive: (viewModel.stepperIndex == 0)? true: false,
                        title: Text(""),
                        content: stepperItem(viewModel: viewModel)
                    ),
                    Step(
                        isActive: (viewModel.stepperIndex == 1)? true: false,
                        title: Text(""),
                        content: stepperItem(viewModel: viewModel)
                    ),
                    Step(
                        isActive: (viewModel.stepperIndex == 2)? true: false,
                        title: Text(""),
                        content: stepperItem(viewModel: viewModel)
                    ),
                  ],
                  currentStep: viewModel.stepperIndex,
                  controlsBuilder: (BuildContext context, {VoidCallback onStepContinue, VoidCallback onStepCancel}){
                    return Row(
                      children: <Widget>[
                        Container(
                          child: null,
                        ),
                        Container(
                          child: null,
                        ),
                      ],
                    );
                  },
                ) :  Positioned.fill(child: Loading())
                  ],
                );
              },
            )
          ),
        ),
      ),
    );
  }


  Widget stepperItem({RoundsViewModel viewModel}){
    List<Widget> _chatBubbles = viewModel.roundModel.usersAnswers.map((message) => chatBubble(message)).toList();
    List<Widget> elements = [
      usersAvatars(viewModel),
      questions(viewModel),
    ];

    _chatBubbles.forEach((widget) {
      elements.add(widget);
    });

    elements.add(viewModel.isDeclined ? declinesMessage() : Container());
    elements.add(viewModel.isWaited ? waitedText() : Container(),);
    elements.add(viewModel.isCompleted ? alreadyCompleted() : Container(),);
    elements.add(acceptAndDecline(viewModel),);
    elements.add(connectAndAnOtherRoundsButtons(viewModel),);
    elements.add(textMessageAndSendButton(viewModel),);
    elements.add(SizedBox(height: 16),);

    return Stack(
      children: [
        ListView.builder(
            controller: viewModel.scrollController,
            shrinkWrap: true,
            itemCount: elements.length,
            itemBuilder: (context, index) => elements[index],
        ),
        viewModel.viewState == ViewState.Busy ? Positioned.fill(child: Loading()) : Container()
      ],
    );
  }

  Widget usersAvatars(RoundsViewModel viewModel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        avatarItem(isMe: false, userName: viewModel.toUserName),
        Text(viewModel.catName ?? '', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),),
        avatarItem(isMe: true, userName: viewModel.fromUserName),
      ],
    );
  }
  
  Widget avatarItem({bool isMe, String userName}) {
    return Container(
      height: 80,
      width: 80,
      decoration:BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: (isMe)? [Colors.orange, Colors.black]:[Colors.green, Colors.grey]),
        borderRadius: (isMe)?BorderRadius.only(
          topLeft: Radius.circular(40.0),
          bottomLeft: Radius.circular(40.0),


        ):BorderRadius.only(
          topRight: Radius.circular(40.0),
          bottomRight: Radius.circular(40.0),
        ),),
      child: Center(child: Text(userName[0],style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold, color: Colors.white),)),
    );
  }

  Widget questions(RoundsViewModel viewModel) {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Align(alignment: Alignment.centerLeft,child: Text('Question:', style: TextStyle(fontSize: 18,fontWeight:FontWeight.w800))),
            SizedBox(height: 12),
            Align(alignment: Alignment.centerLeft,child: Text(viewModel.roundModel.txtQuestion, style: TextStyle(fontSize: 16,fontWeight:FontWeight.w600))),
          ],
        ),
      );
  }

  Widget chatBubble(Answers answers){
    return Container(
      padding: EdgeInsets.only(
          left: answers.type == 'Receiver' ? 16 : 18,
          right: answers.type == 'Receiver' ? 18 : 16,
          top: 8,
          bottom: 8
      ),
      child: Stack(
        children: [
          Align(
            alignment: (answers.type == 'Receiver' ? Alignment.topLeft:Alignment.topRight),
            child: Container(
              // width: MediaQuery.of(context).size.width/1.7,
              margin: answers.type == 'Receiver' ? EdgeInsets.only(right: 40) : EdgeInsets.only(left: 40),
              decoration: BoxDecoration(
                borderRadius: answers.type != 'Receiver' ? BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomLeft: Radius.circular(23)
                ) :
                BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomRight: Radius.circular(23)),
                color: (answers.type  == 'Receiver'?Colors.grey.shade300:Colors.redAccent.shade200),
              ),
              padding: EdgeInsets.all(12),
              child: Text(answers.message, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: answers.type  == 'Receiver' ? Colors.black : Colors.white),),
            ),
          ),
        ],
      ),
    );
  }

  Widget declinesMessage(){
    return Align(alignment: Alignment.center, child: Text('This round has been rejected!', style: TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.w600)));
  }

  Widget waitedText(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(alignment: Alignment.center, child: Text('Awaiting response...', style: TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.w600))),
    );
  }

  Widget alreadyCompleted(){
    return Align(alignment: Alignment.center, child: Text('You have already played this category with ${widget.toUserName}. \n\n Please go back and choose another category.', textAlign: TextAlign.center, style: TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.w600)));
  }

  Widget acceptAndDecline(RoundsViewModel viewModel){
    return viewModel.roundModel.showAcceptButton ? Padding(
      padding: const EdgeInsets.only(top: 24, left:16.0, right: 16),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 45,
              child: CustomRaisedButton(
                  buttonText: 'Accept',
                  cornerRadius: 5,
                  textColor: Colors.white,
                  backgroundColor:AppColors.firstColor,
                  borderWith: 0,
                  action: () => viewModel.btnNextRound()
              ),
            ),
          ),

           SizedBox(width: 12),

           Expanded(
             child: SizedBox(
               height: 45,
               child: CustomRaisedButton(
                   buttonText: 'Decline',
                   cornerRadius: 5,
                   textColor: Colors.white,
                   backgroundColor: Colors.grey,
                   borderWith: 0,
                   action: () => viewModel.btnDeclineOrOtherRoundsService(status: 0)
               ),
             ),
           )
        ],
      ),
    ) :  Container();
  }

  Widget connectAndAnOtherRoundsButtons(RoundsViewModel viewModel){
    return viewModel.roundModel.completedRoundSet ? Padding(
      padding: const EdgeInsets.only(top: 24, left:16.0, right: 16),
      child: Row(
        children: [
          // Expanded(
          //   child: SizedBox(
          //     height: 45,
          //     child: CustomRaisedButton(
          //         buttonText: 'Start Another Round',
          //         cornerRadius: 5,
          //         textColor: Colors.white,
          //         backgroundColor:AppColors.firstColor,
          //         borderWith: 0,
          //         action: () => viewModel.btnDeclineOrOtherRoundsService(status: 2)
          //     ),
          //   ),
          // ),
          //
          // SizedBox(width: 12),

          Expanded(
            child: SizedBox(
              height: 45,
              child: CustomRaisedButton(
                  buttonText: viewModel.alreadyConnected ? 'Go to Matched' : 'Connect Now',
                  cornerRadius: 5,
                  textColor: Colors.white,
                  backgroundColor: AppColors.firstColor,
                  borderWith: 0,
                  action: () => viewModel.btnMakeConnectionService()
              ),
            ),
          )
        ],
      ),
    ) :  Container();
  }

  Widget textMessageAndSendButton(RoundsViewModel viewModel) {
    return viewModel.roundModel.showTextField ? Padding(
      padding: const EdgeInsets.only(top:8.0, left: 12, right: 12),
      child: Container(
        child: Row(
//          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                child: TextFormField(
                  controller: viewModel.textEditingController,
                  onChanged: (value) => viewModel.onChangeAnswer(value),
                  maxLines: null,
                  autocorrect: false,
                  style: TextStyle(fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Type Your Answer',
                    hintStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 16),
            InkWell(
              onTap: viewModel.isValidate ? () => viewModel.checkUsersOnline() : null,
              child: CircleAvatar(
                radius: 20,
                backgroundColor: viewModel.isValidate ? AppColors.firstColor : Colors.grey,
                child: Icon(Icons.send, color: Colors.white, size: 15,),
              ),
            )
          ],
        ),
      ),
    ) :  Container();
  }

}
