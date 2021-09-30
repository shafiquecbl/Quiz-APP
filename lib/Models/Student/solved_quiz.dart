class SolvedQuiz {
  SolvedQuiz({
    this.marks,
    this.questionAttempted,
    this.id,
    this.user,
    this.quizName,
    this.questionId,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  int? marks, questionAttempted;
  String? id, user, quizName, questionId;
  bool? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory SolvedQuiz.fromJson(Map<String, dynamic> json) => SolvedQuiz(
        marks: json["marks"],
        questionAttempted: json["questionAttempted"],
        id: json["_id"],
        user: json["user"],
        quizName: json["quizName"],
        questionId: json["questionId"],
        status: json["status"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "marks": marks,
        "questionAttempted": questionAttempted,
        "_id": id,
        "user": user,
        "quizName": quizName,
        "questionId": questionId,
        "status": status,
        "createdAt": createdAt!.toIso8601String(),
        "updatedAt": updatedAt!.toIso8601String(),
      };
}
