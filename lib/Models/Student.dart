class Student {
  Student(
      {this.role,
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
      this.rollNo});

  String? role,
      id,
      name,
      email,
      phoneNumber,
      gender,
      createdAt,
      updatedAt,
      image,
      rollNo;
  bool? suspend;
  List? deviceTokens;

  factory Student.fromJson(Map<String, dynamic> json) => Student(
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
      rollNo: json['rollno'],
      gender: json['gender']);
}

class AddStudent {
  AddStudent(
      {this.name,
      this.email,
      this.password,
      this.gender,
      this.image,
      this.phoneNo,
      this.rollNo});
  String? name, email, phoneNo, password, rollNo, gender;
  var image;

  Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
        "name": name,
        "phoneNumber": phoneNo,
        "rollno": rollNo,
        "gender": gender,
        "image": image,
      };
}

class UpdateStudent {
  UpdateStudent(
      {this.name,
      this.email,
      this.password,
      this.gender,
      this.image,
      this.phoneNo,
      this.rollNo});
  String? name, email, phoneNo, password, rollNo, gender;
  var image;

  Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
        "name": name,
        "phoneNumber": phoneNo,
        "rollno": rollNo,
        "gender": gender,
        "image": image,
      };
}
