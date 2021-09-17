import 'package:flutter/material.dart';
import 'package:quiz_app/Models/Courses.dart';
import 'package:quiz_app/Models/Enroll_Student.dart';
import 'package:quiz_app/Models/Student.dart';
import 'package:quiz_app/Models/User.dart';
import 'package:quiz_app/Screens/widget/Search_Field.dart';
import 'package:quiz_app/Screens/widget/head_card.dart';
import 'package:quiz_app/Services/api_manager.dart';
import 'package:quiz_app/WIdgets/loading.dart';
import 'package:quiz_app/constants.dart';
import 'package:quiz_app/size_config.dart';

class EnrollStudentsWEB extends StatefulWidget {
  final LoginResponse? loginResponse;
  EnrollStudentsWEB({@required this.loginResponse});
  @override
  _EnrollStudentsWEBState createState() => _EnrollStudentsWEBState();
}

class _EnrollStudentsWEBState extends State<EnrollStudentsWEB> {
  String? search = '';
  List<Student> menuItems = [];
  List<Course> menuItems1 = [];

  //////////////////////////////////

  bool isLoading = false;
  String? courseId, studentId;
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
                  showForm(title: 'ADD ENROLL STUDENT');
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
            child: FutureBuilder<List<EnrollStudent>>(
              future: _enrollModel,
              builder: (BuildContext context,
                  AsyncSnapshot<List<EnrollStudent>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return MyLoading();
                return enrollStudents(snapshot);
              },
            ),
          ),
        ),
      ),
    );
  }

  enrollStudents(AsyncSnapshot<List<EnrollStudent>> snapshot) {
    return SingleChildScrollView(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
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
                    onPressed: () {},
                    child: Text('DELETE')),
              )),
            ]);
          }),
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
            children: [studentField(), coursesField()],
          ),
        ],
      )),
    );
  }

  Widget studentField() {
    return Container(
        width: SizeConfig.screenWidth! / 4,
        child: DropdownButtonFormField(
          onSaved: (newValue) => {studentId = newValue.toString()},
          onChanged: (value) {
            studentId = value.toString();
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
          onSaved: (newValue) => {studentId = newValue.toString()},
          onChanged: (value) {
            studentId = value.toString();
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
