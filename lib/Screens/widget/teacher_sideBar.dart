import 'package:flutter/material.dart';
import 'package:quiz_app/Screens/ADMIN/Main%20Page/Main_Page.dart';
import 'package:quiz_app/constants.dart';
import 'package:quiz_app/controllers/page_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Navigator.dart';
import 'drawerListTile.dart';

class TeacherSideBar extends StatefulWidget {
  final String? role;
  TeacherSideBar({@required this.role});
  @override
  _TeacherSideBarState createState() => _TeacherSideBarState();
}

class _TeacherSideBarState extends State<TeacherSideBar> {
  MyPageController pageController = MyPageController();
  TextStyle style = TextStyle(color: Colors.white);
  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0,
      child: Container(
          color: complexDrawerBlack,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  pageController.changePage(0);
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Text(
                    "QUIZON",
                    style: TextStyle(
                      color: yellow,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  children: [quizTile(), scoreBoardTile()],
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Container(
                  height: 40,
                  child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(primary: yellow),
                      onPressed: () async {
                        SharedPreferences pref =
                            await SharedPreferences.getInstance();
                        pref.remove('LoginResponse').then(
                            (value) => pushAndRemoveUntil(context, MainPage()));
                      },
                      icon: Icon(Icons.logout),
                      label: Text('Logout', style: style)),
                ),
              ),
              SizedBox(height: 20)
            ],
          )),
    );
  }

  Widget quizTile() {
    return ExpansionTile(
      collapsedIconColor: whiteColor,
      backgroundColor: complexDrawerBlueGrey,
      iconColor: yellow,
      expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
      title: Text(
        'Quiz',
        style: style,
      ),
      leading: Icon(Icons.person),
      children: [
        DrawerListTile(
          title: 'Quiz',
          onPressed: () {
            pageController.changePage(0);
          },
        ),
        DrawerListTile(
          title: 'Question',
          onPressed: () {
            pageController.changePage(1);
          },
        ),
      ],
    );
  }

  Widget scoreBoardTile() {
    return Container(
      color: complexDrawerBlack,
      child: ListTile(
          onTap: () {
            pageController.changePage(2);
          },
          title: Text(
            'SCORE BOARD',
            style: TextStyle(color: Colors.white),
          ),
          leading: Icon(
            Icons.score_outlined,
            color: Colors.white,
          )),
    );
  }
}
