class Course {
  Course({
    this.id,
    this.createdAt,
    this.name,
    this.updatedAt,
    this.assignToTeacher,
  });

  String? id, name, createdAt, updatedAt;
  bool? assignToTeacher;

  factory Course.fromJson(Map<String, dynamic> json) => Course(
        id: json['_id'],
        createdAt: json['createdAt'],
        updatedAt: json['updatedAt'],
        assignToTeacher: json['assignToTeacher'],
        name: json['name'],
      );
}

class AddCourse {
  AddCourse({
    this.name,
  });

  String? name;

  Map<String, dynamic> toJson() => {
        "name": name,
      };
}
