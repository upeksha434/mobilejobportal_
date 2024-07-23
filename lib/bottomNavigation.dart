import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final PageController pageController;
  final RxInt page;

  CustomBottomNavigationBar({required this.pageController, required this.page});

  @override
  Widget build(BuildContext context) {
    return Obx(() => BottomNavigationBar(
      backgroundColor: Colors.white60,
      currentIndex: page.value,
      onTap: (index) {
        pageController.animateToPage(index,
            duration: const Duration(milliseconds: 500), curve: Curves.ease);
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
    ));
  }
}
