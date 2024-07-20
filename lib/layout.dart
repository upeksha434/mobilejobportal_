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
        backgroundColor: Color(0xFFD9D2E2),
      ),
      body: Container(
        color: Color(0xFFD9D2E2),
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
                              width: 180, // Adjust this value to increase the width of the image
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
                                        width: 70,
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
                                      SizedBox(width: 20),
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 9),
                                        width: 70,
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
      padding: const EdgeInsets.all(5.0),

      child: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search for a service',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(40.0),
                ),
                fillColor: Colors.white,
                filled: true,
              ),
            ),
            SizedBox(height: 10),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                prefixIcon: Icon(Icons.location_on),
                fillColor: Colors.white,
                filled: true,
              ),
              hint: Text('Select location'),
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
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _performSearch,
              child: Text('Search'),
            ),
          ],
        ),
      ),
    );
  }
}
