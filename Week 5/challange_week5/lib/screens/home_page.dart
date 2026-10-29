/*
NRP     : 162024009
NAMA    : Fathur Ali Algifari
Program : Membuat aplikasi kopi kenangan
*/

import 'package:flutter/material.dart';
import '../main.dart';
import '../models/drink.dart';
import 'drink_detail_page.dart';

class HomePage extends StatefulWidget {
  final List<Drink> drinkList;
  final void Function(Drink, int) onAddToCart;
  final VoidCallback onAdd;
  final void Function(Drink) onEdit;
  final void Function(String) onDelete;

  const HomePage({
    super.key,
    required this.drinkList,
    required this.onAddToCart,
    required this.onAdd,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _searchText = '';

  void _openDetail(Drink drink) {
    Navigator.push(
      context,
      fadeSlideRoute(
        DrinkDetailPage(drink: drink, onAddToCart: widget.onAddToCart),
      ),
    );
  }

  // Tampilkan Bottom Sheet opsi Edit / Hapus saat item di-tekan lama (long press)
  void _showActions(Drink drink) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.edit_outlined),
                title: const Text('Edit menu'),
                onTap: () {
                  Navigator.pop(sheetContext);
                  widget.onEdit(drink);
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.delete_outline,
                  color: Theme.of(context).colorScheme.error,
                ),
                title: const Text('Hapus menu'),
                onTap: () {
                  Navigator.pop(sheetContext);
                  _confirmDelete(drink);
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  void _confirmDelete(Drink drink) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Hapus Menu'),
          content: Text('Yakin ingin menghapus ${drink.name}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                widget.onDelete(drink.id);
              },
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final dark = Color.lerp(primary, Colors.black, 0.3)!;

    final filteredList = widget.drinkList
        .where((drink) =>
            drink.name.toLowerCase().contains(_searchText.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/logo_kopi_kenangan.png',
              height: 28,
              errorBuilder: (_, __, ___) => const SizedBox.shrink(),
            ),
            const SizedBox(width: 8),
            const Text('Kopi Kenangan'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: widget.onAdd,
        icon: const Icon(Icons.add),
        label: const Text('Tambah Menu'),
      ),
      body: Column(
        children: [
          // Banner Banner Sapaan
          Container(
            width: double.infinity,
            margin: const EdgeInsets.fromLTRB(16, 4, 16, 12),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [primary, dark],
              ),
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: primary.withAlpha(70),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Halo, Para Mantan!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Mau ngopi apa hari ini?',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.coffee_rounded,
                  size: 48,
                  color: Colors.white.withAlpha(220),
                ),
              ],
            ),
          ),

          // Kolom Input Pencarian
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Cari Minuman',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  _searchText = value;
                });
              },
            ),
          ),
          const SizedBox(height: 8),

          // List Produk / Empty State
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: filteredList.isEmpty
                  ? const _EmptyState(key: ValueKey('empty'))
                  : ListView.builder(
                      key: const ValueKey('list'),
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                      itemCount: filteredList.length,
                      itemBuilder: (context, index) {
                        final drink = filteredList[index];
                        return _DrinkCard(
                          key: ValueKey(drink.id),
                          drink: drink,
                          index: index,
                          onTap: () => _openDetail(drink),
                          onLongPress: () => _showActions(drink),
                          onQuickAdd: () => widget.onAddToCart(drink, 1),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off_rounded, size: 72, color: Colors.grey.shade400),
          const SizedBox(height: 12),
          Text(
            'Minuman tidak ditemukan',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class _DrinkCard extends StatelessWidget {
  final Drink drink;
  final int index;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final VoidCallback onQuickAdd;

  const _DrinkCard({
    super.key,
    required this.drink,
    required this.index,
    required this.onTap,
    required this.onLongPress,
    required this.onQuickAdd,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final delayStep = index > 8 ? 8 : index;

    // Animasi staggered: Setiap item muncul bertahap dari bawah
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 400 + delayStep * 90),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 28 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(18),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: onTap,
            onLongPress: onLongPress,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Hero(
                    tag: 'drink-${drink.id}',
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: drink.buildImage(width: 84, height: 84),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          drink.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          formatRupiah(drink.price),
                          style: TextStyle(
                            color: primary,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: onLongPress,
                    icon: const Icon(Icons.more_vert),
                    tooltip: 'Opsi menu',
                    visualDensity: VisualDensity.compact,
                  ),
                  IconButton.filled(
                    onPressed: onQuickAdd,
                    icon: const Icon(Icons.add_shopping_cart_rounded),
                    tooltip: 'Tambah ke keranjang',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}