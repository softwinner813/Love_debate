import 'package:app_push_notifications/Helpers/importFiles.dart';

class ChatUsersListView extends StatefulWidget {
  @override
  _ChatUsersListViewState createState() => _ChatUsersListViewState();
}

class _ChatUsersListViewState extends State<ChatUsersListView> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Consumer<ChatUsersListViewModel>(
          builder: (context, viewModel, child){
            return Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 16,right: 16,top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("Chats",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16, left: 16,right: 16),
                      child: TextField(
                        onChanged: (value) => viewModel.onChangeText(value),
                        decoration: InputDecoration(
                          hintText: "Search...",
                          hintStyle: TextStyle(color: Colors.grey.shade400),
                          prefixIcon: Icon(Icons.search,color: Colors.grey.shade400,size: 20,),
                          filled: true,
                          fillColor: Colors.grey.shade200,
                          contentPadding: EdgeInsets.all(8),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(
                                  color: Colors.grey.shade200
                              )
                          ),
                        ),
                      ),
                    ),

                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () => viewModel.getChatUsers(),
                        child: ListView.builder(
                          itemCount: viewModel.searchListOfChatUsers.length,
                          shrinkWrap: true,
                          padding: EdgeInsets.only(top: 16),
                          itemBuilder: (context, index){
                            return ChatUsersListItem(
                              chatUser: viewModel.searchListOfChatUsers[index],
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context){
                                  return ChatDetails(chatUser: viewModel.searchListOfChatUsers[index] );
                                })).then((value) => viewModel.getChatUsers());
                              },
                            );
                          },
                        ),
                      ),
                    ) ,
                  ],
                ),

                viewModel.viewState == ViewState.Idle  && viewModel.listOfChatUsers.length == 0 ? Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: InkWell(
                    onTap: () => viewModel.getChatUsers(),
                    child: Center(
                      child: Text(
                        'No Chat Found \n \n Tap To Refresh',
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
      )
    );
  }
}
