import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/Models/User.dart';
import 'package:quiz_app/Provider/provider.dart';
import 'package:quiz_app/Screens/STUDENT/Courses/student_courses.dart';
import 'package:quiz_app/Screens/STUDENT/Quiz%20List/quiz_list.dart';
import 'package:quiz_app/Screens/STUDENT/Score%20Board/quiz_details.dart';
import 'package:quiz_app/Screens/STUDENT/Score%20Board/score_board.dart';
import 'package:quiz_app/Screens/STUDENT/Subjects/students_subjects_byCourses.dart';
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
    return Consumer<CustomProvier>(
      builder: (context, provider, child) {
        return PageView(
          physics: new NeverScrollableScrollPhysics(),
          controller: MyPageController.controller,
          children: [
            StudentCoursesWEB(
              loginResponse: widget.loginResponse,
            ),
            StudentSubjectsWEB(
              loginResponse: widget.loginResponse,
              course: provider.course,
            ),
            StudentQuizListWEB(
              loginResponse: widget.loginResponse,
              subject: provider.subject,
            ),
            StudentScoreBoard(
              loginResponse: widget.loginResponse,
            ),
            QuizDetails(
              solvedQuiz: provider.solvedQuiz,
              loginResponse: widget.loginResponse,
              isVisible: false,
            )
          ],
        );
      },
    );
  }
}
