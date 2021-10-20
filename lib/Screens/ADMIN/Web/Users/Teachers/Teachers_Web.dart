import 'package:cached_network_image/cached_network_image.dart';
import 'package:data_tables/data_tables.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/Models/Teachers.dart';
import 'package:quiz_app/Models/User.dart';
import 'package:quiz_app/Screens/widget/Search_Field.dart';
import 'package:quiz_app/Screens/widget/head_card.dart';
import 'package:quiz_app/Services/api_manager.dart';
import 'package:quiz_app/WIdgets/Custom_Error.dart';
import 'package:quiz_app/WIdgets/alert_dialog.dart';
import 'package:quiz_app/WIdgets/loading.dart';
import 'package:quiz_app/WIdgets/network_error.dart';
import 'package:quiz_app/constants.dart';
import 'package:quiz_app/size_config.dart';

class TeachersWEB extends StatefulWidget {
  final LoginResponse? loginResponse;
  TeachersWEB({@required this.loginResponse});
  @override
  _TeachersWEBState createState() => _TeachersWEBState();
}

class _TeachersWEBState extends State<TeachersWEB> {
  int _rowsPerPage = 25;
  int _rowsOffset = 0;
  String? search = '';
  String? name, email, phoneNo, password, gender;
  PlatformFile? image;

  bool isLoading = false;
  String? error;
  Teacher? editTeacher;
  Function(void Function())? myState;
  final _formKey = GlobalKey<FormState>();
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
                  showForm(title: 'ADD TEACHER');
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
            child: FutureBuilder<List<Teacher>>(
              future: _teacherModel,
              builder: (BuildContext context,
                  AsyncSnapshot<List<Teacher>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return MyLoading();
                if (snapshot.data == null)
                  return NetworkError(onPressed: () {
                    setState(() {
                      _teacherModel = APIManager().fetchTeachersList(
                          token: widget.loginResponse!.token);
                    });
                  });
                return teacherList(snapshot.data!);
              },
            ),
          ),
        ),
      ),
    );
  }

  teacherList(List<Teacher> list) {
    return NativeDataTable(
      rowsPerPage: _rowsPerPage,
      firstRowIndex: _rowsOffset,
      handleNext: () {
        if (_rowsOffset + 25 < list.length) {
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
        DataColumn(label: Text('Image')),
        DataColumn(label: Text('Action')),
      ],
      rows: List.generate(list.length, (index) => teacher(list[index], index)),
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
          errorWidget: (context, string, dynamic) {
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
                  editTeacher = teacher;
                  showForm(title: 'UPDATE TEACHER');
                },
                child: Text('EDIT')),
            ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.red),
                onPressed: () {
                  //show alert dialog
                  customDialog(context,
                      title: 'Delete User!',
                      content: 'Do you want to delete ${teacher.name}?',
                      onPressed1: () {
                    Navigator.pop(context);
                    // delete user permanently
                    APIManager()
                        .deleteTeacher(
                            token: widget.loginResponse!.token, id: teacher.id)
                        .then((value) {
                      updatePage();
                    });
                  }, onPressed2: () {
                    Navigator.pop(context);
                    // suspend user
                    APIManager()
                        .suspendUser(
                            token: widget.loginResponse!.token,
                            id: teacher.id,
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

  Widget createButton({@required title}) {
    return Container(
        width: 120,
        height: 40,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(primary: yellow),
            onPressed: () {
              title == 'ADD TEACHER' ? checkAdd() : checkUpdate();
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(isLoading && title == 'ADD TEACHER'
                    ? 'CREATING'
                    : isLoading && title == 'UPDATE TEACHER'
                        ? 'UPDATING'
                        : title == 'ADD TEACHER'
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
    if (name == null) {
      myState!(() {
        error = 'Please provide name';
      });
    } else if (email == null) {
      myState!(() {
        error = 'Please provide email';
      });
    } else if (password == null) {
      myState!(() {
        error = 'Please provide password';
      });
    } else if (phoneNo == null) {
      myState!(() {
        error = 'Please provide phone no.';
      });
    } else if (image == null) {
      myState!(() {
        error = 'Please select image';
      });
    } else if (gender == null) {
      myState!(() {
        error = 'Please select gender';
      });
    } else {
      addTeacher();
    }
  }

  addTeacher() {
    myState!(() {
      isLoading = true;
      error = null;
    });

    APIManager()
        .addTeacher(
            token: widget.loginResponse!.token,
            name: name,
            email: email,
            password: password,
            phoneNo: phoneNo,
            image: image,
            gender: gender)
        .then((value) {
      clearValues();
    });
  }

  checkUpdate() {
    if (name == null) {
      name = editTeacher!.name;
    }
    if (email == null) {
      email = editTeacher!.email;
    }
    if (phoneNo == null) {
      phoneNo = editTeacher!.phoneNumber;
    }
    if (gender == null) {
      gender = editTeacher!.gender;
    }
    updateTeacher();
  }

  updateTeacher() {
    myState!(() {
      isLoading = true;
      error = null;
    });
    APIManager()
        .updateTeacher(
            id: editTeacher!.id,
            token: widget.loginResponse!.token,
            name: name,
            email: email,
            password: password,
            phoneNo: phoneNo,
            image: image,
            gender: gender)
        .then((value) {
      clearValues();
    }).catchError((e) {
      myState!(() {
        error = '${e.message}';
      });
    });
  }

  clearValues() {
    isLoading = false;
    name = null;
    email = null;
    password = null;
    phoneNo = null;
    image = null;
    gender = null;
    error = null;
    _formKey.currentState!.reset();
    Navigator.of(context, rootNavigator: true).pop();
    updatePage();
  }

  updatePage() {
    setState(() {
      _teacherModel =
          APIManager().fetchTeachersList(token: widget.loginResponse!.token);
    });
  }

  Widget content({@required String? title}) {
    return Container(
      width: SizeConfig.screenWidth! / 1.8,
      height: SizeConfig.screenHeight! / 1.5,
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
                          onPressed: () {
                            pickImage();
                          },
                          icon: Icon(Icons.attach_file),
                          label: Text('Choose Photo')),
                    ),
                  ),
                  SizedBox(
                    width: 20,
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
          )),
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
          initialValue: editTeacher != null ? editTeacher!.name : null,
          onChanged: (value) {
            name = value;
          },
          onSaved: (value) {
            name = value;
          },
          onFieldSubmitted: (value) {
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
          initialValue: editTeacher != null ? editTeacher!.email : null,
          onChanged: (value) {
            email = value;
          },
          onSaved: (value) {
            email = value;
          },
          onFieldSubmitted: (value) {
            email = value;
          },
          keyboardType: TextInputType.emailAddress,
          decoration:
              InputDecoration(hintText: 'Enter email', labelText: 'EMAIL'),
        ));
  }

  Widget phoneNoField() {
    return Container(
        width: SizeConfig.screenWidth! / 4,
        child: TextFormField(
          initialValue: editTeacher != null ? editTeacher!.phoneNumber : null,
          onChanged: (value) {
            phoneNo = value;
          },
          onSaved: (value) {
            phoneNo = value;
          },
          onFieldSubmitted: (value) {
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
          onSaved: (value) {
            password = value;
          },
          onFieldSubmitted: (value) {
            password = value;
          },
          obscureText: true,
          decoration: InputDecoration(
              hintText: 'Enter password', labelText: 'PASSWORD'),
        ));
  }

  Widget genderField() {
    return Container(
        width: SizeConfig.screenWidth! / 4,
        child: DropdownButtonFormField(
          onSaved: (newValue) => {gender = newValue.toString()},
          onChanged: (value) {
            gender = value.toString();
          },
          decoration: InputDecoration(
            labelText: "GENDER",
            hintText: "Select gender",
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
          items: popUpMenuItem,
        ));
  }
}
