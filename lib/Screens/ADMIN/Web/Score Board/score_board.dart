import 'package:data_tables/data_tables.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/Models/Student/Quiz.dart';
import 'package:quiz_app/Models/Student/solved_quiz.dart';
import 'package:quiz_app/Models/User.dart';
import 'package:quiz_app/Provider/provider.dart';
import 'package:quiz_app/Services/api_manager.dart';
import 'package:quiz_app/WIdgets/loading.dart';
import 'package:quiz_app/WIdgets/network_error.dart';
import 'package:quiz_app/constants.dart';
import 'package:quiz_app/controllers/page_controller.dart';

class ScoreBoardWEB extends StatefulWidget {
  final LoginResponse? loginResponse;

  ScoreBoardWEB({@required this.loginResponse});
  @override
  _ScoreBoardWEBState createState() => _ScoreBoardWEBState();
}

class _ScoreBoardWEBState extends State<ScoreBoardWEB> {
  int _rowsPerPage = 25;
  int _rowsOffset = 0;

  MyPageController pageController = MyPageController();

  Future<List<SolvedQuiz>>? solvedQuiz;
  CustomProvier? provier;

  bool isLoading = true;
  List<Quiz1> quizes = [];

  @override
  void initState() {
    getStudentQuiz();
    super.initState();
  }

  getStudentQuiz() {
    CustomProvier provider = Provider.of<CustomProvier>(context, listen: false);
    solvedQuiz = APIManager().adminGetStudentQuiz(
        token: widget.loginResponse!.token, id: provider.studentId);
    APIManager()
        .adminGetStudentQuiz(
            token: widget.loginResponse!.token, id: provider.studentId)
        .then((value) {
      for (var quiz in value) {
        getQuiz(quiz.quizName!);
      }
    });
  }

  getQuiz(String id) {
    APIManager()
        .getQuizById(token: widget.loginResponse!.token, id: id)
        .then((value) {
      quizes.add(value);
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Score Board'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Stack(
          children: [
            dataTable(),
            Container(
              height: 80,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Card(
                  color: yellow,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Row(
                      children: [
                        Text('Quizes List',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Colors.white)),
                        Spacer(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  dataTable() {
    return FutureBuilder<List<SolvedQuiz>>(
      future: solvedQuiz,
      builder:
          (BuildContext context, AsyncSnapshot<List<SolvedQuiz>> snapshot) {
        // if connection is loading show loading
        if (snapshot.connectionState == ConnectionState.waiting)
          return MyLoading();

        //if data is null show network error
        if (snapshot.data == null)
          return NetworkError(onPressed: () {
            setState(() {
              solvedQuiz = APIManager().adminGetStudentQuiz(
                  token: widget.loginResponse!.token, id: provier!.studentId);
            });
          });

        //if data length is ZERO show message
        if (snapshot.data!.length == 0)
          return Center(
            child: Text('No Quiz Available'),
          );

        //else show data
        return isLoading == true ? MyLoading() : scoreCard(quiz: snapshot.data);
      },
    );
  }

  scoreCard({@required List<SolvedQuiz>? quiz}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Card(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: NativeDataTable(
            rowsPerPage: _rowsPerPage,
            firstRowIndex: _rowsOffset,
            handleNext: () {
              if (_rowsOffset + 25 < quiz!.length) {
                setState(() {
                  _rowsOffset += _rowsPerPage;
                  print(_rowsOffset.toString());
                });
              }
            },
            handlePrevious: () {
              if (_rowsOffset > 0) {
                setState(() {
                  _rowsOffset -= _rowsPerPage;
                  print(_rowsOffset.toString());
                });
              }
            },
            mobileIsLoading: CircularProgressIndicator(),
            columns: [
              DataColumn(label: Text('ID')),
              DataColumn(label: Text('Quiz Name')),
              DataColumn(label: Text('Total Questions')),
              DataColumn(label: Text('Solved Questions')),
              DataColumn(label: Text('Marks')),
              DataColumn(label: Text('Date')),
              DataColumn(label: Text('Action')),
            ],
            rows: List.generate(quiz!.length, (index) {
              return score(index, quiz: quiz[index]);
            }),
          ),
        ),
      ),
    );
  }

  score(int index, {@required SolvedQuiz? quiz}) {
    return DataRow(cells: [
      DataCell(Text('${index + 1}')),
      DataCell(Text('${quizes[index].quizName}')),
      DataCell(Text('${quizes[index].question!.length}')),
      DataCell(Text(quiz!.questionAttempted.toString())),
      DataCell(Text(quiz.marks.toString())),
      DataCell(Text(quiz.createdAt.toString().substring(0, 11))),
      DataCell(Consumer<CustomProvier>(
        builder: (context, provider, child) {
          return Container(
            width: 100,
            height: 30,
            child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(primary: Colors.green),
                onPressed: () {
                  provider.saveSolvedQuiz(quiz: quiz);
                  widget.loginResponse!.user!.role == 'admin'
                      ? pageController.changePage(12)
                      : pageController.changePage(3);
                },
                icon: Icon(Icons.view_list_outlined),
                label: Text('View')),
          );
        },
      )),
    ]);
  }
}
