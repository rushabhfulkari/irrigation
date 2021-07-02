import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:irrigation/constants.dart';
import 'package:irrigation/screens/profile/profilebutton.dart';
import 'package:irrigation/screens/home/homebutton.dart';
import 'package:irrigation/screens/login/loginbutton.dart';
import 'package:path/path.dart';

class AuthService {
  handleAuth1() {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            // return null;
            return ProfileScreen();
          } else {
            return LoginScreen();
          }
        });
  }

  signOut() {
    FirebaseAuth.instance.signOut();
  }

  signIn(AuthCredential authCreds, String phone, BuildContext context) {
    FirebaseAuth.instance.signInWithCredential(authCreds);
    DatabaseReference userDbReferece =
        FirebaseDatabase.instance.reference().child('Profiles/' + phone);
    userDbReferece.once().then((DataSnapshot dataSnapshot) {
      if (dataSnapshot.value.toString() == "null") {
        userDbReferece.set({
          "name": "user",
          "phone": phone,
          "shop": "",
        }).then((value) {
          Fluttertoast.showToast(
              msg: "Registration Successful!!",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: kTextColor,
              textColor: kBackgroundColor,
              fontSize: 16.0);
        });
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => HomeScreen(
              shown: false,
            ),
            transitionDuration: Duration(seconds: 0),
          ),
        );
      } else {
        Fluttertoast.showToast(
            msg: "Logged In!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: kTextColor,
            textColor: kBackgroundColor,
            fontSize: 16.0);
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => HomeScreen(
              shown: false,
            ),
            transitionDuration: Duration(seconds: 0),
          ),
        );
      }
    });
  }

  signInWithOTP(smsCode, verId, phone, context) {
    AuthCredential authCreds =
        PhoneAuthProvider.credential(verificationId: verId, smsCode: smsCode);
    signIn(authCreds, phone, context);
  }
}
