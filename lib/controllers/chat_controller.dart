import 'package:mobilejobportal/utils/http_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatController {
  late final HttpClient httpClient;

  ChatController(this.httpClient);

  Future<int> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId') ?? 0;
  }

  Future<void> sendMessages(int employerId, int employeeId, String message) async {
    print(employerId);
    print(employeeId);
    print(message);
    final userId = await _loadUserId();
    final response = await HttpClient.sendMessages({
      'employerId': employerId,
      'employeeId': employeeId,
      'message': message,
      'sender': userId,
    });
    if (response.statusCode != 201) {
      throw Exception('Failed to send message');
    }
  }
  Future<List> getMessages(int employerId, int employeeId) async{
    final response = await HttpClient.getMessages({
      'employerId': employerId,
      'employeeId': employeeId,
    });
    if (response.statusCode == 201) {
      print(response.data);

      return response.data as List<dynamic>;
    } else {
      throw Exception('Failed to load services');
    }
  }
}
