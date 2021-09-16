import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:quiz_app/Models/Admin_Login.dart';
import 'package:quiz_app/Models/Courses.dart';
import 'package:quiz_app/Models/Student.dart';
import 'package:quiz_app/Models/Teachers.dart';
import 'package:quiz_app/Models/User.dart';

class APIManager {
  var client = http.Client();
  var loginResponse;
  var student;
  String baseUrl = 'http://192.168.100.71:4000';
  Dio dio = Dio();

  ///////////////////////////////////////////////////////////

  Future<LoginResponse> adminLogin(email, password) async {
    return await client
        .post(Uri.parse('$baseUrl/admin/auth/login'),
            body: Login(email: email, password: password).toJson())
        .then((response) {
      var jsonString = response.body;
      var jsonMap = json.decode(jsonString);
      loginResponse = LoginResponse.fromJson(jsonMap);
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
      @required File? image,
      @required gender}) async {
    final mimeTypeDate =
        lookupMimeType(image!.path, headerBytes: [0xFF, 0xD8])!.split('/');
    final imageUploadRequest = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/admin/manage/createStudent'),
    );
    imageUploadRequest.headers['Authorization'] = 'Bearer $token';
    final file = await http.MultipartFile.fromPath('image', image.path,
        contentType: MediaType(mimeTypeDate[0], mimeTypeDate[0]));
    imageUploadRequest.files.add(file);
    imageUploadRequest.fields['name'] = name;
    imageUploadRequest.fields['email'] = email;
    imageUploadRequest.fields['password'] = password;
    imageUploadRequest.fields['gender'] = gender;
    imageUploadRequest.fields['rollno'] = rollNo;
    imageUploadRequest.fields['phoneNumber'] = phoneNo;
    try {
      final streamedResponse = await imageUploadRequest.send();
      final response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode != 200) {
        return null;
      }
      final Map<String, dynamic> responseData = json.decode(response.body);
      return responseData;
    } catch (e) {
      print(e);
      return null;
    }
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
      @required File? image,
      @required gender}) async {
    FormData formData = FormData.fromMap(AddStudent(
            name: name,
            email: email,
            password: password,
            gender: gender,
            rollNo: rollNo,
            image: '',
            phoneNo: phoneNo)
        .toJson());

    return await dio.put('$baseUrl/admin/manage/updateStudent/$id',
        data: formData,
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }));
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
    FormData formData = FormData.fromMap(AddCourse(
      name: courseName,
    ).toJson());
    return await dio.post('$baseUrl/admin/course/addCourse',
        data: formData,
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
    FormData formData = FormData.fromMap(AddCourse(
      name: courseName,
    ).toJson());
    return await dio.post('$baseUrl/admin/course/addCourse/$courseId',
        data: formData,
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }));
  }

  ///////////////////////////////////////////////////////
  /////////////////////// TEACHERS ///////////////////////
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

  ///////////////// ADD NEW STUDENT ///////////////

  addTeacher(
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

  ////////////// UPDATE STUDENT //////////////////

  updateTeacher(
      {@required id,
      @required token,
      @required name,
      @required email,
      @required password,
      @required phoneNo,
      @required File? image,
      @required gender}) async {
    FormData formData = FormData.fromMap(UpdateTeacher(
            name: name,
            email: email,
            password: password,
            gender: gender,
            image: '',
            phoneNo: phoneNo)
        .toJson());

    return await dio.put('$baseUrl/admin/manage/updateTeacher/$id',
        data: formData,
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }));
  }

  deleteTeacher({@required token, @required id}) async {
    return await dio.delete('$baseUrl/admin/manage/deleteTeacher/$id',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }));
  }
}
