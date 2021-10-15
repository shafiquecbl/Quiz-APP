import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/Models/User.dart';
import 'package:quiz_app/Screens/ADMIN/Main%20Page/Main_Page.dart';
import 'package:quiz_app/Screens/widget/Navigator.dart';
import 'package:quiz_app/constants.dart';
import 'package:quiz_app/controllers/page_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudentSideBar extends StatefulWidget {
  final LoginResponse? loginResponse;
  StudentSideBar({@required this.loginResponse});
  @override
  _StudentSideBarState createState() => _StudentSideBarState();
}

class _StudentSideBarState extends State<StudentSideBar> {
  Color white = Colors.white;
  String photo =
      'https://scontent-mct1-1.xx.fbcdn.net/v/t1.6435-9/158479360_1142747166168186_1490317238156797909_n.jpg?_nc_cat=104&ccb=1-5&_nc_sid=09cbfe&_nc_eui2=AeGzTakXuDLbndOKFChcgxMuf5mPHA1hCRF_mY8cDWEJEZqC5WM5KhEDdO7TkZNU70zQf975CBttufFIso0ngT6z&_nc_ohc=cjAkPwpJQlwAX_XNwbU&_nc_ht=scontent-mct1-1.xx&oh=94d8ab49d995d97d04f325dfbf11b355&oe=616F79F8';
  MyPageController pageController = MyPageController();
  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0,
      child: Container(
          color: complexDrawerBlack,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  pageController.changePage(0);
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Text(
                    "QUIZACCPT",
                    style: TextStyle(
                      color: yellow,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              CircleAvatar(
                radius: 50,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: CachedNetworkImage(
                      imageUrl: widget.loginResponse!.user!.image.toString(),
                      width: 120,
                      height: 120,
                      placeholder: (context, string) {
                        return Icon(Icons.image);
                      },
                      errorWidget: (context, string, dynamic) {
                        return Icon(Icons.image);
                      },
                    )),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  widget.loginResponse!.user!.name.toString().toUpperCase(),
                  style: TextStyle(
                    color: white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                child: Text(
                  "( ${widget.loginResponse!.user!.role!.toUpperCase()} )",
                  style: TextStyle(
                    color: white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Expanded(
                child: ListView(
                  children: [homeTile(), scoreTile()],
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
                      label: Text('Logout', style: TextStyle(color: white))),
                ),
              ),
              SizedBox(height: 20)
            ],
          )),
    );
  }

  Widget homeTile() {
    return Container(
      color: complexDrawerBlueGrey,
      child: ListTile(
          onTap: () {
            pageController.changePage(0);
          },
          title: Text(
            'Home',
            style: TextStyle(color: white),
          ),
          leading: Icon(
            Icons.home,
            color: yellow,
          )),
    );
  }

  Widget scoreTile() {
    return Container(
      color: complexDrawerBlueGrey,
      child: ListTile(
          onTap: () {
            pageController.changePage(3);
          },
          title: Text(
            'Score Board',
            style: TextStyle(color: white),
          ),
          leading: Icon(
            Icons.score_outlined,
            color: yellow,
          )),
    );
  }
}
