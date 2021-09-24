import 'package:flutter/material.dart';
import 'package:quiz_app/Models/User.dart';
import 'package:quiz_app/Screens/ADMIN/Mobile/Quiz/Questions/Questions_Mobile.dart';
import 'package:quiz_app/Screens/ADMIN/Mobile/Quiz/Quizs/quiz_Mobile.dart';
import 'package:quiz_app/Screens/ADMIN/Web/Quiz/Questions/Questions_Web.dart';
import 'package:quiz_app/Screens/ADMIN/Web/Quiz/Quizs/Quiz_Web.dart';
import 'package:quiz_app/common/app_responsive.dart';
import 'package:quiz_app/controllers/page_controller.dart';

class TeacherDashboard extends StatefulWidget {
  final LoginResponse loginResponse;
  TeacherDashboard({required this.loginResponse});
  @override
  _TeacherDashboardState createState() => _TeacherDashboardState();
}

class _TeacherDashboardState extends State<TeacherDashboard> {
  @override
  Widget build(BuildContext context) {
    return PageView(
      physics: new NeverScrollableScrollPhysics(),
      controller: MyPageController.controller,
      children: [
        AppResponsive.isDesktop(context)
            ? QuizWEB(loginResponse: widget.loginResponse)
            : QuizMobile(),
        AppResponsive.isDesktop(context)
            ? QuestionsWEB(loginResponse: widget.loginResponse)
            : QuestionsMobile(),
      ],
    );
  }
}
