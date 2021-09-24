import 'package:flutter/material.dart';
import 'package:quiz_app/Models/User.dart';
import 'package:quiz_app/Screens/Teacher/Teacher%20Dashboard/teacher_dashbaord.dart';
import 'package:quiz_app/Screens/widget/teacher_sideBar.dart';
import 'package:quiz_app/common/app_responsive.dart';
import 'package:quiz_app/constants.dart';

class TeacherHomePage extends StatefulWidget {
  final LoginResponse loginResponse;
  TeacherHomePage({required this.loginResponse});
  @override
  _TeacherHomePageState createState() => _TeacherHomePageState();
}

class _TeacherHomePageState extends State<TeacherHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: TeacherSideBar(
        role: widget.loginResponse.user!.role,
      ),
      backgroundColor: complexDrawerBlack,
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Side Navigation Menu
            /// Only show in desktop
            if (AppResponsive.isDesktop(context))
              Expanded(
                child: TeacherSideBar(
                  role: widget.loginResponse.user!.role,
                ),
              ),

            /// Main Body Part
            Expanded(
              flex: 4,
              child: TeacherDashboard(
                loginResponse: widget.loginResponse,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
