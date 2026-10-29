/*
NRP     : 162024009
NAMA    : Fathur Ali Algifari
Program : Membuat aplikasi kopi kenangan
*/

import 'package:flutter/material.dart';
import '../main.dart';
import '../models/cart_item.dart';
import '../models/drink.dart';
import 'add_product.dart';
import 'cart_page.dart';
import 'edit_product.dart';
import 'home_page.dart';

/// Container utama aplikasi yang menghubungkan tab Menu dan Keranjang.
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final List<CartItem> _cartItems = [];

  // Data sampel awal menu Kopi Kenangan
  final List<Drink> _drinkList = [
    const Drink(
      id: 'd1',
      name: 'Kopi Kenangan Mantan',
      price: 22000,
      imageUrl: 'assets/kopi_kenangan_mantan.png',
    ),
    const Drink(
      id: 'd2',
      name: 'Cappuccino',
      price: 24000,
      imageUrl: 'assets/cappucino.png',
    ),
    const Drink(
      id: 'd3',
      name: 'Spanish Latte',
      price: 21000,
      imageUrl: 'assets/spanish_latte.png',
    ),
    const Drink(
      id: 'd4',
      name: 'Oatside Matcha Latte',
      price: 27000,
      imageUrl: 'assets/oatside_matcha_latte.png',
    ),
    const Drink(
      id: 'd5',
      name: 'Milk Oreo Crumble',
      price: 29000,
      imageUrl: 'assets/milk_oreo_crumble.png',
    ),
  ];

  int get _cartCount =>
      _cartItems.fold(0, (total, item) => total + item.quantity);

  // ================= Operasi CRUD Menu =================

  void _addProduct(Drink newDrink) {
    setState(() {
      _drinkList.add(newDrink);
    });
  }

  void _updateProduct(Drink updatedDrink) {
    setState(() {
      final index = _drinkList.indexWhere((d) => d.id == updatedDrink.id);
      if (index != -1) _drinkList[index] = updatedDrink;

      // Sinkronisasi pembaruan nama/harga ke item yang sudah ada di keranjang
      for (final item in _cartItems) {
        if (item.drink.id == updatedDrink.id) {
          item.drink = updatedDrink;
        }
      }
    });
  }

  void _deleteProduct(String id) {
    setState(() {
      _drinkList.removeWhere((d) => d.id == id);
      _cartItems.removeWhere((item) => item.drink.id == id);
    });
  }

  void _navigateToAddPage() {
    Navigator.push(
      context,
      fadeSlideRoute(AddProductPage(onSave: _addProduct)),
    );
  }

  void _navigateToEditPage(Drink drinkToEdit) {
    Navigator.push(
      context,
      fadeSlideRoute(
        EditProductPage(existingDrink: drinkToEdit, onSave: _updateProduct),
      ),
    );
  }

  // ================= Operasi Keranjang =================

  void _addToCart(Drink drink, int quantity) {
    setState(() {
      final existingIndex =
          _cartItems.indexWhere((item) => item.drink.id == drink.id);

      if (existingIndex != -1) {
        _cartItems[existingIndex].quantity += quantity;
      } else {
        _cartItems.add(CartItem(drink: drink, quantity: quantity));
      }
    });

    final scheme = Theme.of(context).colorScheme;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: scheme.inverseSurface,
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          duration: const Duration(seconds: 2),
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.greenAccent),
              const SizedBox(width: 12),
              Expanded(
                child: Text('$quantity× ${drink.name} masuk keranjang'),
              ),
            ],
          ),
        ),
      );
  }

  void _changeQuantity(String drinkId, int delta) {
    setState(() {
      final index = _cartItems.indexWhere((item) => item.drink.id == drinkId);
      if (index == -1) return;

      final newQuantity = _cartItems[index].quantity + delta;
      if (newQuantity <= 0) {
        _cartItems.removeAt(index);
      } else {
        _cartItems[index].quantity = newQuantity;
      }
    });
  }

  void _removeFromCart(String drinkId) {
    setState(() {
      _cartItems.removeWhere((item) => item.drink.id == drinkId);
    });
  }

  void _clearCart() {
    setState(() {
      _cartItems.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack mempertahankan posisi scroll dan state tiap tab
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          HomePage(
            drinkList: _drinkList,
            onAddToCart: _addToCart,
            onAdd: _navigateToAddPage,
            onEdit: _navigateToEditPage,
            onDelete: _deleteProduct,
          ),
          CartPage(
            cartItems: _cartItems,
            onChangeQuantity: _changeQuantity,
            onRemove: _removeFromCart,
            onClear: _clearCart,
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() => _selectedIndex = index);
        },
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.local_cafe_outlined),
            selectedIcon: Icon(Icons.local_cafe),
            label: 'Menu',
          ),
          NavigationDestination(
            icon: Badge(
              isLabelVisible: _cartCount > 0,
              label: Text('$_cartCount'),
              child: const Icon(Icons.shopping_bag_outlined),
            ),
            selectedIcon: Badge(
              isLabelVisible: _cartCount > 0,
              label: Text('$_cartCount'),
              child: const Icon(Icons.shopping_bag),
            ),
            label: 'Keranjang',
          ),
        ],
      ),
    );
  }
}