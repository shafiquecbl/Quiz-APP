import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/Models/User.dart';
import 'package:quiz_app/Provider/provider.dart';
import 'package:quiz_app/Screens/ADMIN/Web/Quiz/Questions/Questions_Web.dart';
import 'package:quiz_app/Screens/ADMIN/Web/Quiz/Quizs/Quiz_Web.dart';
import 'package:quiz_app/Screens/ADMIN/Web/Score%20Board/quiz_details.dart';
import 'package:quiz_app/Screens/ADMIN/Web/Score%20Board/score_board.dart';
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
    return Consumer<CustomProvier>(
      builder: (context, provider, child) {
        return PageView(
          physics: new NeverScrollableScrollPhysics(),
          controller: MyPageController.controller,
          children: [
            // AppResponsive.isDesktop(context)
            //     ? QuizWEB(loginResponse: widget.loginResponse)
            //     : QuizMobile(),
            // AppResponsive.isDesktop(context)
            //     ? QuestionsWEB(loginResponse: widget.loginResponse)
            //     : QuestionsMobile(),
            QuizWEB(loginResponse: widget.loginResponse),
            QuestionsWEB(loginResponse: widget.loginResponse),
            ScoreBoardWEB(loginResponse: widget.loginResponse),
            QuizDetailsWEB(
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
