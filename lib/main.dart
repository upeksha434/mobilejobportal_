import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobilejobportal/layout.dart';
import 'package:mobilejobportal/utils/http_client.dart';
import 'package:mobilejobportal/views/login.dart';
import 'controllers/auth_controller.dart';


void main() {
  HttpClient.initialize();
  runApp(const JobPortal());
  Timer.periodic(Duration(minutes:1), (timer){
    AuthController.checkAndLogoutIfNecessary();
  });
  //auto logout does not work
}

class JobPortal extends StatelessWidget {
  const JobPortal({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );


    return GetMaterialApp(
      title: 'Job Portal  ',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
          textTheme: GoogleFonts.aleoTextTheme(
            Theme.of(context).textTheme.copyWith(
              ),
          ),
          inputDecorationTheme: const InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          )),
      home: //LoginPage(),
      Layout(),
      getPages: [
        GetPage(name: '/views', page: () => Layout()),
      ],

    );
  }
}
