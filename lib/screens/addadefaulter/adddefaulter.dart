import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:irrigation/screens/profile/profilebutton.dart';
import 'package:irrigation/services/authservices.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:irrigation/constants.dart';
import 'package:irrigation/widgets/widgets.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AddDefaulter extends StatefulWidget {
  @override
  _AddDefaulterState createState() => _AddDefaulterState();
}

class _AddDefaulterState extends State<AddDefaulter> {
  String timeString;
  File imageFile;
  Timer time1;
  DatabaseReference userDbReferece;
  String name, aadhar, phone, shop, phoned;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController aadharController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController shopController = TextEditingController();
  final TextEditingController phonedController = TextEditingController();

  Future _showChoiceDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: kTextColor,
            title: Text(
              "Choose option",
              style: TextStyle(color: kBackgroundColor),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Divider(
                    height: 1,
                    color: kPrimaryColor,
                  ),
                  ListTile(
                    onTap: () {
                      _openGallery(context);
                    },
                    title: Text(
                      "Gallery",
                      style: TextStyle(color: kBackgroundColor),
                    ),
                    leading: Icon(
                      Icons.account_box,
                      color: kPrimaryColor,
                    ),
                  ),
                  Divider(
                    height: 1,
                    color: kPrimaryColor,
                  ),
                  ListTile(
                    onTap: () {
                      _openCamera(context);
                    },
                    title: Text(
                      "Camera",
                      style: TextStyle(color: kBackgroundColor),
                    ),
                    leading: Icon(
                      Icons.camera,
                      color: kPrimaryColor,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  void _getTime() {
    final String formattedDateTime =
        DateFormat('yyyy-MM-dd kk:mm:ss').format(DateTime.now()).toString();
    setState(() {
      timeString = formattedDateTime;
      // print(timeString);
    });
  }

  showAlertDialog(BuildContext context) {
    // Create button
    return Center(
        child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
    ));
  }

  void submitDetails(name, phone, aadhar, shop, phoned, time) async {
    if (imageFile != null) {
      Reference firebaseStorageRef =
          FirebaseStorage.instance.ref().child('defaulteruploads/$name');
      await firebaseStorageRef.putFile(imageFile);
      String url = (await firebaseStorageRef.getDownloadURL()).toString();
      // var dowurl = uploadTask
      //     .whenComplete(() async => await firebaseStorageRef.getDownloadURL());
      // String url = dowurl.toString();
      // print(url);

      await userDbReferece.child("Defaulters").push().set({
        "name": name,
        "aadhar": aadhar,
        "phone": phone,
        "shop": shop,
        "phoneshop": phoned,
        "time": time,
        "picurl": url,
      }).then((value) {
        Fluttertoast.showToast(
            msg: "Defaulter added!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: kTextColor,
            textColor: kBackgroundColor,
            fontSize: 16.0);
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => ProfileScreen(),
            transitionDuration: Duration(seconds: 1),
          ),
        );
      });
    } else {
      await userDbReferece.child("Defaulters").push().set({
        "name": name,
        "aadhar": aadhar,
        "phone": phone,
        "shop": shop,
        "phoneshop": phoned,
        "time": time,
      }).then((value) {
        Fluttertoast.showToast(
            msg: "Defaulter added!",
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
          pageBuilder: (context, animation1, animation2) => ProfileScreen(),
          transitionDuration: Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    userDbReferece = FirebaseDatabase.instance.reference();
    time1 = Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
  }

  @override
  void dispose() {
    super.dispose();
    time1.cancel();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        toolbarHeight: 60,
        elevation: 0,
        title: Text("Add a Defaulter"),
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
                    height: size.height * 0.85,
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
                            children: [
                              RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: 'Fill in the Details',
                                        style: TextStyle(
                                            fontFamily: 'Sen',
                                            fontSize: 30,
                                            color: kBackgroundColor)),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              InkWell(
                                onTap: () {
                                  _showChoiceDialog(context);
                                },
                                child: CircleAvatar(
                                  backgroundColor: Colors.black,
                                  radius: 60.0,
                                  child: CircleAvatar(
                                    radius: 55.0,
                                    child: ClipOval(
                                      child: (imageFile == null)
                                          ? Icon(
                                              Icons.photo,
                                              color: kTextColor,
                                              size: 40,
                                            )
                                          : Image.file(File(imageFile.path)),
                                    ),
                                    backgroundColor: kPrimaryColor,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: size.height * 0.019,
                              ),
                              RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: 'Pick a Image',
                                        style: TextStyle(
                                            fontFamily: 'Sen',
                                            color: kBackgroundColor)),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: size.height * 0.019,
                              ),
                              text1(nameController, "DEFAULTER'S NAME"),
                              SizedBox(
                                height: size.height * 0.009,
                              ),
                              text2(aadharController, "AADHAR NUMBER"),
                              SizedBox(
                                height: size.height * 0.009,
                              ),
                              text3(
                                  phoneController, "DEFAULTER'S PHONE NUMBER"),
                              SizedBox(
                                height: size.height * 0.009,
                              ),
                              text4(shopController, "YOUR SHOP NAME"),
                              SizedBox(
                                height: size.height * 0.009,
                              ),
                              text5(phonedController, "YOUR PHONE NUMBER"),
                              SizedBox(
                                height: size.height * 0.03,
                              ),
                              button("ADD")
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

  Widget text1(TextEditingController controller, String labelText) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Container(
        height: 45,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30), color: Colors.black),
        child: TextField(
          onChanged: (value) {
            setState(() {
              this.name = value;
            });
          },
          controller: controller,
          maxLength: 20,
          cursorColor: kPrimaryColor,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
              hintText: labelText,
              counter: SizedBox.shrink(),
              hintStyle: TextStyle(color: Colors.grey, fontSize: 14.0),
              contentPadding: EdgeInsets.symmetric(horizontal: 15),
              border: UnderlineInputBorder(borderSide: BorderSide.none)),
        ),
      ),
    );
  }

  Widget text2(TextEditingController controller, String labelText) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Container(
        height: 45,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30), color: Colors.black),
        child: TextField(
          onChanged: (value) {
            setState(() {
              this.aadhar = value;
            });
          },
          controller: controller,
          keyboardType: TextInputType.number,
          maxLength: 12,
          cursorColor: kPrimaryColor,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
              counter: SizedBox.shrink(),
              hintText: labelText,
              hintStyle: TextStyle(color: Colors.grey, fontSize: 14.0),
              contentPadding: EdgeInsets.symmetric(horizontal: 15),
              border: UnderlineInputBorder(borderSide: BorderSide.none)),
        ),
      ),
    );
  }

  Widget text3(TextEditingController controller, String labelText) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Container(
        height: 45,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30), color: Colors.black),
        child: TextField(
          onChanged: (value) {
            setState(() {
              this.phone = value;
            });
          },
          controller: controller,
          keyboardType: TextInputType.number,
          maxLength: 10,
          cursorColor: kPrimaryColor,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
              counter: SizedBox.shrink(),
              hintText: labelText,
              hintStyle: TextStyle(color: Colors.grey, fontSize: 14.0),
              contentPadding: EdgeInsets.symmetric(horizontal: 15),
              border: UnderlineInputBorder(borderSide: BorderSide.none)),
        ),
      ),
    );
  }

  Widget text4(TextEditingController controller, String labelText) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Container(
        height: 45,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30), color: Colors.black),
        child: TextField(
          onChanged: (value) {
            setState(() {
              this.shop = value;
            });
          },
          controller: controller,
          maxLength: 20,
          cursorColor: kPrimaryColor,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
              counter: SizedBox.shrink(),
              hintText: labelText,
              hintStyle: TextStyle(color: Colors.grey, fontSize: 14.0),
              contentPadding: EdgeInsets.symmetric(horizontal: 15),
              border: UnderlineInputBorder(borderSide: BorderSide.none)),
        ),
      ),
    );
  }

  Widget text5(TextEditingController controller, String labelText) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Container(
        height: 45,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30), color: Colors.black),
        child: TextField(
          onChanged: (value) {
            setState(() {
              this.phoned = value;
            });
          },
          controller: controller,
          keyboardType: TextInputType.number,
          maxLength: 10,
          cursorColor: kPrimaryColor,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
              counter: SizedBox.shrink(),
              hintText: labelText,
              hintStyle: TextStyle(color: Colors.grey, fontSize: 14.0),
              contentPadding: EdgeInsets.symmetric(horizontal: 15),
              border: UnderlineInputBorder(borderSide: BorderSide.none)),
        ),
      ),
    );
  }

  Widget button(String hint) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: InkWell(
        onTap: () async {
          submitDetails(
            this.name,
            this.aadhar,
            this.phone,
            this.shop,
            this.phoned,
            this.timeString.toString(),
          );
          showDialog(
              context: context, builder: (context) => showAlertDialog(context));
        },
        child: Container(
            height: 45,
            width: 100,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30), color: kPrimaryColor),
            child: Stack(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                          children: <TextSpan>[
                            TextSpan(
                                text: hint,
                                style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            )),
      ),
    );
  }

  void _openGallery(BuildContext context) async {
    final pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      File croppedFile = await ImageCropper.cropImage(
        sourcePath: pickedFile.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
        ],
        androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Crop the Image',
          toolbarColor: kPrimaryColor,
          toolbarWidgetColor: Colors.white,
          hideBottomControls: true,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: true,
        ),
      );
      croppedFile != null
          ? setState(() {
              imageFile = File(croppedFile.path);
            })
          : null;
      Navigator.pop(context);
    }
  }

  void _openCamera(BuildContext context) async {
    final pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
    );
    if (pickedFile != null) {
      File croppedFile = await ImageCropper.cropImage(
        sourcePath: pickedFile.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
        ],
        androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Crop the Image',
          toolbarColor: kPrimaryColor,
          toolbarWidgetColor: Colors.white,
          hideBottomControls: true,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: true,
        ),
      );
      croppedFile != null
          ? setState(() {
              imageFile = File(croppedFile.path);
            })
          : Navigator.pop(context);
      Navigator.pop(context);
    }
  }
}
