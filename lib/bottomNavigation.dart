import 'package:flutter/material.dart';
import 'package:mobilejobportal/views/employerChatHistoryView.dart';
import 'package:unicons/unicons.dart';
import 'package:mobilejobportal/layout.dart';
import 'package:mobilejobportal/views/profile.dart';

class CustomBottomNavigationBar extends StatefulWidget{
  @override

  _CustomBottomNavigationBar createState() => _CustomBottomNavigationBar();
}
class _CustomBottomNavigationBar extends State<CustomBottomNavigationBar>{
  int _currentIndex = 0;
  final List<Widget> _screens =[
    Layout(),
    Profile(),
    EmployerChatHistoryView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:_screens[_currentIndex],
      bottomNavigationBar:BottomNavigationBar(
      backgroundColor: Colors.white60,
      currentIndex:_currentIndex,

      onTap: (index) {
        setState(() {
          _currentIndex = index;
          print('$index index');

        });
      },
      elevation: 1,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(UniconsLine.rss_alt),
          label: 'Services',

        ),
        BottomNavigationBarItem(
          icon: Icon(UniconsLine.user_square),
          label: 'Profile',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.subscriptions),
          label: 'Submissions2',
        ),
      ],
      selectedItemColor: const Color(0xff2772F0),
      unselectedItemColor: Colors.grey,

    ),
    );
  }

}
