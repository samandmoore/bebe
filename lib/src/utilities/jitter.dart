import 'dart:math';

Future<int> jitter() {
  final random = Random();
  final delay = random.nextInt(2000) + 300;
  return Future.delayed(Duration(milliseconds: delay), () => delay);
}
