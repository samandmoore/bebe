import 'package:flutter/material.dart';

extension MapExtensions<K, V> on Map<K, V> {
  V get(K key, V defaultValue) {
    if (containsKey(key)) {
      return this[key]!;
    }

    return defaultValue;
  }
}

extension DialogExtensions on BuildContext {
  void closeDialog() {
    Navigator.of(this).pop();
  }
}
