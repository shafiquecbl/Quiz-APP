import 'package:flutter/material.dart';
import 'package:quiz_app/Models/User.dart';
import 'package:quiz_app/Screens/ADMIN/Mobile/Course/Courses/Courses_Mobile.dart';
import 'package:quiz_app/Screens/ADMIN/Mobile/Course/Enroll%20Students/enroll_students_Mobile.dart';
import 'package:quiz_app/Screens/ADMIN/Mobile/Course/Subjects/Subjects_Mobile.dart';
import 'package:quiz_app/Screens/ADMIN/Mobile/Course/Teacher%20Subjects/Teacher_Subjects_Mobile.dart';
import 'package:quiz_app/Screens/ADMIN/Mobile/Quiz/Questions/Questions_Mobile.dart';
import 'package:quiz_app/Screens/ADMIN/Mobile/Quiz/Quizs/quiz_Mobile.dart';
import 'package:quiz_app/Screens/ADMIN/Mobile/Users/Students/Students_Mobile.dart';
import 'package:quiz_app/Screens/ADMIN/Mobile/Users/Sub%20Admin/Sub_Admin_Mobile.dart';
import 'package:quiz_app/Screens/ADMIN/Mobile/Users/Suspended/Suspended_Mobile.dart';
import 'package:quiz_app/Screens/ADMIN/Mobile/Users/Teachers/teachers_mobile.dart';
import 'package:quiz_app/Screens/ADMIN/Web/Course/Courses/Courses_Web.dart';
import 'package:quiz_app/Screens/ADMIN/Web/Course/Enroll%20Students/Enroll_Students_Web.dart';
import 'package:quiz_app/Screens/ADMIN/Web/Course/Subjects/Subjects_Web.dart';
import 'package:quiz_app/Screens/ADMIN/Web/Course/Teacher%20Subjects/Teacher_Subjects_Web.dart';
import 'package:quiz_app/Screens/ADMIN/Web/Quiz/Questions/Questions_Web.dart';
import 'package:quiz_app/Screens/ADMIN/Web/Quiz/Quizs/Quiz_Web.dart';
import 'package:quiz_app/Screens/ADMIN/Web/Users/Students/Students_Web.dart';
import 'package:quiz_app/Screens/ADMIN/Web/Users/Sub%20Admin/Sub_Admin_Web.dart';
import 'package:quiz_app/Screens/ADMIN/Web/Users/Suspended/Suspended_Web.dart';
import 'package:quiz_app/Screens/ADMIN/Web/Users/Teachers/Teachers_Web.dart';
import 'package:quiz_app/common/app_responsive.dart';
import 'package:quiz_app/controllers/page_controller.dart';

import '../dashboard_home.dart';

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
        AppResponsive.isDesktop(context)
            ? TeachersWEB(loginResponse: widget.loginResponse)
            : TeachersMobile(),
        AppResponsive.isDesktop(context)
            ? SuspendedWEB(loginResponse: widget.loginResponse)
            : SuspendedMobile(),
        AppResponsive.isDesktop(context)
            ? SubAdminWEB(loginResponse: widget.loginResponse)
            : SubAdminMobile(),
        AppResponsive.isDesktop(context)
            ? CoursesWEB(
                loginResponse: widget.loginResponse,
              )
            : CoursesMobile(),
        AppResponsive.isDesktop(context)
            ? SubjectsWEB(
                loginResponse: widget.loginResponse,
              )
            : SubjectsMobile(),
        AppResponsive.isDesktop(context)
            ? TeacherSubjectsWEB(loginResponse: widget.loginResponse)
            : TeacherSubjectsMobile(),
        AppResponsive.isDesktop(context)
            ? EnrollStudentsWEB(
                loginResponse: widget.loginResponse,
              )
            : EnrollStudentsMobile(),
        AppResponsive.isDesktop(context)
            ? QuizWEB(loginResponse: widget.loginResponse)
            : QuizMobile(),
        AppResponsive.isDesktop(context)
            ? QuestionsWEB(loginResponse: widget.loginResponse)
            : QuestionsMobile(),
      ],
    );
  }
}
