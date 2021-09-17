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
  AddSubject({this.course, this.subjectName});
  String? subjectName;
  Course? course;

  Map<String, dynamic> toJson() => {
        "course": course,
        "subjectName": subjectName,
      };
}
