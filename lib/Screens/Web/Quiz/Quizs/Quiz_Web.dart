import 'package:flutter/material.dart';
import 'package:quiz_app/Screens/widget/Search_Field.dart';
import 'package:quiz_app/Screens/widget/head_card.dart';
import 'package:quiz_app/constants.dart';
import 'package:quiz_app/size_config.dart';

class QuizWEB extends StatefulWidget {
  @override
  _QuizWEBState createState() => _QuizWEBState();
}

class _QuizWEBState extends State<QuizWEB> {
  String? search = '';
  bool checkBox = false;
  static const menuItems = <String>[
    'Male',
    'Female',
    'Other',
  ];
  final List<DropdownMenuItem<String>> popUpMenuItem = menuItems
      .map((String value) => DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          ))
      .toList();
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
                  showForm(title: 'ADD QUIZS');
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
              child: SingleChildScrollView(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: [
                      DataColumn(label: Text('ID')),
                      DataColumn(label: Text('Name')),
                      DataColumn(label: Text('Attempt Date')),
                      DataColumn(label: Text('Subjects')),
                      DataColumn(label: Text('Course')),
                      DataColumn(label: Text('Action')),
                    ],
                    rows: List.generate(
                        10,
                        (index) => DataRow(cells: [
                              DataCell(Text('$index')),
                              DataCell(Text('Muhammad Shafique')),
                              DataCell(Text('shafiquecbl@gmail.com')),
                              DataCell(Text('03458628858')),
                              DataCell(Container(
                                width: 50,
                                child: Text('093'),
                              )),
                              DataCell(Container(
                                width: 125,
                                height: 60,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            primary: Colors.green),
                                        onPressed: () {},
                                        child: Text('EDIT')),
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            primary: Colors.red),
                                        onPressed: () {},
                                        child: Text('DELETE'))
                                  ],
                                ),
                              )),
                            ])),
                  ),
                ),
              )),
        ),
      ),
    );
  }

  ////////////////////// FORM //////////////////////

  showForm({@required String? title}) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: content(title: title),
            actions: [cancelButton(), createButton()],
          );
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

  Widget createButton() {
    return Container(
        width: 120,
        height: 40,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(primary: yellow),
            onPressed: () {},
            child: Text('CREATE')));
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
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: selectLevelField(),
                ),
              ],
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: selectQuestionsField(),
                ),
              ],
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: quizNameField(),
                ),
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
          ],
        ),
      )),
    );
  }

  Widget selectCourseField() {
    return Container(
        width: SizeConfig.screenWidth! / 4,
        child: DropdownButtonFormField(
          onSaved: (newValue) => {},
          onChanged: (value) {},
          decoration: InputDecoration(
            labelText: "COURSE",
            hintText: "Select course",
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
          items: popUpMenuItem,
        ));
  }

  Widget selectSubjectField() {
    return Container(
        width: SizeConfig.screenWidth! / 4,
        child: DropdownButtonFormField(
          onSaved: (newValue) => {},
          onChanged: (value) {},
          decoration: InputDecoration(
            labelText: "SUBJECT",
            hintText: "Select subject",
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
          items: popUpMenuItem,
        ));
  }

  Widget selectLevelField() {
    return Container(
        width: SizeConfig.screenWidth! / 4,
        child: DropdownButtonFormField(
          onSaved: (newValue) => {},
          onChanged: (value) {},
          decoration: InputDecoration(
            labelText: "LEVEL",
            hintText: "Select level",
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
          items: popUpMenuItem,
        ));
  }

  Widget selectQuestionsField() {
    return Container(
        width: SizeConfig.screenWidth! / 2,
        child: DropdownButtonFormField(
          onSaved: (newValue) => {},
          onChanged: (value) {},
          decoration: InputDecoration(
            labelText: "QUESTIONS",
            hintText: "Select question",
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
          items: popUpMenuItem,
        ));
  }

  Widget quizNameField() {
    return Container(
        width: SizeConfig.screenWidth! / 2,
        child: TextFormField(
          decoration: InputDecoration(
              hintText: 'Enter quiz name', labelText: 'QUIZ NAME'),
        ));
  }

  Widget timeField() {
    return Container(
        width: SizeConfig.screenWidth! / 2,
        child: TextFormField(
          decoration: InputDecoration(
              hintText: 'Enter time in seconds', labelText: 'TIME'),
        ));
  }

  Widget selectTimeBoundingType() {
    return Container(
        width: SizeConfig.screenWidth! / 2,
        child: DropdownButtonFormField(
          onSaved: (newValue) => {},
          onChanged: (value) {},
          decoration: InputDecoration(
            labelText: "ANSWER",
            hintText: "Select correct answer",
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
          items: popUpMenuItem,
        ));
  }
}
