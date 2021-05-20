import 'package:app_push_notifications/Helpers/importFiles.dart';

class SignUpAccountInfoView extends StatefulWidget {

  Map<String, dynamic> parameter;
  SignUpAccountInfoView({this.parameter});
  @override
  _SignUpAccountInfoViewState createState() => _SignUpAccountInfoViewState();
}

class _SignUpAccountInfoViewState extends State<SignUpAccountInfoView> {

  //New

  Map<String, dynamic> parameter;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    parameter = widget.parameter;
  }

  @override
  Widget build(BuildContext context) {

    double _height=(MediaQuery.of(context).size.height-MediaQuery.of(context).padding.vertical)-AppBar().preferredSize.height;
    double _width=MediaQuery.of(context).size.width;

    return ChangeNotifierProvider<SignUpAccountInfoViewModel>(
      create: (_) => SignUpAccountInfoViewModel(parameters: widget.parameter),
      child: Scaffold(
        appBar: CustomAppBar(),
        body: SafeArea(
          top: true,
          child: Container(
            height: _height,
            width: _width,
            color: Colors.white,
//          margin: EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Consumer<SignUpAccountInfoViewModel>(
                builder: (context, viewModel, childe){
                  return Stack(
                    children: [
                      Column(
                        children: <Widget>[
                          SizedBox(height: 32,),
                          Container(
                            height: (70/100)*_height,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: <Widget>[
                                  Center(
                                    child: Text(
                                      "Account Info",
                                      style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey
                                      ),
                                    ),
                                  ),

                                  txtEmailAddress(viewModel),
                                  SizedBox(height: 8),
                                  passwordTextField(viewModel),
                                  SizedBox(height: 8),
                                  txtConfirmedPassword(viewModel),
                                  SizedBox(height: 8),
                                  SizedBox(height: 8),

                                  Row(
                                    children: [
                                      Checkbox(materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, value: viewModel.isAccepted, onChanged: (value)=>viewModel.onChangeAccepted(value)),
                                      RichText(
                                        textAlign: TextAlign.center,
                                        maxLines: 3,
                                        text: TextSpan(
                                          text: 'You agree to our ',
                                          // ignore: deprecated_member_use
                                          style: TextStyle(fontSize: 12, color: Colors.grey,),
                                          children: <TextSpan>[
                                            TextSpan(recognizer: TapGestureRecognizer()..onTap = () => viewModel.onTapTermsAndConditions(),text: 'Terms of Service', style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500, color: Colors.blue, decoration: TextDecoration.underline)),
                                            TextSpan(text: ' and '),
                                            TextSpan(recognizer: TapGestureRecognizer()..onTap = () => viewModel.onTapPrivacy(), text: 'Privacy Policy', style: TextStyle(fontSize:  13,fontWeight: FontWeight.w500, color: Colors.blue,decoration: TextDecoration.underline)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),

                                  btnSignUp(viewModel),
                                ],
                              ),
                            ),
                          ),

                          // Container(
                          //   height: (20/100)*_height,
                          //   width: _width,
                          //   // color: Colors.green,
                          //   margin: EdgeInsets.all(16),
                          //   child: Column(
                          //     mainAxisAlignment: MainAxisAlignment.end,
                          //     crossAxisAlignment: CrossAxisAlignment.center,
                          //     children: <Widget>[
                          //       RichText(
                          //         textAlign: TextAlign.center,
                          //         maxLines: 3,
                          //         text: TextSpan(
                          //           text: 'By clicking sign up, you agree to our ',
                          //           // ignore: deprecated_member_use
                          //           style: TextStyle(fontSize: 12, color: Colors.grey,),
                          //           children: <TextSpan>[
                          //             TextSpan(text: 'Terms of Service', style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500, color: Colors.blue, decoration: TextDecoration.underline)),
                          //             TextSpan(text: ' and '),
                          //             TextSpan(text: 'Privacy Policy', style: TextStyle(fontSize:  13,fontWeight: FontWeight.w500, color: Colors.blue,decoration: TextDecoration.underline)),
                          //           ],
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                        ],

                      ),
                      viewModel.viewState == ViewState.Busy ? Positioned.fill(child: Loading()) : Container()
                    ],
                  );
                },
              ),
            ),
          ),
        ) ,
      ),
    );
  }

  Widget txtEmailAddress(SignUpAccountInfoViewModel viewModel) {
    return FormTextField(
      txtHint: "Email",
      txtIsSecure: false,
      keyboardType: TextInputType.emailAddress,
      capitalization: TextCapitalization.none,
      enableBorderColor: Colors.white,
      focusBorderColor: Colors.white,
      textColor: Colors.white,
      errorText: viewModel.email.error,
      onChanged: (value) => viewModel.onChangedEmail(value),
    );
  }

  Widget txtPassword(SignUpAccountInfoViewModel viewModel) {
    return FormTextField(
      txtHint: "Password",
      txtIsSecure: true,
      keyboardType: TextInputType.text,
      capitalization: TextCapitalization.none,
      enableBorderColor: Colors.white,
      focusBorderColor: Colors.white,
      textColor: Colors.white,
      errorText: viewModel.password.error,
      onChanged: (value) => viewModel.onChangedPassword(value),
    );
  }


  Widget passwordTextField(SignUpAccountInfoViewModel viewModel) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: <Widget>[
        Column(
          children: <Widget>[
            txtPassword(viewModel),
            (viewModel.password.value != '') ? FlutterPasswordStrength(password:viewModel.password.value, height: 4) : Container(),
          ],
        ),
//        Positioned(
//          right: 4,
//          child: InkWell(
//            onTap: (){
//              setState(() {
//                showTooltip = showTooltip ? false : true;
//              });
//            },
//            child: Container(height: 30,width: 50),
//            //child: Icon(Icons.help_outline, color: Colors.black, size: 20,)
//          ),
//        )
      ],
    );
  }

  Widget txtConfirmedPassword(SignUpAccountInfoViewModel viewModel) {
    return FormTextField(
      txtHint: "Confirm Password",
      txtIsSecure: true,
      keyboardType: TextInputType.text,
      capitalization: TextCapitalization.none,
      enableBorderColor: Colors.white,
      focusBorderColor: Colors.white,
      textColor: Colors.white,
      errorText: viewModel.confirmedPassword.error,
      onChanged: (value) => viewModel.onChangedConfirmedPassword(value),
    );
  }

  Widget btnSignUp(SignUpAccountInfoViewModel viewModel) {
    return SizedBox(
      height: 60,
      child: FloatingActionButton(
        backgroundColor: viewModel.isValidate ? AppColors.firstColor : Colors.grey,
        onPressed: viewModel.isValidate ? () => viewModel.saveAccountInfo() : null,
        tooltip: 'Increment',
        child: Icon(Icons.arrow_forward),
      ),
    );
  }
}