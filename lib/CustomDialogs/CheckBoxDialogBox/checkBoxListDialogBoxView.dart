import 'package:app_push_notifications/Helpers/importFiles.dart';


class CheckBoxListDialogBoxView extends StatefulWidget {
  final Questions question;
  final String title;
  CheckBoxListDialogBoxView({this.question, this.title});
  @override
  _CheckBoxListDialogBoxViewState createState() => _CheckBoxListDialogBoxViewState();
}

class _CheckBoxListDialogBoxViewState extends State<CheckBoxListDialogBoxView> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CheckBoxListDialogBoxViewModel>(
      create: (_) => CheckBoxListDialogBoxViewModel(question: widget.question),
      child: Consumer<CheckBoxListDialogBoxViewModel>(
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
                  viewModel.listOfQuestionsWithCheckBox.length > 8 ? Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: SizedBox(
                      height: 40,
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search',
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
                  ):Container(),
                  contentList(viewModel),
                  SizedBox(height: 8),
                  bottomButtons(viewModel)
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Container contentList(CheckBoxListDialogBoxViewModel viewModel) {
    return Container(
                  // height:  viewModel.listOfQuestionsWithCheckBox.length <= 8 ? viewModel.listOfQuestionsWithCheckBox.length * 50.0 : 6*50.0,
                  child: viewModel.listOfQuestionsWithCheckBox.length > 8 ? Expanded(
                    child: listOfOptions(viewModel),
                  ) : Container(
                    height: viewModel.listOfQuestionsWithCheckBox.length * 50.0,
                    child: listOfOptions(viewModel),
                  ),
                );
  }

  ListView listOfOptions(CheckBoxListDialogBoxViewModel viewModel) {
    return ListView(
                    children: viewModel.searchListOfQuestionsWithCheckBox.map((questionOptions){
                      bool isSelectedAll =questionOptions.value == 'All' ? true : false;
                      return InkWell(
                        onTap: () => viewModel.onChangedValue(questionOptions),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8, right: 8),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Checkbox(
                                  value: questionOptions.checkedValue,
                                  onChanged: (value) => viewModel.onChangedValue(questionOptions)
                              ),
                              SizedBox(width: 2),
                              Expanded(child: Text(questionOptions.title, style: TextStyle(fontSize: isSelectedAll ? 18 : 16, fontWeight: isSelectedAll ? FontWeight.w600 : FontWeight.w400, color: isSelectedAll ? AppColors.firstColor : Colors.black)))
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
  }

  Row bottomButtons(CheckBoxListDialogBoxViewModel viewModel) {
    return Row(
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
                    ) ,
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
                );
  }
}