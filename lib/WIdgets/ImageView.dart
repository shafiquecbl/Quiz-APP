import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'dart:ui' as ui;

class ImageView extends StatelessWidget {
  final String? image;
  ImageView({@required this.image}) {
    String imageUrl = image.toString();

    ui.platformViewRegistry.registerViewFactory(
      imageUrl,
      (int _) => html.ImageElement()..src = imageUrl,
    );
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
              color: Colors.grey[200], borderRadius: BorderRadius.circular(5)),
          child: image != null
              ? HtmlElementView(viewType: image!)
              : Icon(Icons.image)),
    );
  }
}

class CustomImageView extends StatelessWidget {
  final String? image;
  final int? width, height;
  CustomImageView(
      {@required this.image, @required this.height, @required this.width}) {
    String imageUrl = image.toString();

    ui.platformViewRegistry.registerViewFactory(
        imageUrl,
        (int _) =>
            html.ImageElement(src: imageUrl, width: width, height: height));
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Container(
        child: image != null
            ? HtmlElementView(viewType: image.toString())
            : Icon(Icons.image),
      ),
    );
  }
}
