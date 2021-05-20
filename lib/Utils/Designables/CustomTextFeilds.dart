import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class UnderLineTextField extends StatelessWidget {

  final FocusNode focusNode;
  final String txtHint;
  final bool isSecure;
  final TextInputType keyboardType;
  final Color enableBorderColor;
  final Color focusBorderColor;
  final Color textColor;
  final TextEditingController txtController;
  final VoidCallback onTapFunc;
  final bool enable;

  UnderLineTextField({
    this.focusNode,
    this.txtHint,
    this.isSecure,
    this.keyboardType,
    this.enableBorderColor,
    this.focusBorderColor,
    this.textColor,
    this.txtController,
    this.onTapFunc,
    this.enable = true
  });
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
          accentColor: focusBorderColor
      ),
      child: SizedBox(
        height: 50,
        child: TextField(
          enabled: enable,
          focusNode: focusNode,
          onTap: onTapFunc,
          style: TextStyle(color: textColor),
          textAlign: TextAlign.justify,
          textAlignVertical: TextAlignVertical.center,
          keyboardType: keyboardType,
          obscureText: isSecure,
          controller: txtController,
          decoration: InputDecoration(
            labelText: txtHint,
            labelStyle: TextStyle(color: focusNode.hasFocus ? focusBorderColor : Colors.grey),
            contentPadding: EdgeInsets.symmetric(vertical: 8),
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    width: 1,
                    style: BorderStyle.solid,
                    color: Colors.grey
                )
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  width: 1.3,
                  style: BorderStyle.solid,
              )
          ),
          ),
        ),
      ),
    );
  }
}
class NewUnderLineTextField extends StatelessWidget {

  final FocusNode focusNode;
  final String txtHint;
  final bool isSecure;
  final TextInputType keyboardType;
  final Color enableBorderColor;
  final Color focusBorderColor;
  final Color textColor;
  final TextEditingController txtController;
  final VoidCallback onTapFunc;


  NewUnderLineTextField({
    this.focusNode,
    this.txtHint,
    this.isSecure,
    this.keyboardType,
    this.enableBorderColor,
    this.focusBorderColor,
    this.textColor,
    this.txtController,
    this.onTapFunc
  });
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
          accentColor: focusBorderColor
      ),
      child: SizedBox(
        height: 50,
        child: TextField(
          focusNode: focusNode,
          onTap: onTapFunc,
          style: TextStyle(color: textColor),
          textAlign: TextAlign.justify,
          textAlignVertical: TextAlignVertical.center,
          keyboardType: keyboardType,
          obscureText: isSecure,
          controller: txtController,
          decoration: InputDecoration(
            labelText: txtHint,
            labelStyle: TextStyle(color: focusNode.hasFocus ? focusBorderColor : Colors.grey),
            contentPadding: EdgeInsets.symmetric(vertical: 8),
//            enabledBorder: UnderlineInputBorder(
//                borderSide: BorderSide(
//                    width: 1,
//                    style: BorderStyle.solid,
//                    color: Colors.grey
//                )
//            ),
//            focusedBorder: UnderlineInputBorder(
//                borderSide: BorderSide(
//                  width: 1.3,
//                  style: BorderStyle.solid,
//                  color: GlobalColors.firstColor,
//                )
//            ),
          ),
        ),
      ),
    );
  }
}

class PasswordTextField extends StatelessWidget {

  final IconData prefixIcon;
  final IconButton suffixIcon;
  final TextCapitalization capitalization;
  final String txtHint;
  final bool txtIsSecure;
  final TextInputType keyboardType;
  final TextEditingController txtController;
  final Function validator;
  final Function onSaved;
  final Function onChanged;

  PasswordTextField({this.prefixIcon, this.suffixIcon, this.capitalization = TextCapitalization.words, this.txtHint, this.txtIsSecure = false, this.keyboardType, this.txtController, this.validator, this.onSaved, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
          accentColor: Theme.of(context).primaryColor
      ),
      child: TextFormField(
        style: TextStyle(fontSize: 14),
        textAlign: TextAlign.justify,
        textCapitalization: capitalization,
        textAlignVertical: TextAlignVertical.center,
        keyboardType: keyboardType,
        obscureText: txtIsSecure,
        controller: txtController,
        validator: validator,
        onSaved: onSaved,
        onChanged: onChanged,
        decoration: InputDecoration(
          prefixIcon: prefixIcon != null ? Container(transform: Matrix4.translationValues(0.0, 0.0, 0.0), child: Icon(prefixIcon, size: 16,)) : null,
          suffixIcon: suffixIcon,
          hintText: txtHint,
          hintStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
          filled: false,
          fillColor: Colors.white,
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  width: 1.3,
                  style: BorderStyle.solid,
                  color: Theme.of(context).primaryColor
              )
          ),
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  width: 1,
                  style: BorderStyle.solid,
                  color: Colors.grey.withOpacity(0.4)
              )
          ),
        ),
      ),
    );
  }
}




class FormTextField extends StatelessWidget {
  final IconData prefixIcon;
  final IconButton suffixIcon;
  final TextCapitalization capitalization;
  final String txtHint;
  final errorText;
  final bool txtIsSecure;
  final TextInputType keyboardType;
  final TextEditingController txtController;
  final Function validator;
  final Function onSaved;
  final Function onChanged;

  final Color enableBorderColor;
  final Color focusBorderColor;
  final Color textColor;

  FormTextField({this.errorText, this.prefixIcon, this.suffixIcon, this.capitalization = TextCapitalization.words, this.txtHint, this.txtIsSecure = false, this.keyboardType, this.txtController, this.validator, this.onSaved, this.onChanged,this.textColor,this.enableBorderColor,this.focusBorderColor,});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
          accentColor: Theme.of(context).primaryColor
      ),
      child: TextFormField(
        style: TextStyle(fontSize: 14),
        textAlign: TextAlign.justify,
        textCapitalization: capitalization,
        textAlignVertical: TextAlignVertical.center,
        keyboardType: keyboardType,
        obscureText: txtIsSecure,
        controller: txtController,
        validator: validator,
        onSaved: onSaved,
        onChanged: onChanged,

        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 2, vertical: 6),
          labelText: txtHint,
          prefixIcon: prefixIcon != null ? Container(transform: Matrix4.translationValues(0.0, 0.0, 0.0), child: Icon(prefixIcon, size: 16,)) : null,
          suffixIcon: suffixIcon,
          hintText: txtHint,
          hintStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
          filled: false,
          fillColor: Colors.white,
          errorText: errorText,
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  width: 1.3,
                  style: BorderStyle.solid,
                  color: Theme.of(context).primaryColor
              )
          ),
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  width: 1,
                  style: BorderStyle.solid,
                  color: Colors.grey.withOpacity(0.4)
              )
          ),
        ),
      ),
    );
  }
}