/*
NRP     : 162024009
NAMA    : Fathur Ali Algifari
Program : Membuat aplikasi warung kopi
*/

import 'package:flutter/material.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  // _formKey dipakai untuk menjalankan validate() pada seluruh field sekaligus
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _hargaController = TextEditingController();
  final _deskripsiController = TextEditingController();
  final _pathController = TextEditingController();

  @override
  void dispose() {
    _namaController.dispose();
    _hargaController.dispose();
    _deskripsiController.dispose();
    _pathController.dispose();
    super.dispose();
  }

  void _simpan() {
    // Hanya validasi form. Data belum disimpan ke daftar menu
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Semua data produk valid!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Tambah Produk Baru'),
      ),
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        // ListView agar form bisa digulir saat keyboard muncul
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // 1. Nama Produk
            TextFormField(
              controller: _namaController,
              decoration: const InputDecoration(
                labelText: 'Nama Produk',
                prefixIcon: Icon(Icons.local_cafe_outlined),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Nama produk tidak boleh kosong.';
                }
                if (value.trim().length < 3) {
                  return 'Nama produk minimal 3 karakter.';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // 2. Harga
            TextFormField(
              controller: _hargaController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Harga',
                prefixIcon: Icon(Icons.payments_outlined),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Harga tidak boleh kosong.';
                }
                final price = int.tryParse(value.trim());
                if (price == null) {
                  return 'Masukkan harga dalam bentuk angka.';
                }
                if (price <= 0) {
                  return 'Harga harus lebih dari 0.';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // 3. Deskripsi Singkat 
            TextFormField(
              controller: _deskripsiController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Deskripsi Singkat',
                prefixIcon: Icon(Icons.description_outlined),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Deskripsi tidak boleh kosong.';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // 4. Path Aset Gambar
            TextFormField(
              controller: _pathController,
              decoration: const InputDecoration(
                labelText: 'Path Aset Gambar',
                hintText: 'contoh: assets/espresso.jpg',
                prefixIcon: Icon(Icons.image_outlined),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Path gambar tidak boleh kosong.';
                }
                final path = value.trim();
                if (!path.startsWith('assets/')) {
                  return "Path harus dimulai dengan 'assets/'.";
                }
                final lowerPath = path.toLowerCase();
                if (!lowerPath.endsWith('.png') &&
                    !lowerPath.endsWith('.jpg') &&
                    !lowerPath.endsWith('.jpeg')) {
                  return 'Path harus berupa file gambar (.png, .jpg).';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            // Tombol Simpan
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _simpan,
                child: const Text('Simpan', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}