import 'package:flutter/cupertino.dart';
import 'package:app_push_notifications/Helpers/importFiles.dart';

class ChatBubble extends StatefulWidget{
  ChatConversationModel chatMessage;
  ChatBubble({@required this.chatMessage});
  @override
  _ChatBubbleState createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          left: widget.chatMessage.type == MessageType.Receiver ? 16 : 100,
          right: widget.chatMessage.type == MessageType.Receiver ? 100 : 16,
          top: 8,
          bottom: 8
      ),
      child: Align(
        alignment: (widget.chatMessage.type == MessageType.Receiver?Alignment.topLeft:Alignment.topRight),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: widget.chatMessage.type != MessageType.Receiver ? BorderRadius.only(
                  topLeft: Radius.circular(23),
                  topRight: Radius.circular(23),
                  bottomLeft: Radius.circular(23)
              ) :
              BorderRadius.only(
                  topLeft: Radius.circular(23),
                  topRight: Radius.circular(23),
                  bottomRight: Radius.circular(23)),
              color: (widget.chatMessage.type  == MessageType.Receiver?Colors.grey.shade200:Colors.redAccent.shade200),
          ),
          padding: EdgeInsets.all(12),
          child: Text(widget.chatMessage.message, style: TextStyle(color: widget.chatMessage.type  == MessageType.Receiver?Colors.black : Colors.white),),
        ),
      ),
    );
  }
}