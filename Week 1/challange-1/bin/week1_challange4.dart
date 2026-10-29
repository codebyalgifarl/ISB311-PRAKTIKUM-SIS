/* 
NRP   : 162024009
NAMA  : Fathur Ali Algifari
Challenge 4
 */
  
Future<String> unduhData() async {
  await Future.delayed(Duration(seconds: 2));
  
  return 'Proses unduh data selesai';
}

void main() async {
  print('Memulai proses unduh...');
  print('Sedang mengunduh data...');

  String hasil = await unduhData();
  print(hasil);
}