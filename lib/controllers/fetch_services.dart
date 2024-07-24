import 'package:mobilejobportal/utils/http_client.dart';

class FetchServices {
  final HttpClient httpClient;

  FetchServices(this.httpClient);

  Future<List<dynamic>> fetchServices(String service, String location) async {

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

  Future<List<dynamic>> getEmployeeRating(int employeeId) async {

    final response = await HttpClient.getEmployeeRating(employeeId.toString());
    final ratings = response.data['ratings'] as List<dynamic>;
    final averageRating = response.data['averageRating'];

    return [ratings, averageRating];
    if (response.statusCode == 201) {
      print(response.data);
      print('ser');
      return response.data as List<dynamic>;
    } else {
      throw Exception('Failed to load services');
    }
  }

}
