import 'package:flutter/material.dart';
import 'package:quiz_app/Models/Courses.dart';
import 'package:quiz_app/Models/User.dart';
import 'package:quiz_app/Screens/widget/Search_Field.dart';
import 'package:quiz_app/Screens/widget/head_card.dart';
import 'package:quiz_app/Services/api_manager.dart';
import 'package:quiz_app/WIdgets/Custom_Error.dart';
import 'package:quiz_app/WIdgets/loading.dart';
import 'package:quiz_app/constants.dart';
import 'package:quiz_app/size_config.dart';

class CoursesWEB extends StatefulWidget {
  final LoginResponse? loginResponse;
  CoursesWEB({@required this.loginResponse});
  @override
  _CoursesWEBState createState() => _CoursesWEBState();
}

class _CoursesWEBState extends State<CoursesWEB> {
  String? search = '';
  String? courseName, error, courseId;
  bool isLoading = false;
  Course? editCourse;
  Future<List<Course>>? _courseModel;
  final _formKey = GlobalKey<FormState>();
  Function(void Function())? myState;

  @override
  void initState() {
    _courseModel =
        APIManager().getCoursesList(token: widget.loginResponse!.token);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Courses',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 0, right: 10),
            child: SearchField(search: search, hintText: 'Search for courses'),
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Stack(
          children: [
            dataTable(),
            HeadCard(
                title: 'Courses List',
                onPressed: () {
                  showForm(title: 'ADD COURSE');
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
            child: FutureBuilder<List<Course>>(
              future: _courseModel,
              builder:
                  (BuildContext context, AsyncSnapshot<List<Course>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return MyLoading();
                return coursesList(snapshot);
              },
            ),
          ),
        ),
      ),
    );
  }

  coursesList(AsyncSnapshot<List<Course>> snapshot) {
    return SingleChildScrollView(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(label: Text('ID')),
            DataColumn(label: Text('Name')),
            DataColumn(label: Text('Action')),
          ],
          rows: List.generate(snapshot.data!.length,
              (index) => course(snapshot.data![index], index)),
        ),
      ),
    );
  }

  course(Course course, index) {
    return DataRow(cells: [
      DataCell(Text('$index')),
      DataCell(Text(course.name.toString())),
      DataCell(Container(
        width: 125,
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.green),
                onPressed: () {
                  editCourse = course;
                  courseId = course.id;
                  showForm(title: 'UPDATE COURSE');
                },
                child: Text('EDIT')),
            ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.red),
                onPressed: () {
                  APIManager()
                      .deleteCourse(
                          token: widget.loginResponse!.token, id: course.id)
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
          return StatefulBuilder(
            builder: (context, state) {
              myState = state;
              return AlertDialog(
                content: content(title: title),
                actions: [cancelButton(), createButton(title)],
              );
            },
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

  Widget createButton(String? title) {
    return Container(
        width: 120,
        height: 40,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(primary: yellow),
            onPressed: () {
              title == 'ADD COURSE' ? checkAdd() : checkUpdate();
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(isLoading && title == 'ADD COURSE'
                    ? 'CREATING'
                    : isLoading && title == 'UPDATE COURSE'
                        ? 'UPDATING'
                        : title == 'ADD COURSE'
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
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 25),
                    child: nameField(),
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

  Widget nameField() {
    return Container(
        width: SizeConfig.screenWidth! / 4,
        child: TextFormField(
          initialValue: editCourse != null ? editCourse!.name : null,
          onChanged: (value) {
            courseName = value;
          },
          onSaved: (value) {
            courseName = value;
          },
          onFieldSubmitted: (value) {
            courseName = value;
          },
          decoration:
              InputDecoration(hintText: 'Enter course name', labelText: 'NAME'),
        ));
  }

  /////////////////////////////////////////////
  /////////////// SOME FUNCTIONS //////////////
  /////////////////////////////////////////////

  checkAdd() {
    if (courseName == null) {
      myState!(() {
        error = 'Please provide course name';
      });
    } else {
      addCourse();
    }
  }

  checkUpdate() {
    if (courseName == null) {
      courseName = editCourse!.name;
    }
    updateCourse();
  }

  addCourse() {
    myState!(() {
      error = null;
      isLoading = true;
    });
    return APIManager()
        .addCourse(token: widget.loginResponse!.token, courseName: courseName)
        .then((value) {
      clearValues();
    });
  }

  updateCourse() {
    myState!(() {
      error = null;
      isLoading = true;
    });
    return APIManager()
        .updateCourse(
            token: widget.loginResponse!.token,
            courseName: courseName,
            courseId: courseId)
        .then((value) {
      clearValues();
    });
  }

  clearValues() {
    isLoading = false;
    courseName = null;
    error = null;
    courseId = null;
    editCourse = null;
    _formKey.currentState!.reset();
    Navigator.of(context, rootNavigator: true).pop();
    updatePage();
  }

  updatePage() {
    setState(() {
      _courseModel =
          APIManager().getCoursesList(token: widget.loginResponse!.token);
    });
  }
}
