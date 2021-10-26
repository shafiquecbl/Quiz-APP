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
      this.rollNo,
      this.updatedAt});

  String? role,
      id,
      name,
      email,
      image,
      phoneNumber,
      gender,
      createdAt,
      rollNo,
      updatedAt;
  bool? suspend;

  factory User.fromJson(Map<String, dynamic> json) => User(
      role: json['role'],
      id: json['_id'],
      rollNo: json['rollno'] == null ? null : json['rollno'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      phoneNumber: json['phoneNumber'],
      email: json['email'],
      name: json['name'],
      image: json['image'],
      suspend: json['suspend'],
      gender: json['gender']);

  Map<String, dynamic> toJson() => {
        "_id": id,
        "role": role,
        "rollno": rollNo,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "phoneNumber": phoneNumber,
        "email": email,
        "name": name,
        "image": image,
        "suspend": suspend,
        "gender": gender,
      };
}
