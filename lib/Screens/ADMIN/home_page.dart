import 'package:flutter/material.dart';
import 'package:quiz_app/Models/User.dart';
import 'package:quiz_app/common/app_responsive.dart';
import 'package:quiz_app/constants.dart';
import '../widget/side_bar_menu.dart';
import 'Dashboard/dashboard.dart';

class HomePage extends StatefulWidget {
  final LoginResponse loginResponse;
  HomePage({required this.loginResponse});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideBar(),
      backgroundColor: complexDrawerBlack,
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Side Navigation Menu
            /// Only show in desktop
            if (AppResponsive.isDesktop(context))
              Expanded(
                child: SideBar(),
              ),

            /// Main Body Part
            Expanded(
              flex: 4,
              child: Dashboard(
                loginResponse: widget.loginResponse,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
