import 'package:flutter/material.dart';
import 'package:irrigation/constants.dart';
import 'package:irrigation/screens/Login/components/textfield.dart';

class OtpRoundedInputField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final ValueChanged<String> onChanged;
  const OtpRoundedInputField({
    Key key,
    this.hintText,
    this.icon = Icons.send_to_mobile,
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
