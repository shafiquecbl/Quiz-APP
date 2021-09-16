import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quiz_app/Models/Student.dart';
import 'package:quiz_app/Models/User.dart';
import 'package:quiz_app/Screens/widget/Search_Field.dart';
import 'package:quiz_app/Screens/widget/head_card.dart';
import 'package:quiz_app/Services/api_manager.dart';
import 'package:quiz_app/WIdgets/loading.dart';
import 'package:quiz_app/constants.dart';
import 'package:quiz_app/size_config.dart';

class StudentsWEB extends StatefulWidget {
  final LoginResponse loginResponse;
  StudentsWEB({required this.loginResponse});
  @override
  _StudentsWEBState createState() => _StudentsWEBState();
}

class _StudentsWEBState extends State<StudentsWEB> {
  //////////////////////////////////////////////////////////

  String? name, email, phoneNo, password, gender, rollNo;
  File? image;
  bool isLoading = false;
  String? error;
  String? search = '';
  Student? updateStudent;
  Future<List<Student>>? _studentModel;
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
                showAddStudentForm();
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
            child: FutureBuilder<List<Student>>(
              future: _studentModel,
              builder: (BuildContext context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return MyLoading();

                return studentsData(snapshot);
              },
            ),
          ),
        ),
      ),
    );
  }

  studentsData(AsyncSnapshot<List<Student>> snapshot) {
    return SingleChildScrollView(
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
          rows: List.generate(snapshot.data!.length, (index) {
            Student? student = snapshot.data![index];
            return students(student, index);
          }),
        ),
      ),
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
        margin: EdgeInsets.all(5),
        width: 50,
        height: 50,
        child: CachedNetworkImage(
          imageUrl: student.image.toString(),
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
                onPressed: () {
                  updateStudent = student;
                  showUpdateStudentForm();
                },
                child: Text('EDIT')),
            ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.red),
                onPressed: () {
                  updateStudent = student;
                  APIManager()
                      .deleteStudent(
                          token: widget.loginResponse.token,
                          id: updateStudent!.id)
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

  /////////////////////////////////////////////////////////////
  ////////////////////// ADD STUENT FORM //////////////////////
  ////////////////////////////////////////////////////////////

  showAddStudentForm() {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, myState) {
            return AlertDialog(
              content: content(myState, title: 'ADD STUDENT'),
              actions: [cancelButton(), createButton(myState)],
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

  Widget createButton(Function(void Function()) myState) {
    return Container(
        width: 120,
        height: 40,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(primary: yellow),
            onPressed: () {
              if (name == null) {
                myState(() {
                  error = 'Please enter name';
                });
              } else if (email == null) {
                myState(() {
                  error = 'Please enter email';
                });
              } else if (password == null) {
                myState(() {
                  error = 'Please enter password';
                });
              } else if (rollNo == null) {
                myState(() {
                  error = 'Please enter roll number';
                });
              } else if (phoneNo == null) {
                myState(() {
                  error = 'Please enter phone number';
                });
              } else if (gender == null) {
                myState(() {
                  error = 'Please select gender';
                });
              } else if (image == null) {
                myState(() {
                  error = 'Please select image';
                });
              } else {
                addStudent(myState);
              }
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(isLoading ? 'CREATING' : 'CREATE'),
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

  Widget updateButton(Function(void Function()) myState) {
    return Container(
        width: 120,
        height: 40,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(primary: yellow),
            onPressed: () {
              if (password == null) {
                myState(() {
                  error = 'Please enter password';
                });
              } else {
                if (name == null) {
                  name = updateStudent!.name;
                }
                if (email == null) {
                  email = updateStudent!.email;
                }

                if (rollNo == null) {
                  rollNo = updateStudent!.rollNo;
                }
                if (phoneNo == null) {
                  phoneNo = updateStudent!.phoneNumber;
                }
                if (gender == null) {
                  gender = updateStudent!.gender;
                }
                updateStudentt(myState);
              }
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(isLoading ? 'UPDATING' : 'UPDATE'),
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

  addStudent(Function(void Function()) myState) {
    myState(() {
      error = null;
      isLoading = true;
    });

    return APIManager()
        .addStudent(
            token: widget.loginResponse.token,
            name: name,
            email: email,
            password: password,
            rollNo: rollNo,
            phoneNo: phoneNo,
            image: image,
            gender: gender)
        .then((value) {
      isLoading = false;
      Navigator.of(context, rootNavigator: true).pop();
      updatePage();
    });
  }

  updateStudentt(Function(void Function()) myState) {
    myState(() {
      error = null;
      isLoading = true;
    });
    return APIManager()
        .updateStudent(
            id: updateStudent!.id,
            token: widget.loginResponse.token,
            name: name,
            email: email,
            password: password,
            rollNo: rollNo,
            phoneNo: phoneNo,
            image: image,
            gender: gender)
        .then((value) {
      isLoading = false;
      Navigator.of(context, rootNavigator: true).pop();
      updatePage();
    });
  }

  Widget content(Function(void Function()) myState, {@required String? title}) {
    return Container(
      width: SizeConfig.screenWidth! / 1.8,
      height: SizeConfig.screenHeight! / 1.5,
      child: SingleChildScrollView(
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
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                rollNoField(),
                genderField(),
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
                          pickImage(myState);
                        },
                        icon: Icon(Icons.attach_file),
                        label: Text('Choos File')),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                image != null ? Text(image!.path.split('/').last) : Container()
              ],
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.only(left: 25),
              child: Row(
                children: [
                  error != null
                      ? Row(
                          children: [
                            Icon(Icons.error, color: Colors.red),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              '$error',
                              style: TextStyle(color: Colors.red),
                            )
                          ],
                        )
                      : Container(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  pickImage(Function(void Function()) myState) async {
    PickedFile? pickedImage = await
        // ignore: invalid_use_of_visible_for_testing_member
        ImagePicker.platform.pickImage(source: ImageSource.gallery);
    myState(() {
      image = File(pickedImage!.path);
    });

    return image;
  }

  Widget nameField() {
    return Container(
        width: SizeConfig.screenWidth! / 4,
        child: TextFormField(
          onChanged: (value) {
            name = value;
          },
          onFieldSubmitted: (value) {
            setState(() {
              name = value;
            });
          },
          onSaved: (value) {
            name = value;
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
          onChanged: (value) {
            email = value;
          },
          onFieldSubmitted: (value) {
            email = value;
          },
          onSaved: (value) {
            email = value;
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
          onChanged: (value) {
            phoneNo = value;
          },
          onFieldSubmitted: (value) {
            phoneNo = value;
          },
          onSaved: (value) {
            phoneNo = value;
          },
          decoration:
              InputDecoration(hintText: 'Enter phone #', labelText: 'PHONE #'),
        ));
  }

  Widget passwordField() {
    return Container(
        width: SizeConfig.screenWidth! / 4,
        child: TextFormField(
          onChanged: (value) {
            password = value;
          },
          onFieldSubmitted: (value) {
            password = value;
          },
          onSaved: (value) {
            password = value;
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
          onChanged: (value) {
            rollNo = value;
          },
          onFieldSubmitted: (value) {
            rollNo = value;
          },
          onSaved: (value) {
            rollNo = value;
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
          onChanged: (value) => gender = value.toString(),
          onSaved: (value) => gender = value.toString(),
          decoration: InputDecoration(
            labelText: "GENDER",
            hintText: "Select gender",
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
          items: popUpMenuItem,
        ));
  }

  /////////////////////////////////////////////////////////////
  ////////////////////// UPDATE STUENT FORM //////////////////////
  ////////////////////////////////////////////////////////////

  showUpdateStudentForm() {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, myState) {
            return AlertDialog(
              content: updateContet(myState, title: 'UPDATE STUDENT'),
              actions: [cancelButton(), updateButton(myState)],
            );
          });
        });
  }

  updateContet(Function(void Function()) myState, {@required String? title}) {
    return Container(
      width: SizeConfig.screenWidth! / 1.8,
      height: SizeConfig.screenHeight! / 1.5,
      child: SingleChildScrollView(
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
              children: [
                ////// NAME FIELD /////
                Container(
                    width: SizeConfig.screenWidth! / 4,
                    child: TextFormField(
                      initialValue:
                          updateStudent != null ? updateStudent!.name : null,
                      onChanged: (value) {
                        name = value;
                      },
                      onFieldSubmitted: (value) {
                        name = value;
                      },
                      onSaved: (value) {
                        name = value;
                      },
                      decoration: InputDecoration(
                          hintText: 'Enter name', labelText: 'NAME'),
                    )),

                ////// EMAIL FIELD //////

                Container(
                    width: SizeConfig.screenWidth! / 4,
                    child: TextFormField(
                      initialValue:
                          updateStudent != null ? updateStudent!.email : null,
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) {
                        email = value;
                      },
                      onFieldSubmitted: (value) {
                        email = value;
                      },
                      onSaved: (value) {
                        email = value;
                      },
                      decoration: InputDecoration(
                          hintText: 'Enter email', labelText: 'EMAIL'),
                    ))
              ],
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ////// PHONE No ///////

                Container(
                    width: SizeConfig.screenWidth! / 4,
                    child: TextFormField(
                      initialValue: updateStudent != null
                          ? updateStudent!.phoneNumber
                          : null,
                      keyboardType: TextInputType.phone,
                      onChanged: (value) {
                        phoneNo = value;
                      },
                      onFieldSubmitted: (value) {
                        phoneNo = value;
                      },
                      onSaved: (value) {
                        phoneNo = value;
                      },
                      decoration: InputDecoration(
                          hintText: 'Enter phone #', labelText: 'PHONE #'),
                    )),

                ////// PASSWORD FIELD ///////

                Container(
                    width: SizeConfig.screenWidth! / 4,
                    child: TextFormField(
                      onChanged: (value) {
                        password = value;
                      },
                      onFieldSubmitted: (value) {
                        password = value;
                      },
                      onSaved: (value) {
                        password = value;
                      },
                      obscureText: true,
                      decoration: InputDecoration(
                          hintText: 'Enter password', labelText: 'PASSWORD'),
                    )),
              ],
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ///// ROLL NO /////
                Container(
                    width: SizeConfig.screenWidth! / 4,
                    child: TextFormField(
                      initialValue:
                          updateStudent != null ? updateStudent!.rollNo : null,
                      onChanged: (value) {
                        rollNo = value;
                      },
                      onFieldSubmitted: (value) {
                        rollNo = value;
                      },
                      onSaved: (value) {
                        rollNo = value;
                      },
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          hintText: 'Enter Roll #', labelText: 'ROLL #'),
                    )),

                ///// GENDER  /////

                Container(
                    width: SizeConfig.screenWidth! / 4,
                    child: DropdownButtonFormField(
                      onChanged: (value) => gender = value.toString(),
                      onSaved: (value) => gender = value.toString(),
                      decoration: InputDecoration(
                        labelText: "GENDER",
                        hintText: "Select gender",
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      items: popUpMenuItem,
                    )),
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
                          pickImage(myState);
                        },
                        icon: Icon(Icons.attach_file),
                        label: Text('Choos File')),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                image != null ? Text(image!.path.split('/').last) : Container()
              ],
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.only(left: 25),
              child: Row(
                children: [
                  error != null
                      ? Row(
                          children: [
                            Icon(Icons.error, color: Colors.red),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              '$error',
                              style: TextStyle(color: Colors.red),
                            )
                          ],
                        )
                      : Container(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
