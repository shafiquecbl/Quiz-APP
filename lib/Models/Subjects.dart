import 'package:quiz_app/Models/Courses.dart';

class Subject {
  Subject({this.id, this.course, this.subjectName});

  String? id, subjectName;
  Course? course;

  factory Subject.fromJson(Map<String, dynamic> json) => Subject(
        id: json['_id'],
        course: Course.fromJson(json['course'][0]),
        subjectName: json['subjectName'],
      );
}

class AddSubject {
  AddSubject({this.courseId, this.subjectName});
  String? subjectName, courseId;

  Map<String, dynamic> toJson() => {
        "course": courseId,
        "subjectName": subjectName,
      };
}

class NewSubject {
  NewSubject({
    this.course,
    this.id,
    this.subjectName,
  });

  List<String>? course;
  String? id;
  String? subjectName;

  factory NewSubject.fromJson(Map<String, dynamic> json) => NewSubject(
        course: List<String>.from(json["course"].map((x) => x)),
        id: json["_id"],
        subjectName: json["subjectName"],
      );
}
