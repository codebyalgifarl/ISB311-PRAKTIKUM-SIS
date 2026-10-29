/*
NRP     : 162024009
NAMA    : Fathur Ali Algifari
Program : Membuat aplikasi kopi kenangan
*/

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/drink.dart';

class EditProductPage extends StatefulWidget {
  final Drink existingDrink;
  final void Function(Drink) onSave;

  const EditProductPage({
    super.key,
    required this.existingDrink,
    required this.onSave,
  });

  @override
  State<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _priceController;
  late final TextEditingController _imageController;

  @override
  void initState() {
    super.initState();
    // Mengisi nilai awal form dari objek existingDrink
    _nameController = TextEditingController(text: widget.existingDrink.name);
    _priceController =
        TextEditingController(text: widget.existingDrink.price.toString());
    _imageController =
        TextEditingController(text: widget.existingDrink.imageUrl);
  }

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

    final updatedDrink = widget.existingDrink.copyWith(
      name: _nameController.text.trim(),
      price: int.parse(_priceController.text),
      imageUrl: _imageController.text.trim(),
    );

    widget.onSave(updatedDrink);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Menu')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Pratinjau gambar produk saat ini
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: widget.existingDrink.buildImage(
                  width: double.infinity,
                  height: 160,
                ),
              ),
              const SizedBox(height: 20),
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
                icon: const Icon(Icons.check),
                label: const Text('Simpan Perubahan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}