import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

void onShare(BuildContext context) async {
  final RenderBox box = context.findRenderObject() as RenderBox;

  await Share.share(
      "Irri\nWorlds Best Defaulter Finder App\nAvailable on Play Store for Free\n\nhttps://play.google.com/store/apps/details?id=com.dts.irrigation",
      subject: "Share",
      sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
}

void launchURL(url) async =>
    await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
