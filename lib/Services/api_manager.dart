import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:quiz_app/Models/Admin_Login.dart';
import 'package:quiz_app/Models/Courses.dart';
import 'package:quiz_app/Models/Enroll_Student.dart';
import 'package:quiz_app/Models/Questions.dart';
import 'package:quiz_app/Models/Quiz.dart';
import 'package:quiz_app/Models/Student.dart';
import 'package:quiz_app/Models/Student/Quiz.dart';
import 'package:quiz_app/Models/Student/solved_quiz.dart';
import 'package:quiz_app/Models/Student/student_courses.dart';
import 'package:quiz_app/Models/Student/student_subjects.dart';
import 'package:quiz_app/Models/Student/submit_quiz.dart';
import 'package:quiz_app/Models/SubAdmin.dart';
import 'package:quiz_app/Models/Subjects.dart';
import 'package:quiz_app/Models/Teacher_Subject.dart';
import 'package:quiz_app/Models/Teachers.dart';
import 'package:quiz_app/Models/User.dart';
import 'package:quiz_app/Screens/STUDENT/Home/student_home.dart';
import 'package:quiz_app/Screens/STUDENT/Score%20Board/quiz_details.dart';
import 'package:quiz_app/Screens/widget/Navigator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class APIManager {
  var client = http.Client();
  var loginResponse;
  String baseUrl = 'http://192.168.100.84:4000';
  Dio dio = Dio();

  ///////////////////////////////////////////////////////////

  adminLogin(email, password) async {
    return await client
        .post(Uri.parse('$baseUrl/admin/auth/login'),
            body: Login(email: email, password: password).toJson())
        .then((response) async {
      var jsonMap = json.decode(response.body);
      print(jsonMap);
      loginResponse = LoginResponse.fromJson(jsonMap);
      SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.setString('LoginResponse', jsonEncode(jsonMap));
      return loginResponse;
    });
  }

  Future<List<Student>> fetchStudentsList({@required token}) async {
    return await client.get(Uri.parse('$baseUrl/admin/manage/getAllStudents'),
        headers: {
          'Authorization': 'Bearer $token',
          "Content-Type": "application/json"
        }).then((response) async {
      List<Student> jsonMap = (json.decode(response.body) as List)
          .map((e) => Student.fromJson(e))
          .toList();
      return jsonMap;
    });
  }

  ///////////////// ADD NEW STUDENT ///////////////

  addStudent(
      {@required token,
      @required name,
      @required email,
      @required password,
      @required rollNo,
      @required phoneNo,
      @required PlatformFile? image,
      @required gender}) async {
    http.MultipartRequest request = http.MultipartRequest(
      "POST",
      Uri.parse('$baseUrl/admin/manage/createStudent'),
    );
    request.headers['Authorization'] = 'Bearer $token';

    request.fields['name'] = name;
    request.fields['email'] = email;
    request.fields['password'] = password;
    request.fields['gender'] = gender;
    request.fields['rollno'] = rollNo;
    request.fields['phoneNumber'] = phoneNo;
    request.files.add(new http.MultipartFile(
        'image', image!.readStream!, image.size,
        filename: image.name));

    //-------Send request
    await request.send().then((value) async {
      //------Read response
      String result = await value.stream.bytesToString();

      //-------Your response
      print(result);
    });
  }

  ////////////// UPDATE STUDENT //////////////////

  updateStudent(
      {@required id,
      @required token,
      @required name,
      @required email,
      @required password,
      @required rollNo,
      @required phoneNo,
      @required PlatformFile? image,
      @required gender}) async {
    http.MultipartRequest request = http.MultipartRequest(
      "PUT",
      Uri.parse('$baseUrl/admin/manage/updateStudent/$id'),
    );
    request.headers['Authorization'] = 'Bearer $token';

    request.fields['name'] = name;
    request.fields['email'] = email;
    if (password != null) {
      request.fields['password'] = password;
    }
    request.fields['gender'] = gender;
    request.fields['rollno'] = rollNo;
    request.fields['phoneNumber'] = phoneNo;
    if (image != null) {
      request.files.add(new http.MultipartFile(
          'image', image.readStream!, image.size,
          filename: image.name));
    }

    //-------Send request
    var resp = await request.send();
    //------Read response
    String result = await resp.stream.bytesToString();

    //-------Your response
    print(result);

    return result;
  }

  deleteStudent({@required token, @required id}) async {
    return await dio.delete('$baseUrl/admin/manage/deleteStudent/$id',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }));
  }

  ///////////////////////////////////////////////////////
  /////////////////////// COURSES ///////////////////////
  ///////////////////////////////////////////////////////

  Future<List<Course>> getCoursesList({@required token}) async {
    return await client.get(Uri.parse('$baseUrl/admin/course/getAllCourses'),
        headers: {
          'Authorization': 'Bearer $token',
          "Content-Type": "application/json"
        }).then((response) async {
      List<Course> jsonMap = (json.decode(response.body) as List)
          .map((e) => Course.fromJson(e))
          .toList();
      return jsonMap;
    });
  }

  ///////////////// ADD NEW COURSE ///////////////

  addCourse({
    @required token,
    @required courseName,
  }) async {
    return await dio.post('$baseUrl/admin/course/addCourse',
        data: AddCourse(
          name: courseName,
        ).toJson(),
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }));
  }

  ///////////////// UPDATE COURSE ///////////////

  updateCourse({
    @required courseId,
    @required token,
    @required courseName,
  }) async {
    return await dio.put('$baseUrl/admin/course/updateCourse/$courseId',
        data: AddCourse(
          name: courseName,
        ).toJson(),
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }));
  }

  deleteCourse({@required token, @required id}) async {
    return await dio.delete('$baseUrl/admin/course/deleteCourse/$id',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }));
  }

  ///////////////////////////////////////////////////////
  /////////////////////// TEACHERS //////////////////////
  ///////////////////////////////////////////////////////

  Future<List<Teacher>> fetchTeachersList({@required token}) async {
    return await client.get(Uri.parse('$baseUrl/admin/manage/getAllTeachers'),
        headers: {
          'Authorization': 'Bearer $token',
          "Content-Type": "application/json"
        }).then((response) async {
      List<Teacher> jsonMap = (json.decode(response.body) as List)
          .map((e) => Teacher.fromJson(e))
          .toList();
      return jsonMap;
    });
  }

  ///////////////// ADD NEW TEACHER ///////////////

  addTeacher(
      {@required token,
      @required name,
      @required email,
      @required password,
      @required phoneNo,
      @required PlatformFile? image,
      @required gender}) async {
    http.MultipartRequest request = http.MultipartRequest(
      "POST",
      Uri.parse('$baseUrl/admin/manage/createTeacher'),
    );
    request.headers['Authorization'] = 'Bearer $token';

    request.fields['name'] = name;
    request.fields['email'] = email;
    request.fields['password'] = password;
    request.fields['gender'] = gender;
    request.fields['phoneNumber'] = phoneNo;
    if (image != null) {
      request.files.add(new http.MultipartFile(
          'image', image.readStream!, image.size,
          filename: image.name));
    }

    //-------Send request
    var resp = await request.send();
    //------Read response
    String result = await resp.stream.bytesToString();

    //-------Your response
    print(result);

    return result;
  }

  ////////////// UPDATE TEACHER //////////////////

  updateTeacher(
      {@required id,
      @required token,
      @required name,
      @required email,
      @required password,
      @required phoneNo,
      @required PlatformFile? image,
      @required gender}) async {
    http.MultipartRequest request = http.MultipartRequest(
      "PUT",
      Uri.parse('$baseUrl/admin/manage/updateTeacher/$id'),
    );
    request.headers['Authorization'] = 'Bearer $token';

    request.fields['name'] = name;
    request.fields['email'] = email;
    if (password != null) {
      request.fields['password'] = password;
    }
    request.fields['gender'] = gender;
    request.fields['phoneNumber'] = phoneNo;
    if (image != null) {
      request.files.add(new http.MultipartFile(
          'image', image.readStream!, image.size,
          filename: image.name));
    }

    //-------Send request
    var resp = await request.send();
    //------Read response
    String result = await resp.stream.bytesToString();

    //-------Your response
    print(result);

    return result;
  }

  deleteTeacher({@required token, @required id}) async {
    return await dio.delete('$baseUrl/admin/manage/deleteTeacher/$id',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }));
  }

  ///////////////////////////////////////////////////////
  /////////////////////// SUB ADMINS ////////////////////
  ///////////////////////////////////////////////////////

  Future<List<SubAdmin>> fetchSubAdminsList({@required token}) async {
    return await client.get(Uri.parse('$baseUrl/admin/manage/getAllSubadmins'),
        headers: {
          'Authorization': 'Bearer $token',
          "Content-Type": "application/json"
        }).then((response) async {
      List<SubAdmin> jsonMap = (json.decode(response.body) as List)
          .map((e) => SubAdmin.fromJson(e))
          .toList();
      return jsonMap;
    });
  }

  ///////////////// ADD SUBADMIN ///////////////

  addSubAdmin(
      {@required token,
      @required name,
      @required email,
      @required password,
      @required phoneNo,
      @required PlatformFile? image,
      @required gender}) async {
    http.MultipartRequest request = http.MultipartRequest(
      "POST",
      Uri.parse('$baseUrl/admin/manage/createSubAdmin'),
    );
    request.headers['Authorization'] = 'Bearer $token';

    request.fields['name'] = name;
    request.fields['email'] = email;
    request.fields['password'] = password;
    request.fields['gender'] = gender;
    request.fields['phoneNumber'] = phoneNo;
    request.files.add(new http.MultipartFile(
        'image', image!.readStream!, image.size,
        filename: image.name));

    //-------Send request
    var resp = await request.send();
    //------Read response
    String result = await resp.stream.bytesToString();

    //-------Your response
    print(result);

    return result;
  }

  ////////////// UPDATE SUBADMIN //////////////////

  updateSubAdmin(
      {@required id,
      @required token,
      @required name,
      @required email,
      @required password,
      @required phoneNo,
      @required PlatformFile? image,
      @required gender}) async {
    http.MultipartRequest request = http.MultipartRequest(
      "PUT",
      Uri.parse('$baseUrl/admin/manage/updateSubAdmin/$id'),
    );
    request.headers['Authorization'] = 'Bearer $token';

    request.fields['name'] = name;
    request.fields['email'] = email;
    if (password != null) {
      request.fields['password'] = password;
    }
    request.fields['gender'] = gender;
    request.fields['phoneNumber'] = phoneNo;
    if (image != null) {
      request.files.add(new http.MultipartFile(
          'image', image.readStream!, image.size,
          filename: image.name));
    }
    //-------Send request
    var resp = await request.send();
    //------Read response
    String result = await resp.stream.bytesToString();

    //-------Your response
    print(result);

    return result;
  }

  deleteSubAdmin({@required token, @required id}) async {
    return await dio.delete('$baseUrl/admin/manage/deleteSubAdmin/$id',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }));
  }

  ///////////////////////////////////////////////////////
  /////////////////////// ALL USER //////////////////////
  ///////////////////////////////////////////////////////

  Future<List<User>> fetchAllUsers({@required token}) async {
    return await client.get(Uri.parse('$baseUrl/admin/manage/getAllUsers'),
        headers: {
          'Authorization': 'Bearer $token',
          "Content-Type": "application/json"
        }).then((response) async {
      List<User> jsonMap = (json.decode(response.body) as List)
          .map((e) => User.fromJson(e))
          .toList();
      return jsonMap;
    });
  }

  Future<http.Response> suspendUser(
      {@required String? token,
      @required String? id,
      @required bool? suspend}) async {
    return await client
        .put(Uri.parse('$baseUrl/admin/manage/updateUser/$id'), body: {
      'suspend': '$suspend'
    }, headers: {
      'Authorization': 'Bearer $token',
    }).then((value) => value);
  }

  ///////////////// ADD SUBADMIN ///////////////

  activateSuspended(
      {@required token,
      @required name,
      @required email,
      @required password,
      @required phoneNo,
      @required File? image,
      @required gender}) async {
    FormData formData = FormData.fromMap(AddTeacher(
            name: name,
            email: email,
            password: password,
            gender: gender,
            image: '',
            phoneNo: phoneNo)
        .toJson());
    return await dio.post('$baseUrl/admin/manage/createTeacher',
        data: formData,
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }));
  }

  ///////////////////////////////////////////////////////
  /////////////////////// SUBJETCS ////////////////////
  ///////////////////////////////////////////////////////

  Future<List<Subject>> fetchSubjectsList({@required token}) async {
    return await client.get(Uri.parse('$baseUrl/admin/subject/getAllSubjects'),
        headers: {
          'Authorization': 'Bearer $token',
          "Content-Type": "application/json"
        }).then((response) async {
      List<Subject> jsonMap = (json.decode(response.body) as List)
          .map((e) => Subject.fromJson(e))
          .toList();
      return jsonMap;
    });
  }

  ///////////////// ADD SUBJECT ///////////////

  addSubject({
    @required token,
    @required course,
    @required subjectName,
  }) async {
    return await dio.post('$baseUrl/admin/subject/addSubject',
        data: AddSubject(subjectName: subjectName, courseId: course).toJson(),
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }));
  }

  ////////////// UPDATE SUBJECT //////////////////

  updateSubject({
    @required token,
    @required id,
    @required subjectName,
  }) async {
    return await dio.put('$baseUrl/admin/subject/updateSubject/$id',
        data: {"subjectName": subjectName},
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }));
  }

  deleteSubject({@required token, @required id}) async {
    return await dio.delete('$baseUrl/admin/subject/deleteSubject/$id',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }));
  }

  ///////////////////////////////////////////////////////
  /////////////////////// TEACHER SUBJECTS //////////////
  ///////////////////////////////////////////////////////

  Future<List<TeacherSubject>> fetchTeacherSubjectList(
      {@required token}) async {
    return await client.get(Uri.parse('$baseUrl/admin/manage/teacherSubjects'),
        headers: {
          'Authorization': 'Bearer $token',
          "Content-Type": "application/json"
        }).then((response) async {
      List<TeacherSubject> jsonMap = (json.decode(response.body) as List)
          .map((e) => TeacherSubject.fromJson(e))
          .toList();
      return jsonMap;
    });
  }

  ///////////////// ADD TEACHER SUBJECT ///////////////

  addTeacherSubject(
      {@required token,
      @required teacher,
      @required courseId,
      @required subjectId}) async {
    return await dio.post('$baseUrl/admin/manage/addTeacherSubjects',
        data: AddTeacherSubject(
                teacherId: teacher, subjectId: subjectId, courseId: courseId)
            .toJson(),
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }));
  }

  ////////////// UPDATE TEACHER SUBJECT //////////////////

  updateTeacherSubject(
      {@required id,
      @required token,
      @required teacher,
      @required courseId,
      @required subjectId}) async {
    return await dio.put('$baseUrl/admin/manage/updateTeacherSubjects/$id',
        data: AddTeacherSubject(
                teacherId: teacher, subjectId: subjectId, courseId: courseId)
            .toJson(),
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }));
  }

  deleteTeacherSubject({@required token, @required id}) async {
    return await dio.delete('$baseUrl/admin/manage/deleteTeacherSubejcts/$id',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }));
  }

  ///////////////////////////////////////////////////////
  /////////////////////// ENROLL STUDENTS ///////////////
  ///////////////////////////////////////////////////////

  Future<List<EnrollStudent>> fetchENrollStudentList({@required token}) async {
    return await client.get(Uri.parse('$baseUrl/api/enrollStudent'), headers: {
      'Authorization': 'Bearer $token',
      "Content-Type": "application/json"
    }).then((response) async {
      List<EnrollStudent> jsonMap = (json.decode(response.body) as List)
          .map((e) => EnrollStudent.fromJson(e))
          .toList();

      return jsonMap;
    });
  }

  ///////////////// ADD ENROLL STUDENT ///////////////

  addENrollStudent({
    @required token,
    @required studentID,
    @required courseID,
  }) async {
    return await dio.post('$baseUrl/api/enrollStudent/enroll',
        data:
            AddEnrollStudent(courseId: courseID, studentId: studentID).toJson(),
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }));
  }

  deleteENrollStudent({@required token, @required id}) async {
    return await dio.delete('$baseUrl/api/enrollStudent/deleteEnroll/$id',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }));
  }

  ///////////////////////////////////////////////////////
  /////////////////////// QUESTIONS /////////////////////
  ///////////////////////////////////////////////////////

  Future<List<Questions>> fetchQuestiontList({@required token}) async {
    return await client
        .get(Uri.parse('$baseUrl/admin/question/getAllQuestions'), headers: {
      'Authorization': 'Bearer $token',
      "Content-Type": "application/json"
    }).then((response) async {
      print(response.body);
      List<Questions> jsonMap = (json.decode(response.body) as List)
          .map((e) => Questions.fromJson(e))
          .toList();
      return jsonMap;
    });
  }

  ///////////////// ADD Question ///////////////

  addQuestion(
      {@required token,
      @required questionStatement,
      @required type,
      @required answer,
      @required level,
      @required List? subjectId,
      @required courseId,
      @required List? questionImage,
      @required AddQustionOption? options}) async {
    print('START');
    http.MultipartRequest request = http.MultipartRequest(
      "POST",
      Uri.parse('$baseUrl/admin/question/addQuestion'),
    );
    request.headers['Authorization'] = 'Bearer $token';

    for (String subject in subjectId!) {
      request.files.add(http.MultipartFile.fromString('subject', subject));
    }
    request.fields['questionStatement'] = questionStatement;
    request.fields['type'] = type;
    request.fields['answer'] = answer;
    request.fields['course'] = courseId;
    request.fields['level'] = level;
    request.fields['options'] = json.encode(options!);
    request.files.add(new http.MultipartFile(
        'questionImage', questionImage![0].readStream!, questionImage[0].size,
        filename: questionImage[0].name));

    //-------Send request
    var resp = await request.send();
    //------Read response
    String result = await resp.stream.bytesToString();

    //-------Your response
    print('RESULTTTTTTTTTTTTTT: $result');
    print('END');

    return result;
  }

  ////////////// UPDATE Question //////////////////

  updateQuestion(
      {@required id,
      @required token,
      @required questionStatement,
      @required type,
      @required answer,
      @required level,
      @required List? subjectId,
      @required courseId,
      @required PlatformFile? questionImage,
      @required AddQustionOption? options}) async {
    print('START');
    http.MultipartRequest request = http.MultipartRequest(
      "PUT",
      Uri.parse('$baseUrl/admin/question/updateQuestion/$id'),
    );
    request.headers['Authorization'] = 'Bearer $token';

    for (String subject in subjectId!) {
      request.files.add(http.MultipartFile.fromString('subject', subject));
    }
    request.fields['questionStatement'] = questionStatement;
    request.fields['type'] = type;
    request.fields['answer'] = answer;
    request.fields['course'] = courseId;
    request.fields['level'] = level;
    request.fields['options'] = json.encode(options!);
    if (questionImage != null) {
      request.files.add(new http.MultipartFile(
          'questionImage', questionImage.readStream!, questionImage.size,
          filename: questionImage.name));
    }

    //-------Send request
    var resp = await request.send();
    //------Read response
    String result = await resp.stream.bytesToString();

    //-------Your response
    print('RESULTTTTTTTTTTTTTT: $result');
    print('END');

    return result;
  }

  deleteQuestion({@required token, @required id}) async {
    return await dio.delete('$baseUrl/admin/manage/deleteQuestion/$id',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }));
  }

  ///////////////////////////////////////////////////////
  /////////////////////// QUIZ //////////////////////////
  ///////////////////////////////////////////////////////

  Future<List<Quiz>> fetchQUIZList({@required token}) async {
    return await client.get(Uri.parse('$baseUrl/admin/quiz/getAllQuiz'),
        headers: {
          'Authorization': 'Bearer $token',
          "Content-Type": "application/json"
        }).then((response) async {
      List<Quiz> jsonMap = (json.decode(response.body) as List)
          .map((e) => Quiz.fromJson(e))
          .toList();
      return jsonMap;
    });
  }

  ///////////////// ADD QUIZ ///////////////

  addQUIZ(
      {@required token,
      @required quizName,
      @required courseId,
      @required attemptDate,
      @required List? subjectId,
      @required level,
      @required bool? public,
      @required timeType,
      @required int? time,
      @required List? questions}) async {
    return await dio.post('$baseUrl/admin/quiz/addQuiz',
        data: AddQuiz(
                quizName: quizName,
                attemptDate: attemptDate,
                courseId: courseId,
                subjectId: subjectId,
                level: level,
                questions: questions,
                public: public,
                timeType: timeType,
                time: time)
            .toJson(),
        options: Options(headers: {
          'Authorization': 'Bearer $token',
          "Content-Type": "application/json"
        }));
  }

  ////////////// UPDATE QUIZ //////////////////

  updateQUIZ(
      {@required id,
      @required token,
      @required quizName,
      @required courseId,
      @required attemptDate,
      @required subjectId,
      @required level,
      @required bool? public,
      @required timeType,
      @required int? time,
      @required List? questions}) async {
    return await dio.put('$baseUrl/admin/quiz/updateQuiz/$id',
        data: AddQuiz(
                quizName: quizName,
                attemptDate: attemptDate,
                courseId: courseId,
                subjectId: subjectId,
                level: level,
                questions: questions,
                public: public,
                timeType: timeType,
                time: time)
            .toJson(),
        options: Options(headers: {
          'Authorization': 'Bearer $token',
          "Content-Type": "application/json"
        }));
  }

  deleteQUIZ({@required token, @required id}) async {
    return await dio.delete('$baseUrl/admin/quiz/deleteQuiz/$id',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }));
  }

  //////////////////////////////////
  ///////////////////////////////////
  ////////////////////////////////////

  Future<List<NewSubject>> getSubjectByCourseId(
      {@required token, @required courseId}) async {
    return await client
        .get(Uri.parse('$baseUrl/admin/quiz/getSubjects/$courseId'), headers: {
      'Authorization': 'Bearer $token',
      "Content-Type": "application/json"
    }).then((response) async {
      List<NewSubject> jsonMap = (json.decode(response.body) as List)
          .map((e) => NewSubject.fromJson(e))
          .toList();
      return jsonMap;
    });
  }

  Future<List<Questions>> getQuestionsBySubjectId(
      {@required token, @required subjectId, @required level}) async {
    return await client
        .post(Uri.parse('$baseUrl/admin/quiz/getQuestions'), headers: {
      'Authorization': 'Bearer $token',
    }, body: {
      'id': subjectId,
      'level': level,
    }).then((response) async {
      List<Questions> jsonMap = (json.decode(response.body) as List)
          .map((e) => Questions.fromJson(e))
          .toList();
      return jsonMap;
    });
  }

  ///////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////
  /////////////////////// STUDENTS SIDE /////////////////
  ///////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////

  Future<StudentLoginResponse> studentLogin(rollNo, password) async {
    return await client.post(Uri.parse('$baseUrl/student/auth/login'),
        body: {"rollno": rollNo, "password": password}).then((response) async {
      print(response.body);
      var jsonMap = json.decode(response.body);
      StudentLoginResponse loginResponse =
          StudentLoginResponse.fromJson(jsonMap);
      SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.setString('LoginResponse', jsonEncode(jsonMap));
      return loginResponse;
    });
  }

  Future<List<StudentCourse>> getStudentCourses(
      {@required token, @required String? id}) async {
    return await client.get(
        Uri.parse('$baseUrl/api/enrollStudent/getCourseByStdId/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          "Content-Type": "application/json"
        }).then((response) async {
      List<StudentCourse> jsonMap = (json.decode(response.body) as List)
          .map((e) => StudentCourse.fromJson(e))
          .toList();
      return jsonMap;
    });
  }

  Future<List<StudentSubject>> getStudentSubjects(
      {@required token, @required String? id}) async {
    return await client.get(
        Uri.parse('$baseUrl/api/enrollStudent/getSubjectsByCourseId/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          "Content-Type": "application/json"
        }).then((response) async {
      List<StudentSubject> jsonMap = (json.decode(response.body) as List)
          .map((e) => StudentSubject.fromJson(e))
          .toList();
      return jsonMap;
    });
  }

  Future<List<Quiz1>> getSubjectQuizs(
      {@required token, @required String? id}) async {
    return await client.get(Uri.parse('$baseUrl/api/student/$id/quizname'),
        headers: {
          'Authorization': 'Bearer $token',
          "Content-Type": "application/json"
        }).then((response) async {
      List<Quiz1> jsonMap = (json.decode(response.body) as List)
          .map((e) => Quiz1.fromJson(e))
          .toList();
      return jsonMap;
    });
  }

  submitQuestion(BuildContext context, StudentLoginResponse loginResponse,
      {@required token,
      @required String? quizId,
      @required String? questionId,
      @required String? correctAnswer}) async {
    return await dio
        .post('$baseUrl/api/solvedQuizData/addSolvedQuizData',
            data: SubmitQuiz(
                    quizId: quizId,
                    questionId: questionId,
                    correctAnswer: correctAnswer)
                .toJson(),
            options: Options(headers: {
              'Authorization': 'Bearer $token',
            }))
        .then((value) => print(value.data));
  }

  submitLastQuestion(BuildContext context, StudentLoginResponse loginResponse,
      {@required token,
      @required String? quizId,
      @required String? questionId,
      @required String? correctAnswer}) async {
    return await dio
        .post('$baseUrl/api/solvedQuizData/addSolvedQuizData',
            data: SubmitQuiz(
                    quizId: quizId,
                    questionId: questionId,
                    correctAnswer: correctAnswer)
                .toJson(),
            options: Options(headers: {
              'Authorization': 'Bearer $token',
              "Content-Type": "application/json"
            }))
        .then((value) {
      var jsonMap = json.decode(value.data);
      SolvedQuiz solvedQuiz = SolvedQuiz.fromJson(jsonMap);

      pushAndRemoveUntil(
          context,
          QuizDetails(
            solvedQuiz: solvedQuiz,
            loginResponse: loginResponse,
            isVisible: true,
          ));
    });
  }

  Future<List<SolvedQuiz>> getStudentQuiz(
      {@required token, @required String? id}) async {
    return await client.get(
        Uri.parse('$baseUrl/api/solvedQuizData/getQuizStudent/$id'),
        headers: {
          'Authorization': 'Bearer $token',
        }).then((response) async {
      print(response.body);
      List<SolvedQuiz> jsonMap = (json.decode(response.body) as List)
          .map((e) => SolvedQuiz.fromJson(e))
          .toList();
      return jsonMap;
    });
  }

  Future<Quiz1> getQuizById({@required token, @required String? id}) async {
    return await client.get(Uri.parse('$baseUrl/admin/quiz/getQuiz/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          "Content-Type": "application/json"
        }).then((response) async {
      var jsonMap = json.decode(response.body);
      Quiz1 quiz = Quiz1.fromJson(jsonMap);
      return quiz;
    });
  }

  ///////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////
  /////////////////////// TEACHER SIDE //////////////////
  ///////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////

  Future<LoginResponse> teacherLogin(email, password) async {
    return await client.post(Uri.parse('$baseUrl/teacher/auth/login'),
        body: {"email": email, "password": password}).then((response) async {
      print(response.body);
      var jsonMap = json.decode(response.body);
      LoginResponse loginResponse = LoginResponse.fromJson(jsonMap);
      SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.setString('LoginResponse', jsonEncode(jsonMap));
      return loginResponse;
    });
  }
}
