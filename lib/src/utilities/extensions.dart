import 'dart:developer';

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
  void closeDialog<T extends Object?>([T? result]) {
    Navigator.of(this).pop(result);
  }

  void logErrorAndShowSnackbar(Object? error, [StackTrace? stackTrace]) {
    log(error.toString(), stackTrace: stackTrace);

    ScaffoldMessenger.of(this)
      ..clearSnackBars()
      ..showSnackBar(
        const SnackBar(
          content: Text('An error occurred'),
        ),
      );
  }
}
