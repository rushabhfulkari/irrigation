import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:irrigation/components/navbar.dart';
import 'package:irrigation/constants.dart';
import 'package:irrigation/main.dart';
import 'package:irrigation/screens/home/components/body.dart';
import 'package:irrigation/services/versioncheck.dart';
import 'package:irrigation/widgets/maindrawer.dart';
import 'package:irrigation/widgets/widgets.dart';

class HomeScreen extends StatefulWidget {
  bool shown;
  HomeScreen({@required this.shown});
  @override
  _HomeScreenState createState() => _HomeScreenState(shown);
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  bool shown;
  _HomeScreenState(this.shown);
  @override
  void initState() {
    super.initState();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                color: kPrimaryColor,
                playSound: true,
                icon: '@mipmap/launcher_icon1',
              ),
            ));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification.android;
      if (notification != null && android != null) {
        showDialog(
            context: context,
            builder: (_) {
              return HomeScreen(
                shown: true,
              );
            });
      }
    });
  }

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

  Future<Null> _refresh() {
    return Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => HomeScreen(
          shown: true,
        ),
        transitionDuration: Duration(seconds: 1),
      ),
    );
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    DatabaseReference userDbReferece;
    userDbReferece = FirebaseDatabase.instance.reference();
    if (shown == false) {
      versionCheck(context, userDbReferece);
    }
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        key: _scaffoldKey,
        drawer: Theme(
          data: Theme.of(context).copyWith(
            canvasColor:
                kPrimaryColor, //This will change the drawer background to blue.
            //other styles
          ),
          child: Drawer(
            child: MainDrawer(),
          ),
        ),
        appBar: buildAppBar(context),
        body: RefreshIndicator(
            color: kPrimaryColor,
            backgroundColor: kTextColor,
            key: _refreshIndicatorKey,
            onRefresh: _refresh,
            child: Body()),
        bottomNavigationBar: MyBottomNavBar(
          onhome: true,
          onprofile: false,
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext ctx) {
    return AppBar(
      elevation: 0,
      leading: IconButton(
        icon: SvgPicture.asset("assets/icons/menu.svg"),
        onPressed: () => _scaffoldKey.currentState.openDrawer(),
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.share,
            color: Colors.white,
          ),
          onPressed: () {
            onShare(context);
          },
        )
      ],
    );
  }
}
