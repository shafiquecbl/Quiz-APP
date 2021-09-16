import 'package:quiz_app/Models/Courses.dart';
import 'package:quiz_app/Models/Subjects.dart';

class Quiz {
  Quiz({
    this.id,
    this.attempDate,
    this.subject,
    this.course,
    this.name,
  });

  String? id, name, attempDate;
  Subject? subject;
  Course? course;

  factory Quiz.fromJson(Map<String, dynamic> json) => Quiz(
        id: json['_id'],
        name: json['name'],
        attempDate: json['attempDate'],
        subject: json['subject'],
        course: json['course'],
      );
}

class AddQuiz {
  AddQuiz({this.name, this.attempDate, this.course, this.subject});

  String? name, attempDate;
  Subject? subject;
  Course? course;

  Map<String, dynamic> toJson() => {
        "name": name,
        "attempDate": attempDate,
        "subject": subject,
        "course": course
      };
}
