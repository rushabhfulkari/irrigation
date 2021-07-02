import 'dart:io';
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:image_cropper/image_cropper.dart';
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
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class EditProfile extends StatefulWidget {
  EditProfile({
    Key key,
    this.name,
    this.phone,
    this.picurl,
    this.shop,
  }) : super(key: key);

  final String name;
  final String phone;
  final String picurl;
  final String shop;
  @override
  _EditProfileState createState() =>
      _EditProfileState(name, phone, picurl, shop);
}

class _EditProfileState extends State<EditProfile> {
  String name;
  String phone;
  String picurl;
  String shop;
  _EditProfileState(this.name, this.phone, this.picurl, this.shop);
  String timeString;
  File imageFile;
  DatabaseReference userDbReferece;
  Timer time1;

  bool updated = false;

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
    });
  }

  showAlertDialog(BuildContext context) {
    // Create button
    return Center(
        child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
    ));
  }

  void submitDetails(name, shop, time) async {
    if (imageFile != null) {
      final FirebaseAuth auth = FirebaseAuth.instance;
      final User user = auth.currentUser;
      final uid = user.uid;
      final userphone = user.phoneNumber.toString();
      Reference firebaseStorageRef =
          FirebaseStorage.instance.ref().child('profileuploads/$name');
      await firebaseStorageRef.putFile(imageFile);
      String url = (await firebaseStorageRef.getDownloadURL()).toString();
      userDbReferece.child('Profiles/' + userphone).set({
        "name": name,
        "phone": userphone,
        "shop": shop,
        "time": time,
        "picurl": url,
        "userid": uid,
      }).then((value) {
        Fluttertoast.showToast(
            msg: "Profile Updated!",
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
      final FirebaseAuth auth = FirebaseAuth.instance;
      final User user = auth.currentUser;
      final uid = user.uid;
      final userphone = user.phoneNumber.toString();
      await userDbReferece.child("Profiles").child(userphone).set({
        "name": name,
        "phone": userphone,
        "shop": shop,
        "time": time,
        "picurl": picurl,
        "userid": uid,
      }).then((value) {
        Fluttertoast.showToast(
            msg: "Profile Updated!",
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
        title: Text("Edit Profile"),
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
                    height: size.height * 0.6655,
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
                                        text: 'Edit Your Profile',
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
                                  child: (imageFile == null)
                                      ? picurl == "null"
                                          ? CircleAvatar(
                                              backgroundColor: Colors.black,
                                              radius: 60.0,
                                              child: CircleAvatar(
                                                radius: 55.0,
                                                child: ClipOval(
                                                    child: Icon(
                                                  Icons.photo,
                                                  color: kTextColor,
                                                  size: 40,
                                                )),
                                                backgroundColor: kPrimaryColor,
                                              ),
                                            )
                                          : CircleAvatar(
                                              backgroundColor: kPrimaryColor,
                                              radius: 59.0,
                                              backgroundImage: NetworkImage(
                                                picurl,
                                              ),
                                            )
                                      : CircleAvatar(
                                          backgroundColor: Colors.black,
                                          radius: 60.0,
                                          child: CircleAvatar(
                                            radius: 55.0,
                                            child: ClipOval(
                                              child: Image.file(
                                                  File(imageFile.path)),
                                            ),
                                            backgroundColor: kPrimaryColor,
                                          ),
                                        )),
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
                              text1("NAME"),
                              SizedBox(
                                height: size.height * 0.009,
                              ),
                              text4("SHOP NAME"),
                              SizedBox(
                                height: size.height * 0.009,
                              ),
                              text3("PHONE NUMBER"),
                              SizedBox(
                                height: size.height * 0.009,
                              ),
                              button("UPDATE")
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

  Widget text1(String labelText) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Container(
        height: 45,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30), color: Colors.black),
        child: TextFormField(
          onChanged: (value) {
            setState(() {
              this.name = value;
            });
          },
          initialValue: "$name",
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

  Widget text3(String labelText) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Container(
        height: 45,
        width: size.width * 0.8,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30), color: Colors.black),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "$phone",
                textAlign: TextAlign.left,
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget text4(String labelText) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Container(
        height: 45,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30), color: Colors.black),
        child: TextFormField(
          onChanged: (value) {
            setState(() {
              this.shop = value;
            });
          },
          initialValue: "$shop",
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

  Widget button(String hint) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: InkWell(
        onTap: () async {
          showDialog(
              context: context, builder: (context) => showAlertDialog(context));
          submitDetails(this.name, this.shop, this.timeString);
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
