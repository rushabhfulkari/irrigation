import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:irrigation/constants.dart';
import 'package:photo_view/photo_view.dart';

class ImageView extends StatefulWidget {
  final String imgUrl;
  ImageView({@required this.imgUrl});

  @override
  _ImageViewState createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  var filePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        Hero(
          tag: widget.imgUrl,
          child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: PhotoView(
                imageProvider: NetworkImage(
                  widget.imgUrl,
                ),
                initialScale: PhotoViewComputedScale.contained,
                minScale: PhotoViewComputedScale.contained,
                disableGestures: true,
              )),
        ),
      ],
    ));
  }
}
