import 'package:data_tables/data_tables.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/Models/Teacher_Subject.dart';
import 'package:quiz_app/Models/User.dart';
import 'package:quiz_app/Screens/widget/Search_Field.dart';
import 'package:quiz_app/Screens/widget/head_card.dart';
import 'package:quiz_app/Services/api_manager.dart';
import 'package:quiz_app/WIdgets/Custom_Error.dart';
import 'package:quiz_app/WIdgets/loading.dart';
import 'package:quiz_app/WIdgets/network_error.dart';
import 'package:quiz_app/constants.dart';
import 'package:quiz_app/size_config.dart';

class TeacherSubjectsWEB extends StatefulWidget {
  final LoginResponse? loginResponse;
  TeacherSubjectsWEB({@required this.loginResponse});
  @override
  _TeacherSubjectsWEBState createState() => _TeacherSubjectsWEBState();
}

class _TeacherSubjectsWEBState extends State<TeacherSubjectsWEB> {
  int _rowsPerPage = 25;
  int _rowsOffset = 0;
  String? search = '';
  String? error;
  bool isLoading = false;

  Future<List<TeacherSubject>>? _teacherSubjectModel;
  final _formKey = GlobalKey<FormState>();
  TeacherSubject? editTeacherSubject;
  Function(void Function())? myState;

  String? teacherId, subject, course;

  static List menuItems = [];
  static List menuItems1 = [];
  static List menuItems2 = [];

  getTeachers() {
    APIManager()
        .fetchTeachersList(token: widget.loginResponse!.token)
        .then((value) {
      setState(() {
        menuItems = value;
      });
      myState!(() {
        menuItems = value;
      });
    });
  }

  getCourses() {
    APIManager()
        .getCoursesList(token: widget.loginResponse!.token)
        .then((value) {
      setState(() {
        menuItems1 = value;
      });
      myState!(() {
        menuItems1 = value;
      });
    });
  }

  getSubjects() {
    APIManager()
        .fetchSubjectsList(token: widget.loginResponse!.token)
        .then((value) {
      setState(() {
        menuItems2 = value;
      });
      myState!(() {
        menuItems2 = value;
      });
    });
  }

  @override
  void initState() {
    _teacherSubjectModel = APIManager()
        .fetchTeacherSubjectList(token: widget.loginResponse!.token);
    getTeachers();
    getCourses();
    getSubjects();

    super.initState();
  }

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
            child:
                SearchField(search: search, hintText: 'Search teacher subject'),
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
                  showForm(title: 'ADD TEACHER SUBJECT');
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
            child: FutureBuilder<List<TeacherSubject>>(
              future: _teacherSubjectModel,
              builder: (BuildContext context,
                  AsyncSnapshot<List<TeacherSubject>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return MyLoading();
                if (snapshot.data == null)
                  return NetworkError(onPressed: () {
                    setState(() {
                      _teacherSubjectModel = APIManager()
                          .fetchTeacherSubjectList(
                              token: widget.loginResponse!.token);
                      getTeachers();
                      getCourses();
                      getSubjects();
                    });
                  });
                return teacherSubjectsList(snapshot.data!);
              },
            ),
          ),
        ),
      ),
    );
  }

  teacherSubjectsList(List<TeacherSubject> teacherSubject) {
    return Expanded(
        child: Container(
      height: MediaQuery.of(context).size.height / 1.1,
      child: NativeDataTable(
        rowsPerPage: _rowsPerPage,
        firstRowIndex: _rowsOffset,
        handleNext: () {
          if (_rowsOffset + 25 < teacherSubject.length) {
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
          DataColumn(label: Text('Course')),
          DataColumn(label: Text('Subject')),
          DataColumn(label: Text('Action')),
        ],
        rows: List.generate(teacherSubject.length,
            (index) => teacherSubjects(teacherSubject[index], index)),
      ),
    ));
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
                onPressed: () {
                  editTeacherSubject = subject;
                  showForm(title: 'UPDATE TEACHER SUBJECT');
                },
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
              title == 'ADD TEACHER SUBJECT' ? checkAdd() : checkUpdate();
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(isLoading && title == 'ADD TEACHER SUBJECT'
                    ? 'CREATING'
                    : isLoading && title == 'UPDATE TEACHER SUBJECT'
                        ? 'UPDATING'
                        : title == 'ADD TEACHER SUBJECT'
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
      height: SizeConfig.screenHeight! / 1.8,
      child: Form(
          key: _formKey,
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
          )),
    );
  }

  Widget teacherField() {
    return Container(
        width: SizeConfig.screenWidth! / 4,
        child: DropdownButtonFormField(
          onSaved: (newValue) => {teacherId = newValue.toString()},
          onChanged: (value) {
            teacherId = value.toString();
          },
          decoration: InputDecoration(
            labelText: "TEACHERS",
            hintText: "Select teacher",
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
          items: menuItems.map((e) {
            return DropdownMenuItem(
              child: Text(e.name.toString()),
              value: e.id,
            );
          }).toList(),
        ));
  }

  Widget courseField() {
    return Container(
        width: SizeConfig.screenWidth! / 4,
        child: DropdownButtonFormField(
          onSaved: (newValue) => {course = newValue.toString()},
          onChanged: (value) {
            course = value.toString();
          },
          decoration: InputDecoration(
            labelText: "COURSE",
            hintText: "Select course",
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
          items: menuItems1.map((e) {
            return DropdownMenuItem(
              child: Text(e.name.toString()),
              value: e.id,
            );
          }).toList(),
        ));
  }

  Widget subjectField() {
    return Container(
        width: SizeConfig.screenWidth! / 4,
        child: DropdownButtonFormField(
          onSaved: (newValue) => {subject = newValue.toString()},
          onChanged: (value) {
            subject = value.toString();
          },
          decoration: InputDecoration(
            labelText: "SUBJECT",
            hintText: "Select subject",
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
          items: menuItems2.map((e) {
            return DropdownMenuItem(
              child: Text(e.subjectName.toString()),
              value: e.id,
            );
          }).toList(),
        ));
  }

  /////////////////////////////////////////////
  /////////////// SOME FUNCTIONS //////////////
  /////////////////////////////////////////////

  checkAdd() {
    if (teacherId == null) {
      myState!(() {
        error = 'Please select teacher';
      });
    } else if (course == null) {
      myState!(() {
        error = 'Please select course';
      });
    } else if (subject == null) {
      myState!(() {
        error = 'Please select subject';
      });
    } else {
      addCourse();
    }
  }

  checkUpdate() {
    if (teacherId == null) {
      teacherId = editTeacherSubject!.teacher!.id;
    }
    if (course == null) {
      course = editTeacherSubject!.course!.id;
    }
    if (subject == null) {
      subject = editTeacherSubject!.subject!.id;
    }
    updateCourse();
  }

  addCourse() {
    myState!(() {
      error = null;
      isLoading = true;
    });
    return APIManager()
        .addTeacherSubject(
            token: widget.loginResponse!.token,
            teacher: teacherId,
            courseId: course,
            subjectId: subject)
        .then((value) {
      clearValues();
    }).catchError((e) {
      isLoading = false;
      myState!(() {
        error = e.message;
      });
    });
  }

  updateCourse() {
    myState!(() {
      error = null;
      isLoading = true;
    });
    return APIManager()
        .updateTeacherSubject(
            id: editTeacherSubject!.id,
            token: widget.loginResponse!.token,
            teacher: teacherId,
            courseId: course,
            subjectId: subject)
        .then((value) {
      clearValues();
    }).catchError((e) {
      isLoading = false;
      myState!(() {
        error = e.message;
      });
    });
  }

  clearValues() {
    isLoading = false;
    error = null;

    course = null;
    subject = null;
    teacherId = null;

    _formKey.currentState!.reset();
    Navigator.of(context, rootNavigator: true).pop();
    updatePage();
  }

  updatePage() {
    setState(() {
      _teacherSubjectModel = APIManager()
          .fetchTeacherSubjectList(token: widget.loginResponse!.token);
    });
  }
}
