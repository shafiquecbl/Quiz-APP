import 'package:flutter/material.dart';
import 'package:quiz_app/Models/Student/student_courses.dart';
import 'package:quiz_app/Models/User.dart';
import 'package:quiz_app/Screens/widget/custom_card.dart';
import 'package:quiz_app/Services/api_manager.dart';
import 'package:quiz_app/WIdgets/loading.dart';
import 'package:quiz_app/common/app_responsive.dart';

class StudentCoursesWEB extends StatefulWidget {
  final StudentLoginResponse? loginResponse;
  StudentCoursesWEB({@required this.loginResponse});

  @override
  _StudentCoursesWEBState createState() => _StudentCoursesWEBState();
}

class _StudentCoursesWEBState extends State<StudentCoursesWEB> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('COURSES',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600)),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
        child: FutureBuilder<List<StudentCourse>>(
          future: APIManager().getStudentCourses(
              token: widget.loginResponse!.token,
              id: widget.loginResponse!.user!.id),
          builder: (BuildContext context,
              AsyncSnapshot<List<StudentCourse>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return MyLoading();
            print(snapshot.data);
            return GridView.count(
                crossAxisCount: AppResponsive.isMobile(context) ? 2 : 5,
                mainAxisSpacing: 20,
                crossAxisSpacing: 25,
                childAspectRatio: 1.4,
                children: List.generate(2, (index) {
                  StudentCourse course = snapshot.data![index];
                  print(snapshot.data![index].id);
                  return CustomCard(
                      onPressed: () {}, courseName: course.course!.name);
                }));
          },
        ),
      ),
    );
  }
}
