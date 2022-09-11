import 'package:flutter_riverpod/flutter_riverpod.dart';

enum LiquidUnit { ml, oz }

final liquidUnitProvider = StateProvider((_) => LiquidUnit.ml);
