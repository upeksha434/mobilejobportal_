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
                itemCount: _services.length,
                itemBuilder: (context, index) {
                  var service = _services[index];
                  var serviceName = service['fname'] ?? 'No name';
                  var serviceRate = service['hourlyRate']?. toString() ?? 'No rate';
                  var serviceDescription = service['profileDescription'] ?? 'No description available';
                  var imageUrl = service['profilePic'] ?? 'https://myjopportal-sem6.s3.eu-north-1.amazonaws.com/3da39-no-user-image-icon-27.webp'; // Default image

                  return Card(
                    child: ListTile(
                      leading: Image.network(
                        imageUrl,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.network(
                            'https://myjopportal-sem6.s3.eu-north-1.amazonaws.com/3da39-no-user-image-icon-27.webp',
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                      title: Text(serviceName),
                      subtitle: Text('$serviceRate rs/hour'),
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
                    ),
                  );
                },
              ),
            )


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
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search for a service',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
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
    );
  }
}

