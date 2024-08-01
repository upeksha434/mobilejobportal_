import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:dio/dio.dart';
import 'package:mobilejobportal/controllers/auth_controller.dart';
import 'package:mobilejobportal/utils/http_client.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool _isLoading = true;
  int loggedInUserId = AuthController.userId;
  final AuthController authController = AuthController();
  late Map<String, dynamic> infoProfile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    final fetchedInfo = await AuthController.getProfileInfo(loggedInUserId.toString());
    setState(() {
      infoProfile = fetchedInfo;
      _isLoading = false;
    });
  }

  Future<void> _pickAndUploadImage() async {
    if (await Permission.photos.request().isGranted) {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        File file = File(pickedFile.path);
        String fileName = file.path.split('/').last;

        try {
          FormData formData = FormData.fromMap({
            "file": await MultipartFile.fromFile(file.path, filename: fileName),
            "ext": fileName.split('.').last,
          });

          HttpResponse response = (await HttpClient.post('/auth/upload-new-profile-pic/${infoProfile['profilePicId']}', formData)) as HttpResponse;

          if (response.statusCode == 200) {
            // Update UI with new profile picture URL
            setState(() {
              infoProfile['profilePic'] = response.data['imageURL'];
            });
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Profile picture updated successfully')));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update profile picture')));
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('An error occurred: $e')));
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Permission to access photos is required')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (infoProfile['profilePic'] != null)
              Center(
                child: Image.network(
                  infoProfile['profilePic'],
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                ),
              ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _pickAndUploadImage,
              child: Text('Change Profile Picture'),
            ),
            SizedBox(height: 16),
            Text('First Name: ${infoProfile['fname'] ?? 'N/A'}'),
            Text('Last Name: ${infoProfile['lname'] ?? 'N/A'}'),
            Text('Email: ${infoProfile['email'] ?? 'N/A'}'),
            Text('Location: ${infoProfile['location'] ?? 'N/A'}'),
            Text('Job Type: ${infoProfile['jobType'] ?? 'N/A'}'),
            Text('Profile Description: ${infoProfile['profileDescription'] ?? 'N/A'}'),
            Text('Hourly Rate: ${infoProfile['hourlyRate'] ?? 'N/A'}'),
            Text('Verified: ${infoProfile['isVerified'] ? 'Yes' : 'No'}'),
          ],
        ),
      ),
    );
  }
}
