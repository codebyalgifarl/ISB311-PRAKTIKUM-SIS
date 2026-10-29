/*
Nama    : Fathur Ali Algifari
NRP     : 162024009
Program : Membuat program untuk menampilkan daftar nama mahasiswa
*/

import 'dart:io';

void main() {
stdout.write("Masukkan jumlah Mahasiswa: ");
int jumlah = int.parse(stdin.readLineSync()!);

List<String> daftarMahasiswa = [];

  for (int i = 0; i < jumlah; i++) {
    stdout.write("Masukkan nama mahasiswa ke-${i + 1}: ");
    String nama = stdin.readLineSync()!;
    daftarMahasiswa.add(nama);  
  }
 
  print("\nDaftar Nama Mahasiswa:");
  for (int i = 0; i < daftarMahasiswa.length; i++) {
    print("${i + 1}. ${daftarMahasiswa[i]}");
  }

  print("Total Jumlah Mahasiswa: ${daftarMahasiswa.length}");
}