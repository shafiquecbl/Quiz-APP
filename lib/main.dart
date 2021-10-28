import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/Models/User.dart';
import 'package:quiz_app/Provider/provider.dart';
import 'package:quiz_app/Screens/ADMIN/Main%20Page/Main_Page.dart';
import 'package:quiz_app/Screens/ADMIN/home_page.dart';
import 'package:quiz_app/Screens/STUDENT/Home/student_home.dart';
import 'package:quiz_app/Screens/Teacher/teacher_main.dart';
import 'package:quiz_app/WIdgets/loading.dart';
import 'package:quiz_app/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CustomProvier>(
      create: (context) => CustomProvier(),
      child: MaterialApp(
        title: 'QuizOn',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            appBarTheme: AppBarTheme(
                elevation: 0,
                backgroundColor: whiteColor,
                iconTheme: IconThemeData(color: Colors.black87)),
            scaffoldBackgroundColor: whiteColor,
            primaryColor: yellow,
            textTheme:
                GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)),
        home: FutureBuilder<LoginResponse>(
          future: getResponse(),
          builder:
              (BuildContext context, AsyncSnapshot<LoginResponse> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return MyLoading();

            WidgetsBinding.instance!.addPostFrameCallback((_) {
              if (snapshot.data != null) {
                CustomProvier provider =
                    Provider.of<CustomProvier>(context, listen: false);
                provider.saveLoginResponse(response: snapshot.data);
              }
            });

            return snapshot.data != null && snapshot.data!.user!.role == 'admin'
                ? HomePage(
                    loginResponse:
                        snapshot.data!) // data not null and roll is admin

                : snapshot.data != null &&
                        snapshot.data!.user!.role == 'student'
                    ? StudentHome(
                        loginResponse:
                            snapshot.data!) // data not null and roll is student

                    : snapshot.data != null &&
                            snapshot.data!.user!.role == 'teacher'
                        ? TeacherHomePage(
                            loginResponse: snapshot
                                .data!) // data not null and roll is teacher

                        : MainPage();
          },
        ),
      ),
    );
  }

  Future<LoginResponse> getResponse() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String userPref = pref.getString('LoginResponse').toString();
    var jsonMap = json.decode(userPref);
    return LoginResponse.fromJson(jsonMap);
  }
}
