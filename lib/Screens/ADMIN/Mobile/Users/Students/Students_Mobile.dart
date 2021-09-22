import 'package:flutter/material.dart';
import 'package:quiz_app/Screens/ADMIN/Mobile/Users/Students/components/head.dart';
import 'package:quiz_app/Screens/widget/Search_Field.dart';
import 'package:quiz_app/Screens/widget/side_bar_menu.dart';
import 'package:quiz_app/size_config.dart';

class StudentsMobile extends StatefulWidget {
  @override
  _StudentsMobileState createState() => _StudentsMobileState();
}

class _StudentsMobileState extends State<StudentsMobile> {
  String? search = '';

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Students',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 0, right: 10),
            child: SearchField(search: search, hintText: 'Search for students'),
          )
        ],
      ),
      drawer: SideBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Stack(
          children: [
            dataTable(),
            SMHead(),
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
                      DataColumn(label: Text('Email')),
                      DataColumn(label: Text('Phone #')),
                      DataColumn(label: Text('Roll #')),
                      DataColumn(label: Text('Image')),
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
                                width: 50,
                                child: Text('093'),
                              )),
                              DataCell(Text('NULL')),
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
}
