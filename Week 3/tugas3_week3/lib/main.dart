/*
NRP     : 162024009
NAMA    : Fathur Ali Algifari
Program : Membuat aplikasi warung kopi
*/

import 'package:flutter/material.dart';
import 'package:tugas3_week3/screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Warung Monkey Coffee',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(),
    );
  }
}