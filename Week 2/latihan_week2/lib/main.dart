/*
Nama : Fathur Ali Algifari
NRP  : 162024009
Program : Membuat halaman profil 
*/

import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';

void main() {
  runApp(
    DevicePreview(
      builder: (context) => const MyApp(),
    ),
  );    
}

// MyApp (StatelessWidget) 
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Challenge Week 2 - Profile Page',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const ProfilePage(),
    );
  }
}

// Halaman Profil 
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  // Warna placeholder abu-abu seperti pada desain
  static final Color placeholderColor = Colors.grey.shade700;

  // Widget untuk satu kolom statistik (angka + label)
  Widget buildStat(String angka, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          angka,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  // Widget untuk tombol aksi (Edit Profile / Share Profile)
  Widget buildActionButton(String text) {
    return Expanded(
      child: Container(
        height: 36,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //  Username 
            const Padding(
              padding: EdgeInsets.fromLTRB(18, 18, 18, 6),
              child: Text(
                '_algifarl',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.2,
                  color: Colors.black,
                ),
              ),
            ),

            //  Header: foto profil + statistik 
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 8, 18, 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Foto profil berbentuk lingkaran
                  Container(
                    width: 92,
                    height: 92,
                    decoration: BoxDecoration(
                      color: placeholderColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 20),
                  // Statistik: Posts, Followers, Following
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(child: buildStat('400', 'Posts')),
                        Expanded(child: buildStat('679M', 'Followers')),
                        Expanded(child: buildStat('637', 'Following')),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ---------- Baris tombol aksi ----------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  buildActionButton('Edit Profile'),
                  buildActionButton('Share Profile'),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Ikon tambah (+) 
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: placeholderColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.add, color: Colors.white),
              ),
            ),

            const SizedBox(height: 12),

            // Ikon grid dengan garis bawah 
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.grid_on, color: placeholderColor),
                  Container(
                    width: 28,
                    height: 2,
                    color: placeholderColor,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Galeri postingan (3 kolom) 
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.zero,
                itemCount: 6,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // 3 kolom
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                ),
                itemBuilder: (context, index) {
                  return Container(color: placeholderColor);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}