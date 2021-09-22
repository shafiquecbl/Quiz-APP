import 'package:flutter/material.dart';

pushAndRemoveUntil(BuildContext context, Widget page) {
  return Navigator.pushAndRemoveUntil(
      context, MaterialPageRoute(builder: (_) => page), (route) => false);
}
