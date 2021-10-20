import 'package:data_tables/data_tables.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/Models/Student.dart';
import 'package:quiz_app/Models/User.dart';
import 'package:quiz_app/Provider/provider.dart';
import 'package:quiz_app/Services/api_manager.dart';
import 'package:quiz_app/WIdgets/loading.dart';
import 'package:quiz_app/WIdgets/network_error.dart';
import 'package:quiz_app/constants.dart';
import 'package:quiz_app/controllers/page_controller.dart';
import 'package:quiz_app/size_config.dart';

class StudentsListWEB extends StatefulWidget {
  final LoginResponse loginResponse;
  StudentsListWEB({required this.loginResponse});
  @override
  _StudentsListWEBState createState() => _StudentsListWEBState();
}

class _StudentsListWEBState extends State<StudentsListWEB> {
  int _rowsPerPage = 25;
  int _rowsOffset = 0;

  String? search = '';
  Future<List<Student>>? _studentModel;
  MyPageController pageController = MyPageController();

  @override
  void initState() {
    _studentModel =
        APIManager().fetchStudentsList(token: widget.loginResponse.token);
    super.initState();
  }

  updatePage() {
    setState(() {
      _studentModel =
          APIManager().fetchStudentsList(token: widget.loginResponse.token);
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('SCORE BOARD',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600)),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Stack(
          children: [
            dataTable(),
            Container(
              height: 80,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Card(
                  color: yellow,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Row(
                      children: [
                        Text('Students List',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: whiteColor)),
                        Spacer(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
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
            child: FutureBuilder<List<Student>>(
              future: _studentModel,
              builder: (BuildContext context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return MyLoading();
                if (snapshot.data != null) return studentsData(snapshot);
                return NetworkError(onPressed: () {
                  setState(() {
                    _studentModel = APIManager()
                        .fetchStudentsList(token: widget.loginResponse.token);
                  });
                });
              },
            ),
          ),
        ),
      ),
    );
  }

  studentsData(AsyncSnapshot<List<Student>> snapshot) {
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
        DataColumn(label: Text('Email')),
        DataColumn(label: Text('Phone #')),
        DataColumn(label: Text('Roll #')),
        DataColumn(label: Text('Action')),
      ],
      rows: List.generate(snapshot.data!.length, (index) {
        Student? student = snapshot.data![index];
        return students(student, index);
      }),
    );
  }

  students(Student? student, index) {
    return DataRow(cells: [
      DataCell(Text('$index')),
      DataCell(Text(student!.name.toString())),
      DataCell(Text(student.email.toString())),
      DataCell(Text(student.phoneNumber.toString())),
      DataCell(Container(
        width: 50,
        child: Text(student.rollNo.toString()),
      )),
      DataCell(Container(
        width: 125,
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Consumer<CustomProvier>(
              builder: (context, provider, child) {
                return ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.green),
                    onPressed: () {
                      provider.saveStudentId(id: student.id);
                      pageController.changePage(11);
                    },
                    child: Text('View Score'));
              },
            )
          ],
        ),
      )),
    ]);
  }
}
