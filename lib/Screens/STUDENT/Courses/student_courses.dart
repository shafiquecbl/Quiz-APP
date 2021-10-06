import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/Models/Student/student_courses.dart';
import 'package:quiz_app/Models/User.dart';
import 'package:quiz_app/Provider/provider.dart';
import 'package:quiz_app/Screens/widget/custom_card.dart';
import 'package:quiz_app/Services/api_manager.dart';
import 'package:quiz_app/WIdgets/loading.dart';
import 'package:quiz_app/WIdgets/network_error.dart';
import 'package:quiz_app/common/app_responsive.dart';
import 'package:quiz_app/controllers/page_controller.dart';

class StudentCoursesWEB extends StatefulWidget {
  final LoginResponse? loginResponse;
  StudentCoursesWEB({@required this.loginResponse});

  @override
  _StudentCoursesWEBState createState() => _StudentCoursesWEBState();
}

class _StudentCoursesWEBState extends State<StudentCoursesWEB> {
  MyPageController pageController = MyPageController();
  Future<List<StudentCourse>>? courseModel;

  @override
  void initState() {
    getStudentCourse();
    super.initState();
  }

  getStudentCourse() {
    courseModel = APIManager().getStudentCourses(
        token: widget.loginResponse!.token, id: widget.loginResponse!.user!.id);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CustomProvier>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text('COURSES',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600)),
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
            child: FutureBuilder<List<StudentCourse>>(
              future: courseModel,
              builder: (BuildContext context,
                  AsyncSnapshot<List<StudentCourse>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return MyLoading();
                if (snapshot.data == null)
                  return NetworkError(onPressed: () {
                    updatePage();
                  });
                if (snapshot.data!.length == 0)
                  return Center(
                    child: Text('No Courses yet!'),
                  );

                return GridView.count(
                    crossAxisCount: AppResponsive.isMobile(context) ? 2 : 5,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 25,
                    childAspectRatio: 1.4,
                    children: List.generate(snapshot.data!.length, (index) {
                      StudentCourse course = snapshot.data![index];

                      return CustomCard(
                          onPressed: () {
                            provider.saveStudentCourse(studentCourse: course);
                            pageController.changePage(1);
                          },
                          courseName: course.course!.name);
                    }));
              },
            ),
          ),
        );
      },
    );
  }

  updatePage() {
    setState(() {
      courseModel = APIManager().getStudentCourses(
          token: widget.loginResponse!.token,
          id: widget.loginResponse!.user!.id);
    });
  }
}
