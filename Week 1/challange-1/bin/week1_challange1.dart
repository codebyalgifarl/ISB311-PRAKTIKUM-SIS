/* 
NRP   : 162024009
NAMA  : Fathur Ali Algifari
Challenge 1
 */

import 'dart:io';

void main() {
  print('===== Latihan Input Output DART ====');

  stdout.write('Enter First Number: ');
  int angka1 = int.parse(stdin.readLineSync()!);

  stdout.write('Enter Second Number: ');
  int angka2 = int.parse(stdin.readLineSync()!);

  int sum = angka1 + angka2;
  int min = angka1 - angka2;
  int times = angka1 * angka2;
  int div = angka1 ~/ angka2;

  print('Sum is $sum');
  print('min is $min');
  print('times is $times');
  print('div is $div');
}