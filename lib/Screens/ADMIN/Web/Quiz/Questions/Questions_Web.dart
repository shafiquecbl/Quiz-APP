import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quiz_app/Models/Questions.dart';
import 'package:quiz_app/Models/Quiz.dart';
import 'package:quiz_app/Models/User.dart';
import 'package:quiz_app/Screens/widget/Search_Field.dart';
import 'package:quiz_app/Screens/widget/head_card.dart';
import 'package:quiz_app/Services/api_manager.dart';
import 'package:quiz_app/WIdgets/Custom_Error.dart';
import 'package:quiz_app/WIdgets/loading.dart';
import 'package:quiz_app/constants.dart';
import 'package:quiz_app/size_config.dart';

class QuestionsWEB extends StatefulWidget {
  final LoginResponse? loginResponse;
  QuestionsWEB({@required this.loginResponse});
  @override
  _QuestionsWEBState createState() => _QuestionsWEBState();
}

class _QuestionsWEBState extends State<QuestionsWEB> {
  String? search = '';
  bool isLoading = false;
  Future<List<Questions>>? _questionModel;
  String? questionStatement,
      optionA,
      optionB,
      optionC,
      optionD,
      correctAnswerr,
      subjectId,
      courseId,
      type,
      level,
      error;
  File? image;
  Questions? editQuestion;

  Function(void Function())? myState;
  final _formKey = GlobalKey<FormState>();

  static List courseMenu = [];
  static List subjectMenu = [];

  static const levelMenu = <String>[
    'Beginner',
    'Intermediate',
    'Advanced',
  ];
  final List<DropdownMenuItem<String>> levelItem = levelMenu
      .map((String value) => DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          ))
      .toList();

  static const typeMenu = <String>[
    'MCQ\'s',
    'True/False',
  ];
  final List<DropdownMenuItem<String>> typeItem = typeMenu
      .map((String value) => DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          ))
      .toList();

  getCourses() {
    APIManager()
        .getCoursesList(token: widget.loginResponse!.token)
        .then((value) {
      setState(() {
        courseMenu = value;
      });
    });
  }

  getSubjects() {
    APIManager()
        .getSubjectByCourseId(
            token: widget.loginResponse!.token, courseId: courseId)
        .then((value) {
      if (this.mounted) {
        myState!(() {
          subjectMenu = value;
        });
      }
    });
  }

  @override
  void initState() {
    _questionModel =
        APIManager().fetchQuestiontList(token: widget.loginResponse!.token);
    getCourses();
    getSubjects();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Questions',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 0, right: 10),
            child: SearchField(search: search, hintText: 'Search questions'),
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Stack(
          children: [
            dataTable(),
            HeadCard(
                title: 'Questions List',
                onPressed: () {
                  showForm(title: 'ADD QUESTION');
                }),
          ],
        ),
      ),
    );
  }

  ////////////////////// DATA TABLE //////////////////////

  Widget dataTable() {
    return Padding(
      padding: const EdgeInsets.only(top: 30, bottom: 30),
      child: Container(
        width: SizeConfig.screenWidth,
        height: SizeConfig.screenHeight,
        child: Card(
          child: Padding(
            padding: EdgeInsets.only(
              left: 10,
              right: 10,
              top: 50,
            ),
            child: FutureBuilder<List<Questions>>(
              future: _questionModel,
              builder: (BuildContext context,
                  AsyncSnapshot<List<Questions>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return MyLoading();
                return questionsList(snapshot.data!);
              },
            ),
          ),
        ),
      ),
    );
  }

  questionsList(List<Questions> list) {
    return SingleChildScrollView(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          dataRowHeight: 60,
          columns: [
            DataColumn(label: Text('ID')),
            DataColumn(label: Text('Question Statement')),
            DataColumn(label: Text('Type')),
            DataColumn(label: Text('Level')),
            DataColumn(label: Text('Subjects')),
            DataColumn(label: Text('Course')),
            DataColumn(label: Text('Action')),
          ],
          rows: List.generate(
              list.length, (index) => questions(list[index], index)),
        ),
      ),
    );
  }

  questions(Questions? question, index) {
    return DataRow(cells: [
      DataCell(Text('$index')),
      DataCell(Container(
          width: 290,
          child: Text(
            question!.questionStatement.toString(),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ))),
      DataCell(Text(question.type.toString())),
      DataCell(Text(question.level.toString())),
      DataCell(Container(
        width: 50,
        child: Text(question.subject!.subjectName.toString()),
      )),
      DataCell(Text(question.course!.name.toString())),
      DataCell(Container(
        width: 125,
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.green),
                onPressed: () {},
                child: Text('EDIT')),
            ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.red),
                onPressed: () {},
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
              Navigator.pop(context);
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
              title == 'ADD QUESTION' ? checkAdd() : checkUpdate();
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(isLoading && title == 'ADD QUESTION'
                    ? 'CREATING'
                    : isLoading && title == 'UPDATE QUESTION'
                        ? 'UPDATING'
                        : title == 'ADD QUESTION'
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

  Widget content({@required String? title}) {
    return Container(
      width: SizeConfig.screenWidth! / 1.8,
      height: SizeConfig.screenHeight! / 0.5,
      child: Form(
          child: SingleChildScrollView(
        child: Column(
          children: [
            ///////////////////// TITLE /////////////////////

            Text(title.toString(),
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                selectLevelField(),
                selectTypeField(),
              ],
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: questionStatementField(),
                ),
              ],
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: Container(
                    height: 35,
                    color: Colors.grey[300],
                    child: ElevatedButton.icon(
                        onPressed: () {
                          pickImage();
                        },
                        icon: Icon(Icons.attach_file),
                        label: Text('Choos File')),
                  ),
                ),
                SizedBox(width: 20),
                image != null ? Text(image!.path.split('/').last) : Container()
              ],
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                optionAField(),
                optionBField(),
              ],
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [optionCField(), optionDField()],
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: correctAnswer(),
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

  pickImage() async {
    PickedFile? pickedImae =
        // ignore: invalid_use_of_visible_for_testing_member
        await ImagePicker.platform.pickImage(source: ImageSource.gallery);

    myState!(() {
      image = File(pickedImae!.path);
    });
    return image;
  }

  Widget selectCourseField() {
    return Container(
        width: SizeConfig.screenWidth! / 4,
        child: DropdownButtonFormField(
          onSaved: (value) {
            courseId = value.toString();
            getSubjects();
          },
          onChanged: (value) {
            courseId = value.toString();
            getSubjects();
          },
          decoration: InputDecoration(
            labelText: "COURSE",
            hintText: "Select course",
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
          items: courseMenu.map((e) {
            return DropdownMenuItem(
              child: Text(e.name.toString()),
              value: e.id,
            );
          }).toList(),
        ));
  }

  Widget selectSubjectField() {
    return Container(
        width: SizeConfig.screenWidth! / 4,
        child: DropdownButtonFormField(
          onSaved: (value) => {subjectId = value.toString()},
          onChanged: (value) {
            subjectId = value.toString();
          },
          decoration: InputDecoration(
            labelText: "SUBJECT",
            hintText: "Select subject",
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
          items: subjectMenu.map((e) {
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
          onSaved: (newValue) => {level = newValue.toString()},
          onChanged: (value) {
            level = value.toString();
          },
          decoration: InputDecoration(
            labelText: "LEVEL",
            hintText: "Select level",
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
          items: levelItem,
        ));
  }

  Widget selectTypeField() {
    return Container(
        width: SizeConfig.screenWidth! / 4,
        child: DropdownButtonFormField(
            onSaved: (newValue) => {type = newValue.toString()},
            onChanged: (value) {
              type = value.toString();
            },
            decoration: InputDecoration(
              labelText: "TYPE",
              hintText: "Select type",
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
            items: typeItem));
  }

  Widget questionStatementField() {
    return Container(
        width: SizeConfig.screenWidth! / 2,
        child: TextFormField(
          onChanged: (value) {
            questionStatement = value;
          },
          onFieldSubmitted: (value) {
            questionStatement = value;
          },
          onSaved: (value) {
            questionStatement = value;
          },
          decoration: InputDecoration(
              hintText: 'Enter question statement',
              labelText: 'QUESTION STATEMENT'),
        ));
  }

  Widget optionAField() {
    return Container(
        width: SizeConfig.screenWidth! / 4,
        child: TextFormField(
          onChanged: (value) {
            optionA = value;
          },
          onFieldSubmitted: (value) {
            optionA = value;
          },
          onSaved: (value) {
            optionA = value;
          },
          decoration: InputDecoration(
              hintText: 'Enter option a', labelText: 'OPTION A'),
        ));
  }

  Widget optionBField() {
    return Container(
        width: SizeConfig.screenWidth! / 4,
        child: TextFormField(
          onChanged: (value) {
            optionB = value;
          },
          onFieldSubmitted: (value) {
            optionB = value;
          },
          onSaved: (value) {
            optionB = value;
          },
          decoration: InputDecoration(
              hintText: 'Enter option b', labelText: 'OPTION B'),
        ));
  }

  Widget optionCField() {
    return Container(
        width: SizeConfig.screenWidth! / 4,
        child: TextFormField(
          onChanged: (value) {
            optionC = value;
          },
          onFieldSubmitted: (value) {
            optionC = value;
          },
          onSaved: (value) {
            optionC = value;
          },
          decoration: InputDecoration(
              hintText: 'Enter option c', labelText: 'OPTION C'),
        ));
  }

  Widget optionDField() {
    return Container(
        width: SizeConfig.screenWidth! / 4,
        child: TextFormField(
          onChanged: (value) {
            optionD = value;
          },
          onFieldSubmitted: (value) {
            optionD = value;
          },
          onSaved: (value) {
            optionD = value;
          },
          decoration: InputDecoration(
              hintText: 'Enter option d', labelText: 'OPTION D'),
        ));
  }

  Widget correctAnswer() {
    return Container(
        width: SizeConfig.screenWidth! / 2,
        child: TextFormField(
          onChanged: (value) {
            correctAnswerr = value;
          },
          onFieldSubmitted: (value) {
            correctAnswerr = value;
          },
          onSaved: (value) {
            correctAnswerr = value;
          },
          decoration: InputDecoration(
              hintText: 'Enter correct answer', labelText: 'ANSWER'),
        ));
  }

  /////////////////////////////////////////////
  /////////////// SOME FUNCTIONS //////////////
  /////////////////////////////////////////////

  checkAdd() {
    if (courseId == null) {
      myState!(() {
        error = 'Please select course';
      });
    } else if (subjectId == null) {
      myState!(() {
        error = 'Please select subject';
      });
    } else if (type == null) {
      myState!(() {
        error = 'Please select type';
      });
    } else if (level == null) {
      myState!(() {
        error = 'Please select level';
      });
    } else if (questionStatement == null) {
      myState!(() {
        error = 'Please provide question statement';
      });
    } else if (optionA == null) {
      myState!(() {
        error = 'Please provide option A';
      });
    } else if (optionB == null) {
      myState!(() {
        error = 'Please provide option B';
      });
    } else if (optionC == null) {
      myState!(() {
        error = 'Please provide option C';
      });
    } else if (correctAnswerr == null) {
      myState!(() {
        error = 'Please provide correct answer';
      });
    } else if (image == null) {
      myState!(() {
        error = 'Please select image';
      });
    } else {
      addQuestion();
    }
  }

  checkUpdate() {
    if (courseId == null) {
      courseId = editQuestion!.course!.id;
    }
    if (subjectId == null) {
      subjectId = editQuestion!.subject!.id;
    }
    if (type == null) {
      type = editQuestion!.type;
    }
    if (level == null) {
      level = editQuestion!.level;
    }
    if (questionStatement == null) {
      questionStatement = editQuestion!.questionStatement;
    }
    if (optionA == null) {
      optionA = editQuestion!.options!.option1;
    }
    if (optionB == null) {
      optionB = editQuestion!.options!.option2;
    }
    if (optionC == null) {
      optionC = editQuestion!.options!.option3;
    }
    if (correctAnswerr == null) {
      correctAnswerr = editQuestion!.answer;
    }
    if (image == null) {
      // image = editQuestion!.questionImage
    }
    updateQuestion();
  }

  addQuestion() {
    myState!(() {
      isLoading = true;
      error = null;
    });
    return APIManager()
        .addQuestion(
            token: widget.loginResponse!.token,
            questionStatement: questionStatement,
            type: type,
            answer: correctAnswerr,
            level: level,
            subjectId: [subjectId],
            courseId: courseId,
            questionImage: [],
            options: AddQustionOption(
                option1: optionA,
                option2: optionB,
                option3: optionC,
                option4: optionD))
        .then((value) {
      clearValues();
    });
  }

  updateQuestion() {
    myState!(() {
      error = null;
      isLoading = true;
    });
    return APIManager()
        .updateQuestion(
      id: editQuestion!.id,
      token: widget.loginResponse!.token,
      questionStatement: questionStatement,
      type: type,
      answer: correctAnswerr,
      level: level,
      subjectId: subjectId,
      courseId: courseId,
      questionImage: ['image'],
      options: AddQustionOption(
          option1: optionA,
          option2: optionB,
          option3: optionC,
          option4: optionD),
    )
        .then((value) {
      clearValues();
    });
  }

  clearValues() {
    isLoading = false;
    error = null;

    questionStatement = null;
    type = null;
    correctAnswerr = null;
    level = null;
    subjectId = null;
    image = null;
    optionA = null;
    optionB = null;
    optionC = null;
    optionD = null;
    courseId = null;

    editQuestion = null;
    _formKey.currentState!.reset();
    Navigator.of(context, rootNavigator: true).pop();
    updatePage();
  }

  updatePage() {
    setState(() {
      _questionModel =
          APIManager().fetchQuestiontList(token: widget.loginResponse!.token);
    });
  }
}
