class LoginResponse {
  LoginResponse({this.token, this.user});

  String? token;
  User? user;

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      LoginResponse(token: json["token"], user: User.fromJson(json['user']));
}

class User {
  User(
      {this.role,
      this.id,
      this.createdAt,
      this.email,
      this.gender,
      this.name,
      this.phoneNumber,
      this.suspend,
      this.image,
      this.updatedAt});

  String? role,
      id,
      name,
      email,
      image,
      phoneNumber,
      gender,
      createdAt,
      updatedAt;
  bool? suspend;

  factory User.fromJson(Map<String, dynamic> json) => User(
      role: json['role'],
      id: json['_id'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      phoneNumber: json['phoneNumber'],
      email: json['email'],
      name: json['name'],
      image: json['image'],
      suspend: json['suspend'],
      gender: json['gender']);
}

class StudentLoginResponse {
  StudentLoginResponse({this.token, this.user});

  String? token;
  StudentLogin? user;

  factory StudentLoginResponse.fromJson(Map<String, dynamic> json) =>
      StudentLoginResponse(
          token: json["token"], user: StudentLogin.fromJson(json['user']));
}

class StudentLogin {
  StudentLogin(
      {this.role,
      this.id,
      this.createdAt,
      this.email,
      this.gender,
      this.name,
      this.phoneNumber,
      this.suspend,
      this.image,
      this.updatedAt});

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

  factory StudentLogin.fromJson(Map<String, dynamic> json) => StudentLogin(
      role: json['role'],
      id: json['_id'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      phoneNumber: json['phoneNumber'],
      email: json['email'],
      name: json['name'],
      image: json['image'],
      suspend: json['suspend'],
      gender: json['gender']);
}
