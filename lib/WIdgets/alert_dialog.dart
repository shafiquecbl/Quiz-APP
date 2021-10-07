import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

customDialog(BuildContext context,
    {@required String? title,
    @required String? content,
    @required Function()? onPressed1,
    @required Function()? onPressed2}) {
  // set up the button
  Widget button1 = CupertinoDialogAction(
    child: Text("Delete"),
    onPressed: onPressed1,
  );

  Widget button2 = CupertinoDialogAction(
    child: Text('De-Activate'),
    onPressed: onPressed2,
  );

  // set up the AlertDialog
  CupertinoAlertDialog alert = CupertinoAlertDialog(
    title: Text(title.toString()),
    content: Text(content.toString()),
    actions: [
      button2,
      button1,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
