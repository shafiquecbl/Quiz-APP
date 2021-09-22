class StudentCourse {
  StudentCourse({
    this.student,
    this.id,
    this.course,
  });

  List<Student1>? student;
  String? id;
  Course1? course;

  factory StudentCourse.fromJson(Map<String, dynamic> json) => StudentCourse(
        student: List<Student1>.from(
            json["student"].map((x) => Student1.fromJson(x))),
        id: json["_id"],
        course: Course1.fromJson(json["course"]),
      );

  Map<String, dynamic> toJson() => {
        "student": List<dynamic>.from(student!.map((x) => x.toJson())),
        "_id": id,
        "course": course!.toJson(),
      };
}

class Course1 {
  Course1({
    this.id,
    this.name,
  });

  String? id;
  String? name;

  factory Course1.fromJson(Map<String, dynamic> json) => Course1(
        id: json["_id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
      };
}

class Student1 {
  Student1({
    this.role,
    this.suspend,
    this.deviceTokens,
    this.id,
    this.name,
    this.email,
    this.rollno,
    this.phoneNumber,
    this.gender,
    this.image,
  });

  String? role;
  bool? suspend;
  List<dynamic>? deviceTokens;
  String? id;
  String? name;
  String? email;
  String? rollno;
  String? phoneNumber;
  String? gender;
  String? image;

  factory Student1.fromJson(Map<String, dynamic> json) => Student1(
        role: json["role"],
        suspend: json["suspend"],
        deviceTokens: List<dynamic>.from(json["deviceTokens"].map((x) => x)),
        id: json["_id"],
        name: json["name"],
        email: json["email"],
        rollno: json["rollno"],
        phoneNumber: json["phoneNumber"],
        gender: json["gender"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "role": role,
        "suspend": suspend,
        "deviceTokens": List<dynamic>.from(deviceTokens!.map((x) => x)),
        "_id": id,
        "name": name,
        "email": email,
        "rollno": rollno,
        "phoneNumber": phoneNumber,
        "gender": gender,
        "image": image,
      };
}
