import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/Models/Student/Quiz.dart';
import 'package:quiz_app/Models/Student/student_subjects.dart';
import 'package:quiz_app/Models/User.dart';
import 'package:quiz_app/Provider/provider.dart';
import 'package:quiz_app/Screens/STUDENT/QuizPage/quiz_page.dart';
import 'package:quiz_app/Screens/widget/custom_card.dart';
import 'package:quiz_app/Services/api_manager.dart';
import 'package:quiz_app/WIdgets/loading.dart';
import 'package:quiz_app/common/app_responsive.dart';
import 'package:quiz_app/controllers/page_controller.dart';

class StudentQuizListWEB extends StatefulWidget {
  final StudentLoginResponse? loginResponse;
  final StudentSubject? subject;
  StudentQuizListWEB({@required this.loginResponse, @required this.subject});

  @override
  _StudentQuizListWEBState createState() => _StudentQuizListWEBState();
}

class _StudentQuizListWEBState extends State<StudentQuizListWEB> {
  MyPageController pageController = MyPageController();
  @override
  Widget build(BuildContext context) {
    return Consumer<CustomProvier>(builder: (context, provider, child) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Quizes in ${widget.subject!.subjectName}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600)),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
          child: FutureBuilder<List<Quiz1>>(
            future: APIManager().getSubjectQuizs(
                token: widget.loginResponse!.token, id: widget.subject!.id),
            builder:
                (BuildContext context, AsyncSnapshot<List<Quiz1>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting)
                return MyLoading();
              if (snapshot.data!.length == 0)
                return Center(
                  child: Text('No Quiz in this subject!'),
                );
              return GridView.count(
                  crossAxisCount: AppResponsive.isMobile(context) ? 2 : 5,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 25,
                  childAspectRatio: 1.4,
                  children: List.generate(snapshot.data!.length, (index) {
                    Quiz1 quiz = snapshot.data![index];
                    return CustomCard(
                        onPressed: () {
                          print(quiz.quizName);
                          print(quiz.id);
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (builder) => QuizPage(
                          //               quiz: quiz,
                          //               loginResponse: widget.loginResponse,
                          //             )));
                        },
                        courseName: quiz.quizName);
                  }));
            },
          ),
        ),
      );
    });
  }
}
