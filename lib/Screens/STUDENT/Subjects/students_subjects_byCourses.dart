import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/Models/Student/student_courses.dart';
import 'package:quiz_app/Models/Student/student_subjects.dart';
import 'package:quiz_app/Models/User.dart';
import 'package:quiz_app/Provider/provider.dart';
import 'package:quiz_app/Screens/widget/custom_card.dart';
import 'package:quiz_app/Services/api_manager.dart';
import 'package:quiz_app/WIdgets/loading.dart';
import 'package:quiz_app/WIdgets/network_error.dart';
import 'package:quiz_app/common/app_responsive.dart';
import 'package:quiz_app/controllers/page_controller.dart';

class StudentSubjectsWEB extends StatefulWidget {
  final StudentLoginResponse? loginResponse;
  final StudentCourse? course;
  StudentSubjectsWEB({@required this.loginResponse, @required this.course});

  @override
  _StudentSubjectsWEBState createState() => _StudentSubjectsWEBState();
}

class _StudentSubjectsWEBState extends State<StudentSubjectsWEB> {
  MyPageController pageController = MyPageController();
  Future<List<StudentSubject>>? subjectModel;

  @override
  void initState() {
    getSubjects();
    super.initState();
  }

  getSubjects() {
    subjectModel = APIManager().getStudentSubjects(
        token: widget.loginResponse!.token, id: widget.course!.course!.id);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CustomProvier>(builder: (context, provider, child) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Subjects in ${widget.course!.course!.name}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600)),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
          child: FutureBuilder<List<StudentSubject>>(
            future: subjectModel,
            builder: (BuildContext context,
                AsyncSnapshot<List<StudentSubject>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting)
                return MyLoading();
              if (snapshot.data == null)
                return NetworkError(onPressed: () {
                  updatePage();
                });
              if (snapshot.data!.length == 0)
                return Center(
                  child: Text('No Subjects in this course!'),
                );

              return GridView.count(
                  crossAxisCount: AppResponsive.isMobile(context) ? 2 : 5,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 25,
                  childAspectRatio: 1.4,
                  children: List.generate(snapshot.data!.length, (index) {
                    StudentSubject subject = snapshot.data![index];
                    print(subject.id);
                    return CustomCard(
                        onPressed: () {
                          provider.saveStudentSubject(studentSubject: subject);
                          pageController.changePage(2);
                        },
                        courseName: subject.subjectName);
                  }));
            },
          ),
        ),
      );
    });
  }

  updatePage() {
    setState(() {
      subjectModel = APIManager().getStudentSubjects(
          token: widget.loginResponse!.token, id: widget.course!.course!.id);
    });
  }
}
