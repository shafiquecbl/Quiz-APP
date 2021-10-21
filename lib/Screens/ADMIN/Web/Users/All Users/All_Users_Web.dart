import 'package:cached_network_image/cached_network_image.dart';
import 'package:data_tables/data_tables.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/Models/User.dart';
import 'package:quiz_app/Screens/widget/Search_Field.dart';
import 'package:quiz_app/Services/api_manager.dart';
import 'package:quiz_app/WIdgets/ImageView.dart';
import 'package:quiz_app/WIdgets/loading.dart';
import 'package:quiz_app/WIdgets/network_error.dart';
import 'package:quiz_app/constants.dart';
import 'package:quiz_app/size_config.dart';
import 'dart:ui' as ui;

class AllUsersWEB extends StatefulWidget {
  final LoginResponse? loginResponse;
  AllUsersWEB({@required this.loginResponse});
  @override
  _AllUsersWEBState createState() => _AllUsersWEBState();
}

class _AllUsersWEBState extends State<AllUsersWEB> {
  int _rowsPerPage = 25;
  int _rowsOffset = 0;
  String? search = '';

  Future<List<User>>? _userModel;

  @override
  void initState() {
    _userModel = APIManager().fetchAllUsers(token: widget.loginResponse!.token);
    super.initState();
  }

  updatePage() {
    setState(() {
      _userModel =
          APIManager().fetchAllUsers(token: widget.loginResponse!.token);
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Users',
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
          children: [dataTable(), headCard('All Users')],
        ),
      ),
    );
  }

  headCard(String? title) {
    return Container(
      height: 80,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Card(
          color: yellow,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                Text(title.toString(),
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
            child: FutureBuilder<List<User>>(
              future: _userModel,
              builder:
                  (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return MyLoading();
                if (snapshot.data == null)
                  return NetworkError(onPressed: () {
                    setState(() {
                      _userModel = APIManager()
                          .fetchAllUsers(token: widget.loginResponse!.token);
                    });
                  });
                return userList(snapshot.data!);
              },
            ),
          ),
        ),
      ),
    );
  }

  userList(List<User> list) {
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
        DataColumn(label: Text('Role')),
        DataColumn(label: Text('Email')),
        DataColumn(label: Text('Phone #')),
        DataColumn(label: Text('Image')),
        DataColumn(label: Text('Action')),
      ],
      rows: List.generate(list.length, (index) => user(list[index], index)),
    );
  }

  user(User? user, index) {
    return DataRow(cells: [
      DataCell(Text('$index')),
      DataCell(Text(user!.name.toString())),
      DataCell(Text(user.role.toString())),
      DataCell(Text(user.email.toString())),
      DataCell(Text(user.phoneNumber.toString())),
      DataCell(ImageView(image: user.image)),
      DataCell(ElevatedButton(
          style: ElevatedButton.styleFrom(
              primary: user.suspend == false ? Colors.green : Colors.red),
          onPressed: () {
            APIManager()
                .suspendUser(
                    token: widget.loginResponse!.token,
                    id: user.id,
                    suspend: user.suspend == true ? false : true)
                .then((e) {
              print(e.body);
              updatePage();
            });
          },
          child: Text(user.suspend == false ? 'DEACTIVATE' : 'ACTIVATE'))),
    ]);
  }
}
