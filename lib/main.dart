import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/Models/User.dart';
import 'package:quiz_app/Provider/provider.dart';
import 'package:quiz_app/Screens/STUDENT/Home/student_home.dart';
import 'package:quiz_app/Screens/STUDENT/Main/student_main.dart';
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
        title: 'Quiz App',
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
        home: FutureBuilder<StudentLoginResponse>(
          future: getResponse(),
          builder: (BuildContext context,
              AsyncSnapshot<StudentLoginResponse> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return MyLoading();

            return snapshot.data != null
                ? StudentHome(loginResponse: snapshot.data!)
                : StudentMainPage();
          },
        ),
      ),
    );
  }

  Future<StudentLoginResponse> getResponse() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String userPref = pref.getString('LoginResponse').toString();
    var jsonMap = json.decode(userPref);
    return StudentLoginResponse.fromJson(jsonMap);
  }
}
