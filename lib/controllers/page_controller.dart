import 'package:flutter/material.dart';

class MyPageController {
  static PageController controller =
      PageController(initialPage: 2, keepPage: false);

  void changePage(int index) {
    controller.jumpToPage(index);
  }
}
