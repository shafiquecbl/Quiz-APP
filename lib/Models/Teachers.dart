class Teacher {
  Teacher({
    this.role,
    this.id,
    this.createdAt,
    this.email,
    this.gender,
    this.name,
    this.phoneNumber,
    this.suspend,
    this.updatedAt,
    this.deviceTokens,
    this.image,
  });

  String? role,
      id,
      name,
      email,
      phoneNumber,
      gender,
      createdAt,
      updatedAt,
      image;
  bool? suspend;
  List? deviceTokens;

  factory Teacher.fromJson(Map<String, dynamic> json) => Teacher(
      role: json['role'],
      id: json['_id'],
      image: json['image'],
      deviceTokens: json['deviceTokens'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      phoneNumber: json['phoneNumber'],
      email: json['email'],
      name: json['name'],
      suspend: json['suspend'],
      gender: json['gender']);
}

class AddTeacher {
  AddTeacher({
    this.name,
    this.email,
    this.password,
    this.gender,
    this.image,
    this.phoneNo,
  });
  String? name, email, phoneNo, password, gender;
  var image;

  Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
        "name": name,
        "phoneNumber": phoneNo,
        "gender": gender,
        "image": image,
      };
}

class UpdateTeacher {
  UpdateTeacher({
    this.name,
    this.email,
    this.password,
    this.gender,
    this.image,
    this.phoneNo,
  });
  String? name, email, phoneNo, password, gender;
  var image;

  Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
        "name": name,
        "phoneNumber": phoneNo,
        "gender": gender,
        "image": image,
      };
}
