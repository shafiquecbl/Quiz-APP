import 'package:flutter/material.dart';
import 'package:quiz_app/Screens/widget/Search_Field.dart';
import 'package:quiz_app/Screens/widget/head_card.dart';
import 'package:quiz_app/constants.dart';
import 'package:quiz_app/size_config.dart';

class TeacherSubjectsWEB extends StatefulWidget {
  @override
  _TeacherSubjectsWEBState createState() => _TeacherSubjectsWEBState();
}

class _TeacherSubjectsWEBState extends State<TeacherSubjectsWEB> {
  String? search = '';
  static const menuItems = <String>[
    'ALI',
    'AHMAD',
    'USAMA',
  ];
  static const menuItems1 = <String>[
    'ENGLISH',
    'MATH',
    'SCIENCE',
  ];
  static const menuItems2 = <String>[
    'SUBJECT 1',
    'SUBJECT 2',
    'SUBJECT 3',
  ];
  final List<DropdownMenuItem<String>> teachers = menuItems
      .map((String value) => DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          ))
      .toList();
  final List<DropdownMenuItem<String>> courses = menuItems1
      .map((String value) => DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          ))
      .toList();
  final List<DropdownMenuItem<String>> subjects = menuItems2
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
        title: Text('Teacher Subjects',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 0, right: 10),
            child: SearchField(
                search: search, hintText: 'Search teacher subjects'),
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Stack(
          children: [
            dataTable(),
            HeadCard(
                title: 'Teacher Subjects List',
                onPressed: () {
                  showForm(title: 'ADD TEACHER SUBJECTS');
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
                      DataColumn(label: Text('Courses')),
                      DataColumn(label: Text('Subjects')),
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
      height: SizeConfig.screenHeight! / 1.8,
      child: Form(
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
            children: [teacherField(), courseField()],
          ),
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: subjectField(),
              ),
            ],
          ),
        ],
      )),
    );
  }

  Widget teacherField() {
    return Container(
        width: SizeConfig.screenWidth! / 4,
        child: DropdownButtonFormField(
          onSaved: (newValue) => {},
          onChanged: (value) {},
          decoration: InputDecoration(
            labelText: "TEACHERS",
            hintText: "Select teacher",
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
          items: teachers,
        ));
  }

  Widget courseField() {
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
          items: courses,
        ));
  }

  Widget subjectField() {
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
          items: subjects,
        ));
  }
}
