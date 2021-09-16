import 'package:quiz_app/Models/Courses.dart';
import 'package:quiz_app/Models/Subjects.dart';
import 'package:quiz_app/Models/Teachers.dart';

class TeacherSubject {
  TeacherSubject({this.id, this.course, this.teacher, this.subject});

  String? id, name;
  Course? course;
  Teacher? teacher;
  Subject? subject;

  factory TeacherSubject.fromJson(Map<String, dynamic> json) => TeacherSubject(
        id: json['_id'],
        teacher: json['teacher'],
        course: json['course'][0],
        subject: json['subject'][0],
      );
}

class AddTeacherSubject {
  AddTeacherSubject({this.name, this.courseId, this.subjectId});
  String? courseId, subjectId, name;

  Map<String, dynamic> toJson() => {
        "subjects": subjectId,
        "course": courseId,
        "teacher": name,
      };
}
