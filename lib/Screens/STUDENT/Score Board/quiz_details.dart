import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:quiz_app/Models/Student/Quiz.dart';
import 'package:quiz_app/Models/Student/solved_quiz.dart';
import 'package:quiz_app/Models/Student/student_solved_quiz.dart';
import 'package:quiz_app/Models/User.dart';
import 'package:quiz_app/Screens/STUDENT/Home/student_home.dart';
import 'package:quiz_app/Screens/widget/Navigator.dart';
import 'package:quiz_app/WIdgets/ImageView.dart';
import 'package:quiz_app/constants.dart';
import 'package:quiz_app/controllers/page_controller.dart';

import 'components/option.dart';

class QuizDetails extends StatefulWidget {
  final StudentQuiz? studentQuiz;
  final LoginResponse? loginResponse;
  final bool? isVisible;
  const QuizDetails(
      {@required this.studentQuiz,
      @required this.loginResponse,
      @required this.isVisible});

  @override
  _QuizDetailsState createState() => _QuizDetailsState();
}

class _QuizDetailsState extends State<QuizDetails> {
  ScrollController controller = ScrollController();
  MyPageController pageController = MyPageController();
  double? percentage;
  Future<Quiz1>? quizModel;

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
              pageController.changePage(3);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black87,
            )),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: SingleChildScrollView(
            controller: controller,
            child: Column(
              children: [
                widget.isVisible == true
                    ? Row(
                        children: [
                          Container(
                            width: 120,
                            decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(30)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextButton.icon(
                                  onPressed: () {
                                    pushAndRemoveUntil(
                                        context,
                                        StudentHome(
                                            loginResponse:
                                                widget.loginResponse!));
                                  },
                                  icon: Icon(Icons.arrow_back_ios),
                                  label: Text('Home')),
                            ),
                          ),
                          Spacer()
                        ],
                      )
                    : Container(),
                scoreDetails(quiz: widget.studentQuiz!.quiz!),
                for (int index = 0;
                    index <=
                        widget.studentQuiz!.solvedQuiz!.submittedAnswer!
                                .length -
                            1;
                    index++)
                  questionData(
                      question: widget.studentQuiz!.quiz!.question![index],
                      submittedAnswer: widget
                          .studentQuiz!.solvedQuiz!.submittedAnswer![index])
              ],
            )),
      ),
    );
  }

  Widget scoreDetails({@required Quizz? quiz}) {
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
                    quiz!.question!.length.toString(),
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
                    widget.studentQuiz!.solvedQuiz!.questionAttempted
                        .toString(),
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
                    widget.studentQuiz!.solvedQuiz!.marks.toString(),
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

  questionData(
      {@required Question1? question,
      @required SubmittedAnswer? submittedAnswer}) {
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
        question.questionImage!.length != 0
            ? Container(
                width: MediaQuery.of(context).size.width / 1.3,
                child: CarouselSlider(
                  options: CarouselOptions(
                    viewportFraction: 2.0,
                    height: 450,
                    enableInfiniteScroll: false,
                  ),
                  items: question.questionImage!.map((i) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          child: CustomImageView(
                            image: i,
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
              )
            : Container(),

        //////////////////////////////////////////////////////

        SizedBox(
          height: 10,
        ),

        submittedAnswer!.answer != question.answer
            ? OptionWidgett(
                text: submittedAnswer.answer.toString(),
                isTrue: false,
              )
            : Container(),

        SizedBox(
          height: 10,
        ),

        OptionWidgett(
          text: question.answer.toString(),
          isTrue: true,
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
