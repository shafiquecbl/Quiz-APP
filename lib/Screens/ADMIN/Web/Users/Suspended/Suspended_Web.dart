import 'package:flutter/material.dart';
import 'package:quiz_app/Models/User.dart';
import 'package:quiz_app/Screens/widget/Search_Field.dart';
import 'package:quiz_app/Services/api_manager.dart';
import 'package:quiz_app/WIdgets/loading.dart';
import 'package:quiz_app/constants.dart';
import 'package:quiz_app/size_config.dart';

class SuspendedWEB extends StatefulWidget {
  final LoginResponse? loginResponse;
  SuspendedWEB({@required this.loginResponse});
  @override
  _SuspendedWEBState createState() => _SuspendedWEBState();
}

class _SuspendedWEBState extends State<SuspendedWEB> {
  String? search = '';

  Future<List<User>>? _userModel;

  @override
  void initState() {
    _userModel =
        APIManager().fetchSuspendedUserList(token: widget.loginResponse!.token);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Suspended Users',
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
          children: [dataTable(), headCard('Suspended Users List')],
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
            child: FutureBuilder<List<User>>(
              future: _userModel,
              builder:
                  (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return MyLoading();
                return userList(snapshot.data!);
              },
            ),
          ),
        ),
      ),
    );
  }

  userList(List<User> list) {
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
          rows: List.generate(list.length, (index) => user(list[index], index)),
        ),
      ),
    );
  }

  user(User? user, index) {
    return DataRow(cells: [
      DataCell(Text('$index')),
      DataCell(Text(user!.name.toString())),
      DataCell(Text(user.email.toString())),
      DataCell(Text(user.phoneNumber.toString())),
      DataCell(Text(user.role.toString())),
      DataCell(ElevatedButton(
          style: ElevatedButton.styleFrom(primary: Colors.red),
          onPressed: () {},
          child: Text('AVTIVATE'))),
    ]);
  }
}
