import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobilejobportal/views/employerChatHistoryView.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobilejobportal/utils/http_client.dart';
import '../bottomNavigation.dart';
import '../layout.dart';
import '../models/auth_user.dart';
import '../views/login.dart';


class AuthController {
  static TextEditingController emailController = TextEditingController();
  static TextEditingController passwordController = TextEditingController();


  static RxBool isPasswordVisible = true.obs;
  static RxBool loading = false.obs;

  static String token = '';

  static late AuthUser user;
  static int userId = 0;

  static signIn() async {
    loading.value = true;
    HttpResponse res = await HttpClient.testRoute({
      'email': emailController.text,
      'password': passwordController.text,
    });

    if (res.statusCode == 201) {
      HttpClient.setAuthToken(res.data['accessToken']);
      token = res.data['accessToken'];

      user = AuthUser.fromJSON(res.data['user']);

      // Store user ID in SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('userId', user.id);
      userId = user.id;

      if(user.roleId==1)
        //Get.offAll(() => Layout());
        Get.offAll(()=>CustomBottomNavigationBar());
      else
        Get.offAll(() => EmployerChatHistoryView());



    }
    else {
      Get.snackbar('Error', 'Invalid Credentials');
    }
    loading.value = false;
  }
  static Future<bool> shouldLogout() async {
    final prefs = await SharedPreferences.getInstance();
    final lastActivityTimeStamp = prefs.getInt('last_activity_timestamp');
    if (lastActivityTimeStamp != null) {
      final now = DateTime.now();
      final lastActivity = DateTime.fromMillisecondsSinceEpoch(
          lastActivityTimeStamp);
      final difference = now.difference(lastActivity);
      return difference.inMinutes >= 2;
    }
    return false;
  }
  static logout() async {
    // Perform any necessary cleanup or API calls for logout. backend

    emailController.clear();
    passwordController.clear();
    Get.off(() => LoginPage());
  }

  static Future<void> checkAndLogoutIfNecessary() async{
    if (await shouldLogout()){
      logout();
    }
  }

  static Future<Map<String,dynamic>> getProfileInfo(String id) async {
    final Response = await HttpClient.getProfileInfo(id);
    print(Response.data);
    print(Response.data.runtimeType);
    return(Response.data );
    if (Response.statusCode == 200) {
      return Response.data;
    } else {
      throw Exception('Failed to load profile info');
    }

  }
//  updateProfileInfo(Map data,id)

  static Future<void> updateProfileInfo(Map data, id) async {
    final Response = await HttpClient.updateProfileInfo(data,id);
    print(Response.data);
    print(Response.data.runtimeType);
    if (Response.statusCode == 200) {
      return Response.data;
    } else {
      throw Exception('Failed to load profile info');
    }

  }
}