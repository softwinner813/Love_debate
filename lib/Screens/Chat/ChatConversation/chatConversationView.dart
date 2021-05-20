import 'package:app_push_notifications/Helpers/importFiles.dart';
import 'package:flutter/services.dart';

class ChatDetails extends StatefulWidget {
  final ChatUserModel chatUser;

  const ChatDetails({Key key, this.chatUser}) : super(key: key);
  @override
  _ChatDetailsState createState() => _ChatDetailsState();
}

class _ChatDetailsState extends State<ChatDetails> {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ChatConversationViewModel>(
        create: (_) => ChatConversationViewModel(chatUserModel: widget.chatUser),
        child: Consumer<ChatConversationViewModel>(
          builder: (context, viewModel, child){
            return Scaffold(
                resizeToAvoidBottomInset: true,
                appBar: ChatDetailPageAppBar(user: widget.chatUser),
                body: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Container(
                          height:MediaQuery.of(context).size.height - 102 - AppBar().preferredSize.height,
                          child: chatList()
                      ),

                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Container(
                          padding: EdgeInsets.only(left: 24, bottom: 10, right: 16),
                          width: double.infinity,
                          color: Colors.white,
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: TextField(
                                  controller: viewModel.textEditingController,
                                  decoration: InputDecoration(
                                    hintText: "Type message...",
                                    hintStyle: TextStyle(color: Colors.grey.shade500),
                                    border: InputBorder.none,
                                  ),
                                  maxLines: null,
                                  onChanged: (value) => viewModel.onChangeMessage(value),
                                ),
                              ),
                              GestureDetector(
                                onTap: viewModel.isValidate ? () => viewModel.sendMessage() : null,
                                child:
                                Container(
                                  height: 35,
                                  width: 35,
                                  decoration: BoxDecoration(
                                    color: viewModel.isValidate ? Colors.redAccent.shade200 : Colors.grey.shade500,
                                    borderRadius: BorderRadius.circular(40 / 2),
                                  ),
                                  child: Center(child: Icon(
                                    Icons.send, color: Colors.white, size: 20,)),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
            );
          },
        ),
    );
  }

  Widget chatList(){
    return Consumer<ChatConversationViewModel>(
      builder: (context, provider, child){
        return ListView.builder(
          shrinkWrap: true,
          itemCount: provider.listOfMessages.length,
          controller: provider.scrollController,
          itemBuilder: (context, index){
            return ChatBubble(
              chatMessage: provider.listOfMessages[index],
            );
          },
        );
      }
    );
  }

}




