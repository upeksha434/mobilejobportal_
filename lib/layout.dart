import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobilejobportal/utils/http_client.dart';
import 'package:mobilejobportal/controllers/fetch_services.dart';
import 'package:mobilejobportal/views/service_detail_page.dart';

class Layout extends StatefulWidget {
  @override
  _LayoutState createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
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
        title: Text('Odd Job Portal'),
        backgroundColor: Colors.lightBlueAccent,
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
                    child: Card(
                      margin: EdgeInsets.zero, // Remove margin around the card
                      child: Container(
                        height: 150, // Adjust this value to increase the height of each card
                        padding: EdgeInsets.all(8), // Adjust padding inside the container
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
                                      Container(
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
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
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
      
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerRight, // Aligns the container to the right
            child: Container(
              height: 150,
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
            height: 40, // Adjust the height of the search bar
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                hintText: 'Search for a service',
                hintStyle: TextStyle(fontSize: 16,color: Color(0xFF9586A8)),
                prefixIcon: Icon(Icons.search, color: Colors.black),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(40.0),
                  borderSide: BorderSide(color: Color(0xFFD9D0E3),width: 40),
                ),
                fillColor: Colors.white,
                filled: true,
              ),
            ),
          ),
          SizedBox(height: 10),
          Row(

            //height of the row
            children: [
              Expanded(
                flex: 2,

                child: Container(
                  height: 40, // Adjust this value to change the height of the dropdown button container
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                        border: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFD9D0E3),width: 2.5),
                        borderRadius: BorderRadius.circular(40.0),

                      ),
                      prefixIcon: Icon(Icons.location_on,color: Colors.black,),

                      fillColor: Colors.white,
                      filled: true,
                    ),
                    hint: Text('Select location', style: TextStyle(fontSize: 16, color: Color(0xFF9586A8)),),
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
                flex: 1,  // Adjust this value to change the width of the search button
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
            ],
          ),

        ],
      ),
    );
  }
}
