class Subject {
  Subject({this.id, this.courseName, this.subjectName});

  String? id, courseName, subjectName;

  factory Subject.fromJson(Map<String, dynamic> json) => Subject(
        id: json['_id'],
        courseName: json['course'][0]['name'],
        subjectName: json['subjectName'],
      );
}

class AddSubject {
  AddSubject({this.courseName, this.subjectName});
  String? courseName, subjectName;

  Map<String, dynamic> toJson() => {
        "course": courseName,
        "subjectName": subjectName,
      };
}
