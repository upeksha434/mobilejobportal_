import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mobilejobportal/auth/auth.dart';
import 'package:mobilejobportal/controllers/chat_controller.dart';
import 'package:mobilejobportal/utils/http_client.dart';

import '../bottomNavigation.dart';
import '../controllers/auth_controller.dart';
import 'chat.dart';

class EmployerChatHistoryView extends StatefulWidget {
  const EmployerChatHistoryView({Key? key}) : super(key: key);

  @override
  _EmployerChatHistoryViewState createState() => _EmployerChatHistoryViewState();
}

class _EmployerChatHistoryViewState extends State<EmployerChatHistoryView> {
  final ChatController _chatController = ChatController(HttpClient());
  List<dynamic> _chatHistories = [];
  bool _isLoading = true;

  PageController pageController = PageController();
  RxInt page = 0.obs;

  @override
  void initState() {
    super.initState();
    _fetchChatHistories();
  }

  Future<void> _fetchChatHistories() async {
    try {
      final chats = await _chatController.getEmployeeChats();
      setState(() {
        _chatHistories = chats;
        _isLoading = false;
      });
    } catch (e) {
      print('Failed to fetch chat histories: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat Histories')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _chatHistories.isEmpty
          ? Center(child: Text('No chat history available.'))
          : ListView.builder(
        itemCount: _chatHistories.length,
        itemBuilder: (context, index) {
          var chat = _chatHistories[index];
          print("chat1");
          print(chat);
          var profilePicUrl = chat['OtherEndProfilePic'];
          var createdAt = DateTime.parse(chat['createdAt']);
          var formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(createdAt);

          return Card(
            child: ListTile(leading: CircleAvatar(
              backgroundImage: NetworkImage(profilePicUrl),
              onBackgroundImageError: (error, stackTrace) {
                // Handle the error
              },
            ),
              title: Text(chat['OtherEndName']),
              subtitle: Text(chat['message']),
              trailing: Text(formattedDate, style: TextStyle(fontSize: 12),),
              onTap: () {
                if(AuthController.user.roleId ==2){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatPage(
                        employerId: chat['OtherEndId'],
                        employeeId: AuthController.userId,
                      ),
                    ),
                  );
                }
                else{
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatPage(
                        employerId: AuthController.userId,
                        employeeId: chat['OtherEndId'],
                      ),
                    ),
                  );
                }
              },
            ),
          );
        },

      ),
      // bottomNavigationBar: CustomBottomNavigationBar(
      //   pageController: pageController,
      //   page: page,
      // ),
    );

  }


}
