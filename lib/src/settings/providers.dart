import 'package:flutter_riverpod/flutter_riverpod.dart';

enum LiquidUnits { ml, oz }

final liquidUnitsProvider = StateProvider((_) => LiquidUnits.ml);
