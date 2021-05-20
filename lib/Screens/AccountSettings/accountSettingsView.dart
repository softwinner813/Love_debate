import 'package:app_push_notifications/Helpers/importFiles.dart';

class AccountSettingsView extends StatefulWidget {
  String forgotEmail;
  AccountSettingsView({this.forgotEmail});
  @override
  _AccountSettingsViewState createState() => _AccountSettingsViewState();
}

class _AccountSettingsViewState extends State<AccountSettingsView> {

  TextEditingController _emailController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AccountSettingsViewModel>(
      create: (_) =>  AccountSettingsViewModel(forgotPassword: widget.forgotEmail),
      child: Scaffold(
        appBar: CustomAppBar(title: 'Account Setting'),
        body: Consumer<AccountSettingsViewModel>(
          builder: (context, viewModel, child){
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView(
                    children: <Widget>[
                      emailTextField(viewModel),
                      SizedBox(height: 16),
                      viewModel.isResetPassword == false ? oldPasswordTextField(viewModel) : Container(),
                      SizedBox(height: 16),
                      newPasswordTextField(viewModel),
                      SizedBox(height: 16),
                      confirmedPasswordTextField(viewModel),
                      SizedBox(height: 16),
                      btnUpdate(viewModel)
                    ],
                  ),
                ),
                viewModel.viewState == ViewState.Busy ? Positioned.fill(child: Loading()) : Container()
              ],
            );
          },
        ),
      ),
    );
  }

  Widget emailTextField(AccountSettingsViewModel viewModel) {
    _emailController.text = viewModel.email.value;
    return FormTextField(
      txtHint: "Email",
      txtIsSecure: false,
      keyboardType: TextInputType.emailAddress,
      enableBorderColor: Colors.white,
      focusBorderColor: Colors.white,
      textColor: Colors.white,
      txtController: _emailController,
    );
  }

  Widget oldPasswordTextField(AccountSettingsViewModel viewModel) {
    return FormTextField(
      txtHint: "Old Password",
      txtIsSecure: false,
      keyboardType: TextInputType.emailAddress,
      enableBorderColor: Colors.white,
      focusBorderColor: Colors.white,
      textColor: Colors.white,
      errorText: viewModel.oldPassword.error,
      onChanged: (value) => viewModel.onChangedOldPassword(value),
    );
  }

  Widget newPasswordTextField(AccountSettingsViewModel viewModel) {
    return Column(
      children: [
        FormTextField(
          txtHint: "New Password",
          txtIsSecure: true,
          keyboardType: TextInputType.emailAddress,
          enableBorderColor: Colors.white,
          focusBorderColor: Colors.white,
          textColor: Colors.white,
          errorText: viewModel.newPassword.error,
          onChanged: (value) => viewModel.onChangedNewPassword(value),
        ),

        (viewModel.newPassword.value != '') ? FlutterPasswordStrength(password:viewModel.newPassword.value, height: 4) : Container(),
      ],
    );
  }

  Widget confirmedPasswordTextField(AccountSettingsViewModel viewModel) {
    return FormTextField(
      txtHint: "Confirm Password",
      txtIsSecure: true,
      keyboardType: TextInputType.emailAddress,
      enableBorderColor: Colors.white,
      focusBorderColor: Colors.white,
      textColor: Colors.white,
      errorText: viewModel.confirmedPassword.error,
      onChanged: (value) => viewModel.onChangedConfirmPassword(value),
    );
  }

  Widget btnUpdate(AccountSettingsViewModel viewModel) {
    return SizedBox(
      height: 45,
      width: double.infinity,
      child: CustomRaisedButton(
          buttonText: viewModel.isResetPassword ? 'Reset Password' : 'Update Password',
          cornerRadius: 5,
          textColor: Colors.white,
          backgroundColor:viewModel.isValidate ? AppColors.firstColor:Colors.grey,
          borderWith: 0,
          action: viewModel.isValidate? ()=> viewModel.updateResetPassword() : null
      ),
    );
  }
}
