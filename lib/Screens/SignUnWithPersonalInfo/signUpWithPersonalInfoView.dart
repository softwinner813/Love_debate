import 'package:app_push_notifications/Helpers/importFiles.dart';
import 'package:flutter/cupertino.dart';

class SignUpWithPersonalInfoView extends StatefulWidget {
  User user;
  bool isSocialLogin;
  SignUpWithPersonalInfoView({this.user, this.isSocialLogin});
  @override
  _SignUpWithPersonalInfoViewState createState() => _SignUpWithPersonalInfoViewState();
}
enum Gender { male, female}
class _SignUpWithPersonalInfoViewState extends State<SignUpWithPersonalInfoView> {

  TextEditingController _txtHeightController = TextEditingController();
  TextEditingController _txtDateOfBirthController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    double _height = (MediaQuery
        .of(context)
        .size
        .height - MediaQuery
        .of(context)
        .padding
        .vertical) - AppBar().preferredSize.height;
    double _width = MediaQuery
        .of(context)
        .size
        .width;

    return ChangeNotifierProvider<SignUpWithPersonalInfoViewModel>(
      create: (_) =>
          SignUpWithPersonalInfoViewModel(
              user: widget.user, isSocialLogin: widget.isSocialLogin),
      child: Scaffold(
        appBar: CustomAppBar(),
        body: SafeArea(
            top: true,
            child: Consumer<SignUpWithPersonalInfoViewModel>(
              builder: (context, viewModel, child) {
                return Stack(
                  children: [
                    Container(
                      height: _height,
                      width: _width,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ListView(
                          children: <Widget>[
                            SizedBox(height: 32,),
                            Center(
                              child: Text(
                                viewModel.isSocialLogin
                                    ? "Sign Up"
                                    : "Personal Info",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey
                                ),
                              ),
                            ),
                            SizedBox(height: 16),
                            viewModel.isSocialLogin
                                ? Container()
                                : txtFirstName(viewModel),
                            viewModel.isSocialLogin ? Container() : SizedBox(
                                height: 8),
                            viewModel.isSocialLogin ? Container() : txtLastName(
                                viewModel),
                            viewModel.isSocialLogin ? Container() : SizedBox(
                                height: 8),
                            txtDateOfBirth(viewModel),
                            SizedBox(height: 8),
                            txtHeight(viewModel),
                            SizedBox(height: 8),
                            gendersRadioButtons(viewModel),
                            SizedBox(height: 16),
                            btnSignUp(viewModel),
                          ],
                        ),
                      ),
                    ),
                    viewModel.viewState == ViewState.Busy ? Positioned.fill(
                        child: Loading()) : Container()
                  ],
                );
              },
            )
        ),
      ),
    );
  }

  Widget txtFirstName(SignUpWithPersonalInfoViewModel viewModel) {
    return FormTextField(
      txtHint: "First Name",
      txtIsSecure: false,
      keyboardType: TextInputType.text,
      enableBorderColor: Colors.white,
      focusBorderColor: Colors.white,
      textColor: Colors.white,
      errorText: viewModel.firstName.error,
      onChanged: (value) => viewModel.onChangedFirstName(value),
    );
  }

  Widget txtLastName(SignUpWithPersonalInfoViewModel viewModel) {
    return FormTextField(
      txtHint: "Last Name",
      txtIsSecure: false,
      keyboardType: TextInputType.text,
      enableBorderColor: Colors.white,
      focusBorderColor: Colors.white,
      textColor: Colors.white,
      errorText: viewModel.lastName.error,
      onChanged: (value) => viewModel.onChangedLastName(value),
    );
  }

  Widget txtDateOfBirth(SignUpWithPersonalInfoViewModel viewModel) {
    return InkWell(
      onTap: (){
        if (Platform.isIOS){
          showDialog(
              context: context,
              builder: (BuildContext context){
                return IOSDateTimePicker();
              }
          ).then((value){
            if(value != null){
              if(value.toString().toDateTime(dateFormat: 'MMM dd, yyyy').toDateString(dateFormat: 'yyyy-mm-dd').calculateAge.toInt() > 17){
                _txtDateOfBirthController.text = value;
                viewModel.setDateOfBirth(value);
              }else{
                viewModel.showAlert();
              }
            }
          });
        }else{
          showDatePicker(
              context:context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime(2050)
          ).then((value){
            if(value != null){
              if(value.toDateString(dateFormat: 'yyyy-mm-dd').calculateAge.toInt() > 17){
                String dateToString = value.toDateString(dateFormat: 'MMM dd, yyyy');
                _txtDateOfBirthController.text = dateToString;
                viewModel.setDateOfBirth(dateToString);
              }else{
                viewModel.showAlert();
              }
            }
          });
        }
      },
      child: Stack(
        children: [
          FormTextField(
            txtController: _txtDateOfBirthController,
            txtHint: "Date of Birth",
            txtIsSecure: false,
            enableBorderColor: Colors.white,
            focusBorderColor: Colors.white,
            textColor: Colors.white,
//            errorText: viewModel.firstName.error,
//            onChanged: (value) => viewModel.onChangedFirstName(value),
          ),
          Positioned.fill(child: Container(color: Colors.transparent,))
        ],
      ),
    );
  }

  Widget txtHeight(SignUpWithPersonalInfoViewModel viewModel) {
    return InkWell(
      onTap: () {
        showDialog(
            barrierDismissible: true,
            context: context,
            builder: (context) {
              return HeightDialogBoxView();
            }
        ).then((value){
          _txtHeightController.text = value.toString().split('/')[1];
          viewModel.setHeight(value.toString().split('/')[0]);
        });
      },
      child: Stack(
        children: [
          FormTextField(
            txtController: _txtHeightController,
            txtHint: "Height (ft. in.)",
            txtIsSecure: false,
            enableBorderColor: Colors.white,
            focusBorderColor: Colors.white,
            textColor: Colors.white,
//            errorText: viewModel.firstName.error,
//            onChanged: (value) => viewModel.onChangedFirstName(value),
          ),
          Positioned.fill(child: Container(color: Colors.transparent,))
        ],
      ),
    );
  }

  Widget gendersRadioButtons(SignUpWithPersonalInfoViewModel viewModel) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
              width: 100,
              child:CustomRadioButton(
                title: 'Male',
                value: '1',
                groupedValue: viewModel.gender.value,
                onChange: (value) => viewModel.onGenderChange(value)
              )
          ),
        ),
        Expanded(
          child: Container(
              width: 100,
              child: CustomRadioButton(
                  title: 'Female',
                  value: '2',
                  groupedValue: viewModel.gender.value,
                  onChange: (value) => viewModel.onGenderChange(value)
              )
          ),
        ),
      ],
    );
  }

  Widget btnSignUp(SignUpWithPersonalInfoViewModel viewModel) {
    return SizedBox(
      height: 60,
      child: FloatingActionButton(
        backgroundColor: viewModel.isValidate ? AppColors.firstColor : Colors.grey,
        onPressed: viewModel.isValidate ?  () => viewModel.goToAccountInfo() : null,
        tooltip: 'Increment',
        child: Icon(Icons.arrow_forward),
      ),
    );

//      CustomRaisedButton(
//      buttonText: '',
//      cornerRadius: 30,
//      textColor: Colors.white,
//      backgroundColor:GlobalColors.firstColor,
//      borderWith: 0,
//      action: (){
//        setState(() {
//          ValidateFields();
//        });
//      },
//    );
  }
}