import 'package:flutter/material.dart';
import 'package:new_flutter_project/screens/home_screen.dart';

import 'screens/auth/sign_up_screen.dart';

// import 'screens/home_screen.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Medical Care',
      theme: ThemeData(
        // primaryColor: const Color(0xff372948),
        primarySwatch: Colors.brown,
      ),
      home: const HomeScreen(),
    );
  }
}
