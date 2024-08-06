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

  final TextEditingController fnameController = TextEditingController();
  final TextEditingController lnameController = TextEditingController();
  final TextEditingController profileDescriptionController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController hourlyRateController = TextEditingController();
  final TextEditingController jobTypeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  bool isEditing = false;
  bool isUploadNewImage = false;

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

      // Initialize controllers with fetched info
      fnameController.text = infoProfile['fname'] ?? '';
      lnameController.text = infoProfile['lname'] ?? '';
      profileDescriptionController.text = infoProfile['profileDescription'] ?? '';
      locationController.text = infoProfile['location'] ?? '';
      hourlyRateController.text = infoProfile['hourlyRate'] ?? '';
      jobTypeController.text = infoProfile['jobType'] ?? '';
      emailController.text = infoProfile['email'] ?? '';
      print(fnameController.text);
      print(infoProfile['roleId']==2 );
    });
  }

  void _pickAndUploadImage() async {

      setState(() {
        isUploadNewImage = !isUploadNewImage;
      });

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

  void _updateProfileInfo() async {
    Map<String, dynamic> updatedData = {
      'fname': fnameController.text,
      'lname': lnameController.text,
      'profileDescription': profileDescriptionController.text,
      'location': locationController.text,
      'hourlyRate': hourlyRateController.text,
      'jobType': jobTypeController.text,
      'email': emailController.text,
    };

    try {
      await AuthController.updateProfileInfo(updatedData, loggedInUserId);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Profile updated successfully')));
      load(); // Reload to update the profile info
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update profile')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body:
      SingleChildScrollView(
      child:
      _isLoading
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
            if(infoProfile['roleId']==1)...[
              SizedBox(height: 16),
              _buildEditableField('First name', fnameController),
              SizedBox(height: 8),
              _buildEditableField('Last name', lnameController),
              SizedBox(height: 8),
              _buildEditableField('Profile', profileDescriptionController),
              SizedBox(height: 8),
              _buildEditableField('Email', emailController),],
            if(infoProfile['roleId']==2) ...[
              SizedBox(height: 16),
              _buildEditableField('First name', fnameController),
              SizedBox(height: 8),
              _buildEditableField('Last name', lnameController),
              SizedBox(height: 8),
              _buildEditableField('Profile', profileDescriptionController),
              SizedBox(height: 8),
              _buildEditableField('Location', locationController),
              SizedBox(height: 8),
              _buildEditableField('Hourly rate', hourlyRateController),
              SizedBox(height: 8),
              _buildEditableField('Job Category', jobTypeController),
              SizedBox(height: 8),
              _buildEditableField('Email', emailController),
              SizedBox(height: 16),],
    if( isUploadNewImage) ...[
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
            ),],
            SizedBox(height: 16),
            if(isEditing)...[
              ElevatedButton(

                onPressed: _updateProfileInfo,
                child: Text('Update Profile Info'),
              ),
            ],

          ],
        ),
      ),),
    );
  }

  Widget _buildEditableField(String label, TextEditingController controller) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: label,
              border: OutlineInputBorder(),
            ),
            enabled: isEditing,
          ),
        ),
        IconButton(
          icon: Icon(Icons.edit),
          onPressed: () {
            setState(() {
              isEditing = !isEditing;
            });
          },
        ),
      ],
    );
  }
}
