import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:irrigation/components/navbar.dart';
import 'package:irrigation/constants.dart';
import 'package:irrigation/screens/profile/components/profilebody.dart';
import 'package:irrigation/widgets/maindrawer.dart';
import 'package:irrigation/widgets/widgets.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: ProfileBody(),
      bottomNavigationBar: MyBottomNavBar(
        onhome: false,
        onprofile: true,
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
