import 'package:flutter/material.dart';
import 'package:quiz_app/Models/User.dart';
import 'package:quiz_app/Screens/STUDENT/Student%20Dashboard/student_dashboard.dart';
import 'package:quiz_app/Screens/widget/student_side_bar.dart';
import 'package:quiz_app/common/app_responsive.dart';
import 'package:quiz_app/constants.dart';

class StudentHome extends StatefulWidget {
  final LoginResponse loginResponse;
  StudentHome({required this.loginResponse});
  @override
  _StudentHomeState createState() => _StudentHomeState();
}

class _StudentHomeState extends State<StudentHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: StudentSideBar(
        loginResponse: widget.loginResponse,
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
                child: StudentSideBar(
                  loginResponse: widget.loginResponse,
                ),
              ),

            /// Main Body Part
            Expanded(
              flex: 4,
              child: StudentDashboard(
                loginResponse: widget.loginResponse,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
