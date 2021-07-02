import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:irrigation/constants.dart';
import 'package:irrigation/screens/addadefaulter/adddefaulter.dart';
import 'package:irrigation/screens/profile/components/profileheader.dart';
import 'package:irrigation/screens/profile/components/roundedbutton.dart';
import 'package:irrigation/screens/profile/components/roundedbuttonsmall.dart';
import 'package:irrigation/screens/profile/editprofilescreen.dart';
import 'package:irrigation/services/authservices.dart';

class ProfileBody extends StatefulWidget {
  @override
  _ProfileBodyState createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<ProfileBody> {
  Size size;
  String name, shop, phone, picurl;
  bool fetched = false;
  final formKey = new GlobalKey<FormState>();
  String phoneNo, verificationId, smsCode;
  bool codeSent = false;
  DateTime currentBackPressTime;

  void getData() {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    final userphone = user.phoneNumber.toString();
    // print(userphone);
    final dbRef =
        FirebaseDatabase.instance.reference().child("Profiles/" + userphone);
    dbRef.once().then((value) {
      setState(() {
        name = value.value['name'].toString();
        phone = value.value['phone'].toString();
        shop = value.value['shop'].toString();
        picurl = value.value['picurl'].toString();
        fetched = true;
      });
    });
  }

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
    getData();
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      // ignore: missing_return
      onWillPop: onWillPop,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Form(
            key: formKey,
            child: ListView(
              children: <Widget>[
                ProfileHeader(size: size),
                Container(
                  height: size.height * 0.42,
                  child: Column(
                    children: [
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  fetched
                                      ? picurl == "null"
                                          ? CircleAvatar(
                                              backgroundColor: kBack,
                                              radius: 60.0,
                                              child: CircleAvatar(
                                                radius: 59.0,
                                                child: ClipOval(
                                                    child: Icon(
                                                  Icons.person,
                                                  color: kTextColor,
                                                  size: 40,
                                                )),
                                                backgroundColor: kPrimaryColor,
                                              ),
                                            )
                                          : CircleAvatar(
                                              backgroundColor: kPrimaryColor,
                                              foregroundImage: NetworkImage(
                                                picurl,
                                              ),
                                              radius: 59.0,
                                              backgroundImage: AssetImage(
                                                  "assets/circleprofile.png"),
                                            )
                                      : Center(
                                          child: CircularProgressIndicator(
                                            valueColor:
                                                new AlwaysStoppedAnimation<
                                                    Color>(kPrimaryColor),
                                          ),
                                        )
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Column(
                              children: [
                                text1("NAME", "$name"),
                                text1("SHOP NAME", "$shop"),
                                text1("PHONE NUMBER", "$phone"),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: size.height * 0.001,
                ),
                RoundedButton(
                  text: "Add a Defaulter",
                  press: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddDefaulter()),
                    );
                  },
                ),
                SizedBox(
                  height: size.height * 0.016,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SmallRoundedButton(
                      text: "Edit Profile",
                      press: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditProfile(
                                    name: name,
                                    shop: shop,
                                    phone: phone,
                                    picurl: picurl,
                                  )),
                        );
                      },
                    ),
                    SmallRoundedButton(
                      text: "SignOut",
                      press: () {
                        showDialog(
                          barrierDismissible: true,
                          context: context,
                          builder: (ctx) {
                            return Align(
                              alignment: Alignment.center,
                              child: Container(
                                width: size.width * 0.7,
                                height: size.height * 0.15,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: 15,
                                ),
                                decoration: BoxDecoration(
                                  color: kTextColor,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(30),
                                    topRight: Radius.circular(30),
                                    bottomLeft: Radius.circular(30),
                                    bottomRight: Radius.circular(30),
                                  ),
                                ),
                                child: SizedBox(
                                  height: 10,
                                  child: Stack(
                                    children: [
                                      SingleChildScrollView(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Center(
                                              child: RichText(
                                                text: TextSpan(
                                                  style: TextStyle(
                                                      fontSize: 24,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                        text: 'Sign out?',
                                                        style: TextStyle(
                                                            color:
                                                                kBackgroundColor)),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: size.height * 0.01,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                GestureDetector(
                                                  onTap: () async {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Container(
                                                      height: 45,
                                                      width: 100,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(30),
                                                          color: kPrimaryColor),
                                                      child: Stack(
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Center(
                                                                child: RichText(
                                                                  text:
                                                                      TextSpan(
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            15,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                    children: <
                                                                        TextSpan>[
                                                                      TextSpan(
                                                                          text:
                                                                              "NO",
                                                                          style:
                                                                              TextStyle(color: kBackgroundColor)),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      )),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 5),
                                                  child: GestureDetector(
                                                    onTap: () async {
                                                      AuthService().signOut();
                                                      Navigator.pop(context);
                                                    },
                                                    child: Container(
                                                        height: 45,
                                                        width: 100,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        30),
                                                            color:
                                                                kPrimaryColor),
                                                        child: Stack(
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Center(
                                                                  child:
                                                                      RichText(
                                                                    text:
                                                                        TextSpan(
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              15,
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                      children: <
                                                                          TextSpan>[
                                                                        TextSpan(
                                                                            text:
                                                                                "YES",
                                                                            style:
                                                                                TextStyle(color: kBackgroundColor)),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        )),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ],
            )),
      ),
    );
  }

  Widget text1(String keytext, String valuetext) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Container(
        height: size.height * 0.07,
        width: size.width * 0.8,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: kPrimaryColor.withOpacity(1)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 2,
              child: Icon(
                keytext == "NAME"
                    ? Icons.person
                    : keytext == "SHOP NAME"
                        ? Icons.home
                        : Icons.phone,
                color: kBack,
                size: 28.0,
                // semanticLabel: 'Text to announce in accessibility modes',
              ),
            ),
            Expanded(
              flex: 5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      fetched
                          ? Text(
                              valuetext,
                              // "name",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18.0,
                                color: kBackgroundColor,
                              ),
                            )
                          : Text(
                              "",
                              // "name",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18.0,
                                color: kBackgroundColor,
                              ),
                            )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        keytext,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 12,
                            color: kBackgroundColor.withOpacity(0.7)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
