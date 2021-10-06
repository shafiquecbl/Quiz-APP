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
  late List<Quiz1> subjectQuiz;
  List<Quiz1> quizList = [];
  List<String> idList = [];
  bool isLoaded = false;
  bool isEmpty = false;

  @override
  void initState() {
    getStudentQuiz();
    super.initState();
  }

  getStudentQuiz() {
    APIManager()
        .getStudentQuiz(
            token: widget.loginResponse!.token,
            id: widget.loginResponse!.user!.id)
        .then((value) {
      for (var quiz in value) {
        idList.add(quiz.quizName!);
      }
      getSubjectQuiz();
    });
  }

  getSubjectQuiz() {
    APIManager()
        .getSubjectQuizs(
            token: widget.loginResponse!.token, id: widget.subject!.id)
        .then((value) {
      subjectQuiz = value;
      if (value.isNotEmpty) {
        filterList();
      } else {
        setState(() {
          isLoaded = true;
        });
      }
    });
  }

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
          child: isLoaded == false
              ? MyLoading()
              : quizList.isEmpty || subjectQuiz.isEmpty
                  ? Center(
                      child: Text('No quiz available right now!'),
                    )
                  : GridView.count(
                      crossAxisCount: AppResponsive.isMobile(context) ? 2 : 5,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 25,
                      childAspectRatio: 1.4,
                      children: List.generate(quizList.length, (index) {
                        Quiz1 quiz = quizList[index];
                        return CustomCard(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (builder) => QuizPage(
                                            quiz: quiz,
                                            loginResponse: widget.loginResponse,
                                          )));
                            },
                            courseName: quiz.quizName);
                      })),
        ),
      );
    });
  }

  filterList() {
    subjectQuiz.forEach((quiz) {
      print('1: ${quiz.id}');
      if (idList.contains(quiz.id) == true) {
        setState(() {
          isLoaded = true;
        });
      } else {
        setState(() {
          isLoaded = true;
          quizList.add(quiz);
        });
      }
    });
  }
}
