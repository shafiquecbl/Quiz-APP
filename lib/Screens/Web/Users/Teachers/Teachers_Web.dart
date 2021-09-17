import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/Models/Teachers.dart';
import 'package:quiz_app/Models/User.dart';
import 'package:quiz_app/Screens/widget/Search_Field.dart';
import 'package:quiz_app/Screens/widget/head_card.dart';
import 'package:quiz_app/Services/api_manager.dart';
import 'package:quiz_app/WIdgets/loading.dart';
import 'package:quiz_app/constants.dart';
import 'package:quiz_app/size_config.dart';

class TeachersWEB extends StatefulWidget {
  final LoginResponse? loginResponse;
  TeachersWEB({@required this.loginResponse});
  @override
  _TeachersWEBState createState() => _TeachersWEBState();
}

class _TeachersWEBState extends State<TeachersWEB> {
  String? search = '';
  static const menuItems = <String>[
    'Male',
    'Female',
    'Other',
  ];
  final List<DropdownMenuItem<String>> popUpMenuItem = menuItems
      .map((String value) => DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          ))
      .toList();
  Future<List<Teacher>>? _teacherModel;

  @override
  void initState() {
    _teacherModel =
        APIManager().fetchTeachersList(token: widget.loginResponse!.token);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Teachers',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 0, right: 10),
            child: SearchField(search: search, hintText: 'Search for users'),
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Stack(
          children: [
            dataTable(),
            HeadCard(
                title: 'Teachers List',
                onPressed: () {
                  showForm(title: 'ADD TEACHERS');
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
            child: FutureBuilder<List<Teacher>>(
              future: _teacherModel,
              builder: (BuildContext context,
                  AsyncSnapshot<List<Teacher>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return MyLoading();
                return teacherList(snapshot.data!);
              },
            ),
          ),
        ),
      ),
    );
  }

  teacherList(List<Teacher> list) {
    return SingleChildScrollView(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(label: Text('ID')),
            DataColumn(label: Text('Name')),
            DataColumn(label: Text('Email')),
            DataColumn(label: Text('Phone #')),
            DataColumn(label: Text('Image')),
            DataColumn(label: Text('Action')),
          ],
          rows: List.generate(
              list.length, (index) => teacher(list[index], index)),
        ),
      ),
    );
  }

  teacher(Teacher? teacher, index) {
    return DataRow(cells: [
      DataCell(Text('$index')),
      DataCell(Text(teacher!.name.toString())),
      DataCell(Text(teacher.email.toString())),
      DataCell(Text(teacher.phoneNumber.toString())),
      DataCell(Container(
        margin: EdgeInsets.all(5),
        width: 50,
        height: 50,
        child: CachedNetworkImage(
          imageUrl: teacher.image.toString(),
          fit: BoxFit.cover,
          placeholder: (context, string) {
            return Icon(Icons.image);
          },
        ),
      )),
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
            children: [nameField(), emailField()],
          ),
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              phoneNoField(),
              passwordField(),
            ],
          ),
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: genderField(),
              ),
            ],
          ),
          SizedBox(height: 30),

          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: Container(
                  height: 35,
                  color: Colors.grey[300],
                  child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.attach_file),
                      label: Text('Choos File')),
                ),
              ),
              Spacer(),
            ],
          )
        ],
      )),
    );
  }

  Widget nameField() {
    return Container(
        width: SizeConfig.screenWidth! / 4,
        child: TextFormField(
          decoration:
              InputDecoration(hintText: 'Enter name', labelText: 'NAME'),
        ));
  }

  Widget emailField() {
    return Container(
        width: SizeConfig.screenWidth! / 4,
        child: TextFormField(
          decoration:
              InputDecoration(hintText: 'Enter email', labelText: 'EMAIL'),
        ));
  }

  Widget phoneNoField() {
    return Container(
        width: SizeConfig.screenWidth! / 4,
        child: TextFormField(
          decoration:
              InputDecoration(hintText: 'Enter phone #', labelText: 'PHONE #'),
        ));
  }

  Widget passwordField() {
    return Container(
        width: SizeConfig.screenWidth! / 4,
        child: TextFormField(
          obscureText: true,
          decoration: InputDecoration(
              hintText: 'Enter password', labelText: 'PASSWORD'),
        ));
  }

  Widget genderField() {
    return Container(
        width: SizeConfig.screenWidth! / 4,
        child: DropdownButtonFormField(
          onSaved: (newValue) => {},
          onChanged: (value) {},
          decoration: InputDecoration(
            labelText: "GENDER",
            hintText: "Select gender",
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
          items: popUpMenuItem,
        ));
  }
}
