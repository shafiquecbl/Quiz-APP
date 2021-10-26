import 'package:flutter/widgets.dart';
import 'package:quiz_app/Models/Student/solved_quiz.dart';
import 'package:quiz_app/Models/Student/student_courses.dart';
import 'package:quiz_app/Models/Student/student_solved_quiz.dart';
import 'package:quiz_app/Models/Student/student_subjects.dart';
import 'package:quiz_app/Models/User.dart';

class CustomProvier extends ChangeNotifier {
  StudentCourse? course;
  StudentSubject? subject;
  int? remainingTime;
  int? getRemainingTime() => remainingTime;

  LoginResponse? loginResponse;

  SolvedQuiz? solvedQuiz;
  StudentQuiz? studentQuiz;
  String? studentId;

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

  saveSolvedQuiz({@required SolvedQuiz? quiz}) {
    solvedQuiz = quiz;
    notifyListeners();
  }

  saveStudentQuiz({@required StudentQuiz? quiz}) {
    studentQuiz = quiz;
    notifyListeners();
  }

  saveStudentId({@required String? id}) {
    studentId = id;
    notifyListeners();
  }

  saveLoginResponse({@required LoginResponse? response}) {
    loginResponse = response;
    notifyListeners();
  }
}
