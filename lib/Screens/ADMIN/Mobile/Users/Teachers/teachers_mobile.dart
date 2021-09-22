import 'package:flutter/material.dart';
import 'package:quiz_app/Screens/widget/side_bar_menu.dart';
import 'package:quiz_app/common/app_responsive.dart';
import 'package:quiz_app/size_config.dart';

class TeachersMobile extends StatefulWidget {
  @override
  _TeachersMobileState createState() => _TeachersMobileState();
}

class _TeachersMobileState extends State<TeachersMobile> {
  String? search = '';

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Teachers',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 0, right: 10),
            child: searchField(),
          )
        ],
      ),
      drawer: SideBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [if (AppResponsive.isDesktop(context)) head()],
        ),
      ),
    );
  }

  Widget head() {
    return Row(
      children: [],
    );
  }

  Widget searchField() {
    return Container(
      width: SizeConfig.screenWidth! / 2.3,
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
          hintText: 'Search for teachers',
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
}
