import 'package:data_tables/data_tables.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/Models/Questions.dart';
import 'package:quiz_app/Models/Quiz.dart';
import 'package:quiz_app/Models/User.dart';
import 'package:quiz_app/Screens/widget/Search_Field.dart';
import 'package:quiz_app/Screens/widget/head_card.dart';
import 'package:quiz_app/Services/api_manager.dart';
import 'package:quiz_app/WIdgets/Custom_Error.dart';
import 'package:quiz_app/WIdgets/loading.dart';
import 'package:quiz_app/WIdgets/network_error.dart';
import 'package:quiz_app/constants.dart';
import 'package:quiz_app/size_config.dart';
import 'package:intl/intl.dart';

class QuizWEB extends StatefulWidget {
  final LoginResponse? loginResponse;
  QuizWEB({@required this.loginResponse});
  @override
  _QuizWEBState createState() => _QuizWEBState();
}

class _QuizWEBState extends State<QuizWEB> {
  int _rowsPerPage = 25;
  int _rowsOffset = 0;
  String? search = '';
  bool checkBox = false;
  Quiz? editQuiz;
  bool isLoading = false;
  bool isLoad = false;
  String? error, quizName, courseId, subjectId, level, attemptDate, timeType;
  int? timeInSeconds;

  ////////////////////////////////////////////////////

  String? setDate;

  String? dateTime;

  DateTime selectedDate = DateTime.now();

  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);

  TextEditingController _dateController = TextEditingController();

  ////////////////////////////////////////////////////

  Function(void Function())? myState;
  final _formKey = GlobalKey<FormState>();

  static List coursesMenu = [];
  static List subjectsMenu = [];
  static List questionsMenu = [];
  List? questionsList = [];
  static const levelMenu = <String>[
    'Beginner',
    'Intermediate',
    'Advanced',
  ];
  final List<DropdownMenuItem<String>> popUpMenuItem = levelMenu
      .map((String value) => DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          ))
      .toList();

  static const timetype = <String>[
    'perQuestion',
    'Overall',
  ];
  final List<DropdownMenuItem<String>> timeMenuItem = timetype
      .map((String value) => DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          ))
      .toList();

  Future<List<Quiz>>? _quizModel;

  getCourses() {
    APIManager()
        .getCoursesList(token: widget.loginResponse!.token)
        .then((value) {
      coursesMenu = value;
    });
  }

  getSubjects() {
    APIManager()
        .getSubjectByCourseId(
            token: widget.loginResponse!.token, courseId: courseId)
        .then((value) {
      if (this.mounted) {
        myState!(() {
          subjectsMenu = value;
        });
      }
    });
  }

  getQuestions() {
    myState!(() {
      isLoad = true;
    });
    APIManager()
        .getQuestionsBySubjectId(
            token: widget.loginResponse!.token,
            subjectId: subjectId,
            level: level)
        .then((value) {
      myState!(() {
        isLoad = false;
        questionsMenu = value;
      });
    });
  }

  @override
  void initState() {
    _quizModel = APIManager().fetchQUIZList(token: widget.loginResponse!.token);
    getCourses();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Quizs',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 0, right: 10),
            child: SearchField(search: search, hintText: 'Search quizes'),
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Stack(
          children: [
            dataTable(),
            HeadCard(
                title: 'Quizs List',
                onPressed: () {
                  showForm(title: 'ADD QUIZ');
                }),
          ],
        ),
      ),
    );
  }

  ////////////////////// DATA TABLE //////////////////////

  Widget dataTable() {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 20),
      child: Container(
        width: SizeConfig.screenWidth,
        height: SizeConfig.screenHeight,
        child: Card(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: FutureBuilder<List<Quiz>>(
              future: _quizModel,
              builder:
                  (BuildContext context, AsyncSnapshot<List<Quiz>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return MyLoading();
                if (snapshot.data == null)
                  return NetworkError(onPressed: () {
                    setState(() {
                      _quizModel = APIManager()
                          .fetchQUIZList(token: widget.loginResponse!.token);
                      getCourses();
                    });
                  });
                return quizList(snapshot.data!);
              },
            ),
          ),
        ),
      ),
    );
  }

  quizList(List<Quiz> list) {
    return Expanded(
        child: Container(
      height: MediaQuery.of(context).size.height / 1.1,
      child: NativeDataTable(
        rowsPerPage: _rowsPerPage,
        firstRowIndex: _rowsOffset,
        handleNext: () {
          if (_rowsOffset + 25 < list.length) {
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
        mobileItemBuilder: (context, index) {
          return ExpansionTile(
              leading: Text('${index + 1}'),
              title: Text(
                'ABC',
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ));
        },
        columns: [
          DataColumn(label: Text('ID')),
          DataColumn(label: Text('Name')),
          DataColumn(label: Text('Attempt Date')),
          DataColumn(label: Text('Subjects')),
          DataColumn(label: Text('Course')),
          DataColumn(label: Text('Action')),
        ],
        rows: List.generate(list.length, (index) => quiz(list[index], index)),
      ),
    ));
  }

  quiz(Quiz? quiz, index) {
    return DataRow(cells: [
      DataCell(Text('$index')),
      DataCell(Text(quiz!.quizName.toString())),
      DataCell(Text(quiz.attempDate.toString())),
      DataCell(Text(quiz.subject!.subjectName.toString())),
      DataCell(Text(quiz.course!.name.toString())),
      DataCell(Container(
        width: 125,
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.green),
                onPressed: () {
                  editQuiz = quiz;
                  showForm(title: 'UPDATE QUIZ');
                },
                child: Text('EDIT')),
            ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.red),
                onPressed: () {
                  APIManager()
                      .deleteQUIZ(
                          token: widget.loginResponse!.token, id: quiz.id)
                      .then((value) {
                    updatePage();
                  });
                },
                child: Text('DELETE'))
          ],
        ),
      )),
    ]);
  }

  ////////////////////// FORM //////////////////////

  showForm({@required String? title}) {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, state) {
            myState = state;
            return AlertDialog(
              content: content(title: title),
              actions: [cancelButton(), createButton(title: title)],
            );
          });
        });
  }

  Widget cancelButton() {
    return Container(
        width: 120,
        height: 40,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(primary: Colors.red),
            onPressed: () {
              clearValues('Cancel');
            },
            child: Text('CANCEL')));
  }

  Widget createButton({@required String? title}) {
    return Container(
        width: 120,
        height: 40,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(primary: yellow),
            onPressed: () {
              title == 'ADD QUIZ' ? checkAdd() : checkUpdate();
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(isLoading && title == 'ADD QUIZ'
                    ? 'CREATING'
                    : isLoading && title == 'UPDATE QUIZ'
                        ? 'UPDATING'
                        : title == 'ADD QUIZ'
                            ? 'CREATE'
                            : 'UPDATE'),
                SizedBox(
                  width: 10,
                ),
                isLoading
                    ? Center(
                        child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator()),
                      )
                    : Container()
              ],
            )));
  }

  checkAdd() {
    if (quizName == null) {
      myState!(() {
        error = 'Please provide quiz name';
      });
    } else if (courseId == null) {
      myState!(() {
        error = 'Please select course';
      });
    } else if (subjectId == null) {
      myState!(() {
        error = 'Please select subject';
      });
    } else if (level == null) {
      myState!(() {
        error = 'Please select level';
      });
    } else if (attemptDate == null) {
      myState!(() {
        error = 'Please select date';
      });
    } else if (timeInSeconds == null) {
      myState!(() {
        error = 'Please provide time';
      });
    } else if (timeType == null) {
      myState!(() {
        error = 'Please select time type';
      });
    } else if (questionsList!.length == 0) {
      myState!(() {
        error = 'Please select questions';
      });
    } else {
      addQuiz();
    }
  }

  checkUpdate() {
    if (quizName == null) {
      quizName = editQuiz!.quizName;
    }
    if (courseId == null) {
      courseId = editQuiz!.course!.id;
    }
    if (subjectId == null) {
      subjectId = editQuiz!.subject!.id;
    }
    if (level == null) {
      level = editQuiz!.level;
    }
    if (attemptDate == null) {
      attemptDate = editQuiz!.attempDate;
    }
    if (timeInSeconds == null) {
      timeInSeconds = editQuiz!.time;
    }
    if (timeType == null) {
      timeType = editQuiz!.bound;
    }
    if (questionsList!.isEmpty) {
      questionsList = editQuiz!.question;
    }
    updateQuiz();
  }

  addQuiz() {
    myState!(() {
      error = null;
      isLoading = true;
    });
    APIManager()
        .addQUIZ(
            token: widget.loginResponse!.token,
            quizName: quizName,
            courseId: courseId,
            attemptDate: attemptDate,
            subjectId: [subjectId],
            level: level,
            public: checkBox,
            timeType: timeType,
            time: timeInSeconds,
            questions: questionsList)
        .then((value) {
      clearValues('');
    }).catchError((e) {
      setState(() {
        print('ERROR');
        error = 'e';
      });
    });
  }

  updateQuiz() {
    myState!(() {
      error = null;
      isLoading = true;
    });
    APIManager()
        .updateQUIZ(
            id: editQuiz!.id,
            token: widget.loginResponse!.token,
            quizName: quizName,
            courseId: courseId,
            attemptDate: attemptDate,
            subjectId: [subjectId],
            level: level,
            public: checkBox,
            timeType: timeType,
            time: timeInSeconds,
            questions: questionsList)
        .then((value) {
      clearValues('');
    });
  }

  clearValues(title) {
    isLoading = false;
    error = null;
    quizName = null;
    courseId = null;
    attemptDate = null;
    subjectId = null;
    level = null;
    timeType = null;
    timeInSeconds = null;
    questionsList!.clear();
    questionsMenu.clear();

    _formKey.currentState!.reset();
    Navigator.of(context, rootNavigator: true).pop();
    if (title != 'Cancel') {
      updatePage();
    }
  }

  updatePage() {
    setState(() {
      _quizModel =
          APIManager().fetchQUIZList(token: widget.loginResponse!.token);
    });
  }

  Widget content({@required String? title}) {
    return Container(
      width: SizeConfig.screenWidth! / 1.8,
      height: SizeConfig.screenHeight! / 0.5,
      child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                ///////////////////// TITLE /////////////////////

                Text(title.toString(),
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(
                  height: 40,
                ),

                /////////////////////////////////////////////////

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [selectCourseField(), selectSubjectField()],
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 25),
                      child: selectLevelField(),
                    ),
                    SizedBox(
                      width: 40,
                    ),
                    isLoad
                        ? SizedBox(
                            width: 30,
                            height: 30,
                            child: CircularProgressIndicator())
                        : Container()
                  ],
                ),
                questionsMenu.isNotEmpty ? SizedBox(height: 30) : Container(),
                questionsMenu.isNotEmpty
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 25),
                            child: selectQuestionsField(),
                          ),
                        ],
                      )
                    : Container(),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    quizNameField(),
                    dateField(),
                  ],
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 25),
                      child: Text('Public'),
                    ),
                    SizedBox(width: 20),
                    StatefulBuilder(
                      builder: (BuildContext context,
                          void Function(void Function()) setState1) {
                        return Checkbox(
                            value: checkBox,
                            onChanged: (value) {
                              if (checkBox == true) {
                                setState1(() {
                                  checkBox = false;
                                });
                              } else {
                                setState1(() {
                                  checkBox = true;
                                });
                              }
                            });
                      },
                    )
                  ],
                ),
                SizedBox(height: 30),

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 25),
                      child: selectTimeBoundingType(),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 25),
                      child: timeField(),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.only(left: 25),
                  child: Row(
                    children: [
                      error != null
                          ? MyError(
                              error: error,
                            )
                          : Container(),
                    ],
                  ),
                )
              ],
            ),
          )),
    );
  }

  Widget selectCourseField() {
    return Container(
        width: SizeConfig.screenWidth! / 4,
        child: DropdownButtonFormField(
          onSaved: (value) {
            clearThis();
            courseId = value.toString();

            getSubjects();
          },
          onChanged: (value) {
            clearThis();
            courseId = value.toString();
            getSubjects();
          },
          decoration: InputDecoration(
            labelText: "COURSE",
            hintText: "Select course",
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
          items: coursesMenu.map((e) {
            return DropdownMenuItem(
              child: Text(e.name.toString()),
              value: e.id,
            );
          }).toList(),
        ));
  }

  clearThis() {
    myState!(() {
      isLoad = false;
      subjectId = null;
      questionsList!.clear();
      questionsMenu.clear();
    });
  }

  Widget selectSubjectField() {
    return Container(
        width: SizeConfig.screenWidth! / 4,
        child: DropdownButtonFormField(
          onSaved: (value) {
            myState!(() {
              questionsMenu.clear();
              subjectId = value.toString();
            });
          },
          onChanged: (value) {
            myState!(() {
              questionsMenu.clear();
              subjectId = value.toString();
            });
          },
          decoration: InputDecoration(
            labelText: "SUBJECT",
            hintText: "Select subject",
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
          items: subjectsMenu.map((e) {
            return DropdownMenuItem(
              child: Text(e.subjectName.toString()),
              value: e.id,
            );
          }).toList(),
        ));
  }

  Widget selectLevelField() {
    return Container(
        width: SizeConfig.screenWidth! / 4,
        child: DropdownButtonFormField(
          onSaved: (value) {
            level = value.toString();
            getQuestions();
          },
          onChanged: subjectId != null
              ? (value) {
                  level = value.toString();
                  getQuestions();
                }
              : null,
          decoration: InputDecoration(
            labelText: "LEVEL",
            hintText: editQuiz != null ? editQuiz!.level : "Select level",
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
          items: popUpMenuItem,
        ));
  }

  Widget selectQuestionsField() {
    return Expanded(
      child: Container(
          width: SizeConfig.screenWidth! / 2,
          height: 200,
          child: ListView(
            children: List.generate(questionsMenu.length, (index) {
              return questionText(questionsMenu[index]);
            }),
          )),
    );
  }

  questionText(Questions? question) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Container(
        width: MediaQuery.of(context).size.width / 2.2,
        child: Chip(
            deleteIcon: questionsList!.contains(question!.id)
                ? Icon(Icons.delete)
                : Icon(Icons.add),
            onDeleted: () {
              if (questionsList!.contains(question.id)) {
                myState!(() {
                  questionsList!.remove(question.id);
                });
              } else {
                myState!(() {
                  questionsList!.add(question.id);
                  print(questionsList);
                });
              }
            },
            backgroundColor: questionsList!.contains(question.id)
                ? Colors.grey[200]
                : Colors.grey[50],
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.zero)),
            label: Text(
              question.questionStatement.toString(),
              textAlign: TextAlign.start,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )),
      ),
    );
  }

  Widget quizNameField() {
    return Container(
        width: SizeConfig.screenWidth! / 4,
        child: TextFormField(
          initialValue: editQuiz != null ? editQuiz!.quizName : null,
          onChanged: (value) {
            quizName = value;
          },
          onFieldSubmitted: (value) {
            quizName = value;
          },
          onSaved: (value) {
            quizName = value;
          },
          decoration: InputDecoration(
              hintText: 'Enter quiz name', labelText: 'QUIZ NAME'),
        ));
  }

  Widget dateField() {
    return InkWell(
      onTap: () {
        _selectDate(context);
      },
      child: Container(
        width: SizeConfig.screenWidth! / 4,
        alignment: Alignment.center,
        child: TextFormField(
          textAlign: TextAlign.center,
          enabled: false,
          keyboardType: TextInputType.text,
          controller: _dateController,
          onSaved: (val) {
            setDate = val;
          },
          decoration: InputDecoration(
              suffixIcon: Icon(Icons.calendar_today_sharp),
              labelText: 'DATE',
              hintText: 'Select Date',
              contentPadding: EdgeInsets.only(top: 0.0)),
        ),
      ),
    );
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime.now(),
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        selectedDate = picked;
        _dateController.text = DateFormat.yMd().format(selectedDate);
        attemptDate = _dateController.text;
        print(attemptDate);
      });
  }

  Widget timeField() {
    return Container(
        width: SizeConfig.screenWidth! / 2,
        child: TextFormField(
          initialValue: editQuiz != null ? editQuiz!.time.toString() : null,
          onChanged: (value) {
            timeInSeconds = int.parse(value);
          },
          onFieldSubmitted: (value) {
            timeInSeconds = int.parse(value);
          },
          onSaved: (value) {
            timeInSeconds = int.parse(value!);
          },
          decoration: InputDecoration(
              hintText: 'Enter time in seconds', labelText: 'TIME'),
        ));
  }

  Widget selectTimeBoundingType() {
    return Container(
        width: SizeConfig.screenWidth! / 2,
        child: DropdownButtonFormField(
          onSaved: (value) {
            timeType = value.toString();
          },
          onChanged: (value) {
            timeType = value.toString();
          },
          decoration: InputDecoration(
            labelText: "TIME TYPE",
            hintText: editQuiz == null ? "Select time type" : editQuiz!.bound,
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
          items: timeMenuItem,
        ));
  }
}
