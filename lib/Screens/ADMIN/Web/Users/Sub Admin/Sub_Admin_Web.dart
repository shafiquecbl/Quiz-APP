import 'package:data_tables/data_tables.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/Models/SubAdmin.dart';
import 'package:quiz_app/Models/User.dart';
import 'package:quiz_app/Screens/widget/Search_Field.dart';
import 'package:quiz_app/Screens/widget/head_card.dart';
import 'package:quiz_app/Services/api_manager.dart';
import 'package:quiz_app/WIdgets/ImageView.dart';
import 'package:quiz_app/WIdgets/alert_dialog.dart';
import 'package:quiz_app/WIdgets/loading.dart';
import 'package:quiz_app/WIdgets/network_error.dart';
import 'package:quiz_app/constants.dart';
import 'package:quiz_app/size_config.dart';

class SubAdminWEB extends StatefulWidget {
  final LoginResponse? loginResponse;
  SubAdminWEB({@required this.loginResponse});
  @override
  _SubAdminWEBState createState() => _SubAdminWEBState();
}

class _SubAdminWEBState extends State<SubAdminWEB> {
  int _rowsPerPage = 25;
  int _rowsOffset = 0;
  String? search = '';

///////////////////// CONTROLLER ////////////////////////
  String? name, email, phoneNo, password;
  /////////////////////////////////////////////////////////

  String? gender;
  PlatformFile? image;

  bool isLoading = false;
  String? error;
  SubAdmin? editSubAdmin;
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

  Future<List<SubAdmin>>? _subAdminModel;

  @override
  void initState() {
    _subAdminModel =
        APIManager().fetchSubAdminsList(token: widget.loginResponse!.token);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Sub Admins',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 0, right: 10),
            child:
                SearchField(search: search, hintText: 'Search for sub-admins'),
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Stack(
          children: [
            dataTable(),
            HeadCard(
                title: 'Sub-Admins List',
                onPressed: () {
                  showForm(title: 'ADD SUB ADMIN');
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
            child: FutureBuilder<List<SubAdmin>>(
              future: _subAdminModel,
              builder: (BuildContext context,
                  AsyncSnapshot<List<SubAdmin>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return MyLoading();
                if (snapshot.data == null)
                  return NetworkError(onPressed: () {
                    setState(() {
                      _subAdminModel = APIManager().fetchSubAdminsList(
                          token: widget.loginResponse!.token);
                    });
                  });
                return subAdminsList(snapshot.data!);
              },
            ),
          ),
        ),
      ),
    );
  }

  subAdminsList(List<SubAdmin> list) {
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
      rows: List.generate(list.length, (index) => subAdmin(list[index], index)),
    );
  }

  subAdmin(SubAdmin subAdmin, index) {
    return DataRow(cells: [
      DataCell(Text('$index')),
      DataCell(Text(subAdmin.name.toString())),
      DataCell(Text(subAdmin.email.toString())),
      DataCell(Text(subAdmin.phoneNumber.toString())),
      DataCell(ImageView(image: subAdmin.image)),
      DataCell(Container(
        width: 125,
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.green),
                onPressed: () {
                  editSubAdmin = subAdmin;
                  showForm(title: 'UPDATE SUB ADMIN');
                },
                child: Text('EDIT')),
            ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.red),
                onPressed: () {
                  //show alert dialog
                  customDialog(context,
                      title: 'Delete User!',
                      content: 'Do you want to delete ${subAdmin.name}?',
                      onPressed1: () {
                    Navigator.pop(context);
                    // delete user permanently
                    APIManager()
                        .deleteSubAdmin(
                            token: widget.loginResponse!.token, id: subAdmin.id)
                        .then((value) {
                      updatePage();
                    });
                  }, onPressed2: () {
                    Navigator.pop(context);
                    // suspend user
                    APIManager()
                        .suspendUser(
                            token: widget.loginResponse!.token,
                            id: subAdmin.id,
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
              clearController();
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
              title == 'ADD SUB ADMIN' ? checkAdd() : checkUpdate();
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(isLoading && title == 'ADD SUB ADMIN'
                    ? 'CREATING'
                    : isLoading && title == 'UPDATE SUB ADMIN'
                        ? 'UPDATING'
                        : title == 'ADD SUB ADMIN'
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
        addSubAdmin();
      }
    }
  }

  addSubAdmin() {
    myState!(() {
      isLoading = true;
      error = null;
    });
    APIManager()
        .addSubAdmin(
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
    if (_formKey.currentState!.validate()) {
      if (gender == null) {
        gender = editSubAdmin!.gender;
      }
      updateSubAdmin();
    }
  }

  updateSubAdmin() {
    myState!(() {
      isLoading = true;
      error = null;
    });
    APIManager()
        .updateSubAdmin(
            id: editSubAdmin!.id,
            token: widget.loginResponse!.token,
            name: name,
            email: email,
            phoneNo: phoneNo,
            image: image,
            gender: gender)
        .then((value) {
      clearValues();
    });
  }

  clearValues() {
    isLoading = false;
    error = null;
    _formKey.currentState!.reset();
    Navigator.of(context, rootNavigator: true).pop();
    clearController();
    updatePage();
  }

  clearController() {
    editSubAdmin = null;
    name = null;
    email = null;
    password = null;
    phoneNo = null;
    gender = null;
    image = null;
  }

  updatePage() {
    setState(() {
      _subAdminModel =
          APIManager().fetchSubAdminsList(token: widget.loginResponse!.token);
    });
  }

  Widget content({@required String? title}) {
    return Container(
      width: SizeConfig.screenWidth! / 1.8,
      height: SizeConfig.screenHeight! / 1.8,
      child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                ///////////////////// TITLE /////////////////////

                Text(title.toString(),
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
                title == 'ADD SUB ADMIN'
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 25),
                            child: passwordField(),
                          ),
                        ],
                      )
                    : Container(),
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
                )
              ],
            ),
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
          initialValue: editSubAdmin == null ? null : editSubAdmin!.name,
          onChanged: (value) {
            name = value;
          },
          onFieldSubmitted: (value) {
            name = value;
          },
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
          initialValue: editSubAdmin == null ? null : editSubAdmin!.email,
          onFieldSubmitted: (value) {
            email = value;
          },
          onChanged: (value) {
            email = value;
          },
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
          initialValue: editSubAdmin == null ? null : editSubAdmin!.phoneNumber,
          onChanged: (value) {
            phoneNo = value;
          },
          onFieldSubmitted: (value) {
            phoneNo = value;
          },
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
          onChanged: (value) {
            password = value;
          },
          onFieldSubmitted: (value) {
            password = value;
          },
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

  Widget genderField() {
    return Container(
        width: SizeConfig.screenWidth! / 4,
        child: DropdownButtonFormField(
          validator: (value) {
            if (editSubAdmin == null) {
              if (value == null) {
                return 'Please select gender';
              }
            }
            return null;
          },
          onSaved: (newValue) => {gender = newValue.toString()},
          onChanged: (value) {
            gender = value.toString();
          },
          decoration: InputDecoration(
            labelText: "GENDER",
            hintText:
                editSubAdmin == null ? "Select gender" : editSubAdmin!.gender,
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
          items: popUpMenuItem,
        ));
  }
}
