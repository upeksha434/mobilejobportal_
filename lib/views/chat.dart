import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mobilejobportal/controllers/chat_controller.dart';
import 'package:mobilejobportal/utils/http_client.dart';

class ChatPage extends StatefulWidget {
  final int employerId;
  final int employeeId;

  ChatPage({required this.employerId, required this.employeeId});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatController _chatController = ChatController(HttpClient());
  List<Map<String, dynamic>> _messages = [];

  @override
  void initState() {
    super.initState();
    // Fetch initial chat history here if needed
  }

  void _sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      // Send the message using the controller
      try {
        await _chatController.sendMessages(widget.employerId, widget.employeeId, _messageController.text);

        // Add the message to the local list for display
        setState(() {
          _messages.add({
            'sender': 'me', // or loggedInUserId
            'message': _messageController.text,
            'timestamp': DateTime.now(),
          });
        });

        // Clear the input field
        _messageController.clear();
      } catch (e) {
        // Handle the error
        print('Failed to send message: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
        backgroundColor: Color(0xFFD9D2E2),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(10.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                var message = _messages[index];
                return Align(
                  alignment: message['sender'] == 'me'
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 5.0),
                    padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                    decoration: BoxDecoration(
                      color: message['sender'] == 'me'
                          ? Colors.blueAccent
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Text(
                      message['message'],
                      style: TextStyle(color: message['sender'] == 'me' ? Colors.white : Colors.black),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    ),
                  ),
                ),
                SizedBox(width: 10.0),
                FloatingActionButton(
                  onPressed: _sendMessage,
                  child: Icon(Icons.send),
                  backgroundColor: Colors.blueAccent,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
