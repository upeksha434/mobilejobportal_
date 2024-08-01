import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mobilejobportal/controllers/auth_controller.dart';
import 'package:permission_handler/permission_handler.dart';
ispermissionallowed() async {
  var permissionStatus = await Permission.storage.request();
  print("permission status");
  print(permissionStatus);
  if (permissionStatus.isGranted) {
    return true;
//permission granted
  }else{
    ispermissionallowed();
  }

}

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  File? file;
  String fileName='';
  String? path ='';
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
    print('fetching');
    final fetchedInfo = await AuthController.getProfileInfo(loggedInUserId.toString());
    setState(() {
      infoProfile = fetchedInfo;
      _isLoading = false;
      print('fetched info $infoProfile');
    });
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

            Container(
              child:ElevatedButton(
                onPressed:() async{
                  final isPermissionGranted = await ispermissionallowed();
                  print('permission $isPermissionGranted');

                  if(!isPermissionGranted){
                    return;
                  }

                  FilePickerResult? result = await FilePicker.platform.pickFiles();
                  if (result != null){
                    File file = File(result.files.single.path!);
                    fileName = result.files.single.name;
                    fileNameController.text = fileName;
                  }
                  else{
                    print('User canceled file picking');
                  }


                },child: const Text('Choose File'),
              )
            ),
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
