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
      this.updatedAt});

  String? role, id, name, email, phoneNumber, gender, createdAt, updatedAt;
  bool? suspend;

  factory User.fromJson(Map<String, dynamic> json) => User(
      role: json['role'],
      id: json['id'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      phoneNumber: json['phoneNumber'],
      email: json['email'],
      name: json['name'],
      suspend: json['suspend'],
      gender: json['gender']);
}
