/* 
NRP   : 162024009
NAMA  : Fathur Ali Algifari
Challenge 3
 */

String KategoriUsia(int umur) {
  if (umur < 18) {
    return 'Anak-anak';
  } else if (umur < 60) {
    return 'Dewasa';
  } else {
    return 'Lansia';
  }
}

void main() {

  print('Usia 15 termasuk kategori: ${KategoriUsia(15)}');
  print('Usia 25 termasuk kategori: ${KategoriUsia(25)}');
  print('Usia 65 termasuk kategori: ${KategoriUsia(65)}');
}