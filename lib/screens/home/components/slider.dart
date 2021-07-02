import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:irrigation/constants.dart';
import 'package:irrigation/widgets/widgets.dart';

class ImageSlider extends StatefulWidget {
  ImageSlider({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _ImageSliderState createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  final userDbReferece =
      FirebaseDatabase.instance.reference().child("SliderImages").once();
  String i1;
  String i2;
  String i3;
  String i4;
  String i5;
  String l1;
  String l2;
  String l3;
  String l4;
  String l5;
  bool fetched = false;

  @override
  Widget build(BuildContext context) {
    userDbReferece.then((value) {
      setState(() {
        i1 = value.value['i1'].toString();
        i2 = value.value['i2'].toString();
        i3 = value.value['i3'].toString();
        i4 = value.value['i4'].toString();
        i5 = value.value['i5'].toString();
        l1 = value.value['l1'].toString();
        l2 = value.value['l2'].toString();
        l3 = value.value['l3'].toString();
        l4 = value.value['l4'].toString();
        l5 = value.value['l5'].toString();
        fetched = true;
      });
    });
    return 
    
    Container(
      margin: EdgeInsets.symmetric(vertical: kDefaultPadding),
      child: ListView(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: [
          CarouselSlider(
            items: [
              //1st Image of Slider
              fetched
                  ? GestureDetector(
                      onTap: () {
                        launchURL(l1);
                      },
                      child: Container(
                        margin: EdgeInsets.all(6.0),
                        decoration: BoxDecoration(
                          // color: kPrimaryColor,
                          borderRadius: BorderRadius.circular(8.0),
                          image: DecorationImage(
                            image: NetworkImage(i1),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    )
                  : Center(
                      child: CircularProgressIndicator(
                          valueColor: new AlwaysStoppedAnimation<Color>(
                              kPrimaryColor))),
              fetched
                  ? GestureDetector(
                      onTap: () {
                        launchURL(l2);
                      },
                      child: Container(
                        margin: EdgeInsets.all(6.0),
                        decoration: BoxDecoration(
                          // color: kPrimaryColor,
                          borderRadius: BorderRadius.circular(8.0),
                          image: DecorationImage(
                            image: NetworkImage(i2),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    )
                  : Center(
                      child: CircularProgressIndicator(
                          valueColor: new AlwaysStoppedAnimation<Color>(
                              kPrimaryColor))),
              fetched
                  ? GestureDetector(
                      onTap: () {
                        launchURL(l3);
                      },
                      child: Container(
                        margin: EdgeInsets.all(6.0),
                        decoration: BoxDecoration(
                          // color: kPrimaryColor,
                          borderRadius: BorderRadius.circular(8.0),
                          image: DecorationImage(
                            image: NetworkImage(i3),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    )
                  : Center(
                      child: CircularProgressIndicator(
                          valueColor: new AlwaysStoppedAnimation<Color>(
                              kPrimaryColor))),
              fetched
                  ? GestureDetector(
                      onTap: () {
                        launchURL(l4);
                      },
                      child: Container(
                        margin: EdgeInsets.all(6.0),
                        decoration: BoxDecoration(
                          // color: kPrimaryColor,
                          borderRadius: BorderRadius.circular(8.0),
                          image: DecorationImage(
                            image: NetworkImage(i4),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    )
                  : Center(child: CircularProgressIndicator()),
              fetched
                  ? GestureDetector(
                      onTap: () {
                        launchURL(l5);
                      },
                      child: Container(
                        margin: EdgeInsets.all(6.0),
                        decoration: BoxDecoration(
                          // color: kPrimaryColor,
                          borderRadius: BorderRadius.circular(8.0),
                          image: DecorationImage(
                            image: NetworkImage(i5),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    )
                  : Center(
                      child: CircularProgressIndicator(
                          valueColor: new AlwaysStoppedAnimation<Color>(
                              kPrimaryColor))),
            ],
            //Slider Container properties
            options: CarouselOptions(
              height: 180.0,
              enlargeCenterPage: true,
              autoPlayInterval: Duration(seconds: 3),
              autoPlay: true,
              aspectRatio: 16 / 9,
              autoPlayCurve: Curves.fastOutSlowIn,
              enableInfiniteScroll: true,
              autoPlayAnimationDuration: Duration(milliseconds: 1000),
              viewportFraction: 0.8,
            ),
          ),
        ],
      ),
    );
 
  }
}
