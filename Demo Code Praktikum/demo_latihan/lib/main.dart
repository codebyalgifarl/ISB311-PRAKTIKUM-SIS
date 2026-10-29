/*
NRP     : 162024009
NAMA    : Fathur Ali Algifari
Program : Membuat aplikasi warung kopi
*/

import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:demo_latihan/screens/splash_screen.dart';

void main() {
  runApp(
    DevicePreview(
      builder: (context) => const MyApp(),
    ),
  );
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