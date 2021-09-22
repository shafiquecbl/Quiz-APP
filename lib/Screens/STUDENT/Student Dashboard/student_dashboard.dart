import 'package:flutter/material.dart';
import 'package:quiz_app/Models/User.dart';
import 'package:quiz_app/Screens/STUDENT/Courses/student_courses.dart';
import 'package:quiz_app/controllers/page_controller.dart';

class StudentDashboard extends StatefulWidget {
  final StudentLoginResponse loginResponse;
  StudentDashboard({required this.loginResponse});
  @override
  _StudentDashboardState createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  @override
  Widget build(BuildContext context) {
    return PageView(
      physics: new NeverScrollableScrollPhysics(),
      controller: MyPageController.controller,
      children: [
        StudentCoursesWEB(
          loginResponse: widget.loginResponse,
        )
      ],
    );
  }
}
