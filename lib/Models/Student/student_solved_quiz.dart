import 'package:quiz_app/Models/Student/Quiz.dart';
import 'package:quiz_app/Models/Student/solved_quiz.dart';
import 'package:quiz_app/Models/User.dart';

class StudentQuiz {
  StudentQuiz({
    this.solvedQuiz,
    this.quiz,
  });

  SolvedQuiz? solvedQuiz;
  Quizz? quiz;

  factory StudentQuiz.fromJson(Map<String, dynamic> json) => StudentQuiz(
        solvedQuiz: SolvedQuiz.fromJson(json["solvedQuiz"]),
        quiz: Quizz.fromJson(json["quiz"]),
      );

  Map<String, dynamic> toJson() => {
        "solvedQuiz": solvedQuiz!.toJson(),
        "quiz": quiz!.toJson(),
      };
}

class Quizz {
  Quizz({
    this.subject,
    this.level,
    this.question,
    this.public,
    this.id,
    this.quizName,
    this.attemptDate,
    this.course,
    this.time,
    this.bound,
    this.user,
    this.createdAt,
    this.updatedAt,
  });

  List<Subjectt>? subject;
  List<String>? level;
  List<Question1>? question;
  bool? public;
  String? id;
  String? quizName;
  DateTime? attemptDate;
  Coursee? course;
  int? time;
  String? bound;
  User? user;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Quizz.fromJson(Map<String, dynamic> json) => Quizz(
        subject: List<Subjectt>.from(
            json["subject"].map((x) => Subjectt.fromJson(x))),
        level: List<String>.from(json["level"].map((x) => x)),
        question: List<Question1>.from(
            json["question"].map((x) => Question1.fromJson(x))),
        public: json["public"],
        id: json["_id"],
        quizName: json["quizName"],
        attemptDate: DateTime.parse(json["attemptDate"]),
        course: Coursee.fromJson(json["course"]),
        time: json["time"],
        bound: json["bound"],
        user: User.fromJson(json["user"]),
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "subject": List<dynamic>.from(subject!.map((x) => x.toJson())),
        "level": List<dynamic>.from(level!.map((x) => x)),
        "question": List<dynamic>.from(question!.map((x) => x.toJson())),
        "public": public,
        "_id": id,
        "quizName": quizName,
        "attemptDate": attemptDate!.toIso8601String(),
        "course": course!.toJson(),
        "time": time,
        "bound": bound,
        "user": user!.toJson(),
        "createdAt": createdAt!.toIso8601String(),
        "updatedAt": updatedAt!.toIso8601String(),
      };
}

class Coursee {
  Coursee({
    this.assignToTeacher,
    this.id,
    this.name,
    this.createdAt,
    this.updatedAt,
  });

  bool? assignToTeacher;
  String? id;
  String? name;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Coursee.fromJson(Map<String, dynamic> json) => Coursee(
        assignToTeacher: json["assignToTeacher"],
        id: json["_id"],
        name: json["name"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "assignToTeacher": assignToTeacher,
        "_id": id,
        "name": name,
        "createdAt": createdAt!.toIso8601String(),
        "updatedAt": updatedAt!.toIso8601String(),
      };
}

class Subjectt {
  Subjectt({
    this.course,
    this.id,
    this.subjectName,
    this.createdAt,
    this.updatedAt,
  });

  List<Coursee>? course;
  String? id;
  String? subjectName;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Subjectt.fromJson(Map<String, dynamic> json) => Subjectt(
        course:
            List<Coursee>.from(json["course"].map((x) => Coursee.fromJson(x))),
        id: json["_id"],
        subjectName: json["subjectName"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "course": List<dynamic>.from(course!.map((x) => x.toJson())),
        "_id": id,
        "subjectName": subjectName,
        "createdAt": createdAt!.toIso8601String(),
        "updatedAt": updatedAt!.toIso8601String(),
      };
}
