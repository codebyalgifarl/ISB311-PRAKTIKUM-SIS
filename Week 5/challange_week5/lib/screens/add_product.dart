/*
NRP     : 162024009
NAMA    : Fathur Ali Algifari
Program : Membuat aplikasi kopi kenangan
*/

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/drink.dart';

class AddProductPage extends StatefulWidget {
  final void Function(Drink) onSave;

  const AddProductPage({super.key, required this.onSave});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _imageController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nama minuman wajib diisi';
    }
    if (value.trim().length < 3) {
      return 'Nama minimal 3 karakter';
    }
    return null;
  }

  String? _validatePrice(String? value) {
    if (value == null || value.isEmpty) {
      return 'Harga wajib diisi';
    }
    final price = int.tryParse(value);
    if (price == null) {
      return 'Harga harus berupa angka';
    }
    if (price < 1000) {
      return 'Harga minimal Rp 1.000';
    }
    return null;
  }

  String? _validateImage(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final v = value.trim();
    if (!v.startsWith('http') && !v.startsWith('assets/')) {
      return 'Gunakan URL (http...) atau path assets/...';
    }
    return null;
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final newDrink = Drink(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text.trim(),
      price: int.parse(_priceController.text),
      imageUrl: _imageController.text.trim(),
    );

    widget.onSave(newDrink);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Menu')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'Nama Minuman',
                  prefixIcon: Icon(Icons.local_cafe_outlined),
                ),
                validator: _validateName,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  labelText: 'Harga',
                  prefixText: 'Rp ',
                  prefixIcon: Icon(Icons.payments_outlined),
                ),
                validator: _validatePrice,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _imageController,
                keyboardType: TextInputType.url,
                decoration: const InputDecoration(
                  labelText: 'Gambar (opsional)',
                  hintText: 'assets/espresso.jpg atau https://...',
                  prefixIcon: Icon(Icons.image_outlined),
                ),
                validator: _validateImage,
              ),
              const SizedBox(height: 28),
              ElevatedButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.save_outlined),
                label: const Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}