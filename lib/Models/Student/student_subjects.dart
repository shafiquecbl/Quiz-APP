import 'package:quiz_app/Models/Student/student_courses.dart';

class StudentSubject {
  StudentSubject({
    this.course,
    this.id,
    this.subjectName,
  });

  List<Course1>? course;
  String? id;
  String? subjectName;

  factory StudentSubject.fromJson(Map<String, dynamic> json) => StudentSubject(
        course:
            List<Course1>.from(json["course"].map((x) => Course1.fromJson(x))),
        id: json["_id"],
        subjectName: json["subjectName"],
      );

  Map<String, dynamic> toJson() => {
        "course": List<dynamic>.from(course!.map((x) => x.toJson())),
        "_id": id,
        "subjectName": subjectName,
      };
}
