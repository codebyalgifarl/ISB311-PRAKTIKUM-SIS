/*
NRP     : 162024009
NAMA    : Fathur Ali Algifari
Program : Membuat aplikasi warung kopi
*/

import 'package:flutter/material.dart';
import '../models/drink.dart';
import 'add_product.dart';
import 'drink_detail_page.dart';

class HomePage extends StatefulWidget {
  final List<Drink> drinkList;
  final Function(Drink, int) onAddToCart;

  const HomePage({
    super.key,
    required this.drinkList,
    required this.onAddToCart,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String searchText = "";

  void _quickOrder(Drink drink) {
    // Pesan cepat: langsung tambah 1 porsi ke keranjang
    widget.onAddToCart(drink, 1);
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${drink.name} telah ditambahkan ke keranjang.'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = widget.drinkList
        .where((drink) => drink.name.toLowerCase().contains(searchText))
        .toList();

    // Scaffold dipakai di sini hanya agar HomePage bisa punya floatingActionButton.
    // AppBar dan BottomNavigationBar tetap berada di MainScreen.
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigasi ke halaman tambah produk
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddProductPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
                labelText: 'Cari Minuman',
              ),
              onChanged: (value) {
                setState(() {
                  searchText = value.toLowerCase();
                });
              },
            ),
          ),
          Expanded(
            child: filteredList.isEmpty
                ? const Center(child: Text('Minuman tidak ditemukan.'))
                : ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      final drink = filteredList[index];
                      return Container(
                        padding: const EdgeInsets.all(8.0),
                        margin: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue[100],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Image.asset(
                              drink.imageUrl,
                              width: 48,
                              height: 48,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.local_cafe, size: 40),
                            ),
                          ),
                          title: Text(
                            drink.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            'Rp ${drink.price}',
                            style: TextStyle(
                              color: Colors.green[700],
                              fontSize: 15,
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DrinkDetailPage(
                                        drink: drink,
                                        onAddToCart: widget.onAddToCart,
                                      ),
                                    ),
                                  );
                                },
                                child: const Text('Detail'),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: () => _quickOrder(drink),
                                child: const Text('Pesan'),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}