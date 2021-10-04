import 'package:data_tables/data_tables.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/Models/Student/solved_quiz.dart';
import 'package:quiz_app/Models/User.dart';
import 'package:quiz_app/Provider/provider.dart';
import 'package:quiz_app/Services/api_manager.dart';
import 'package:quiz_app/WIdgets/loading.dart';
import 'package:quiz_app/WIdgets/network_error.dart';
import 'package:quiz_app/controllers/page_controller.dart';

class StudentScoreBoard extends StatefulWidget {
  final StudentLoginResponse? loginResponse;
  StudentScoreBoard({@required this.loginResponse});
  @override
  _StudentScoreBoardState createState() => _StudentScoreBoardState();
}

class _StudentScoreBoardState extends State<StudentScoreBoard> {
  int _rowsPerPage = 25;
  int _rowsOffset = 0;

  MyPageController pageController = MyPageController();

  Future<List<SolvedQuiz>>? solvedQuiz;

  @override
  void initState() {
    getStudentQuiz();
    super.initState();
  }

  getStudentQuiz() {
    solvedQuiz = APIManager().getStudentQuiz(
        token: widget.loginResponse!.token, id: widget.loginResponse!.user!.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Score Board'),
      ),
      body: FutureBuilder<List<SolvedQuiz>>(
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
                solvedQuiz = APIManager().getStudentQuiz(
                    token: widget.loginResponse!.token,
                    id: widget.loginResponse!.user!.id);
              });
            });

          //if data length is ZERO show message
          if (snapshot.data!.length == 0)
            return Center(
              child: Text('No Quiz Available'),
            );

          //else show data
          return scoreCard(quiz: snapshot.data);
        },
      ),
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
            // mobileItemBuilder: (context, index) {
            //   return ExpansionTile(
            //       leading: Text('${index + 1}'),
            //       title: Text(
            //         'ABC',
            //         maxLines: 3,
            //         overflow: TextOverflow.ellipsis,
            //       ));
            // },
            columns: [
              DataColumn(label: Text('ID')),
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
      DataCell(Text('$index')),
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
                  pageController.changePage(4);
                },
                icon: Icon(Icons.view_list_outlined),
                label: Text('View')),
          );
        },
      )),
    ]);
  }
}
