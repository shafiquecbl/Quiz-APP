import 'package:data_tables/data_tables.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/Models/Courses.dart';
import 'package:quiz_app/Models/Enroll_Student.dart';
import 'package:quiz_app/Models/Student.dart';
import 'package:quiz_app/Models/User.dart';
import 'package:quiz_app/Screens/widget/Search_Field.dart';
import 'package:quiz_app/Screens/widget/head_card.dart';
import 'package:quiz_app/Services/api_manager.dart';
import 'package:quiz_app/WIdgets/Custom_Error.dart';
import 'package:quiz_app/WIdgets/loading.dart';
import 'package:quiz_app/WIdgets/network_error.dart';
import 'package:quiz_app/constants.dart';
import 'package:quiz_app/size_config.dart';

class EnrollStudentsWEB extends StatefulWidget {
  final LoginResponse? loginResponse;
  EnrollStudentsWEB({@required this.loginResponse});
  @override
  _EnrollStudentsWEBState createState() => _EnrollStudentsWEBState();
}

class _EnrollStudentsWEBState extends State<EnrollStudentsWEB> {
  int _rowsPerPage = 25;
  int _rowsOffset = 0;
  String? search = '';
  List<Student> menuItems = [];
  List<Course> menuItems1 = [];

  //////////////////////////////////

  bool isLoading = false;
  String? courseId, studentId, error;
  final _formKey = GlobalKey<FormState>();
  Function(void Function())? myState;
  EnrollStudent? editEnrollStudent;
  Future<List<EnrollStudent>>? _enrollModel;

  //////////////////////////////////

  @override
  void initState() {
    _enrollModel =
        APIManager().fetchENrollStudentList(token: widget.loginResponse!.token);
    getStudents();
    getCourses();
    super.initState();
  }

  updatePage() {
    setState(() {
      _enrollModel = APIManager()
          .fetchENrollStudentList(token: widget.loginResponse!.token);
    });
  }

  getStudents() {
    APIManager()
        .fetchStudentsList(token: widget.loginResponse!.token)
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

  /////////////////////////////////
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Enroll Students',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 0, right: 10),
            child: SearchField(search: search, hintText: 'Search for student'),
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Stack(
          children: [
            dataTable(),
            HeadCard(
                title: 'Enroll Students List',
                onPressed: () {
                  showForm(title: 'ENROLL STUDENT');
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
            child: FutureBuilder<List<EnrollStudent>>(
              future: _enrollModel,
              builder: (BuildContext context,
                  AsyncSnapshot<List<EnrollStudent>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return MyLoading();
                if (snapshot.data == null)
                  return NetworkError(onPressed: () {
                    setState(() {
                      _enrollModel = APIManager().fetchENrollStudentList(
                          token: widget.loginResponse!.token);
                      getStudents();
                      getCourses();
                    });
                  });
                return enrollStudents(snapshot);
              },
            ),
          ),
        ),
      ),
    );
  }

  enrollStudents(AsyncSnapshot<List<EnrollStudent>> snapshot) {
    return NativeDataTable(
      rowsPerPage: _rowsPerPage,
      firstRowIndex: _rowsOffset,
      handleNext: () {
        if (_rowsOffset + 25 < snapshot.data!.length) {
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
        DataColumn(label: Text('Action')),
      ],
      rows: List.generate(snapshot.data!.length, (index) {
        EnrollStudent std = snapshot.data![index];
        return DataRow(cells: [
          DataCell(Text('$index')),
          DataCell(Text(std.student!.name.toString())),
          DataCell(Text(std.course!.name.toString())),
          DataCell(Container(
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.red),
                onPressed: () {
                  APIManager()
                      .deleteENrollStudent(
                          token: widget.loginResponse!.token, id: std.id)
                      .then((value) {
                    updatePage();
                  });
                },
                child: Text('DELETE')),
          )),
        ]);
      }),
    );
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
              checkAdd();
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(isLoading && title == 'ENROLL STUDENT'
                    ? 'CREATING'
                    : 'CREATE'),
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
    if (studentId == null) {
      myState!(() {
        error = 'Please select student ID';
      });
    } else if (courseId == null) {
      myState!(() {
        error = 'Please select course ID';
      });
    } else {
      addEnrollStudent();
    }
  }

  addEnrollStudent() {
    myState!(() {
      isLoading = true;
      error = null;
    });
    APIManager()
        .addENrollStudent(
            token: widget.loginResponse!.token,
            studentID: studentId,
            courseID: courseId)
        .then((value) {
      clearValues();
    });
  }

  clearValues() {
    isLoading = false;
    courseId = null;
    studentId = null;
    error = null;
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
                children: [studentField(), coursesField()],
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

  Widget studentField() {
    return Container(
        width: SizeConfig.screenWidth! / 4,
        child: DropdownButtonFormField(
          onSaved: (newValue) {
            studentId = newValue.toString();
            print(newValue);
          },
          onChanged: (value) {
            studentId = value.toString();
            print(value);
          },
          decoration: InputDecoration(
            labelText: "STUDENTS",
            hintText: "Select student",
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

  Widget coursesField() {
    return Container(
        width: SizeConfig.screenWidth! / 4,
        child: DropdownButtonFormField(
          onSaved: (newValue) {
            courseId = newValue.toString();
            print(newValue);
          },
          onChanged: (value) {
            courseId = value.toString();
            print(value);
          },
          decoration: InputDecoration(
            labelText: "COURSES",
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
}
