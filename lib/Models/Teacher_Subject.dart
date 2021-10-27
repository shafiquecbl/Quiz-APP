import 'package:quiz_app/Models/Courses.dart';
import 'package:quiz_app/Models/Subjects.dart';
import 'package:quiz_app/Models/Teachers.dart';

class TeacherSubject {
  TeacherSubject({this.id, this.course, this.teacher, this.subject});

  String? id, name;
  List<Course>? course;
  Teacher? teacher;
  List<Subject>? subject;

  factory TeacherSubject.fromJson(Map<String, dynamic> json) => TeacherSubject(
        id: json['_id'],
        teacher: Teacher.fromJson(json['teacher']),
        course:
            List<Course>.from(json["course"].map((x) => Course.fromJson(x))),
        subject:
            List<Subject>.from(json["subject"].map((x) => Subject.fromJson(x))),
      );
}

class AddTeacherSubject {
  AddTeacherSubject({this.teacherId, this.courseId, this.subjectId});
  String? courseId, teacherId;
  List<String>? subjectId;

  Map<String, dynamic> toJson() => {
        "subjects": subjectId,
        "course": courseId,
        "teacher": teacherId,
      };
}
