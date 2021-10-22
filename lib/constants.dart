import 'package:flutter/material.dart';

const Color complexDrawerBlack = Color(0xff11111d);
const Color complexDrawerBlueGrey = Color(0xff1d1b31);
const Color whiteColor = Colors.white;
const kTextColor = Color(0xFF757575);

const Color yellow = Color(0xfff7c844);
const Color bgColor = Color(0xfff8f7f3);
const Color black = Colors.black;

bool isEmail(String em) {
  String p =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  RegExp regExp = new RegExp(p);

  return regExp.hasMatch(em);
}
