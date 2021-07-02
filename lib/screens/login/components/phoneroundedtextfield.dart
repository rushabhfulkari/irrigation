import 'package:flutter/material.dart';
import 'package:irrigation/constants.dart';
import 'package:irrigation/screens/Login/components/textfield.dart';

class RoundedInputField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final ValueChanged<String> onChanged;
  const RoundedInputField({
    Key key,
    this.hintText,
    this.icon = Icons.person,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        keyboardType: TextInputType.phone,
        onChanged: onChanged,
        cursorColor: kBackgroundColor,
        style: TextStyle(fontSize: 18, color: kBackgroundColor),
        decoration: InputDecoration(
          // prefixText: '+91',
          // prefixStyle: TextStyle(fontSize: 18, color: kBackgroundColor),
          icon: Icon(
            icon,
            color: kBackgroundColor,
          ),
          hintText: hintText,
          hintStyle: TextStyle(
            color: kBackgroundColor,
            fontSize: 18,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
