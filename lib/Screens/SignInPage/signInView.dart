import 'package:app_push_notifications/Helpers/importFiles.dart';
import 'package:flutter/cupertino.dart';

class SignInView extends StatefulWidget {
  @override
  _SignInViewState createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {

  @override
  Widget build(BuildContext context) {
    double _height=MediaQuery.of(context).size.height - MediaQuery.of(context).padding.vertical;
    double _width=MediaQuery.of(context).size.width;
    return ChangeNotifierProvider<SignInViewModel>(
      create: (_) => SignInViewModel(),
      child: Scaffold(
        body: SafeArea(
          top: true,
          bottom: true,
          child: SingleChildScrollView(
            child: Container(
              height:  _height,
              width: _width,
              child: Consumer<SignInViewModel>(
                builder: (context, viewModel, child){
                  return Stack(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          topSection(_height),
                          centerSection(_height, viewModel),
                          bottomSection(_height,_width, viewModel)
                        ],
                      ),
                      viewModel.viewState == ViewState.Busy ? Positioned.fill(child: Loading()) : Container(),
                    ],
                  );
                }
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container bottomSection(double _height,double _width, SignInViewModel viewModel) {
    return Container(
        height: (30/100)*_height,
        child: Column(
          children: <Widget>[
            Container(
              height: (25/100)*_height,
              width: _width,
              // color: Colors.lightBlue,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  InkWell(
                    child: RichText(
                      text: TextSpan(
                        text: "Don't have an account? ",
                        style: TextStyle(fontSize: 14, color: Colors.black),
                        children: <TextSpan>[
                          TextSpan(text: 'Sign Up', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.firstColor, decoration: TextDecoration.underline)),
                        ],
                      ),
                    ),
                    onTap: () => viewModel.goToSignUp(),
                  ),
                ],
              ),
            ),

          ],
        )
    );
  }

  Widget centerSection(double _height, SignInViewModel viewModel) {
    return Container(
      height: (40/100)*_height,
      //color: Colors.blue,
      margin: EdgeInsets.only(left: 16,right: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          emailTextField(viewModel),
          SizedBox(height: 8),
          passwordTextField(viewModel),
          SizedBox(height: 16,),
          btnContinue(viewModel),
          SizedBox(height: 16),
          GestureDetector(
              onTap: () => viewModel.goToForgotPassword(),
              child: Text('Forgot Password?',style: TextStyle(color:Colors.lightBlueAccent,fontSize: 16, decoration: TextDecoration.underline))),
        ],
      ),
    );
  }

  Container topSection(double _height) {
    return Container(
      height: (30/100)*_height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Center(
            child: Container(
                height: 180,
                width: 180,
                child: Image.asset("images/LoveDebatelogo.png")
            ),
          )

        ],
      ),
    );
  }


  Widget emailTextField(SignInViewModel viewModel) {
    return FormTextField(
      txtHint: "Email",
      txtIsSecure: false,
      keyboardType: TextInputType.emailAddress,
      capitalization: TextCapitalization.none,
      enableBorderColor: Colors.white,
      focusBorderColor: Colors.white,
      textColor: Colors.white,
      errorText: viewModel.email.error,
      onChanged: (value) => viewModel.onEmailChanged(value),
    );
  }

  Widget passwordTextField(SignInViewModel viewModel) {
    return FormTextField(
      txtHint: "Password",
      txtIsSecure: true,
      keyboardType: TextInputType.text,
      enableBorderColor: Colors.white,
      focusBorderColor: Colors.white,
      textColor: Colors.white,
      errorText: viewModel.password.error,
      onChanged: (value) => viewModel.onPasswordChange(value),
    );
  }

  Widget btnContinue(SignInViewModel viewModel) {
    return SizedBox(
      height: 45,
      width: double.infinity,
      child: CustomRaisedButton(
        buttonText: 'Login',
        cornerRadius: 5,
        textColor: Colors.white,
        backgroundColor:AppColors.firstColor,
        borderWith: 0,
        action: viewModel.isValidated ? ()=> viewModel.loginUser() : null
      ),
    );
  }
}

