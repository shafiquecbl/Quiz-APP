import 'package:quiz_app/Models/User.dart';

import 'Courses.dart';
import 'Quiz.dart';
import 'Subjects.dart';

class Questions {
  Questions(
      {this.name,
      this.attempDate,
      this.options,
      this.subject,
      this.id,
      this.flag,
      this.questionStatement,
      this.type,
      this.answer,
      this.course,
      this.level,
      this.user,
      this.questionImage});

  String? id, name, attempDate, questionStatement, type, answer, level;
  Subject? subject;
  Course? course;
  User? user;
  List? questionImage;
  bool? flag;
  QuestionOptions? options;

  factory Questions.fromJson(Map<String, dynamic> json) => Questions(
      id: json['_id'],
      name: json['name'],
      attempDate: json['attempDate'],
      subject: Subject.fromJson(json['subject'][0]),
      questionImage: List.from(json['questionImage'].map((x) => x)),
      flag: json['flag'],
      questionStatement: json['questionStatement'],
      type: json['type'],
      answer: json['answer'],
      course: Course.fromJson(json['course']),
      level: json['level'],
      user: User.fromJson(json['user']),
      options: QuestionOptions.fromJson(json['options'][0]));
}
