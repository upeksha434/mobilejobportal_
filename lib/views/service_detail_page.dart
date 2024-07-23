import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mobilejobportal/utils/http_client.dart';

import '../controllers/fetch_services.dart';

class ServiceDetailPage extends StatelessWidget {
  final String serviceName;
  final String serviceDescription;
  final String serviceRate;
  final String imageUrl;
  final String? averageRating;
  final int employeeId;


  ServiceDetailPage({
    required this.serviceName,
    required this.serviceDescription,
    required this.serviceRate,
    required this.imageUrl,
    required this.employeeId,
    this.averageRating,
  });

  final FetchServices fetchServices = FetchServices(HttpClient() as HttpClient);
  List<dynamic> _reviews = [];




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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
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
                        SizedBox(height: 8),
                        Text(
                          '⭐ $averageRating ️',
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
                  Padding(
                    padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  _showBookingDialog(context);
                                },
                                child: Text('Book Now'),
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {},
                                child: Text('Another Button'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
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


  Future<void> _showBookingDialog(BuildContext context) async {
    final reviews = await fetchServices.getEmployeeRating(employeeId);
    print('reviews');





    print(reviews);
    print('rev');




    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Container(
            padding: EdgeInsets.all(0.0),
            width: double.infinity,
            height:double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Reviews', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
                Container(
                  child: Text('Post a Review', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),

                  decoration: BoxDecoration(

                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.grey[200],
                  ),

                ),

                Expanded(child: ListView.builder(
                  itemCount: reviews.length, // reviews['reviews'
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(reviews[index]['employerName'], style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(reviews[index]['review']),
                      trailing: Text(reviews[index]['rating'].toString(),
                        style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
                    );
                  },
                ),),



              ],
            ),
          ),
        );
      },
    );
  }
}
