/*
Nama    : Fathur Ali Algifari
NRP     : 162024009
Program : Menghitung Luas dan Keliling Bangun Datar
*/

import 'dart:io';

void main (){
  print("=== Menghitung Luas dan Keliling Bangun Datar ===");
  print("1. Persegi");
  print("2. Persegi Panjang");
  print("3. Segitiga");
  print("4. Lingkaran");

  stdout.write("Pilih Menu (1-4): ");
  String? pilihan = stdin.readLineSync();

  if (pilihan == "1"){
    stdout.write("\nMasukkan panjang sisi: ");
    double sisi = double.parse(stdin.readLineSync()!);
    double luas = sisi * sisi;
    double keliling = 4 * sisi;
    print("Luas Persegi: $luas");
    print("Keliling Persegi: $keliling");

  } else if (pilihan == "2"){ 
    stdout.write("Masukkan panjang: ");
    double panjang = double.parse(stdin.readLineSync()!);
    stdout.write("Masukkan lebar: ");
    double lebar = double.parse(stdin.readLineSync()!);
    double luas = panjang * lebar;
    double keliling = 2 * (panjang + lebar);
    print("Luas Persegi Panjang: $luas");
    print("Keliling Persegi Panjang: $keliling");

  } else if (pilihan == "3"){
    stdout.write("Masukkan alas: ");
    double alas = double.parse(stdin.readLineSync()!);
    stdout.write("Masukkan tinggi: ");
    double tinggi = double.parse(stdin.readLineSync()!);
    stdout.write("Masukkan sisi A: ");
    double sisiA = double.parse(stdin.readLineSync()!);
    stdout.write("Masukkan sisi B: ");
    double sisiB = double.parse(stdin.readLineSync()!);
    stdout.write("Masukkan sisi C: ");
    double sisiC = double.parse(stdin.readLineSync()!);
    double luas = 0.5 * alas * tinggi;
    double keliling = sisiA + sisiB + sisiC;
    print("Luas Segitiga: $luas");
    print("Keliling Segitiga: $keliling");

  } else if (pilihan == "4"){
    stdout.write("Masukkan jari-jari: ");
    double jariJari = double.parse(stdin.readLineSync()!);
    double luas = 3.14 * jariJari * jariJari;
    double keliling = 2 * 3.14 * jariJari;
    print("Luas Lingkaran: $luas");
    print("Keliling Lingkaran: $keliling");
  } else {
    print("Pilihan tidak valid!");
  }
}