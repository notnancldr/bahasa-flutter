import 'dart:math';

String randomChar(int length) {
  const randomChar = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
  final random = Random.secure();
  return List
    .generate(length, (index) => randomChar[random.nextInt(randomChar.length)])
    .join();
}