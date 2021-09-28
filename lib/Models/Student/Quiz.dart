class Quiz1 {
  Quiz1({
    this.level,
    this.question,
    this.public,
    this.id,
    this.quizName,
    this.attemptDate,
    this.time,
    this.bound,
  });

  List<String>? level;
  List<Question1>? question;
  bool? public;
  String? id;
  String? quizName;
  String? attemptDate;
  int? time;
  String? bound;

  factory Quiz1.fromJson(Map<String, dynamic> json) => Quiz1(
        level: List<String>.from(json["level"].map((x) => x)),
        question: List<Question1>.from(
            json["question"].map((x) => Question1.fromJson(x))),
        public: json["public"],
        id: json["_id"],
        quizName: json["quizName"],
        attemptDate: json["attemptDate"],
        time: json["time"],
        bound: json["bound"],
      );

  Map<String, dynamic> toJson() => {
        "level": List<String>.from(level!.map((x) => x)),
        "question": List<Question1>.from(question!.map((x) => x.toJson())),
        "public": public,
        "_id": id,
        "quizName": quizName,
        "attemptDate": attemptDate,
        "time": time,
        "bound": bound,
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

class Question1 {
  Question1({
    this.options,
    this.questionImage,
    this.flag,
    this.id,
    this.questionStatement,
    this.type,
    this.answer,
    this.level,
  });

  List<Option1>? options;
  List<String>? questionImage;
  bool? flag;
  String? id;
  String? questionStatement;
  String? type;
  String? answer;
  String? level;

  factory Question1.fromJson(Map<String, dynamic> json) => Question1(
        options:
            List<Option1>.from(json["options"].map((x) => Option1.fromJson(x))),
        questionImage: List<String>.from(json["questionImage"].map((x) => x)),
        flag: json["flag"],
        id: json["_id"],
        questionStatement: json["questionStatement"],
        type: json["type"],
        answer: json["answer"],
        level: json["level"],
      );

  Map<String, dynamic> toJson() => {
        "options": List<Option1>.from(options!.map((x) => x.toJson())),
        "questionImage": List<String>.from(questionImage!.map((x) => x)),
        "flag": flag,
        "_id": id,
        "questionStatement": questionStatement,
        "type": type,
        "answer": answer,
        "level": level,
      };
}

class Option1 {
  Option1({
    this.options1,
    this.options2,
    this.options3,
    this.options4,
  });

  String? options1;
  String? options2;
  String? options3;
  String? options4;

  factory Option1.fromJson(Map<String, dynamic> json) => Option1(
        options1: json["options1"],
        options2: json["options2"],
        options3: json["options3"],
        options4: json["options4"],
      );

  Map<String, dynamic> toJson() => {
        "options1": options1,
        "options2": options2,
        "options3": options3,
        "options4": options4,
      };
}
