import 'package:quiz_app/Models/User.dart';

class SuspendedUser {
  SuspendedUser({
    this.user,
  });

  User? user;

  factory SuspendedUser.fromJson(Map<String, dynamic> json) =>
      SuspendedUser(user: json['user']);
}

class AddSuspendedUser {
  AddSuspendedUser({
    this.user,
  });
  User? user;

  Map<String, dynamic> toJson() => {
        "user": user,
      };
}
