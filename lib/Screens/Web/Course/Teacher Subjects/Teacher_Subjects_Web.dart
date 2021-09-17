import 'package:flutter/material.dart';
import 'package:quiz_app/Models/Teacher_Subject.dart';
import 'package:quiz_app/Models/User.dart';
import 'package:quiz_app/Screens/widget/Search_Field.dart';
import 'package:quiz_app/Screens/widget/head_card.dart';
import 'package:quiz_app/Services/api_manager.dart';
import 'package:quiz_app/WIdgets/loading.dart';
import 'package:quiz_app/constants.dart';
import 'package:quiz_app/size_config.dart';

class TeacherSubjectsWEB extends StatefulWidget {
  final LoginResponse? loginResponse;
  TeacherSubjectsWEB({@required this.loginResponse});
  @override
  _TeacherSubjectsWEBState createState() => _TeacherSubjectsWEBState();
}

class _TeacherSubjectsWEBState extends State<TeacherSubjectsWEB> {
  String? search = '';
  Future<List<TeacherSubject>>? _teacherSubjectModel;

  @override
  void initState() {
    _teacherSubjectModel = APIManager()
        .fetchTeacherSubjectList(token: widget.loginResponse!.token);
    super.initState();
  }

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
            child: FutureBuilder<List<TeacherSubject>>(
              future: _teacherSubjectModel,
              builder: (BuildContext context,
                  AsyncSnapshot<List<TeacherSubject>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return MyLoading();
                return teacherSubjectsList(snapshot.data!);
              },
            ),
          ),
        ),
      ),
    );
  }

  teacherSubjectsList(List<TeacherSubject> teacherSubject) {
    return SingleChildScrollView(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(label: Text('ID')),
            DataColumn(label: Text('Name')),
            DataColumn(label: Text('Course')),
            DataColumn(label: Text('Subject')),
            DataColumn(label: Text('Action')),
          ],
          rows: List.generate(teacherSubject.length,
              (index) => teacherSubjects(teacherSubject[index], index)),
        ),
      ),
    );
  }

  teacherSubjects(TeacherSubject? subject, index) {
    return DataRow(cells: [
      DataCell(Text('$index')),
      DataCell(Text(subject!.teacher!.name.toString())),
      DataCell(Text(subject.course!.name.toString())),
      DataCell(Text(subject.subject!.subjectName.toString())),
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
