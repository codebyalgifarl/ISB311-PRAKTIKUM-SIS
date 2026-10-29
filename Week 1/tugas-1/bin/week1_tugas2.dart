/*
Nama    : Fathur Ali Algifari
NRP     : 162024009
Program : Simulasi Hitung Mundur Peluncuran Roket
*/

Future<void> hitungMundur() async {
  print('Memulai hitung mundur...');
  
  for (int i = 5; i >= 1; i--) {
    print(i);
    await Future.delayed(Duration(seconds: 1));
  }
  print('Hitung Selesai!');
}

void main() async {
  await hitungMundur();
}