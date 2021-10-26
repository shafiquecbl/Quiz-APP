import 'package:data_tables/data_tables.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/Models/Student.dart';
import 'package:quiz_app/Models/User.dart';
import 'package:quiz_app/Screens/widget/Search_Field.dart';
import 'package:quiz_app/Screens/widget/head_card.dart';
import 'package:quiz_app/Services/api_manager.dart';
import 'package:quiz_app/WIdgets/Custom_Error.dart';
import 'package:quiz_app/WIdgets/ImageView.dart';
import 'package:quiz_app/WIdgets/alert_dialog.dart';
import 'package:quiz_app/WIdgets/loading.dart';
import 'package:quiz_app/WIdgets/network_error.dart';
import 'package:quiz_app/constants.dart';
import 'package:quiz_app/size_config.dart';

class StudentsWEB extends StatefulWidget {
  final LoginResponse loginResponse;
  StudentsWEB({required this.loginResponse});
  @override
  _StudentsWEBState createState() => _StudentsWEBState();
}

class _StudentsWEBState extends State<StudentsWEB> {
  int _rowsPerPage = 25;
  int _rowsOffset = 0;

  ///////////////////// CONTROLLER ////////////////////////
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phoneNo = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController rollNo = TextEditingController();
  /////////////////////////////////////////////////////////

  String? gender;
  PlatformFile? image;

  bool isLoading = false;
  String? error;
  String? search = '';
  Student? updateStudent;

  final _formKey = GlobalKey<FormState>();
  Future<List<Student>>? _studentModel;
  Function(void Function())? myState;

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

  /////////////////////////////////////////////////////////

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
        title: Text('Students',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600)),
        actions: [
          IconButton(
              onPressed: () {
                updatePage();
              },
              icon: Icon(Icons.refresh)),
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 0, right: 10),
            child: SearchField(search: search, hintText: 'Search for students'),
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Stack(
          children: [
            dataTable(),
            HeadCard(
              onPressed: () {
                showAddStudentForm(title: 'ADD STUDENT');
              },
              title: 'ADD STUDENT',
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
        DataColumn(label: Text('Image')),
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
      DataCell(ImageView(image: student.image)),
      DataCell(Container(
        width: 125,
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.green),
                onPressed: () {
                  updateStudent = student;
                  showAddStudentForm(title: 'UPDATE STUDENT');
                },
                child: Text('EDIT')),
            ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.red),
                onPressed: () {
                  updateStudent = student;

                  //show alert dialog
                  customDialog(context,
                      title: 'Delete User!',
                      content: 'Do you want to delete ${student.name}?',
                      onPressed1: () {
                    Navigator.pop(context);
                    // delete user permanently
                    APIManager()
                        .deleteStudent(
                            token: widget.loginResponse.token,
                            id: updateStudent!.id)
                        .then((value) {
                      updatePage();
                    });
                  }, onPressed2: () {
                    Navigator.pop(context);
                    // suspend user
                    APIManager()
                        .suspendUser(
                            token: widget.loginResponse.token,
                            id: student.id,
                            suspend: true)
                        .then((e) {
                      updatePage();
                    });
                  });
                },
                child: Text('DELETE'))
          ],
        ),
      )),
    ]);
  }

  /////////////////////////////////////////////////////////////
  ////////////////////// ADD STUENT FORM //////////////////////
  ////////////////////////////////////////////////////////////

  showAddStudentForm({@required String? title}) {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, state) {
            myState = state;
            return AlertDialog(
              content: content(title: title),
              actions: [cancelButton(), createButton(title)],
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
              title == 'ADD STUDENT' ? checkAdd() : checkUpdate();
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(isLoading && title == 'ADD STUDENT'
                    ? 'CREATING'
                    : isLoading && title == 'UPDATE STUDENT'
                        ? 'UPDATING'
                        : title == 'ADD STUDENT'
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
    if (_formKey.currentState!.validate()) {
      if (image == null) {
        myState!(() {
          error = 'Please select image';
        });
      } else {
        addStudent();
      }
    }
  }

  checkUpdate() {
    if (_formKey.currentState!.validate()) {
      if (gender == null) {
        gender = updateStudent!.gender;
      }
      updateStudentt();
    }
  }

  addStudent() {
    myState!(() {
      error = null;
      isLoading = true;
    });

    return APIManager()
        .addStudent(
            token: widget.loginResponse.token,
            name: name.text,
            email: email.text,
            password: password.text,
            rollNo: rollNo.text,
            phoneNo: phoneNo.text,
            image: image,
            gender: gender)
        .then((value) {
      myState!(() {
        isLoading = false;
      });
      updatePage();
    }).catchError((e) {
      myState!(() {
        isLoading = false;
        error = 'Create Failed';
      });
    });
  }

  updateStudentt() {
    myState!(() {
      error = null;
      isLoading = true;
    });
    return APIManager()
        .updateStudent(
            id: updateStudent!.id,
            token: widget.loginResponse.token,
            name: name.text,
            email: email.text,
            rollNo: rollNo.text,
            phoneNo: phoneNo.text,
            image: image,
            gender: gender)
        .then((value) {
      clearValues();
      updatePage();
    });
  }

  clearValues() {
    _formKey.currentState!.reset();
    isLoading = false;
    Navigator.of(context, rootNavigator: true).pop();
    clearController();
  }

  Widget content({@required String? title}) {
    return Container(
      width: SizeConfig.screenWidth! / 1.8,
      height: SizeConfig.screenHeight! / 1.5,
      child: SingleChildScrollView(
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
                children: [nameField(), emailField()],
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  phoneNoField(),
                  genderField(),
                ],
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: title == 'ADD STUDENT'
                    ? MainAxisAlignment.spaceEvenly
                    : MainAxisAlignment.start,
                children: [
                  title != 'ADD STUDENT'
                      ? Padding(
                          padding: const EdgeInsets.only(left: 25),
                          child: rollNoField(),
                        )
                      : rollNoField(),
                  title == 'ADD STUDENT' ? passwordField() : Container(),
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
                          onPressed: () {
                            pickImage();
                          },
                          icon: Icon(Icons.attach_file),
                          label: Text('Choose Photo')),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  image != null ? Text('Image Selected') : Container()
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
          ),
        ),
      ),
    );
  }

  pickImage() async {
    await FilePicker.platform
        .pickFiles(
      withReadStream:
          true, // this will return PlatformFile object with read stream
    )
        .then((value) {
      myState!(() {
        image = value!.files.single;
      });
    });

    return image;
  }

  Widget nameField() {
    return Container(
        width: SizeConfig.screenWidth! / 4,
        child: TextFormField(
          controller: name
            ..text = updateStudent != null ? updateStudent!.name! : '',
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter name';
            }

            return null;
          },
          decoration:
              InputDecoration(hintText: 'Enter name', labelText: 'NAME'),
        ));
  }

  Widget emailField() {
    return Container(
        width: SizeConfig.screenWidth! / 4,
        child: TextFormField(
          keyboardType: TextInputType.emailAddress,
          controller: email
            ..text = updateStudent != null ? updateStudent!.email! : '',
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter email';
            } else if (!isEmail(value)) {
              return 'Email format is not correcct';
            }

            return null;
          },
          decoration:
              InputDecoration(hintText: 'Enter email', labelText: 'EMAIL'),
        ));
  }

  Widget phoneNoField() {
    return Container(
        width: SizeConfig.screenWidth! / 4,
        child: TextFormField(
          keyboardType: TextInputType.phone,
          controller: phoneNo
            ..text = updateStudent != null ? updateStudent!.phoneNumber! : '',
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter phone no';
            } else if (value.length != 11) {
              return 'Please enter 11 digit phone number';
            }

            return null;
          },
          decoration:
              InputDecoration(hintText: 'Enter phone #', labelText: 'PHONE #'),
        ));
  }

  Widget passwordField() {
    return Container(
        width: SizeConfig.screenWidth! / 4,
        child: TextFormField(
          controller: password,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter password';
            } else if (value.length < 8) {
              return 'Password length must be 8';
            }
            return null;
          },
          obscureText: true,
          decoration: InputDecoration(
              hintText: 'Enter password', labelText: 'PASSWORD'),
        ));
  }

  Widget rollNoField() {
    return Container(
        width: SizeConfig.screenWidth! / 4,
        child: TextFormField(
          controller: rollNo
            ..text = updateStudent != null ? updateStudent!.rollNo! : '',
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter roll no';
            }

            return null;
          },
          keyboardType: TextInputType.number,
          decoration:
              InputDecoration(hintText: 'Enter Roll #', labelText: 'ROLL #'),
        ));
  }

  Widget genderField() {
    return Container(
        width: SizeConfig.screenWidth! / 4,
        child: DropdownButtonFormField(
          validator: (value) {
            if (updateStudent == null) {
              if (value == null) {
                return 'Please select gender';
              }
            }

            return null;
          },
          onChanged: (value) => gender = value.toString(),
          onSaved: (value) => gender = value.toString(),
          decoration: InputDecoration(
            labelText: "GENDER",
            hintText:
                updateStudent == null ? "Select gender" : updateStudent!.gender,
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
          items: popUpMenuItem,
        ));
  }

  clearController() {
    updateStudent = null;
    name.clear();
    email.clear();
    password.clear();
    phoneNo.clear();
    rollNo.clear();
    gender = null;
    image = null;
  }
}
