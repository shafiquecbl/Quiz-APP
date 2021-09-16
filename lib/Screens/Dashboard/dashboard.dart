import 'package:flutter/material.dart';
import 'package:quiz_app/Models/User.dart';
import 'package:quiz_app/Screens/Dashboard/dashboard_home.dart';
import 'package:quiz_app/Screens/Mobile/Course/Courses/Courses_Mobile.dart';
import 'package:quiz_app/Screens/Mobile/Course/Enroll%20Students/enroll_students_Mobile.dart';
import 'package:quiz_app/Screens/Mobile/Course/Subjects/Subjects_Mobile.dart';
import 'package:quiz_app/Screens/Mobile/Course/Teacher%20Subjects/Teacher_Subjects_Mobile.dart';
import 'package:quiz_app/Screens/Mobile/Quiz/Questions/Questions_Mobile.dart';
import 'package:quiz_app/Screens/Mobile/Quiz/Quizs/quiz_Mobile.dart';
import 'package:quiz_app/Screens/Mobile/Users/Students/Students_Mobile.dart';
import 'package:quiz_app/Screens/Mobile/Users/Sub%20Admin/Sub_Admin_Mobile.dart';
import 'package:quiz_app/Screens/Mobile/Users/Suspended/Suspended_Mobile.dart';
import 'package:quiz_app/Screens/Mobile/Users/Teachers/teachers_mobile.dart';
import 'package:quiz_app/Screens/Web/Course/Courses/Courses_Web.dart';
import 'package:quiz_app/Screens/Web/Course/Enroll%20Students/Enroll_Students_Web.dart';
import 'package:quiz_app/Screens/Web/Course/Subjects/Subjects_Web.dart';
import 'package:quiz_app/Screens/Web/Course/Teacher%20Subjects/Teacher_Subjects_Web.dart';
import 'package:quiz_app/Screens/Web/Quiz/Questions/Questions_Web.dart';
import 'package:quiz_app/Screens/Web/Quiz/Quizs/Quiz_Web.dart';
import 'package:quiz_app/Screens/Web/Users/Students/Students_Web.dart';
import 'package:quiz_app/Screens/Web/Users/Sub%20Admin/Sub_Admin_Web.dart';
import 'package:quiz_app/Screens/Web/Users/Suspended/Suspended_Web.dart';
import 'package:quiz_app/Screens/Web/Users/Teachers/Teachers_Web.dart';
import 'package:quiz_app/common/app_responsive.dart';
import 'package:quiz_app/controllers/page_controller.dart';

class Dashboard extends StatefulWidget {
  final LoginResponse loginResponse;
  Dashboard({required this.loginResponse});
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return PageView(
      physics: new NeverScrollableScrollPhysics(),
      controller: MyPageController.controller,
      children: [
        DashboardHome(),
        AppResponsive.isDesktop(context)
            ? StudentsWEB(loginResponse: widget.loginResponse)
            : StudentsMobile(),
        AppResponsive.isDesktop(context) ? TeachersWEB() : TeachersMobile(),
        AppResponsive.isDesktop(context) ? SuspendedWEB() : SuspendedMobile(),
        AppResponsive.isDesktop(context) ? SubAdminWEB() : SubAdminMobile(),
        AppResponsive.isDesktop(context)
            ? CoursesWEB(
                loginResponse: widget.loginResponse,
              )
            : CoursesMobile(),
        AppResponsive.isDesktop(context) ? SubjectsWEB() : SubjectsMobile(),
        AppResponsive.isDesktop(context)
            ? TeacherSubjectsWEB()
            : TeacherSubjectsMobile(),
        AppResponsive.isDesktop(context)
            ? EnrollStudentsWEB()
            : EnrollStudentsMobile(),
        AppResponsive.isDesktop(context) ? QuizWEB() : QuizMobile(),
        AppResponsive.isDesktop(context) ? QuestionsWEB() : QuestionsMobile(),
      ],
    );
  }
}
