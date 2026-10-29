/*
NRP     : 162024009
NAMA    : Fathur Ali Algifari
Program : Membuat aplikasi kopi kenangan
*/

import 'drink.dart';

class CartItem {
  Drink drink;
  int quantity;

  CartItem({
    required this.drink,
    this.quantity = 1,
  });

  int get subtotal => drink.price * quantity;
}