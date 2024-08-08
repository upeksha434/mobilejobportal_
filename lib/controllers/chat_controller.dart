import 'package:mobilejobportal/controllers/auth_controller.dart';
import 'package:mobilejobportal/utils/http_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatController {
  late final HttpClient httpClient;

  ChatController(this.httpClient);


  Future<void> sendMessages(int employerId, int employeeId, String message) async {
    print(employerId);
    print(employeeId);
    print(message);
    final response = await HttpClient.sendMessages({
      'employerId': employerId,
      'employeeId': employeeId,
      'message': message,
      'sender': AuthController.userId,
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

  Future<List>getEmployeeChats() async{
    print(AuthController.userId);
    print(AuthController.user.roleId);
    final response = await HttpClient.getEmployeeChatcards({
      'employeeId': AuthController.userId,
      'roleId': AuthController.user.roleId,
    });
    if (response.statusCode == 201) {
      print(response.data);

      return response.data as List<dynamic>;
    } else {
      throw Exception('Failed to load services');
    }
  }
}
