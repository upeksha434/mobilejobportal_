import 'package:mobilejobportal/utils/http_client.dart';

class FetchServices {
  final HttpClient httpClient;

  FetchServices(this.httpClient);

  Future<List<dynamic>> fetchServices(String service, String location) async {
    print('Fetching services...');
    print('Service: $service');
    print('Location: $location');
    final response = await HttpClient.getServices({
        'service': service,
        'location': location,
      },);

    if (response.statusCode == 201) {
      return response.data as List<dynamic>;
    } else {
      throw Exception('Failed to load services');
    }
  }
}
