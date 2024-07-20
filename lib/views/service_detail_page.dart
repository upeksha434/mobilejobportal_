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
    print('ServiceDetailPage: $serviceName, $serviceDescription, $serviceRate, $imageUrl');
    return Scaffold(
      appBar: AppBar(
        title: Text(serviceName),
        backgroundColor: Color(0xFFD9D2E2),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              imageUrl,
              width: 80,
              height: 200,
              fit: BoxFit.cover,
            ),
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
    );
  }
}
