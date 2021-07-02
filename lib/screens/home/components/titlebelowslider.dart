import 'package:flutter/material.dart';
import 'package:irrigation/constants.dart';

class TitleBelowSlider extends StatelessWidget {
  const TitleBelowSlider({
    Key key,
    this.title,
  }) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TitleWithCustomUnderline(text: title),
      ],
    );
  }
}

class TitleWithCustomUnderline extends StatelessWidget {
  const TitleWithCustomUnderline({
    Key key,
    this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return 
    
    Container(
      margin: EdgeInsets.only(bottom: kDefaultPadding),
      height: 24,
      child: Stack(
        children: <Widget>[
          Text(
            text,
            style: TextStyle(
                color: kBackgroundColor,
                fontSize: 20,
                fontWeight: FontWeight.w400),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              margin: EdgeInsets.only(right: kDefaultPadding / 4),
              height: 7,
              color: kPrimaryColor.withOpacity(0.2),
            ),
          )
        ],
      ),
    );
 
  }
}
