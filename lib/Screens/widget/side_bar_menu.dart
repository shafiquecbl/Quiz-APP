import 'package:flutter/material.dart';
import 'package:quiz_app/constants.dart';
import 'package:quiz_app/controllers/page_controller.dart';

import 'drawerListTile.dart';

class SideBar extends StatefulWidget {
  @override
  _SideBarState createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
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
                    "QUIZ APP",
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
                  children: [
                    userTile(),
                    courseTile(),
                    quizTile(),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Container(
                  height: 40,
                  child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(primary: yellow),
                      onPressed: () {},
                      icon: Icon(Icons.logout),
                      label: Text('Logout', style: style)),
                ),
              ),
              SizedBox(height: 20)
            ],
          )),
    );
  }

  Widget userTile() {
    return ExpansionTile(
      collapsedIconColor: whiteColor,
      backgroundColor: complexDrawerBlueGrey,
      iconColor: yellow,
      expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
      title: Text(
        'Users',
        style: style,
      ),
      leading: Icon(Icons.person),
      children: [
        DrawerListTile(
          title: 'Students',
          onPressed: () {
            pageController.changePage(1);
          },
        ),
        DrawerListTile(
          title: 'Teachers',
          onPressed: () {
            pageController.changePage(2);
          },
        ),
        DrawerListTile(
          title: 'Admin',
          onPressed: () {
            pageController.changePage(3);
          },
        ),
        DrawerListTile(
          title: 'SubAdmin',
          onPressed: () {
            pageController.changePage(4);
          },
        ),
      ],
    );
  }

  Widget courseTile() {
    return ExpansionTile(
      collapsedIconColor: whiteColor,
      backgroundColor: complexDrawerBlueGrey,
      iconColor: yellow,
      expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
      title: Text(
        'Course',
        style: style,
      ),
      leading: Icon(Icons.person),
      children: [
        DrawerListTile(
          title: 'Course',
          onPressed: () {
            pageController.changePage(5);
          },
        ),
        DrawerListTile(
          title: 'Subjects',
          onPressed: () {
            pageController.changePage(6);
          },
        ),
        DrawerListTile(
          title: 'Teacher Subjects',
          onPressed: () {
            pageController.changePage(7);
          },
        ),
        DrawerListTile(
          title: 'Enroll Students',
          onPressed: () {
            pageController.changePage(8);
          },
        ),
      ],
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
            pageController.changePage(9);
          },
        ),
        DrawerListTile(
          title: 'Question',
          onPressed: () {
            pageController.changePage(10);
          },
        ),
      ],
    );
  }
}
