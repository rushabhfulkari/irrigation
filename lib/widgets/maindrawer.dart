import 'package:flutter/material.dart';
import 'package:irrigation/constants.dart';
import 'package:irrigation/screens/feedback.dart';
import 'package:irrigation/widgets/widgets.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:launch_review/launch_review.dart';

class MainDrawer extends StatefulWidget {
  const MainDrawer({Key key}) : super(key: key);
  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        decoration: BoxDecoration(
          color: kPrimaryColor,
        ),
        child: Padding(
          padding: EdgeInsets.only(top: 50.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: kBackgroundColor,
                  border: Border.all(color: kBackgroundColor),
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                ),
                child: CircleAvatar(
                  radius: 40.0,
                  backgroundImage: AssetImage('assets/icon.png'),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                "Irri",
                style: TextStyle(
                  fontSize: 35.0,
                  fontWeight: FontWeight.bold,
                  color: kBackgroundColor,
                ),
              ),
              SizedBox(
                height: 1.0,
              ),
              Text(
                "Beware from Defaulters",
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.w500,
                  color: kBackgroundColor,
                ),
              ),
            ],
          ),
        ),
      ),
      SizedBox(
        height: 20.0,
      ),
      ListTile(
        onTap: () {
          LaunchReview.launch(androidAppId: "com.dts.irrigation");
        },
        leading: Icon(
          Icons.star,
          color: kBackgroundColor,
          size: 30,
        ),
        title: Text(
          "Rate Us",
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: kBackgroundColor,
          ),
        ),
      ),
      ListTile(
        onTap: () {
          launchURL(
              'https://play.google.com/store/search?q=pub%3ADEVTAS&c=apps');
        },
        leading: Icon(
          Icons.apps_rounded,
          color: kBackgroundColor,
          size: 30,
        ),
        title: Text(
          "More Apps",
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: kBackgroundColor,
          ),
        ),
      ),
      ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => GetFeedback()),
          );
        },
        leading: Icon(
          Icons.email_rounded,
          color: kBackgroundColor,
          size: 30,
        ),
        title: Text(
          "Feedback",
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: kBackgroundColor,
          ),
        ),
      ),
      ListTile(
        onTap: () {
          _showMyDialog();
        },
        leading: Icon(
          Icons.shield,
          color: kBackgroundColor,
          size: 30,
        ),
        title: Text(
          "Privacy Policy",
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: kBackgroundColor,
          ),
        ),
      ),
      ListTile(
        onTap: () {
          onShare(context);
        },
        leading: Icon(
          Icons.share,
          color: kBackgroundColor,
          size: 30,
        ),
        title: Text(
          "Share this App",
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: kBackgroundColor,
          ),
        ),
      ),
    ]);
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Privacy Policy'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    "This Privacy Policy is only applicable if you have downloaded this App from the developer DEVTAS.\n\nDEVTAS built the Irri app as a Free app.\n\nThis SERVICE is provided by DEVTAS at no cost and is intended for use as is.\n\nCopyright: DEVTAS. ALL RIGHTS RESERVED."),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
