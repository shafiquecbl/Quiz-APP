import 'package:quiz_app/Models/Courses.dart';
import 'package:quiz_app/Models/Subjects.dart';

class Questions {
  Questions({
    this.id,
    this.statement,
    this.subject,
    this.course,
    this.level,
    this.type,
  });

  String? id, statement, level, type;
  Subject? subject;
  Course? course;

  factory Questions.fromJson(Map<String, dynamic> json) => Questions(
      id: json['_id'],
      statement: json['statement'],
      level: json['level'],
      type: json['type'],
      subject: json['subject'],
      course: json['course']);
}

class AddQuestion {
  AddQuestion(
      {this.statement, this.level, this.course, this.subject, this.type});

  String? statement, level, type;

  Subject? subject;
  Course? course;

  Map<String, dynamic> toJson() => {
        "statement": statement,
        "level": level,
        "subject": subject,
        "course": course,
        "type": type
      };
}
