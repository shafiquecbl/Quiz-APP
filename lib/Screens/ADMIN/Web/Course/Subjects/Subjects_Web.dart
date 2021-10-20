import 'package:data_tables/data_tables.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/Models/Courses.dart';
import 'package:quiz_app/Models/Subjects.dart';
import 'package:quiz_app/Models/User.dart';
import 'package:quiz_app/Screens/widget/Search_Field.dart';
import 'package:quiz_app/Screens/widget/head_card.dart';
import 'package:quiz_app/Services/api_manager.dart';
import 'package:quiz_app/WIdgets/Custom_Error.dart';
import 'package:quiz_app/WIdgets/loading.dart';
import 'package:quiz_app/WIdgets/network_error.dart';
import 'package:quiz_app/constants.dart';
import 'package:quiz_app/size_config.dart';

class SubjectsWEB extends StatefulWidget {
  final LoginResponse? loginResponse;
  SubjectsWEB({@required this.loginResponse});
  @override
  _SubjectsWEBState createState() => _SubjectsWEBState();
}

class _SubjectsWEBState extends State<SubjectsWEB> {
  int _rowsPerPage = 25;
  int _rowsOffset = 0;
  String? search = '';
  String? error;
  bool isLoading = false;
  String? subjectName, courseId;
  List<Course> menuItems = [];
  Function(void Function())? myState;
  Future<List<Subject>>? _subjectModel;
  final _formKey = GlobalKey<FormState>();
  Subject? editSubject;

  @override
  void initState() {
    _subjectModel =
        APIManager().fetchSubjectsList(token: widget.loginResponse!.token);
    getCourses();
    super.initState();
  }

  getCourses() {
    APIManager()
        .getCoursesList(token: widget.loginResponse!.token)
        .then((value) {
      setState(() {
        menuItems = value;
      });
      myState!(() {
        menuItems = value;
      });
    });
  }

  updatePage() {
    setState(() {
      _subjectModel =
          APIManager().fetchSubjectsList(token: widget.loginResponse!.token);
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Subjects',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 0, right: 10),
            child: SearchField(search: search, hintText: 'Search subjects'),
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Stack(
          children: [
            dataTable(),
            HeadCard(
                title: 'Subjects List',
                onPressed: () {
                  showForm(title: 'ADD SUBJECT');
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
            child: FutureBuilder<List<Subject>>(
              future: _subjectModel,
              builder: (BuildContext context,
                  AsyncSnapshot<List<Subject>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return MyLoading();
                if (snapshot.data == null)
                  return NetworkError(onPressed: () {
                    setState(() {
                      _subjectModel = APIManager().fetchSubjectsList(
                          token: widget.loginResponse!.token);
                      getCourses();
                    });
                  });
                return subjectsList(snapshot.data!);
              },
            ),
          ),
        ),
      ),
    );
  }

  subjectsList(List<Subject> subjects) {
    return NativeDataTable(
      rowsPerPage: _rowsPerPage,
      firstRowIndex: _rowsOffset,
      handleNext: () {
        if (_rowsOffset + 25 < subjects.length) {
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
        DataColumn(label: Text('Subject Name')),
        DataColumn(label: Text('Course Name')),
        DataColumn(label: Text('Action')),
      ],
      rows: List.generate(subjects.length, (index) {
        return subject(subjects[index], index);
      }),
    );
  }

  subject(Subject? subject, int index) {
    return DataRow(cells: [
      DataCell(Text('$index')),
      DataCell(Text(subject!.subjectName.toString())),
      DataCell(Text(subject.course!.name.toString())),
      DataCell(Container(
        width: 125,
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.green),
                onPressed: () {
                  editSubject = subject;
                  showForm(title: 'UPDATE SUBJECT');
                },
                child: Text('EDIT')),
            ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.red),
                onPressed: () {
                  APIManager()
                      .deleteSubject(
                          token: widget.loginResponse!.token, id: subject.id)
                      .then((value) {
                    updatePage();
                  }).catchError((e) {
                    error = 'Network Error';
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
              title == 'ADD SUBJECT' ? checkAdd() : checkUpdate();
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(isLoading && title == 'ADD SUBJECT'
                    ? 'CREATING'
                    : isLoading && title == 'UPDATE SUBJECT'
                        ? 'UPDATING'
                        : title == 'ADD SUBJECT'
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
    if (courseId == null) {
      myState!(() {
        error = 'Please select course';
      });
    } else if (subjectName == null) {
      myState!(() {
        error = 'Please provide subject name';
      });
    } else {
      addSubject();
    }
  }

  addSubject() {
    myState!(() {
      error = null;
      isLoading = true;
    });
    return APIManager()
        .addSubject(
            token: widget.loginResponse!.token,
            subjectName: subjectName,
            course: courseId)
        .then((value) {
      clearValues();
    });
  }

  checkUpdate() {
    if (subjectName == null) {
      subjectName = editSubject!.subjectName;
    }
    updateSubject();
  }

  updateSubject() {
    myState!(() {
      error = null;
      isLoading = true;
    });
    return APIManager()
        .updateSubject(
            token: widget.loginResponse!.token,
            subjectName: subjectName,
            id: editSubject!.id)
        .then((value) {
      clearValues();
    });
  }

  clearValues() {
    isLoading = false;
    subjectName = null;
    error = null;
    courseId = null;
    editSubject = null;
    _formKey.currentState!.reset();
    Navigator.of(context, rootNavigator: true).pop();
    updatePage();
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
                children: [nameField(), coursesField()],
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

  Widget nameField() {
    return Container(
        width: SizeConfig.screenWidth! / 4,
        child: TextFormField(
          initialValue: editSubject != null ? editSubject!.subjectName : null,
          onChanged: (value) {
            subjectName = value;
          },
          onFieldSubmitted: (value) {
            subjectName = value;
          },
          onSaved: (value) {
            subjectName = value;
          },
          decoration: InputDecoration(
              hintText: 'Enter subject name', labelText: 'SUBJECT NAME'),
        ));
  }

  Widget coursesField() {
    return Container(
        width: SizeConfig.screenWidth! / 4,
        child: DropdownButtonFormField(
          onSaved: (value) {
            courseId = value.toString();
          },
          onChanged: editSubject != null
              ? null
              : (value) {
                  courseId = value.toString();
                },
          decoration: InputDecoration(
            labelText: "COURSE NAME",
            hintText: "Select course",
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
}
