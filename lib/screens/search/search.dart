import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:irrigation/components/navbar.dart';
import 'package:irrigation/constants.dart';
import 'package:irrigation/screens/detailsdefaulter/detailsdefaulter.dart';
import 'package:irrigation/screens/home/components/card.dart';
import 'package:irrigation/screens/home/homebutton.dart';
import 'package:irrigation/widgets/maindrawer.dart';
import 'package:irrigation/widgets/widgets.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({Key key, this.list}) : super(key: key);
  final list;
  @override
  _SearchScreenState createState() => _SearchScreenState(list);
}

class _SearchScreenState extends State<SearchScreen> {
  final List list;
  _SearchScreenState(
    this.list,
  );
  TextEditingController _textController = TextEditingController();
  // final list = [];
  var newDataList = [];

  @override
  void initState() {
    super.initState();
    newDataList = list;
  }

  onItemChanged(String value) {
    setState(() {
      newDataList = list.where((string) {
        return (string['name']
                .toString()
                .toLowerCase()
                .contains(value.toLowerCase()) ||
            string['aadhar']
                .toString()
                .toLowerCase()
                .contains(value.toLowerCase()) ||
            string['phone']
                .toString()
                .toLowerCase()
                .contains(value.toLowerCase()) ||
            string['phoneshop']
                .toString()
                .toLowerCase()
                .contains(value.toLowerCase()) ||
            string['shop']
                .toString()
                .toLowerCase()
                .contains(value.toLowerCase()));
      }).toList();
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      // ignore: missing_return
      onWillPop: () {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => HomeScreen(
              shown: true,
            ),
            transitionDuration: Duration(seconds: 1),
          ),
        );
      },
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
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: kDefaultPadding),
                height: size.height * 0.2,
                child: Stack(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(
                        left: kDefaultPadding,
                        right: kDefaultPadding,
                        bottom: 36 + kDefaultPadding,
                      ),
                      height: size.height * 0.2 - 27,
                      decoration: BoxDecoration(
                        color: kPrimaryColor,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(36),
                          bottomRight: Radius.circular(36),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Center(
                            child: Text('Irri',
                                style: TextStyle(
                                    fontSize: 60,
                                    color: kBackgroundColor,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation1, animation2) =>
                                  SearchScreen(),
                              transitionDuration: Duration(seconds: 1),
                            ),
                          );
                        },
                        child: Container(
                          alignment: Alignment.center,
                          margin:
                              EdgeInsets.symmetric(horizontal: kDefaultPadding),
                          padding:
                              EdgeInsets.symmetric(horizontal: kDefaultPadding),
                          height: 54,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(0, 10),
                                blurRadius: 50,
                                color: kPrimaryColor.withOpacity(0.23),
                              ),
                            ],
                          ),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: TextField(
                                  onChanged: onItemChanged,
                                  autofocus: true,
                                  cursorColor: kPrimaryColor,
                                  decoration: InputDecoration(
                                    hintText: "Search for Defaulters",
                                    hintStyle: TextStyle(
                                      color: kPrimaryColor.withOpacity(0.9),
                                      fontSize: 15,
                                    ),
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                  ),
                                ),
                              ),
                              SvgPicture.asset("assets/icons/search.svg"),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                // margin: EdgeInsets.only(bottom: kDefaultPadding),
                height: size.height * 0.05,
                width: size.width,
                child: Text(
                  newDataList.length != 0 ? "Recent Defaulters" : "No Match",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: kBackgroundColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w400),
                ),
              ),
              GridView.builder(
                  primary: true,
                  padding: const EdgeInsets.all(20),
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 0,
                      mainAxisSpacing: 35),
                  itemCount: newDataList.length != 0
                      ? newDataList.length <= 50
                          ? newDataList.length
                          : 50
                      : 0,
                  itemBuilder: (BuildContext ctx, int index) {
                    return newDataList.length != 0
                        ? DefaulterCard(
                            image: newDataList[index]["picurl"],
                            name: newDataList[index]["name"],
                            size: size,
                            press: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailsScreen(
                                    aadhar: newDataList[index]["aadhar"],
                                    name: newDataList[index]["name"],
                                    phone: newDataList[index]["phone"],
                                    phoneshop: newDataList[index]["phoneshop"],
                                    picurl: newDataList[index]["picurl"],
                                    shop: newDataList[index]["shop"],
                                  ),
                                ),
                              );
                            },
                          )
                        : null;
                  }),
            ],
          ),
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
