import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:irrigation/constants.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:irrigation/screens/detailsdefaulter/detailsdefaulter.dart';

class DefaulterCard extends StatelessWidget {
  const DefaulterCard({
    Key key,
    this.image,
    this.name,
    this.press,
    this.size,
    this.fetched,
  }) : super(key: key);

  final String image, name;
  final Function press;
  final Size size;
  final bool fetched;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Container(
        // height: size.height,
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 4,
              child: Container(
                height: size.height / 5.3,
                width: size.width / 2.8,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                    color: kPrimaryColor.withOpacity(0.7)),
                child: image == null
                    ? CircleAvatar(
                        backgroundColor: kPrimaryColor.withOpacity(0.7),
                        radius: 5.0,
                        child: CircleAvatar(
                            radius: 40.0,
                            backgroundColor: kTextColor,
                            child: Center(
                              child: Text(
                                "${name[0]}".toUpperCase(),
                                style: TextStyle(fontSize: 30),
                              ),
                            )),
                      )
                    : Container(
                        height: size.height / 5.3,
                        width: size.width / 2.8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                          image: DecorationImage(
                            image: NetworkImage(
                              image,
                            ),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                width: size.width / 2.8,
                height: size.height / 16,
                padding: EdgeInsets.all(kDefaultPadding / 2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 10),
                      blurRadius: 50,
                      color: kPrimaryColor.withOpacity(0.23),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    AutoSizeText("$name",
                        minFontSize: 8,
                        maxFontSize: 12,
                        style: TextStyle(
                            color: kTextColor, fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
