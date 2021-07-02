import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:irrigation/constants.dart';
import 'package:irrigation/screens/detailsdefaulter/detailsdefaulter.dart';
import 'package:irrigation/screens/home/components/card.dart';
import 'package:irrigation/screens/home/components/slider.dart';
import 'package:irrigation/screens/home/components/titlebelowsearch.dart';
import 'package:irrigation/screens/home/components/titlebelowslider.dart';
import 'package:irrigation/screens/search/search.dart';

class Body extends StatelessWidget {
  final dbRef = FirebaseDatabase.instance.reference().child("Defaulters");
  DateFormat format = new DateFormat("yyyy-m-dd H:m:s");
  final list = [];
  bool fetched = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: kDefaultPadding),
            // It will cover 20% of our total height
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
                  child: 
                  
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation1, animation2) =>
                              SearchScreen(
                            list: list,
                          ),
                          transitionDuration: Duration(seconds: 1),
                        ),
                      );
                    },
                    child: Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.symmetric(horizontal: kDefaultPadding),
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
                              child: Text(
                            "Search for Defaulters",
                            style: TextStyle(
                              color: kPrimaryColor.withOpacity(0.9),
                              fontSize: 15,
                            ),
                          )),
                          SvgPicture.asset("assets/icons/search.svg"),
                        ],
                      ),
                    ),
                  ),
                
                ),
              ],
            ),
          ),
          TitleBelowSearch(title: "Click to Search"),
          ImageSlider(),
          TitleBelowSlider(title: "Recent Defaulters"),
          FutureBuilder(
              future: dbRef.orderByChild("time").once(),
              builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
                if (snapshot.hasData) {
                  list.clear();
                  Map<dynamic, dynamic> values = snapshot.data.value;
                  values.forEach((key, values) {
                    list.add(values);
                    fetched = true;
                  });
                  list.sort((a, b) {
                    return DateTime.parse(b["time"])
                        .compareTo(DateTime.parse(a["time"]));
                  });
                  return new GridView.builder(
                      primary: true,
                      padding: const EdgeInsets.all(20),
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 0,
                          mainAxisSpacing: 35),
                      itemCount: list.length <= 20 ? list.length : 20,
                      itemBuilder: (BuildContext ctx, int index) {
                        return list.length != 0
                            ? DefaulterCard(
                                image: list[index]["picurl"],
                                name: list[index]["name"],
                                size: size,
                                fetched: fetched,
                                press: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DetailsScreen(
                                        aadhar: list[index]["aadhar"],
                                        name: list[index]["name"],
                                        phone: list[index]["phone"],
                                        phoneshop: list[index]["phoneshop"],
                                        picurl: list[index]["picurl"],
                                        shop: list[index]["shop"],
                                      ),
                                    ),
                                  );
                                },
                              )
                            : Text("No Defaulters available!");
                      });
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Center(
                      child: CircularProgressIndicator(
                    valueColor:
                        new AlwaysStoppedAnimation<Color>(kPrimaryColor),
                  )),
                );
              }),
          // SizedBox(height: kDefaultPadding),
        ],
      ),
    );
  }
}
