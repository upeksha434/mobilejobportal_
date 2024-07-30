import 'package:flutter/material.dart';
import 'package:mobilejobportal/controllers/auth_controller.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
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
