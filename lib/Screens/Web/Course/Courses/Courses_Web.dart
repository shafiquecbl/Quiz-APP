import 'package:flutter/material.dart';
import 'package:quiz_app/Models/Courses.dart';
import 'package:quiz_app/Models/User.dart';
import 'package:quiz_app/Screens/widget/head_card.dart';
import 'package:quiz_app/Services/api_manager.dart';
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
  String? courseName;
  Future<List<Course>>? _courseModel;

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
            child: searchField(),
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
                  showForm(title: 'ADD COURSES');
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

  ////////////////////// SEARCH FIELD //////////////////////

  Widget searchField() {
    return Container(
      width: SizeConfig.screenWidth! / 4.2,
      height: 45,
      child: TextFormField(
        onSaved: (value) {
          setState(() {
            search = value;
          });
        },
        onChanged: (value) {
          setState(() {
            search = value;
          });
        },
        onFieldSubmitted: (value) {
          setState(() {
            search = value;
          });
        },
        decoration: InputDecoration(
          hintText: 'Search for courses',
          hintStyle: TextStyle(fontSize: 14),
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide.none,
          ),
          prefixIcon: Icon(Icons.search),
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
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: nameField(),
              ),
            ],
          ),
        ],
      )),
    );
  }

  Widget nameField() {
    return Container(
        width: SizeConfig.screenWidth! / 4,
        child: TextFormField(
          decoration:
              InputDecoration(hintText: 'Enter course name', labelText: 'NAME'),
        ));
  }
}
