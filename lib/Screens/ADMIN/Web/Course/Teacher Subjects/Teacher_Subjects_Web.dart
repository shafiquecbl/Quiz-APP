import 'package:data_tables/data_tables.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/Models/Subjects.dart';
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
  bool isLoad = false;

  Future<List<TeacherSubject>>? _teacherSubjectModel;
  final _formKey = GlobalKey<FormState>();
  TeacherSubject? editTeacherSubject;
  Function(void Function())? myState;

  String? teacherId, subject, course;

  static List menuItems = [];
  static List menuItems1 = [];
  static List<String> subjectsList = [];
  static List<NewSubject> subjectMenu = [];

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
    myState!(() {
      isLoad = true;
    });
    return APIManager()
        .getSubjectByCourseId(
            token: widget.loginResponse!.token, courseId: course)
        .then((value) {
      if (this.mounted) {
        myState!(() {
          isLoad = false;
          subjectMenu = value;
        });
      }
    });
  }

  @override
  void initState() {
    _teacherSubjectModel = APIManager()
        .fetchTeacherSubjectList(token: widget.loginResponse!.token);
    getTeachers();
    getCourses();
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
    return NativeDataTable(
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
    );
  }

  teacherSubjects(TeacherSubject? subject, index) {
    return DataRow(cells: [
      DataCell(Text('${index + 1}')),
      DataCell(Text(subject!.teacher!.name.toString())),
      DataCell(Text(subject.course![0].name!)),
      DataCell(SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: List.generate(
                subject.subject!.length,
                (index) => Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Text('${subject.subject![index].subjectName!}'),
                    )),
          ),
        ),
      )),
      DataCell(Container(
        width: 125,
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // ElevatedButton(
            //     style: ElevatedButton.styleFrom(primary: Colors.green),
            //     onPressed: () {
            //       editTeacherSubject = subject;
            //       showForm(title: 'UPDATE TEACHER SUBJECT');
            //     },
            //     child: Text('EDIT')),
            ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.red),
                onPressed: () {
                  APIManager()
                      .deleteTeacherSubject(
                          token: widget.loginResponse!.token, id: subject.id)
                      .then((e) {
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
              clearValues();
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
                  children: [teacherField(), courseField()],
                ),
                SizedBox(height: 30),
                isLoad
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 25),
                            child: SizedBox(
                                width: 30,
                                height: 30,
                                child: CircularProgressIndicator()),
                          )
                        ],
                      )
                    : Container(),
                subjectMenu.isNotEmpty
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 25),
                            child: selectSubjectsField(),
                          ),
                        ],
                      )
                    : Container(),
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

  Widget teacherField() {
    return Container(
        width: SizeConfig.screenWidth! / 4,
        child: DropdownButtonFormField(
          onSaved: (value) {
            myState!(() {
              teacherId = value.toString();
            });
          },
          onChanged: (value) {
            myState!(() {
              teacherId = value.toString();
            });
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
          onSaved: (value) {
            course = value.toString();
            clearList();
            getSubjects();
          },
          onChanged: teacherId != null
              ? (value) {
                  course = value.toString();
                  clearList();
                  getSubjects();
                }
              : null,
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

  Widget selectSubjectsField() {
    return Container(
        width: SizeConfig.screenWidth! / 4,
        height: 200,
        color: Colors.grey[50],
        child: ListView(
          children: List.generate(subjectMenu.length, (index) {
            return subjectText(subjectMenu[index]);
          }),
        ));
  }

  subjectText(NewSubject? subject) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Container(
        width: MediaQuery.of(context).size.width / 4.2,
        child: Chip(
            deleteButtonTooltipMessage: 'SELECT / UN-SELECT',
            deleteIcon: subjectsList.contains(subject!.id)
                ? Icon(Icons.delete)
                : Icon(Icons.add),
            onDeleted: () {
              if (subjectsList.contains(subject.id)) {
                myState!(() {
                  subjectsList.remove(subject.id);
                });
              } else {
                myState!(() {
                  subjectsList.add(subject.id!);
                  print(subjectsList);
                });
              }
            },
            backgroundColor: subjectsList.contains(subject.id)
                ? Colors.grey[200]
                : Colors.grey[50],
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.zero)),
            label: Container(
              width: MediaQuery.of(context).size.width / 4.5,
              child: Text(
                subject.subjectName.toString(),
                textAlign: TextAlign.start,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            )),
      ),
    );
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
    } else if (subjectsList.isEmpty) {
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
      // course = editTeacherSubject!.course!.id;
    }
    if (subjectsList.isEmpty) {
      // subject = editTeacherSubject!.subject!.id;
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
            subjectId: subjectsList)
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
            subjectId: subjectsList)
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
    clearList();
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

  clearList() {
    subjectsList.clear();
    subjectMenu.clear();
  }
}
