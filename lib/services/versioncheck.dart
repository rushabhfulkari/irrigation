import 'package:flutter/material.dart';
import 'package:irrigation/constants.dart';
import 'package:irrigation/widgets/widgets.dart';

double appVersion = 1.0;
void versionCheck(BuildContext ctx, dbReference) {
  Size size = MediaQuery.of(ctx).size;
  dbReference.child("Version").once().then((value) {
    double version = double.parse(value.value['v'].toString());
    String cu = value.value['cu'].toString();
    String show = value.value['s'].toString();
    String link = value.value['l'].toString();
    if (show == "yes") {
      if (appVersion < version) {
        showDialog(
          barrierDismissible: (cu == "no"),
          context: ctx,
          builder: (ctx) {
            return WillPopScope(
              onWillPop: () async => (cu == "no"),
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  width: size.width * 0.7,
                  height: size.height * 0.1454,
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
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: 'Update Available!',
                                          style: TextStyle(
                                              color: kBackgroundColor)),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: size.height * 0.01,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      Navigator.pop(ctx);
                                    },
                                    child: Container(
                                        height: 45,
                                        width: 100,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            color: kPrimaryColor),
                                        child: Stack(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Center(
                                                  child: RichText(
                                                    text: TextSpan(
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      children: <TextSpan>[
                                                        TextSpan(
                                                            text: "LATER",
                                                            style: TextStyle(
                                                                color:
                                                                    kBackgroundColor)),
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
                                        horizontal: 10, vertical: 5),
                                    child: GestureDetector(
                                      onTap: () async {
                                        launchURL(link);
                                      },
                                      child: Container(
                                          height: 45,
                                          width: 100,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              color: kPrimaryColor),
                                          child: Stack(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Center(
                                                    child: RichText(
                                                      text: TextSpan(
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                        children: <TextSpan>[
                                                          TextSpan(
                                                              text: "UPDATE",
                                                              style: TextStyle(
                                                                  color:
                                                                      kBackgroundColor)),
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
              ),
            );
          },
        );
      }
    }
  });
}
