import 'Courses.dart';
import 'Quiz.dart';
import 'Subjects.dart';

class Questions {
  Questions(
      {this.options,
      this.subject,
      this.id,
      this.questionStatement,
      this.type,
      this.answer,
      this.course,
      this.level,
      this.questionImage});

  String? id, questionStatement, type, answer, level;
  Subject? subject;
  Course? course;
  List<String>? questionImage;
  List<QuestionOptions>? options;

  factory Questions.fromJson(Map<String, dynamic> json) => Questions(
      id: json['_id'],
      subject: Subject.fromJson(json['subject'][0]),
      // questionImage: List<String>.from(json['questionImage'].map((x) => x)),
      questionStatement: json['questionStatement'],
      type: json['type'],
      answer: json['answer'],
      course: Course.fromJson(json['course']),
      level: json['level'],
      options:
          List.from(json['options'].map((x) => QuestionOptions.fromJson(x))));
}

class AddQuestion {
  AddQuestion(
      {this.questionStatement,
      this.type,
      this.answer,
      this.subjectId,
      this.courseId,
      this.questionImage,
      this.options,
      this.level});
  String? questionStatement, type, answer, level, courseId;
  List? subjectId;
  List? questionImage;
  AddQustionOption? options;

  Map<String, dynamic> toJson() => {
        "subject": subjectId,
        "questionImage": questionImage,
        "questionStatement": questionStatement,
        "type": type,
        "answer": answer,
        "course": courseId,
        "level": level,
        "options": options!.toJson(),
      };
}
