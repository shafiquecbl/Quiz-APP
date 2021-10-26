import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/Provider/provider.dart';
import 'package:quiz_app/Screens/ADMIN/Main%20Page/action_button.dart';
import 'package:quiz_app/Screens/ADMIN/home_page.dart';
import 'package:quiz_app/Screens/STUDENT/Home/student_home.dart';
import 'package:quiz_app/Screens/Teacher/teacher_main.dart';
import 'package:quiz_app/Screens/widget/Navigator.dart';
import 'package:quiz_app/Services/api_manager.dart';
import 'package:quiz_app/WIdgets/loading.dart';
import 'package:quiz_app/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogIn extends StatefulWidget {
  final Function? onSignUpSelected;

  LogIn({@required this.onSignUpSelected});

  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String? error;
  String? email, password;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.all(size.height > 770
          ? 64
          : size.height > 670
              ? 32
              : 16),
      child: Center(
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(25),
            ),
          ),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            height: size.height *
                (size.height > 770
                    ? 0.7
                    : size.height > 670
                        ? 0.8
                        : 0.9),
            width: 500,
            color: Colors.white,
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(40),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "LOG IN",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[700],
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Container(
                          width: 30,
                          child: Divider(
                            color: yellow,
                            thickness: 2,
                          ),
                        ),
                        SizedBox(
                          height: 32,
                        ),
                        TextFormField(
                          onChanged: (value) {
                            setState(() {
                              email = value;
                            });
                          },
                          onSaved: (value) {
                            setState(() {
                              email = value;
                            });
                          },
                          onFieldSubmitted: (value) {
                            setState(() {
                              email = value;
                            });
                          },
                          decoration: InputDecoration(
                            hintText: 'Email',
                            labelText: 'Email',
                            suffixIcon: Icon(
                              Icons.mail_outline,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 32,
                        ),
                        TextFormField(
                          obscureText: true,
                          onChanged: (value) {
                            setState(() {
                              password = value;
                            });
                          },
                          onSaved: (value) {
                            setState(() {
                              password = value;
                            });
                          },
                          onFieldSubmitted: (value) {
                            setState(() {
                              password = value;
                            });
                          },
                          decoration: InputDecoration(
                            hintText: 'Password',
                            labelText: 'Password',
                            suffixIcon: Icon(
                              Icons.lock_outline,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 64,
                        ),
                        ActionButton(
                          text: "Log In",
                          onPressed: () {
                            if (email == null) {
                              setState(() {
                                error = 'Please provide email';
                              });
                            } else if (password == null) {
                              setState(() {
                                error = 'Please provide password';
                              });
                            } else {
                              login();
                            }
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        error != null
                            ? Row(
                                children: [
                                  Icon(Icons.error, color: Colors.red),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    '$error',
                                    style: TextStyle(color: Colors.red),
                                  )
                                ],
                              )
                            : Container(),
                        SizedBox(
                          height: 20,
                        ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [
                        //     Text(
                        //       "You do not have an account?",
                        //       style: TextStyle(
                        //         color: Colors.grey,
                        //         fontSize: 14,
                        //       ),
                        //     ),
                        //     SizedBox(
                        //       width: 8,
                        //     ),
                        //     GestureDetector(
                        //       onTap: () {
                        //         widget.onSignUpSelected!();
                        //       },
                        //       child: Row(
                        //         children: [
                        //           Text(
                        //             "Sign Up",
                        //             style: TextStyle(
                        //               color: yellow,
                        //               fontSize: 14,
                        //               fontWeight: FontWeight.bold,
                        //             ),
                        //           ),
                        //           SizedBox(
                        //             width: 8,
                        //           ),
                        //           Icon(
                        //             Icons.arrow_forward,
                        //             color: yellow,
                        //           ),
                        //         ],
                        //       ),
                        //     ),
                        //   ],
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  login() {
    setState(() {
      error = null;
    });
    showLoadingDialog(context);
    APIManager().adminLogin(email, password).then((value) async {
      SharedPreferences pref = await SharedPreferences.getInstance();
      Navigator.pop(context);
      if (value.user!.suspend == true) {
        pref.remove('LoginResponse');
        setState(() {
          error = 'User Suspended';
        });
      } else {
        CustomProvier provider =
            Provider.of<CustomProvier>(context, listen: false);
        provider.saveLoginResponse(response: value);

        value.user!.role == 'admin'
            ? pushAndRemoveUntil(context, HomePage(loginResponse: value))
            : value.user!.role == 'student'
                ? pushAndRemoveUntil(context, StudentHome(loginResponse: value))
                : pushAndRemoveUntil(
                    context, TeacherHomePage(loginResponse: value));
      }
    }).catchError((e) {
      Navigator.pop(context);
      setState(() {
        error = 'Invalid Credentials';
      });
    });
  }
}
