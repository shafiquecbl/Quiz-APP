class Login {
  Login({
    this.email,
    this.password,
  });
  String? email;
  String? password;

  Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
      };
}

class StudentLogin {
  StudentLogin({
    this.rollNo,
    this.password,
  });
  String? rollNo;
  String? password;

  Map<String, dynamic> toJson() => {
        "rollno": rollNo,
        "password": password,
      };
}
