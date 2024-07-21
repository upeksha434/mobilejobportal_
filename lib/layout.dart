import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobilejobportal/utils/http_client.dart';
import 'package:mobilejobportal/controllers/fetch_services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobilejobportal/views/service_detail_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobilejobportal/views/chat.dart';

import 'controllers/auth_controller.dart';

class Layout extends StatefulWidget {
  @override
  _LayoutState createState() => _LayoutState();
}


class _LayoutState extends State<Layout> {

  int loggedInUserId =AuthController.userId;


  final TextEditingController _searchController = TextEditingController();

  String _selectedLocation = '';
  List<dynamic> _services = [];
  bool _isLoading = false;

  final FetchServices fetchServices = FetchServices(HttpClient());

  void _performSearch() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final fetchedServices = await fetchServices.fetchServices(_searchController.text, _selectedLocation);
      setState(() {
        _services = fetchedServices;
        print('Fetched services: $_services');
      });
    } catch (e) {
      print('Error fetching services: $e');
      setState(() {
        _services = [];
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    PageController pageController = PageController();
    RxInt page = 0.obs;

    return Scaffold(
      appBar: AppBar(
        // title: Text('Odd Job Portal'),

        toolbarHeight: 0,
      ),
      body: Container(

        color: Color(0xFFF6F5F5),
        child: Column(
          children: [
            _buildSearchBar(),


            Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _services.isEmpty
                  ? Center(child: Text('No service provider to display.'))
                  : ListView.builder(
                padding: EdgeInsets.all(8.0),
                itemCount: _services.length,
                itemBuilder: (context, index) {
                  var service = _services[index];
                  var serviceName = service['fname'] + ' ' + service['lname'] ?? 'No name';
                  var serviceRate = service['hourlyRate']?.toString() ?? 'No rate';
                  var serviceDescription = service['profileDescription'] ?? 'No description available';
                  var averageRating = service['averageRating']?.toString();
                  var imageUrl = service['profilePic'] ?? 'https://myjopportal-sem6.s3.eu-north-1.amazonaws.com/3da39-no-user-image-icon-27.webp'; // Default image

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child:GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ServiceDetailPage(
                              serviceName: serviceName,
                              serviceDescription: serviceDescription,
                              serviceRate: serviceRate,
                              imageUrl: imageUrl,
                            ),
                          ),
                        );
                      },
                    child: Card(
                      margin: EdgeInsets.zero,
                      elevation: 2.0, // Add this line to set the elevation (shadow) of the card
                      shadowColor: Colors.grey,
                      child: Container(
                        height: 150, // Adjust this value to increase the height of each card
                        padding: EdgeInsets.all(8),
                        child: Row(
                          children: [
                            Container(
                              width: 170, // Adjust this value to increase the width of the image
                              height: 150, // Adjust this value to increase the height of the image
                              decoration: BoxDecoration(

                                borderRadius: BorderRadius.circular(8.0),
                                image: DecorationImage(
                                  image: NetworkImage(imageUrl),
                                  fit: BoxFit.cover,
                                  onError: (error, stackTrace) {
                                    setState(() {
                                      imageUrl = 'https://myjopportal-sem6.s3.eu-north-1.amazonaws.com/3da39-no-user-image-icon-27.webp';
                                    });
                                  },
                                ),
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(serviceName, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                  SizedBox(height: 10),
                                  Text('$serviceRate \$/hour',),
                                  SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                        width: 80,
                                        height : 45,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(color: Colors.grey),
                                        ),
                                        child: Column(
                                          children: [
                                            Text(
                                              '$averageRating',
                                              style: TextStyle(fontSize: 16),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      GestureDetector(
                                        onTap:(){
                                          print('Logged in user ID: $loggedInUserId');
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder:(context)=> ChatPage(

                                                employerId: loggedInUserId,
                                                employeeId: service['id'],


                                              )
                                            )
                                          );
                                        },

                                      child: Container(
                                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 9),
                                        width: 80,
                                        height : 45,
                                        decoration: BoxDecoration(
                                          color: Color(0xFF0BCE83),
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(color: Colors.transparent),
                                        ),
                                        child: Column(
                                          children: [
                                            Icon(
                                              Icons.chat_bubble_outline_sharp,
                                              color: Colors.white,
                                              size: 24.0,
                                            ),
                                          ],
                                        ),
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
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
        backgroundColor: Colors.white60,
        currentIndex: page.value,
        onTap: (index) {
          pageController.animateToPage(index,
              duration: const Duration(milliseconds: 500),
              curve: Curves.ease);
          page.value = index;
        },
        elevation: 1,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.subscriptions),
            label: 'Submissions',
          ),
        ],
        selectedItemColor: const Color(0xff2772F0),
        unselectedItemColor: Colors.grey,
      )),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: EdgeInsetsDirectional.only(top: 0.0, start: 10.0, end: 0.0),

      child: Stack(


        children: [
          Positioned(
              child: Container(
                padding: EdgeInsetsDirectional.only(top: 50), // Adjust top padding
            child: Text(
              'Services',
              style: GoogleFonts.aleo(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          )),
          // Vegetable image
          Positioned(

            right: 0,
            top:0,
            child: Container(
              height: 140,
              width: 150,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage('https://myjopportal-sem6.s3.eu-north-1.amazonaws.com/Vegetables+(1).png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
              //borderRadius: BorderRadius.circular(5.0),
             //border:BorderDirectional(bottom: BorderSide(color: Colors.grey, width: 2.0,shadow)),

            ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              // Search bar
              Container(
                padding: EdgeInsetsDirectional.only(start: 0.0, end: 10.0, top: 120), // Adjust top padding
                height: 160, // Adjust height of the search bar container
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                    hintText: 'Search for a service',
                    hintStyle: TextStyle(fontSize: 16, color: Color(0xFF9586A8)),
                    prefixIcon: Icon(Icons.search, color: Colors.black),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40.0),
                      borderSide: BorderSide(color: Color(0xFFD9D0E3), width: 2.5),
                    ),
                    fillColor: Colors.white,
                    filled: true,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      height: 40, // Adjust this value to match dropdown button height
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFD9D0E3), width: 2.5),
                            borderRadius: BorderRadius.circular(40.0),
                          ),
                          prefixIcon: Icon(Icons.location_on, color: Colors.black),
                          fillColor: Colors.white,
                          filled: true,
                        ),
                        hint: Text('Select location', style: TextStyle(fontSize: 16, color: Color(0xFF9586A8))),
                        items: <String>[
                          'Colombo',
                          'Kandy',
                          'Galle',
                          'Jaffna',
                          'Negombo',
                          'Anuradhapura',
                          'Trincomalee',
                          'Batticaloa',
                          'Matara',
                          'Nuwara Eliya',
                          'Ratnapura',
                          'Badulla',
                          'Kurunegala',
                          'Hambantota',
                          'Vavuniya',
                          'Polonnaruwa',
                          'Puttalam',
                          'Chilaw',
                          'Kalutara',
                          'Kegalle'
                        ].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedLocation = newValue ?? '';
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    flex: 1, // Adjust this value to change the width of the search button
                    child: Container(
                      padding: EdgeInsetsDirectional.only(start: 0.0, end: 10.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFE2CBFF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40.0),
                          ),
                        ),
                        onPressed: _performSearch,
                        child: Text('Search', style: TextStyle(fontSize: 16, color: Color(0xFF6C0EE4))),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox.fromSize(
                size: Size.fromHeight(10),
              )
            ],
          ),
          ),
        ],
      ),
    );
  }


}
