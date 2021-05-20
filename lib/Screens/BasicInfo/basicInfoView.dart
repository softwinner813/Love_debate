import 'package:app_push_notifications/Helpers/importFiles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BasicInfoView extends StatefulWidget {
  @override
  _BasicInfoViewState createState() => _BasicInfoViewState();
}

class _BasicInfoViewState extends State<BasicInfoView> {
  
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BasicInfoViewModel>(
      create: (_) => BasicInfoViewModel(),
      child: Scaffold(
        appBar: CustomAppBar(title: "Basic Info"),
        body: Consumer<BasicInfoViewModel>(
          builder: (context, viewModel, child){
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView(
                    children: <Widget>[
                      firstNameTextField(viewModel),
                      SizedBox(height: 16),
                      lastNameTextField(viewModel),
                      SizedBox(height: 16),
                      genderTextField(viewModel),
                      SizedBox(height: 16),
                      dateOfBirthTextField(viewModel),
                      SizedBox(height: 16),
                      heightTextField(viewModel),
                      // SizedBox(height: 16),
                      // addressTextField(viewModel),
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

  Widget firstNameTextField(BasicInfoViewModel viewModel) {

    return FormTextField(
      txtHint: "First Name",
      txtIsSecure: false,
      keyboardType: TextInputType.emailAddress,
      enableBorderColor: Colors.white,
      focusBorderColor: Colors.white,
      textColor: Colors.white,
      txtController: viewModel.firstNameController,
      errorText: viewModel.firstName.error,
      onChanged: (value) => viewModel.onChangedFirstName(value),
    );
  }

  Widget lastNameTextField(BasicInfoViewModel viewModel) {
    return FormTextField(
      txtHint: "Last Name",
      txtIsSecure: false,
      keyboardType: TextInputType.emailAddress,
      enableBorderColor: Colors.white,
      focusBorderColor: Colors.white,
      textColor: Colors.white,
      txtController: viewModel.lastNameController,
      errorText: viewModel.lastName.error,
      onChanged: (value) => viewModel.onChangedLastName(value),
    );
  }

  Widget genderTextField(BasicInfoViewModel viewModel) {
    return Stack(
      children: [
        FormTextField(
          txtHint: "Gender",
          txtIsSecure: false,
          keyboardType: TextInputType.emailAddress,
          enableBorderColor: Colors.white,
          focusBorderColor: Colors.white,
          textColor: Colors.white,
          txtController: viewModel.genderController,
          errorText: viewModel.gender.error,
          // onChanged: (value) => viewModel.onChangedLastName(value),
        ),
        Positioned.fill(child: Container(color: Colors.transparent))
      ],
    );
  }

  Widget dateOfBirthTextField(BasicInfoViewModel viewModel) {

    return InkWell(
      onTap: () => viewModel.onDateOfBirthTap(),
      child: Stack(
        children: [
          FormTextField(
            txtHint: "Date Of Birth",
            txtIsSecure: false,
            keyboardType: TextInputType.emailAddress,
            enableBorderColor: Colors.white,
            focusBorderColor: Colors.white,
            textColor: Colors.white,
            txtController: viewModel.dateOfBirthController,
          ),
          Positioned.fill(child: Container(color: Colors.transparent),)
        ],
      ),
    );
  }

  Widget heightTextField(BasicInfoViewModel viewModel) {
    return InkWell(
      onTap: () => viewModel.onHeightTap(),
      child: Stack(
        children: [
          FormTextField(
            txtHint: "Height",
            txtIsSecure: false,
            keyboardType: TextInputType.emailAddress,
            enableBorderColor: Colors.white,
            focusBorderColor: Colors.white,
            textColor: Colors.white,
            txtController: viewModel.heightController,
          ),
          Positioned.fill(child: Container(color: Colors.transparent),)
        ],
      ),
    );
  }

  Widget addressTextField(BasicInfoViewModel viewModel) {

    return FormTextField(
      txtHint: "Address",
      txtIsSecure: false,
      keyboardType: TextInputType.emailAddress,
      enableBorderColor: Colors.white,
      focusBorderColor: Colors.white,
      textColor: Colors.white,
      txtController: viewModel.addressController,
      // errorText: viewModel.email.error,
      // onChanged: (value) => viewModel.onEmailChanged(value),
    );
  }

  Widget btnUpdate(BasicInfoViewModel viewModel) {
    return SizedBox(
      height: 45,
      width: double.infinity,
      child: CustomRaisedButton(
          buttonText: 'Update',
          cornerRadius: 5,
          textColor: Colors.white,
          backgroundColor:viewModel.isValidate ? AppColors.firstColor:Colors.grey,
          borderWith: 0,
          action: viewModel.isValidate? ()=> viewModel.updateBasicInfo() : null
      ),
    );
  }
}
