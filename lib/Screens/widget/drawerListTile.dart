import 'package:flutter/material.dart';
import 'package:quiz_app/constants.dart';

class DrawerListTile extends StatelessWidget {
  final String? title;
  final Function()? onPressed;

  const DrawerListTile({this.title, this.onPressed});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      child: TextButton(
          onPressed: onPressed,
          child: Text(
            title.toString(),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: TextStyle(color: whiteColor),
          )),
    );
  }
}
