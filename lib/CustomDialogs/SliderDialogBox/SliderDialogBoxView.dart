import 'package:app_push_notifications/Helpers/importFiles.dart';

class SliderDialogBoxView extends StatefulWidget {
  final Questions question;

  SliderDialogBoxView({@required this.question});
  @override
  _SliderDialogBoxViewState createState() => _SliderDialogBoxViewState();
}

class _SliderDialogBoxViewState extends State<SliderDialogBoxView> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SliderDialogBoxViewModel>(
      create: (_) => SliderDialogBoxViewModel(question: widget.question),
      child: Consumer<SliderDialogBoxViewModel>(
        builder: (context, viewModel, child) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Change slider for match radius',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 8),
                  Slider(
                      min: 0.0,
                      max: 4000,
                      value: viewModel.sliderValue,
                      onChanged: (value) => viewModel.onChangeValue(value)),
                  Text(
                    '${viewModel.sliderValue.round()} Miles',
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 18),
                  Row(
                    children: [
                      btnDoneButton(viewModel),
                      widget.question.qaSkipable != 0 ? SizedBox(width: 8) : Container(),
                      widget.question.qaSkipable != 0 ? btnCancelButton(viewModel) : Container()
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

  Expanded btnDoneButton(SliderDialogBoxViewModel viewModel) {
    return Expanded(
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
    );
  }

  Expanded btnCancelButton(SliderDialogBoxViewModel viewModel) {
    return Expanded(
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
    );
  }
}
