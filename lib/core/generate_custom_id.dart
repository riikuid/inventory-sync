import 'dart:math';

String generateCustomId(String prefix) {
  // 1. Ambil Unix Timestamp dalam milidetik
  int timestamp = DateTime.now().millisecondsSinceEpoch;

  // 2. Generate 4 digit random string (angka dan huruf)
  const chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz0123456789';
  Random rnd = Random();
  String randomStr = String.fromCharCodes(
    Iterable.generate(4, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))),
  );

  // 3. Gabungkan sesuai format
  return '$prefix-$timestamp-$randomStr';
}
