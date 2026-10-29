/*
NRP     : 162024009
NAMA    : Fathur Ali Algifari
Program : Membuat aplikasi kopi kenangan
*/

import 'package:flutter/material.dart';
import '../models/drink.dart';

class DrinkDetailPage extends StatefulWidget {
  final Drink drink;
  final void Function(Drink, int) onAddToCart;

  const DrinkDetailPage({
    super.key,
    required this.drink,
    required this.onAddToCart,
  });

  @override
  State<DrinkDetailPage> createState() => _DrinkDetailPageState();
}

class _DrinkDetailPageState extends State<DrinkDetailPage> {
  int _quantity = 1;

  void _changeQuantity(int delta) {
    final next = _quantity + delta;
    if (next < 1 || next > 20) return;
    setState(() {
      _quantity = next;
    });
  }

  void _addToCart() {
    widget.onAddToCart(widget.drink, _quantity);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final drink = widget.drink;
    final primary = Theme.of(context).colorScheme.primary;
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: Padding(
          padding: const EdgeInsets.all(6),
          child: CircleAvatar(
            backgroundColor: Colors.white.withAlpha(230),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          // Gambar produk dengan Hero Animation
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 340,
            child: Hero(
              tag: 'drink-${drink.id}',
              child: drink.buildImage(width: double.infinity, height: 340),
            ),
          ),

          // Panel Informasi Detail Minuman
          Positioned(
            top: 300,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.fromLTRB(24, 28, 24, 16 + bottomInset),
              decoration: const BoxDecoration(
                color: Color(0xFFFFF8F3),
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    drink.name,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    formatRupiah(drink.price),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Diracik dari biji kopi pilihan dan disajikan segar '
                    'setiap hari. Cocok menemani harimu, kapan pun kamu '
                    'butuh teman bercerita.',
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.5,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const Spacer(),

                  // Pemilih Jumlah Porsi (Quantity Selector)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Jumlah',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton.outlined(
                            onPressed: _quantity > 1
                                ? () => _changeQuantity(-1)
                                : null,
                            icon: const Icon(Icons.remove),
                          ),
                          SizedBox(
                            width: 48,
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 200),
                              transitionBuilder: (child, animation) {
                                return ScaleTransition(
                                  scale: animation,
                                  child: FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  ),
                                );
                              },
                              child: Text(
                                '$_quantity',
                                key: ValueKey(_quantity),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                          IconButton.filled(
                            onPressed: _quantity < 20
                                ? () => _changeQuantity(1)
                                : null,
                            icon: const Icon(Icons.add),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: _addToCart,
                    icon: const Icon(Icons.shopping_bag_outlined),
                    label: Text(
                      'Tambah • ${formatRupiah(drink.price * _quantity)}',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}