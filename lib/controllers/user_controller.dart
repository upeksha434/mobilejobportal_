import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobilejobportal/utils/http_client.dart';
import '../layout.dart';
import '../models/auth_user.dart';
import '../views/login.dart';

class UserController{
  static TextEditingController emailController = TextEditingController();
  static TextEditingController passwordController = TextEditingController();

  static RxBool isPasswordVisible = true.obs;
  static RxBool loading = false.obs;

  static String token = '';

  static late AuthUser user;

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

      Get.offAll(() => Layout());
    } else {
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

  static postEmployeeRating(int employerId, int employeeId, double rating, String review) async {
    final response = await HttpClient.postEmployeeRating({
      'employerId': employerId,
      'employeeId': employeeId,
      'rating': rating,
      'review': review,
    });

    if (response.statusCode == 201) {
      Get.snackbar('Success', 'Rating submitted successfully');
    } else {
      Get.snackbar('Error', 'Failed to submit rating');
    }
  }
  static updateEmployeeRating(int employerId, int employeeId, double rating, String review, int id) async {
    print(employerId);
    print(employeeId);
    print(rating);
    print(review);
    print(id);
    final response = await HttpClient.updateEmployeeRating({
      'employerId': employerId,
      'employeeId': employeeId,
      'rating': rating,
      'review': review,
    },id);

    if (response.statusCode == 201) {
      Get.snackbar('Success', 'Rating updated successfully');
    } else {
      Get.snackbar('Error', 'Failed to update rating');
    }
  }

  static logout() async {
    // Perform any necessary cleanup or API calls for logout. backend

    emailController.clear();
    passwordController.clear();
    Get.off(() => LoginPage());
  }
}