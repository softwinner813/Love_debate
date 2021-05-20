import 'package:app_push_notifications/Helpers/importFiles.dart';

class ForgotPasswordView extends StatefulWidget {
  @override
  _ForgotPasswordViewState createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  TextEditingController txtEmail = TextEditingController();
//  TextEditingController txtDOB = TextEditingController();

  FocusNode txtEmailFocusNode = FocusNode();
  bool apiCall = false;

  @override
  Widget build(BuildContext context) {
    double totalHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.vertical - AppBar().preferredSize.height;
    return Scaffold(
      appBar: AppBar(
        //remove Shadow
        elevation: 0,
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        automaticallyImplyLeading: false,
        leading: (Theme.of(context).platform == TargetPlatform.iOS) ? BackButton(color: AppColors.firstColor) : Container(),
      ),
      body: ChangeNotifierProvider<ForgotPasswordViewModel>(
        create: (_) => ForgotPasswordViewModel(),
        child: SafeArea(
            child: Container(
              child: Consumer<ForgotPasswordViewModel>(
                builder: (context, viewModel, child){
                  return Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                        child: ListView(
                          children: <Widget>[
                            Container(
                              height: ((30/100)*totalHeight),
                              width: MediaQuery.of(context).size.width/1.2,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text("Reset Your Password", style: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.w600),),
                                  SizedBox(height: 4,),
                                  Text("Enter the code sent via email address", style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w600), textAlign: TextAlign.center,),
                                ],
                              ),
                            ),
                            Container(
                                height: ((40/100)*totalHeight),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      emailTextField(viewModel),
                                      SizedBox(height: 16),
                                      btnContinue(viewModel)
                                    ],
                                  ),
                                )
                            ),
                            Container(
                              height: ((30/100)*totalHeight),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      viewModel.viewState == ViewState.Busy ? Positioned.fill(child: Loading()) : Container()
                    ],
                  );
                },
              ),
            )),
      ),
    );
  }
  Container bottomSection({double totalHeight}) {
    return Container(
//      height: ((20 / 100) * totalHeight),
      color: Colors.greenAccent,
    );
  }

  Widget emailTextField(ForgotPasswordViewModel viewModel) {
    return FormTextField(
      txtHint: "Email",
      txtIsSecure: false,
      keyboardType: TextInputType.emailAddress,
      enableBorderColor: Colors.white,
      focusBorderColor: Colors.white,
      textColor: Colors.white,
      errorText: viewModel.email.error,
      onChanged: (value) => viewModel.onChangedEmail(value),
    );
  }

  Widget btnContinue(ForgotPasswordViewModel viewModel) {
    return SizedBox(
      height: 45,
      width: double.infinity,
      child: CustomRaisedButton(
          buttonText: 'Send Email',
          cornerRadius: 5,
          textColor: Colors.white,
          backgroundColor:viewModel.isValidate ? AppColors.firstColor:Colors.grey,
          borderWith: 0,
          action: viewModel.isValidate? ()=> viewModel.sendVerificationCode() : null
      ),
    );
  }
}