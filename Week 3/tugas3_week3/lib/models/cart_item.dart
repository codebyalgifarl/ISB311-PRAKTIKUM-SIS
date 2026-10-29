/*
NRP     : 162024009
NAMA    : Fathur Ali Algifari
Program : Membuat aplikasi warung kopi
*/

import 'drink.dart';

class CartItem {
  final Drink drink;
  final int quantity;

  const CartItem({
    required this.drink,
    required this.quantity,
  });

  // Total harga item (harga satuan * jumlah)
  int get subtotal => drink.price * quantity;
}