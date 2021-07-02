import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:irrigation/constants.dart';
import 'package:irrigation/screens/login/components/goback.dart';
import 'package:irrigation/screens/login/components/otproundedtextfield.dart';
import 'package:irrigation/screens/login/components/popupotpsent.dart';
import 'package:irrigation/screens/login/components/loginheader.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:irrigation/screens/login/components/roundedbutton.dart';
import 'package:irrigation/screens/login/components/phoneroundedtextfield.dart';
import 'package:irrigation/services/authservices.dart';

class LoginBody extends StatefulWidget {
  @override
  _LoginBodyState createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> {
  final formKey = new GlobalKey<FormState>();
  String phoneNo, verificationId, smsCode;
  bool codeSent = false;
  DateTime currentBackPressTime;

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(
          msg: "Double Press to Exit!!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: kTextColor,
          textColor: kBackgroundColor,
          fontSize: 16.0);
      return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Form(
            key: formKey,
            child: ListView(
              children: <Widget>[
                LoginHeader(size: size),
                Container(
                  child: SingleChildScrollView(
                    physics: NeverScrollableScrollPhysics(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RoundedInputField(
                          hintText: "Enter phone number",
                          onChanged: (value) {
                            setState(() {
                              this.phoneNo = "+91" + value;
                            });
                          },
                        ),
                        codeSent
                            ? OtpRoundedInputField(
                                hintText: "Enter OTP",
                                onChanged: (value) {
                                  setState(() {
                                    this.smsCode = value;
                                  });
                                },
                              )
                            : Container(),
                        RoundedButton(
                          text: codeSent ? "LogIn" : "Verify",
                          press: () {
                            showDialog(
                                context: context,
                                builder: (context) => showAlertDialog(context));

                            codeSent
                                ? AuthService().signInWithOTP(
                                    smsCode, verificationId, phoneNo, context)
                                : phoneNo == null
                                    ? null
                                    : verifyPhone(phoneNo);
                          },
                        ),
                        SizedBox(height: size.height * 0.17),
                        codeSent ? OtpSent(size: size) : Container(),
                        SizedBox(height: size.height * 0.02),
                        codeSent ? GoBack(size: size) : Container(),
                      ],
                    ),
                  ),
                )
              ],
            )),
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    // Create button
    return Center(
        child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
    ));
  }

  Future<void> verifyPhone(phoneNo) async {
    final PhoneVerificationCompleted verified = (AuthCredential authResult) {
      AuthService().signIn(authResult, phoneNo, context);
      print("object2");
    };

    final PhoneVerificationFailed verificationfailed =
        (FirebaseAuthException authException) {
      print('${authException.message}');
    };

    final PhoneCodeSent smsSent = (String verId, [int forceResend]) {
      this.verificationId = verId;
      setState(() {
        this.codeSent = true;
        print("object");
        Navigator.pop(context);
      });
    };

    final PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId) {
      this.verificationId = verId;
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNo,
        timeout: const Duration(seconds: 30),
        verificationCompleted: verified,
        verificationFailed: verificationfailed,
        codeSent: smsSent,
        codeAutoRetrievalTimeout: autoTimeout);
  }
}
