import 'package:flutter/material.dart';
import 'package:irrigation/constants.dart';

class SmallRoundedButton extends StatelessWidget {
  final String text;
  final Function press;
  final Color color, textColor;
  const SmallRoundedButton({
    Key key,
    this.text,
    this.press,
    this.color = kPrimaryColor,
    this.textColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: size.height * 0.06,
          width: size.width * 0.4,
          margin: EdgeInsets.symmetric(vertical: 0, horizontal: 5),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(29),
            child: FlatButton(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
              color: color,
              onPressed: press,
              child: Text(
                text,
                style: TextStyle(
                    color: kBackgroundColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
