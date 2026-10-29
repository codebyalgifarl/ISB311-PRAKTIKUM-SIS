/*
NRP     : 162024009
NAMA    : Fathur Ali Algifari
Program : Membuat aplikasi warung kopi
*/

import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../models/drink.dart';
import 'cart_page.dart';
import 'home_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // State tab yang sedang aktif
  int _selectedIndex = 0;

  // State global keranjang belanja
  final List<CartItem> _cartItems = [];

  // Daftar minuman statis sebagai pengganti database
  final List<Drink> _drinkList = const [
    Drink(
      id: 'd1',
      name: 'Espresso',
      price: 18000,
      imageUrl: 'assets/EspressoCoffe.jpg',
    ),
    Drink(
      id: 'd2',
      name: 'Americano',
      price: 20000,
      imageUrl: 'assets/AmericanoCoffe.jpg',
    ),
    Drink(
      id: 'd3',
      name: 'Matcha Latte',
      price: 25000,
      imageUrl: 'assets/MatchaLatte.jpg',
    ),
    Drink(
      id: 'd4',
      name: 'Chocolate Frappe',
      price: 28000,
      imageUrl: 'assets/ChocolateFrappe.jpg',
    ),
  ];

  // Menambah minuman ke keranjang. Jika sudah ada, cukup tambah jumlahnya.
  void _addToCart(Drink drink, int quantity) {
    setState(() {
      final index = _cartItems.indexWhere((item) => item.drink.id == drink.id);
      if (index >= 0) {
        final currentItem = _cartItems[index];
        _cartItems[index] = CartItem(
          drink: currentItem.drink,
          quantity: currentItem.quantity + quantity,
        );
      } else {
        _cartItems.add(CartItem(drink: drink, quantity: quantity));
      }
    });
  }

  // Menghapus item dari keranjang berdasarkan id minuman
  void _removeFromCart(String drinkId) {
    setState(() {
      _cartItems.removeWhere((item) => item.drink.id == drinkId);
    });
  }

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final int totalQuantity =
        _cartItems.fold(0, (sum, item) => sum + item.quantity);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          _selectedIndex == 0 ? 'Monkey Coffee - Menu' : 'Keranjang Anda',
        ),
      ),
      // IndexedStack menjaga state tiap tab, jadi teks pencarian tidak hilang
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          HomePage(
            drinkList: _drinkList,
            onAddToCart: _addToCart,
          ),
          CartPage(
            cartItems: _cartItems,
            onRemoveFromCart: _removeFromCart,
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onTabTapped,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.local_cafe),
            label: 'Menu',
          ),
          BottomNavigationBarItem(
            icon: Badge(
              label: Text('$totalQuantity'),
              isLabelVisible: totalQuantity > 0,
              child: const Icon(Icons.shopping_cart),
            ),
            label: 'Keranjang',
          ),
        ],
      ),
    );
  }
}