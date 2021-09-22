import 'package:flutter/material.dart';

class MyPageController {
  static PageController controller =
      PageController(initialPage: 1, keepPage: false);

  void changePage(int index) {
    controller.animateToPage(
      index,
      duration: Duration(milliseconds: 800),
      curve: Curves.ease,
    );
  }
}
