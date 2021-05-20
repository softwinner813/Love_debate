import 'package:flutter/material.dart';

class CustomRadioButton extends StatelessWidget {
  final String value;
  final String groupedValue;
  final String title;
  final ValueChanged onChange;
  CustomRadioButton({this.title, this.value, this.groupedValue, this.onChange});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        onChange(value);
      },
      child:
      Row(
        children: <Widget>[
          SizedBox(
              width: 35,
              child: Radio(value: value,
                groupValue: groupedValue,
                onChanged: onChange,
                activeColor: Theme.of(context).primaryColor,
              )
          ),
          SizedBox(width: 4),
          Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
        ],
      ),
    );
  }
}
