import 'dart:io';
import 'package:dio/dio.dart';

class HttpResponse {
  final dynamic data;
  final int statusCode;

  HttpResponse({this.data, required this.statusCode});
}

class HttpClient {
  static Dio dio = Dio();

  static initialize() {
    dio.options.baseUrl = 'http://10.0.2.2:3000';
    //dio.options.baseUrl ='https://webappbackend-production.up.railway.app';
    dio.options.connectTimeout = const Duration(seconds: 5);
    dio.options.receiveTimeout = const Duration(seconds: 5);

    print('HttpClient initialized');
  }

  static setAuthToken(String token) {
    dio.options.headers = {'Authorization': 'Bearer $token'};
  }
  static Future<Response> get(String path) async {
    return await dio.get(path);
  }
  static Future<Response> post(String path, dynamic data) async {
    return await dio.post(path, data: data);
  }
  static Future<HttpResponse> getServices(Map data) async {
    try {
      dio.options.headers['Content-Type'] = 'application/json';

      Response response = await post('/employer/getservice', data);
      // print(response);
      return HttpResponse(
          data: response.data, statusCode: response.statusCode ?? 500);
    } on DioException catch (e) {
      print(e);
      print("error");
      return HttpResponse(
          data: e.response?.data,
          statusCode: e.response?.statusCode ?? 500);
    }
  }

  static Future<HttpResponse>sendMessages(Map data) async {
    print(data);
    try {
      dio.options.headers['Content-Type'] = 'application/json';

      Response response = await post('/chats/sendMessage', data);
      // print(response);
      return HttpResponse(
          data: response.data, statusCode: response.statusCode ?? 500);
    } on DioException catch (e) {
      print(e);
      print("error");
      return HttpResponse(
          data: e.response?.data,
          statusCode: e.response?.statusCode ?? 500);
    }
  }

  static Future<HttpResponse>getMessages(Map data) async {
    try {
      dio.options.headers['Content-Type'] = 'application/json';

      Response response = await post('/chats/getMessages', data);
      // print(response);
      return HttpResponse(
          data: response.data, statusCode: response.statusCode ?? 500);
    } on DioException catch (e) {
      print(e);
      print("error");
      return HttpResponse(
          data: e.response?.data,
          statusCode: e.response?.statusCode ?? 500);
    }
  }
  static Future<HttpResponse>getEmployeeChatcards(Map data) async {
    try {
      dio.options.headers['Content-Type'] = 'application/json';

      Response response = await post('/chats/getEmployeeChats', data);
      // print(response);
      return HttpResponse(
          data: response.data, statusCode: response.statusCode ?? 500);
    } on DioException catch (e) {
      print(e);
      print("error");
      return HttpResponse(
          data: e.response?.data,
          statusCode: e.response?.statusCode ?? 500);
    }
  }
  static Future<HttpResponse> getEmployeeRating(String id) async {
    try {
      dio.options.headers['Content-Type'] = 'application/json';


      Response response = await get('/employee/getEmployeeRatings/$id');

      return HttpResponse(
          data: response.data, statusCode: response.statusCode ?? 500);
    } on DioException catch (e) {
      print(e);
      print("error");
      return HttpResponse(
          data: e.response?.data,
          statusCode: e.response?.statusCode ?? 500);
    }
  }
  static Future<HttpResponse> postEmployeeRating(Map data) async {
    try {
      dio.options.headers['Content-Type'] = 'application/json';

      Response response = await post('/employee/postReview', data);
      // print(response);
      return HttpResponse(
          data: response.data, statusCode: response.statusCode ?? 500);
    } on DioException catch (e) {
      print(e);
      print("error");
      return HttpResponse(
          data: e.response?.data,
          statusCode: e.response?.statusCode ?? 500);
    }
  }


  static testRoute(Map data) async {
    try {
      final response = await post('/auth/login', data);
      return HttpResponse(
          data: response.data, statusCode: response.statusCode ?? 500);
    } on DioException catch (e) {
      return HttpResponse(
          data: e.response?.data, statusCode: e.response?.statusCode ?? 500);
    }
  }
}