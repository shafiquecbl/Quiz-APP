class SubAdmin {
  SubAdmin({
    this.role,
    this.id,
    this.email,
    this.gender,
    this.name,
    this.phoneNumber,
    this.suspend,
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

  factory SubAdmin.fromJson(Map<String, dynamic> json) => SubAdmin(
      role: json['role'],
      id: json['_id'],
      image: json['image'],
      deviceTokens: json['deviceTokens'],
      phoneNumber: json['phoneNumber'],
      email: json['email'],
      name: json['name'],
      suspend: json['suspend'],
      gender: json['gender']);
}

class AddSubAdmin {
  AddSubAdmin({
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

class UpdateSubAdmin {
  UpdateSubAdmin({
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
