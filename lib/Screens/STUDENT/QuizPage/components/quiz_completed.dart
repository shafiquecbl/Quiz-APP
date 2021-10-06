import 'package:flutter/material.dart';
import 'package:quiz_app/Models/User.dart';
import 'package:quiz_app/Screens/STUDENT/Home/student_home.dart';
import 'package:quiz_app/Screens/widget/Navigator.dart';
import 'package:quiz_app/constants.dart';

class QuizCompleted extends StatelessWidget {
  final StudentLoginResponse? loginResponse;
  QuizCompleted({@required this.loginResponse});
  @override
  Widget build(BuildContext context) {
    TextStyle style = TextStyle(color: Colors.white, fontSize: 22);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            alignment: WrapAlignment.center,
            direction: Axis.vertical,
            children: [
              Image.asset(
                'assets/done.png',
                width: size.width / 1.7,
                height: size.height / 1.7,
              ),
              SizedBox(
                height: 40,
              ),
              Text(
                'Quiz Completed!',
                style: TextStyle(fontSize: 26),
              ),
              SizedBox(
                height: 40,
              ),
              Container(
                width: 140,
                height: 50,
                child: TextButton.icon(
                    style: ElevatedButton.styleFrom(
                      primary: yellow,
                      elevation: 0,
                    ),
                    onPressed: () async {
                      pushAndRemoveUntil(
                          context, StudentHome(loginResponse: loginResponse!));
                    },
                    icon: Icon(
                      Icons.home,
                      color: Colors.white,
                    ),
                    label: Text('Home', style: style)),
              ),
            ]),
      ),
    );
  }
}
