import 'dart:io';
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:irrigation/widgets/imageview.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:irrigation/constants.dart';
import 'package:irrigation/widgets/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DetailsScreen extends StatefulWidget {
  DetailsScreen({
    Key key,
    this.size,
    this.name,
    this.aadhar,
    this.phone,
    this.phoneshop,
    this.picurl,
    this.shop,
  }) : super(key: key);
  final Size size;
  final String name;
  final String aadhar;
  final String phone;
  final String phoneshop;
  final String picurl;
  final String shop;

  @override
  _DetailsScreenState createState() =>
      _DetailsScreenState(size, name, aadhar, phone, phoneshop, picurl, shop);
}

class _DetailsScreenState extends State<DetailsScreen> {
  Size size;
  String name;
  String aadhar;
  String phone;
  String phoneshop;
  String picurl;
  String shop;
  _DetailsScreenState(this.size, this.name, this.aadhar, this.phone,
      this.phoneshop, this.picurl, this.shop);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        toolbarHeight: 60,
        elevation: 0,
        title: Text("Defaulter Details"),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                decoration: BoxDecoration(
                  color: kPrimaryColor,
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: size.width * 0.9,
                    height: size.height * 0.9,
                    padding: EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 30,
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
                    child: Stack(
                      children: [
                        SingleChildScrollView(
                          // physics: NeverScrollableScrollPhysics(),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: 'Defaulter Details',
                                          style: TextStyle(
                                              fontFamily: 'Sen',
                                              fontSize: 30,
                                              color: kBackgroundColor)),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: size.height * 0.03,
                              ),
                              InkWell(
                                onTap: () {
                                  // _showChoiceDialog(context);
                                },
                                child: picurl != null
                                    ? GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => ImageView(
                                                  imgUrl: picurl,
                                                ),
                                              ));
                                        },
                                        child: Container(
                                          height: size.height / 4.2,
                                          width: size.width / 2.5,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              topRight: Radius.circular(10),
                                              bottomLeft: Radius.circular(10),
                                              bottomRight: Radius.circular(10),
                                            ),
                                            image: DecorationImage(
                                              image: NetworkImage(picurl),
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container(
                                        height: size.height / 4.2,
                                        width: size.width / 2.5,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              topRight: Radius.circular(10),
                                              bottomLeft: Radius.circular(10),
                                              bottomRight: Radius.circular(10),
                                            ),
                                            color:
                                                kPrimaryColor.withOpacity(0.7)),
                                        child: CircleAvatar(
                                          backgroundColor:
                                              kPrimaryColor.withOpacity(0.7),
                                          radius: 5.0,
                                          child: CircleAvatar(
                                              radius: 40.0,
                                              backgroundColor: kTextColor,
                                              child: Center(
                                                child: Text(
                                                  "${name[0]}".toUpperCase(),
                                                  style:
                                                      TextStyle(fontSize: 30),
                                                ),
                                              )),
                                        )),
                              ),
                              SizedBox(
                                height: size.height * 0.03,
                              ),
                              text1("NAME", "$name"),
                              text1("AADHAR CARD NUMBER", "$aadhar"),
                              text1("PHONE NUMBER", "$phone"),
                              text1("SHOP NAME", "$shop"),
                              text1("SHOP PHONE NUMBER", "$phoneshop"),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  valuetext,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, color: kBackgroundColor),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  keytext,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 12, color: kBackgroundColor.withOpacity(0.7)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
