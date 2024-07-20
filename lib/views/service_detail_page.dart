import 'package:flutter/material.dart';

class ServiceDetailPage extends StatelessWidget {
  final String serviceName;
  final String serviceDescription;
  final String serviceRate;
  final String imageUrl;

  ServiceDetailPage({
    required this.serviceName,
    required this.serviceDescription,
    required this.serviceRate,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final imageHeight = screenHeight / 2.5; // Set the height of the background image to half the screen height

    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: imageHeight,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // Content with curved background
          Positioned(
            top: imageHeight - 50, // Adjust to overlap slightly with the image if desired
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.white, Colors.white],
                ),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(30),
                ),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 16),
                      Text(
                        serviceName,
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '$serviceRate rs/hour',
                        style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                      ),
                      SizedBox(height: 16),
                      Text(
                        serviceDescription,
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Custom Back Button
          Positioned(
            top: MediaQuery.of(context).padding.top + 20, // Adjust the position to your preference
            left: 10,
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
