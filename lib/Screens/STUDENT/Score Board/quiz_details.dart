import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:quiz_app/Models/Student/Quiz.dart';
import 'package:quiz_app/Models/Student/solved_quiz.dart';
import 'package:quiz_app/Models/User.dart';
import 'package:quiz_app/Screens/STUDENT/Home/student_home.dart';
import 'package:quiz_app/Screens/widget/Navigator.dart';
import 'package:quiz_app/Services/api_manager.dart';
import 'package:quiz_app/WIdgets/loading.dart';
import 'package:quiz_app/WIdgets/network_error.dart';
import 'package:quiz_app/constants.dart';

class QuizDetails extends StatefulWidget {
  final SolvedQuiz? solvedQuiz;
  final StudentLoginResponse? loginResponse;
  final bool? isVisible;
  const QuizDetails(
      {@required this.solvedQuiz,
      @required this.loginResponse,
      @required this.isVisible});

  @override
  _QuizDetailsState createState() => _QuizDetailsState();
}

class _QuizDetailsState extends State<QuizDetails> {
  ScrollController controller = ScrollController();
  double? percentage;
  Future<Quiz1>? quizModel;

  @override
  void initState() {
    fetchQuizData();
    super.initState();
  }

  fetchQuizData() {
    quizModel = APIManager().getQuizById(
        token: widget.loginResponse!.token, id: widget.solvedQuiz!.quizName);
  }

  double calculatePercentage(
      {@required int? totalQuestions, @required int? marks}) {
    return percentage = (marks! / 100) * totalQuestions!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Quiz1>(
        future: quizModel,
        builder: (BuildContext context, AsyncSnapshot<Quiz1> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return MyLoading();
          if (snapshot.data == null)
            return NetworkError(onPressed: () {
              print(widget.solvedQuiz!.quizName);
              setState(() {
                quizModel = APIManager().getQuizById(
                    token: widget.loginResponse!.token,
                    id: widget.solvedQuiz!.quizName);
              });
            });
          percentage = calculatePercentage(
              marks: widget.solvedQuiz!.marks,
              totalQuestions: snapshot.data!.question!.length);
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
                scoreDetails(quiz: snapshot.data),
                Expanded(
                    child: Scrollbar(
                  showTrackOnHover: true,
                  isAlwaysShown: true,
                  interactive: true,
                  controller: controller,
                  child: ListView.separated(
                      controller: controller,
                      separatorBuilder: (context, index) {
                        return Divider();
                      },
                      itemCount: snapshot.data!.question!.length,
                      itemBuilder: (context, index) {
                        Question1 question = snapshot.data!.question![index];
                        return questionData(question: question);
                      }),
                ))
              ],
            ),
          );
        },
      ),
    );
  }

  scoreDetails({@required Quiz1? quiz}) {
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
                    widget.solvedQuiz!.questionAttempted.toString(),
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
                    widget.solvedQuiz!.marks.toString(),
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
                fontSize: 20,
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
      ],
    );
  }
}
