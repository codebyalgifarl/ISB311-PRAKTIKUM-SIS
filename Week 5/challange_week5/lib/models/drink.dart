/*
NRP     : 162024009
NAMA    : Fathur Ali Algifari
Program : Membuat aplikasi kopi kenangan
*/

import 'package:flutter/material.dart';

class Drink {
  final String id;
  final String name;
  final int price;
  final String imageUrl;

  const Drink({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
  });

  Drink copyWith({
    String? id,
    String? name,
    int? price,
    String? imageUrl,
  }) {
    return Drink(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  Widget buildImage({
    required double width,
    required double height,
    BoxFit fit = BoxFit.cover,
  }) {
    final isNetwork = imageUrl.startsWith('http://') || imageUrl.startsWith('https://');

    if (isNetwork) {
      return Image.network(
        imageUrl,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (_, __, ___) => _buildFallback(width, height),
      );
    }

    return Image.asset(
      imageUrl,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (_, __, ___) => _buildFallback(width, height),
    );
  }

  Widget _buildFallback(double width, double height) {
    return Container(
      width: width,
      height: height,
      color: Colors.grey.shade200,
      child: const Icon(
        Icons.local_cafe_rounded,
        color: Color(0xFFC62828),
        size: 32,
      ),
    );
  }
}

String formatRupiah(int number) {
  final str = number.toString();
  final buffer = StringBuffer();
  int count = 0;

  for (int i = str.length - 1; i >= 0; i--) {
    count++;
    buffer.write(str[i]);
    if (count % 3 == 0 && i != 0) {
      buffer.write('.');
    }
  }

  return 'Rp ${buffer.toString().split('').reversed.join()}';
}