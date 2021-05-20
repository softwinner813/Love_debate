import 'package:app_push_notifications/Helpers/importFiles.dart';
import 'package:app_push_notifications/Models/NewQuestionModel.dart';
import 'package:app_push_notifications/Screens/UserPreferences/userPreferencesViewModel.dart';
import 'package:dio/dio.dart';

class UserPreferencesView extends StatefulWidget {
  @override
  _UserPreferencesViewState createState() => _UserPreferencesViewState();
}

class _UserPreferencesViewState extends State<UserPreferencesView> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserPreferencesViewModel>(
      create: (_) => UserPreferencesViewModel(),
      child: Consumer<UserPreferencesViewModel>(
        builder: (context, viewModel, child){
          return Scaffold(
              appBar: viewModel.userDetail.prCompletionStatus == 0 ? AppBar(
                automaticallyImplyLeading: false,
                title: Text("I Seek" ,style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600,color:  Colors.black)),
                backgroundColor: Colors.white,
                leading: Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: InkWell(
                      onTap: (){
                        SessionManager().clear();
                        Navigator.pushAndRemoveUntil(context,
                            MaterialPageRoute(builder: (BuildContext context) => SignInView()),
                                (Route<dynamic> route) => route is SignInView
                        );            },
                      child: Icon(Icons.exit_to_app)
                  ),
                ),
                actions: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0,top: 12),
                    child: GestureDetector(
                        onTap: () => viewModel.saveAnswerOnServer(),
                        child: Text("Save", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600,color: AppColors.firstColor)),
                        )
                    ),
                ],
              ): CustomAppBar(title: "My Preferences"),
              body: Stack(
                children: [
                  ListView(
                    children: viewModel.listOfQuestions.map((question){
                      return UserPreferencesItem(question: question, answer: question.qaSlug == 'address' ? viewModel.formattedAddress : 'Selected', onTap: () => viewModel.onTap(question),);
                    }).toList(),
                  ),
                  viewModel.viewState == ViewState.Busy ? Positioned.fill(child: Loading()) : Container()
                ],
              ),
          );
        },
      ),
    );
  }
}


class UserPreferencesItem extends StatelessWidget {

  final Questions question;
  final String answer;
  final VoidCallback onTap;
  UserPreferencesItem({@required this.question, @required this.answer, @required this.onTap});

  @override
  Widget build(BuildContext context) {
    var questionTitle = "";
    if(question.qaName == "Address"){
      questionTitle = "Location";
    }else if(question.qaName == "Single"){
      questionTitle = "Why you are single?";
    }else{
      questionTitle = question.qaName;
    }
    questionTitle = (question.qaSkipable == 0) ? questionTitle+"*" : questionTitle;

    return InkWell(
      onTap: onTap,
      child: Container(
        height: 65,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child:Text(questionTitle,style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade600),
                    textAlign: TextAlign.left,
                  )
                ),
                question.isSelected ? Text(answer ,style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: Colors.lightGreen),
                  textAlign: TextAlign.left,
                ) : Container()
              ],
            ),
          ),
        ),
      ),
    );
  }
}




