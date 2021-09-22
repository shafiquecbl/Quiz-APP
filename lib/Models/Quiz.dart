import 'package:quiz_app/Models/Courses.dart';
import 'package:quiz_app/Models/Subjects.dart';

import 'User.dart';

class Quiz {
  Quiz(
      {this.id,
      this.attempDate,
      this.subject,
      this.quizName,
      this.level,
      this.public,
      this.course,
      this.time,
      this.bound,
      this.user,
      this.question});

  String? id, quizName, attempDate, level, bound;
  int? time;
  Subject? subject;
  bool? public;
  List<Question>? question;
  Course? course;
  User? user;

  factory Quiz.fromJson(Map<String, dynamic> json) => Quiz(
      id: json['_id'],
      quizName: json['quizName'],
      attempDate: json['attemptDate'],
      subject: Subject.fromJson(json['subject'][0]),
      level: json['level'][0],
      public: json['public'],
      course: Course.fromJson(json['course']),
      time: json['time'],
      bound: json['bound'],
      user: User.fromJson(json['user']),
      question: List<Question>.from(
          json["question"].map((x) => Question.fromJson(x))));
}

class AddQuiz {
  AddQuiz(
      {this.quizName,
      this.attemptDate,
      this.courseId,
      this.subjectId,
      this.questions,
      this.public,
      this.time,
      this.timeType,
      this.level});

  String? quizName, attemptDate, level, courseId, timeType;
  bool? public;
  List? subjectId;
  int? time;
  List? questions;

  Map<String, dynamic> toJson() => {
        "quizName": quizName,
        "attemptDate": attemptDate,
        "subject": subjectId,
        "course": courseId,
        "level": level,
        "question": questions,
        "time": time,
        "bound": timeType,
        "public": public
      };
}

class Question {
  Question(
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

  String? id,
      name,
      attempDate,
      subject,
      questionStatement,
      type,
      answer,
      course,
      level,
      user;
  List<String>? questionImage;
  bool? flag;
  QuestionOptions? options;

  factory Question.fromJson(Map<String, dynamic> json) => Question(
      id: json['_id'],
      name: json['name'],
      attempDate: json['attempDate'],
      subject: json['subject'][0],
      questionImage: List<String>.from(json['questionImage'].map((x) => x)),
      flag: json['flag'],
      questionStatement: json['questionStatement'],
      type: json['type'],
      answer: json['answer'],
      course: json['course'],
      level: json['level'],
      user: json['user'],
      options: QuestionOptions.fromJson(json['options'][0]));
}

class QuestionOptions {
  QuestionOptions({this.option1, this.option2, this.option3, this.option4});

  String? option1, option2, option3, option4;

  factory QuestionOptions.fromJson(Map<String, dynamic> json) =>
      QuestionOptions(
        option1: json['options1'],
        option2: json['options2'],
        option3: json['options3'],
        option4: json['options4'],
      );
}

class AddQustionOption {
  AddQustionOption({this.option1, this.option2, this.option3, this.option4});

  String? option1, option2, option3, option4;

  Map<String, dynamic> toJson() => {
        "options1": option1,
        "options2": option2,
        "options3": option3,
        "options4": option4,
      };
}
