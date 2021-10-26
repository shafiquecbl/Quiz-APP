import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:quiz_app/Models/Student/Quiz.dart';
import 'package:quiz_app/Models/Student/student_solved_quiz.dart';
import 'package:quiz_app/Models/User.dart';
import 'package:quiz_app/constants.dart';
import 'package:quiz_app/controllers/page_controller.dart';

class QuizDetailsWEB extends StatefulWidget {
  final StudentQuiz? studentQuiz;
  final LoginResponse? loginResponse;
  final bool? isVisible;
  const QuizDetailsWEB(
      {@required this.studentQuiz,
      @required this.loginResponse,
      @required this.isVisible});

  @override
  _QuizDetailsWEBState createState() => _QuizDetailsWEBState();
}

class _QuizDetailsWEBState extends State<QuizDetailsWEB> {
  ScrollController controller = ScrollController();
  MyPageController pageController = MyPageController();
  double? percentage;

  double calculatePercentage(
      {@required int? totalQuestions, @required int? marks}) {
    return percentage = (marks! / totalQuestions!) * 100;
  }

  @override
  Widget build(BuildContext context) {
    percentage = calculatePercentage(
        marks: widget.studentQuiz!.solvedQuiz!.marks,
        totalQuestions: widget.studentQuiz!.quiz!.question!.length);
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                pageController.changePage(
                    widget.loginResponse!.user!.role == 'admin' ? 11 : 3);
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.black87,
              ))),
      body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: SingleChildScrollView(
            controller: controller,
            child: Column(
              children: [
                scoreDetails(sQuiz: widget.studentQuiz),
                for (var question in widget.studentQuiz!.quiz!.question!)
                  questionData(question: question)
              ],
            ),
          )),
    );
  }

  scoreDetails({@required StudentQuiz? sQuiz}) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Total Questions
            Expanded(
              child: Column(
                children: [
                  Text(
                    "Total Questions",
                    style: TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 22.0,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  Text(
                    sQuiz!.quiz!.question!.length.toString(),
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 22.0,
                        fontWeight: FontWeight.w300),
                  )
                ],
              ),
            ),

            // Attempted Questions
            Expanded(
              child: Column(
                children: [
                  Text(
                    "Attempted Questions",
                    style: TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 22.0,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  Text(
                    sQuiz.solvedQuiz!.questionAttempted.toString(),
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 22.0,
                        fontWeight: FontWeight.w300),
                  )
                ],
              ),
            ),

            // Marks Obtained
            Expanded(
              child: Column(
                children: [
                  Text(
                    "Marks Obtained",
                    style: TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 22.0,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  Text(
                    sQuiz.solvedQuiz!.marks.toString(),
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 22.0,
                        fontWeight: FontWeight.w300),
                  )
                ],
              ),
            ),

            // Percentage
            Expanded(
              child: Column(
                children: [
                  SizedBox(
                    height: 25,
                  ),
                  Text(
                    "Percentage",
                    style: TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 22.0,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 10),
                    child: CircularPercentIndicator(
                      radius: 50.0,
                      lineWidth: 2.0,
                      percent: percentage! / 100,
                      center: Text(
                        '${percentage!.toStringAsFixed(0)}%',
                      ),
                      progressColor: percentage! <= 50.0
                          ? Colors.red
                          : 51.0 <= percentage! && percentage! <= 70.0
                              ? Colors.orange
                              : Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  questionData({@required Question1? question}) {
    return Wrap(
      direction: Axis.vertical,
      children: [
        SizedBox(
          height: 30,
        ),
        Container(
          width: MediaQuery.of(context).size.width / 1.3,
          decoration: BoxDecoration(
            color: yellow,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Text(
              question!.questionStatement.toString(),
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Container(
              width: MediaQuery.of(context).size.width / 1.5,
              margin: EdgeInsets.only(top: 10),
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListTile(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                leading: Text(
                  'Answer.',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.blue,
                      fontWeight: FontWeight.w600),
                ),
                title: Text(
                  question.answer.toString(),
                  style: TextStyle(fontSize: 16),
                ),
              )),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
            width: MediaQuery.of(context).size.width,
            height: 0.8,
            color: Colors.grey[300]),
      ],
    );
  }
}
