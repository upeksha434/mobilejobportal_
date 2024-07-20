import 'package:flutter/material.dart';

class Backgrounds {
  static themeBackground() {
    return const LinearGradient(
      colors: [Color(0xff0c82df), Color(0xff334192)],
      stops: [0, 1],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }
}