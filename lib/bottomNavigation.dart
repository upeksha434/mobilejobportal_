// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// class CustomBottomNavigationBar extends StatelessWidget {
//   final PageController pageController;
//   final RxInt page;
//
//   CustomBottomNavigationBar({required this.pageController, required this.page});
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Obx(() => BottomNavigationBar(
//       backgroundColor: Colors.white60,
//       currentIndex: page.value,
//
//       onTap: (index) {
//         print('$index index');
//         pageController.animateToPage(index,
//             duration: const Duration(milliseconds: 500), curve: Curves.ease);
//         page.value = index;
//       },
//       elevation: 1,
//       items: const [
//         BottomNavigationBarItem(
//           icon: Icon(Icons.person),
//           label: 'Profile',
//
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(Icons.subscriptions),
//           label: 'Submissions',
//         ),
//       ],
//       selectedItemColor: const Color(0xff2772F0),
//       unselectedItemColor: Colors.grey,
//     )
//     );
//
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
    Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:_screens[_currentIndex],
      bottomNavigationBar:BottomNavigationBar(
      backgroundColor: Colors.white60,
      //currentIndex:_currentIndex,

      onTap: (index) {
        setState(() {
          _currentIndex = index;

        });
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
