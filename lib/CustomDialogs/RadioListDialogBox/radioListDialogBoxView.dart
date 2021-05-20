import 'package:app_push_notifications/Helpers/importFiles.dart';


class RadioListDialogBoxView extends StatefulWidget {
  final Questions question;
  final String title;
  RadioListDialogBoxView({this.question, this.title});
  @override
  _RadioListDialogBoxViewState createState() => _RadioListDialogBoxViewState();
}

class _RadioListDialogBoxViewState extends State<RadioListDialogBoxView> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RadioListDialogBoxViewModel>(
      create: (_) => RadioListDialogBoxViewModel(question: widget.question),
      child: Consumer<RadioListDialogBoxViewModel>(
        builder: (context, viewModel, child){
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 16.0, bottom: 12, left: 8, right: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('${widget.question.qaName}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
                  SizedBox(height: 8),
                  viewModel.listOfQuestionsWithRadioButton.length > 8 ? Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: SizedBox(
                      height: 40,
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search',
                          contentPadding: EdgeInsets.symmetric(vertical: 1, horizontal: 16),
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
                  ):Container(),
                  SizedBox(height: 8),
                  viewModel.listOfQuestionsWithRadioButton.length > 8 ? 
                  Expanded(child: listOfOptions(viewModel)) : 
                  Container(
                    height: viewModel.listOfQuestionsWithRadioButton.length * 60.0,
                    child: listOfOptions(viewModel),
                  ),
                  Row(
                    children: [
                     Expanded(
                        child: SizedBox(
                          height: 45,
                          child: CustomRaisedButton(
                            buttonText: 'Cancel',
                            cornerRadius: 22.5,
                            textColor: Colors.white,
                            backgroundColor: Colors.grey,
                            action: () => viewModel.onCancelButton(),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: SizedBox(
                          height: 45,
                          child: CustomRaisedButton(
                            buttonText: 'Done',
                            cornerRadius: 22.5,
                            textColor: Colors.white,
                            backgroundColor: AppColors.firstColor,
                            action: () => viewModel.onDoneButton(),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  ListView listOfOptions(RadioListDialogBoxViewModel viewModel) {
    return ListView(
                    children: viewModel.searchListOfQuestionsWithRadioButton.map((questionOptions){
                      return InkWell(
                        onTap: () => viewModel.onChangedValue(questionOptions),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8, right: 8),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Radio(
                                  value: questionOptions.value,
                                  groupValue: viewModel.selectedRadioValue,
                                  onChanged: (value) => viewModel.onChangedValue(questionOptions)
                              ),
                              SizedBox(width: 2),
                              Expanded(child: Text(questionOptions.title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)))
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
  }
}
