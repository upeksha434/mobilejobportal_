import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mobilejobportal/controllers/auth_controller.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:mobilejobportal/utils/http_client.dart';

Future<bool> isPermissionAllowed() async {
  var permissionStatus = await Permission.storage.request();
  if (permissionStatus.isGranted) {
    return true;
  } else {
    return false;
  }
}

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  File? file;
  String fileName = '';
  String? path = '';
  final TextEditingController fileNameController = TextEditingController();
  bool _isLoading = true;
  int loggedInUserId = AuthController.userId;
  final AuthController authController = AuthController();
  late Map<String, dynamic> infoProfile;

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

  void _pickAndUploadImage() async {
    final isPermissionGranted = await isPermissionAllowed();
    if (!isPermissionGranted) return;

    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        file = File(result.files.single.path!);
        fileName = result.files.single.name;
        fileNameController.text = fileName;
      });
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: file != null
                      ? FileImage(file!)
                      : infoProfile['profilePic'] != null
                      ? NetworkImage(infoProfile['profilePic'])
                      : AssetImage('assets/default_profile.png') as ImageProvider,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: _pickAndUploadImage,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.camera_alt,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text('Username', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(infoProfile['fname'] ?? 'N/A'),
            SizedBox(height: 8),
            Text('Birthday', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('1st April, 2000'), // Use actual data here
            SizedBox(height: 8),
            Text('Location', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(infoProfile['location'] ?? 'N/A'),
            SizedBox(height: 8),
            Text('Email', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(infoProfile['email'] ?? 'N/A'),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                if (file != null) {
                  HttpResponse response = await HttpClient.updateProfilePic(file!, infoProfile['profilePicId'].toString());
                  if (response.statusCode == 201) {
                    setState(() {
                      infoProfile['profilePic'] = response.data['imageURL'];
                    });
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Profile picture updated successfully')));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update profile picture')));
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('No file selected')));
                }
              },
              child: Text('Upload profile Pic'),
            ),
          ],
        ),
      ),
    );
  }
}
