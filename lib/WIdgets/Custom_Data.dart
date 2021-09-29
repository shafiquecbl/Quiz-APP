import 'package:flutter/material.dart';

class TextHead extends StatelessWidget {
  final String? heading;
  const TextHead({@required this.heading});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(left: 20),
      height: 50,
      color: Colors.blueGrey[200]!.withOpacity(0.3),
      child: Text(
        '$heading',
        style: TextStyle(color: Colors.black.withOpacity(0.7)),
      ),
    );
  }
}

class TextData extends StatelessWidget {
  final String? data;
  const TextData({@required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 20),
      child: Text(
        data.toString(),
        style: TextStyle(color: Colors.black.withOpacity(0.7)),
      ),
    );
  }
}
