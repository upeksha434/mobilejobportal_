import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:mobilejobportal/controllers/auth_controller.dart';
import 'package:mobilejobportal/utils/http_client.dart';
import 'package:mobilejobportal/views/chat.dart';
import '../controllers/fetch_services.dart';
import '../controllers/user_controller.dart';

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
  int loggedInUserId = AuthController.userId;

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
                                child: Text('Review'),
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  print('Logged in user ID: $loggedInUserId');
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>

                                  ChatPage(
                                    employerId: loggedInUserId,
                                    employeeId: employeeId,
                                  ),),
                                  );
                                },
                                child: Text('Contact'),
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
    final reviews_average = await fetchServices.getEmployeeRating(employeeId);
    final reviews_ = reviews_average[0];
    final averageRating = double.parse(reviews_average[1].toString()).toStringAsFixed(2);

    print(reviews_);
    final reviewExistsForUser = reviews_.any((review) => review['employerId'] == loggedInUserId);
    final postedReview = reviews_.firstWhere((review) => review['employerId'] == loggedInUserId, orElse: () => {});
    final _5star = reviews_.where((review) => review['rating'] == 5).length / reviews_.length;
    final _4star = reviews_.where((review) => review['rating'] == 4).length / reviews_.length;
    final _3star = reviews_.where((review) => review['rating'] == 3).length / reviews_.length;
    final _2star = reviews_.where((review) => review['rating'] == 2).length / reviews_.length;
    final _1star = reviews_.where((review) => review['rating'] == 1).length / reviews_.length;
    final reviews = reviews_.where((review) => review['employerId'] != loggedInUserId).toList();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.white, Colors.white, Colors.white],
                stops: [0.0, 0.6, 0.9],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Reviews', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
                const SizedBox(
                  height: 16,
                  width: double.infinity,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.black12, width: 2.0)),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Text('$averageRating', style: TextStyle(fontSize: 25, color: Colors.black, fontWeight: FontWeight.bold)),
                RatingBar.builder(
                  initialRating: averageRating == 'NaN' ? 0 : double.parse(averageRating),
                  minRating: 1,
                  direction: Axis.horizontal,
                  ignoreGestures: true,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemSize: 24,
                  itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    print(rating);
                  },
                ),
                SizedBox(height: 16),
                Text('Based on ${reviews_.length} reviews', style: TextStyle(fontSize: 16, color: Colors.black)),
                SizedBox(height: 16),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildRatingBars(_5star, _4star, _3star, _2star, _1star),
                        if (reviewExistsForUser)
                          Container(
                            padding: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Colors.white.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    color: Colors.white.withOpacity(0.4),
                                    borderRadius: BorderRadius.circular(10.0),
                                    border: Border.all(color: Colors.black12, width: 2.0),
                                  ),
                                  child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Your Review', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
                                      const SizedBox(
                                        height: 8,
                                        width: double.infinity,
                                        child: DecoratedBox(
                                          decoration: BoxDecoration(
                                            border: Border(bottom: BorderSide(color: Colors.black12, width: 2.0)),
                                          ),
                                        ),
                                      ),
                                      ListTile(
                                        contentPadding: EdgeInsets.all(0),
                                        leading: CircleAvatar(
                                          radius: 22,
                                          backgroundImage: NetworkImage(postedReview['profilePic']),
                                        ),
                                        title: Text(postedReview['employerName'], style: TextStyle(fontWeight: FontWeight.bold)),
                                        //subtitle: Text(postedReview['review'], style: TextStyle(fontSize: 15, color: Colors.black)),
                                        subtitle: RatingBar.builder(
                                          initialRating:postedReview['rating'].toDouble(),
                                          minRating: 1,
                                          direction: Axis.horizontal,
                                          ignoreGestures: true,
                                          allowHalfRating: false,
                                          itemCount: 5,
                                          itemSize: 16,
                                          itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                                          itemBuilder: (context, _) => const Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                          ),
                                          onRatingUpdate: (rating) {
                                            print(rating);
                                          },
                                        ),
                                        //subtitle:Text('⭐ ${postedReview['rating']+1}', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),

                                      ),
                                      Text(postedReview['review'], style: TextStyle(fontSize: 15, color: Colors.black,),),
                                      SizedBox(height: 8),
                                      GestureDetector(
                                        onTap: () {
                                          _showReviewForm(context,postedReview['id']);
                                        },
                                        child: Container(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'Edit your review',
                                            style: TextStyle(color: Colors.blue),
                                            textAlign: TextAlign.start,
                                          ),
                                        ),
                                      )


                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (!reviewExistsForUser)
                          ElevatedButton(
                            onPressed: () {
                              _showReviewForm(context,0);
                            },
                            child: Text('Write Review'),
                          ),
                        SizedBox(height: 16),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: reviews.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.symmetric(vertical: 8.0),
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: Colors.white.withOpacity(0.4),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                              ListTile(
                                contentPadding: EdgeInsets.all(0),
                                leading: CircleAvatar(
                                  radius: 22,
                                  backgroundImage: NetworkImage(reviews[index]['profilePic']),
                                ),
                                title: Text(
                                  reviews[index]['employerName'],
                                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                                ),
                                subtitle: RatingBar.builder(
                                  initialRating:reviews[index]['rating'].toDouble(),
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  ignoreGestures: true,
                                  allowHalfRating: false,
                                  itemCount: 5,
                                  itemSize: 16,
                                  itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                                  itemBuilder: (context, _) => const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  onRatingUpdate: (rating) {
                                    print(rating);
                                  },
                                ),
                                ),
                                    Text(reviews[index]['review'], style: TextStyle(fontSize: 15, color: Colors.black)),
                                  ],),


                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showReviewForm(BuildContext context, int reviewId) {
    final _formKey = GlobalKey<FormState>();
    final _ratingController = TextEditingController();
    final _reviewController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  Text('Post a Review', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,),textAlign: TextAlign.center,),
                  SizedBox(height: 16),
                  RatingBar.builder(
                    initialRating:0.0,
                    minRating: 1,
                    direction: Axis.horizontal,
                    ignoreGestures: false,
                    allowHalfRating: false,
                    itemCount: 5,
                    itemSize: 24,
                    itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      _ratingController.text = rating.toString();
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _reviewController,
                    decoration: InputDecoration(labelText: 'Review'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a review';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _postReview(context, double.parse(_ratingController.text), _reviewController.text, reviewId);
                      }
                    },
                    child: Text('Submit'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _postReview(BuildContext context, double rating, String review, int reviewId) async {
    try {
      if(reviewId != 0) {
        await UserController.updateEmployeeRating(loggedInUserId, employeeId, rating, review, reviewId);
      } else {
        await UserController.postEmployeeRating(loggedInUserId, employeeId, rating, review);
      }
      Navigator.pop(context); // Close the review form
      Navigator.pop(context); // Close the booking dialog
      _showBookingDialog(context); // Reopen the booking dialog to show updated reviews
    } catch (error) {
      print('Error posting review: $error');
    }
  }

  Widget _buildRatingBars(double _5star, double _4star, double _3star, double _2star, double _1star) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildRatingBar('5', Colors.green, _5star),
        _buildRatingBar('4', Colors.lightGreen, _4star),
        _buildRatingBar('3', Colors.yellow, _3star),
        _buildRatingBar('2', Colors.orange, _2star),
        _buildRatingBar('1', Colors.red, _1star),
      ],
    );
  }

  Widget _buildRatingBar(String label, Color color, double percentage) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text('${label} ⭐ - ${(percentage * 100).toStringAsFixed(1)}%'),
          ),
          Expanded(
            child: LinearProgressIndicator(
              value: percentage,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }
}
