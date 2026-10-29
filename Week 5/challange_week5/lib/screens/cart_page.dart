/*
NRP     : 162024009
NAMA    : Fathur Ali Algifari
Program : Membuat aplikasi kopi kenangan
*/

import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../models/drink.dart';

class CartPage extends StatelessWidget {
  final List<CartItem> cartItems;
  final void Function(String drinkId, int delta) onChangeQuantity;
  final void Function(String drinkId) onRemove;
  final VoidCallback onClear;

  const CartPage({
    super.key,
    required this.cartItems,
    required this.onChangeQuantity,
    required this.onRemove,
    required this.onClear,
  });

  int get _total => cartItems.fold(0, (sum, item) => sum + item.subtotal);
  int get _totalQuantity =>
      cartItems.fold(0, (sum, item) => sum + item.quantity);

  void _checkout(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Konfirmasi Pesanan'),
          content: Text(
            'Pesan $_totalQuantity item dengan total ${formatRupiah(_total)}?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                onClear();
                _showSuccessDialog(context);
              },
              child: const Text('Pesan Sekarang'),
            ),
          ],
        );
      },
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: const Duration(milliseconds: 700),
                curve: Curves.elasticOut,
                builder: (context, value, child) {
                  return Transform.scale(scale: value, child: child);
                },
                child: const Icon(
                  Icons.check_circle_rounded,
                  size: 84,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Pesanan Berhasil',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              const Text(
                'Terima kasih! Pesananmu sedang disiapkan.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Keranjang')),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: cartItems.isEmpty
            ? const _EmptyCart(key: ValueKey('empty'))
            : Column(
                key: const ValueKey('filled'),
                children: [
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        final item = cartItems[index];
                        // Mengusap ke kiri untuk menghapus item
                        return Dismissible(
                          key: ValueKey(item.drink.id),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.only(right: 24),
                            alignment: Alignment.centerRight,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.error,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Icon(
                              Icons.delete_outline,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          onDismissed: (_) => onRemove(item.drink.id),
                          child: _CartTile(
                            item: item,
                            onChangeQuantity: onChangeQuantity,
                          ),
                        );
                      },
                    ),
                  ),
                  _SummaryPanel(
                    total: _total,
                    onCheckout: () => _checkout(context),
                  ),
                ],
              ),
      ),
    );
  }
}

class _EmptyCart extends StatelessWidget {
  const _EmptyCart({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.shopping_bag_outlined,
            size: 90,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 12),
          const Text(
            'Keranjang masih kosong',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(
            'Yuk pilih kopi favoritmu dulu!',
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}

class _CartTile extends StatelessWidget {
  final CartItem item;
  final void Function(String drinkId, int delta) onChangeQuantity;

  const _CartTile({required this.item, required this.onChangeQuantity});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
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
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: item.drink.buildImage(width: 72, height: 72),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.drink.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  formatRupiah(item.subtotal),
                  style: TextStyle(color: primary, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton.outlined(
                visualDensity: VisualDensity.compact,
                onPressed: () => onChangeQuantity(item.drink.id, -1),
                icon: const Icon(Icons.remove, size: 18),
              ),
              SizedBox(
                width: 30,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder: (child, animation) =>
                      ScaleTransition(scale: animation, child: child),
                  child: Text(
                    '${item.quantity}',
                    key: ValueKey(item.quantity),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              IconButton.filled(
                visualDensity: VisualDensity.compact,
                onPressed: () => onChangeQuantity(item.drink.id, 1),
                icon: const Icon(Icons.add, size: 18),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryPanel extends StatelessWidget {
  final int total;
  final VoidCallback onCheckout;

  const _SummaryPanel({required this.total, required this.onCheckout});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 20,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              TweenAnimationBuilder<double>(
                tween: Tween(end: total.toDouble()),
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOut,
                builder: (context, value, _) {
                  return Text(
                    formatRupiah(value.round()),
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: primary,
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onCheckout,
            child: const Text('Checkout'),
          ),
        ],
      ),
    );
  }
}