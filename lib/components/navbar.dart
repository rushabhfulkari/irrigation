import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:irrigation/screens/home/homebutton.dart';
import 'package:irrigation/services/authservices.dart';

import '../constants.dart';

class MyBottomNavBar extends StatefulWidget {
  MyBottomNavBar({
    Key key,
    this.onhome,
    this.onprofile,
  }) : super(key: key);
  bool onhome;
  bool onprofile;

  @override
  _MyBottomNavBarState createState() => _MyBottomNavBarState(onhome, onprofile);
}

class _MyBottomNavBarState extends State<MyBottomNavBar> {
  bool onhome;
  bool onprofile;
  _MyBottomNavBarState(this.onhome, this.onprofile);

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.only(
      //   left: kDefaultPadding,
      //   top: kDefaultPadding,
      //   right: kDefaultPadding,
      //   bottom: kDefaultPadding,
      // ),
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, -10),
            blurRadius: 35,
            color: kPrimaryColor.withOpacity(0.38),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 288,
            child: GestureDetector(
              onTap: () {
                if (onhome == false) {
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation1, animation2) =>
                          HomeScreen(
                        shown: true,
                      ),
                      transitionDuration: Duration(seconds: 1),
                    ),
                  );
                } else {
                  return null;
                }
              },
              child: Container(
                color: kBackgroundColor,
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    onhome
                        ? Icon(
                            Icons.home_rounded,
                            color: kPrimaryColor,
                            size: 25.0,
                            // semanticLabel: 'Text to announce in accessibility modes',
                          )
                        : Icon(
                            Icons.home_rounded,
                            color: kTextColor,
                            size: 25.0,
                            // semanticLabel: 'Text to announce in accessibility modes',
                          ),
                    SizedBox(
                      width: kDefaultPadding * 0.5,
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          onhome
                              ? TextSpan(
                                  text: "Home".toUpperCase(),
                                  style: TextStyle(
                                    color: kPrimaryColor,
                                    fontFamily: 'Sen',
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                  ))
                              : TextSpan(
                                  text: "Home".toUpperCase(),
                                  style: TextStyle(
                                    color: kTextColor,
                                    fontFamily: 'Sen',
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                  ))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
              flex: 2,
              child: Container(
                color: kTextColor.withOpacity(0.3),
              )),
          Expanded(
            flex: 288,
            child: GestureDetector(
              onTap: () {
                if (onprofile == false) {
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation1, animation2) =>
                          AuthService().handleAuth1(),
                      transitionDuration: Duration(seconds: 1),
                    ),
                  );
                } else {
                  return null;
                }
              },
              child: Container(
                color: kBackgroundColor,
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    onprofile
                        ? Icon(
                            Icons.person,
                            color: kPrimaryColor,
                            size: 25.0,
                            // semanticLabel: 'Text to announce in accessibility modes',
                          )
                        : Icon(
                            Icons.person,
                            color: kTextColor,
                            size: 25.0,
                            // semanticLabel: 'Text to announce in accessibility modes',
                          ),
                    SizedBox(
                      width: 10,
                    ),
                    RichText(
                        text: TextSpan(
                            text: "Profile".toUpperCase(),
                            style: onprofile
                                ? TextStyle(
                                    color: kPrimaryColor,
                                    fontFamily: 'Sen',
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                  )
                                : TextStyle(
                                    color: kTextColor,
                                    fontFamily: 'Sen',
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                  ))),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
