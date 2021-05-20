import 'package:app_push_notifications/Helpers/importFiles.dart';

class HeightDialogBoxView extends StatefulWidget {
  @override
  _HeightDialogBoxViewState createState() => _HeightDialogBoxViewState();
}

class _HeightDialogBoxViewState extends State<HeightDialogBoxView> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HeightDialogBoxViewModel>(
      create: (_) => HeightDialogBoxViewModel(),
      child: Consumer<HeightDialogBoxViewModel>(
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
                  Text('Select your height', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
                  SizedBox(height: 16),
                  Expanded(child: listOfOptions(viewModel)),
                  SizedBox(height: 16),
                  SizedBox(
                    height: 45,
                    width: double.infinity,
                    child: CustomRaisedButton(
                      buttonText: 'Done',
                      cornerRadius: 22.5,
                      textColor: Colors.white,
                      backgroundColor: AppColors.firstColor,
                      action: () => viewModel.onDoneButton(),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  ListView listOfOptions(HeightDialogBoxViewModel viewModel) {
    return ListView(
      children: viewModel.listOfHeights.map((height){
        return InkWell(
          onTap: () => viewModel.onChangedValue(height),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Radio(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    value: height.value,
                    groupValue: viewModel.selectedValue,
                    onChanged: (value) => viewModel.onChangedValue(height)
                ),
                SizedBox(width: 2),
                Expanded(child: Text(height.title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)))
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
