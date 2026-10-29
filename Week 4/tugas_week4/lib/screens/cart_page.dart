/*
NRP     : 162024009
NAMA    : Fathur Ali Algifari
Program : Membuat aplikasi warung kopi
*/

import 'package:flutter/material.dart';
import '../models/cart_item.dart';

// CartPage kini StatefulWidget karena perlu menyimpan GlobalKey<FormState>
// dan TextEditingController untuk form Nama Pemesan dan Nomor Meja.
class CartPage extends StatefulWidget {
  final List<CartItem> cartItems;
  final Function(String) onRemoveFromCart;

  const CartPage({
    super.key,
    required this.cartItems,
    required this.onRemoveFromCart,
  });

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _mejaController = TextEditingController();

  @override
  void dispose() {
    _namaController.dispose();
    _mejaController.dispose();
    super.dispose();
  }

  // Total harga dihitung dari seluruh item di keranjang
  int get _totalPrice =>
      widget.cartItems.fold(0, (sum, item) => sum + item.subtotal);

  void _checkout() {
    // Dialog hanya muncul jika SEMUA validator mengembalikan null
    if (!_formKey.currentState!.validate()) return;

    // Simpan dulu datanya sebelum form di-reset
    final nama = _namaController.text.trim();
    final meja = int.parse(_mejaController.text.trim());
    final total = _totalPrice;

    _formKey.currentState!.reset();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Checkout Berhasil'),
          content: Text(
            'Anda telah berhasil checkout dengan total belanja: Rp $total\n'
            'Atas nama: $nama\n'
            'Nomor meja: $meja',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Form hanya muncul saat keranjang berisi item
    if (widget.cartItems.isEmpty) {
      return const Center(
        child: Text(
          'Keranjang Anda kosong.',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    // Satu ListView agar seluruh halaman bisa di-scroll saat keyboard muncul
    return ListView(
      padding: const EdgeInsets.all(8),
      children: [
        ...widget.cartItems.map((item) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 4),
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.asset(
                  item.drink.imageUrl,
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.local_cafe, size: 40),
                ),
              ),
              title: Text(item.drink.name),
              subtitle: Text('${item.quantity} x Rp ${item.drink.price}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Rp ${item.subtotal}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: () => widget.onRemoveFromCart(item.drink.id),
                    icon: const Icon(Icons.delete, color: Colors.red),
                  ),
                ],
              ),
            ),
          );
        }),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Data Pemesan',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 12),

                // Nama Pemesan: validasi keberadaan
                TextFormField(
                  controller: _namaController,
                  decoration: const InputDecoration(
                    labelText: 'Nama Pemesan',
                    prefixIcon: Icon(Icons.person_outline),
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Nama Pemesan tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),

                // Nomor Meja: validasi keberadaan, format, dan batasan
                TextFormField(
                  controller: _mejaController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Nomor Meja',
                    hintText: 'contoh: 5',
                    prefixIcon: Icon(Icons.table_restaurant),
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Nomor Meja tidak boleh kosong';
                    }
                    final meja = int.tryParse(value.trim());
                    if (meja == null) {
                      return 'Nomor Meja harus berupa angka';
                    }
                    if (meja < 1 || meja > 20) {
                      return 'Nomor Meja harus antara 1-20';
                    }
                    return null;
                  },
                ),
                const Divider(height: 28),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total:', style: TextStyle(fontSize: 18)),
                    Text(
                      'Rp $_totalPrice',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _checkout,
                    child: const Text('Checkout'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}