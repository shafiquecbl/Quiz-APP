import 'package:flutter/material.dart';
import 'package:quiz_app/Screens/widget/Search_Field.dart';
import 'package:quiz_app/Screens/widget/head_card.dart';
import 'package:quiz_app/constants.dart';
import 'package:quiz_app/size_config.dart';

class QuestionsWEB extends StatefulWidget {
  @override
  _QuestionsWEBState createState() => _QuestionsWEBState();
}

class _QuestionsWEBState extends State<QuestionsWEB> {
  String? search = '';
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
                  showForm(title: 'ADD QUESTIONS');
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
                      DataColumn(label: Text('Question Statement')),
                      DataColumn(label: Text('Type')),
                      DataColumn(label: Text('Level')),
                      DataColumn(label: Text('Subjects')),
                      DataColumn(label: Text('Course')),
                      DataColumn(label: Text('Action')),
                    ],
                    rows: List.generate(
                        10,
                        (index) => DataRow(cells: [
                              DataCell(Text('$index')),
                              DataCell(Container(
                                  width: 290,
                                  child: Text('Muhammad Shafique'))),
                              DataCell(Text('MCQ\'s')),
                              DataCell(Text('Advanced')),
                              DataCell(Container(
                                width: 50,
                                child: Text('Act'),
                              )),
                              DataCell(Text('English')),
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
                        onPressed: () {},
                        icon: Icon(Icons.attach_file),
                        label: Text('Choos File')),
                  ),
                ),
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
              children: [
                optionCField(),
                optionDField(),
              ],
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

  Widget selectTypeField() {
    return Container(
        width: SizeConfig.screenWidth! / 4,
        child: DropdownButtonFormField(
          onSaved: (newValue) => {},
          onChanged: (value) {},
          decoration: InputDecoration(
            labelText: "TYPE",
            hintText: "Select type",
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
          items: popUpMenuItem,
        ));
  }

  Widget questionStatementField() {
    return Container(
        width: SizeConfig.screenWidth! / 2,
        child: TextFormField(
          decoration: InputDecoration(
              hintText: 'Enter question statement',
              labelText: 'QUESTION STATEMENT'),
        ));
  }

  Widget optionAField() {
    return Container(
        width: SizeConfig.screenWidth! / 4,
        child: TextFormField(
          decoration: InputDecoration(
              hintText: 'Enter option a', labelText: 'OPTION A'),
        ));
  }

  Widget optionBField() {
    return Container(
        width: SizeConfig.screenWidth! / 4,
        child: TextFormField(
          decoration: InputDecoration(
              hintText: 'Enter option b', labelText: 'OPTION B'),
        ));
  }

  Widget optionCField() {
    return Container(
        width: SizeConfig.screenWidth! / 4,
        child: TextFormField(
          decoration: InputDecoration(
              hintText: 'Enter option c', labelText: 'OPTION C'),
        ));
  }

  Widget optionDField() {
    return Container(
        width: SizeConfig.screenWidth! / 4,
        child: TextFormField(
          decoration: InputDecoration(
              hintText: 'Enter option d', labelText: 'OPTION D'),
        ));
  }

  Widget correctAnswer() {
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
