import 'package:flutter/widgets.dart';
import 'package:quiz_app/Models/Student/student_courses.dart';
import 'package:quiz_app/Models/Student/student_subjects.dart';

class CustomProvier extends ChangeNotifier {
  StudentCourse? course;
  StudentSubject? subject;
  int? remainingTime;
  int? getRemainingTime() => remainingTime;

  saveStudentCourse({@required StudentCourse? studentCourse}) {
    course = studentCourse;
    notifyListeners();
  }

  saveStudentSubject({@required StudentSubject? studentSubject}) {
    subject = studentSubject;
    notifyListeners();
  }

  updateRemainingTime() {
    if (remainingTime! > 0) {
      remainingTime = remainingTime! - 1;
    }
    notifyListeners();
  }
}
