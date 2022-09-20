import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

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

extension FormGroupExtensions on FormGroup {
  /// Sets the errors for the controls in the form group.
  /// The errors are expected to be in the format of:
  /// {
  ///   'controlName': 'invalid',
  ///   'controlName2': 'too_short',
  /// }
  void setErrorsForControls(Map<String, String> errors) {
    errors.forEach((controlName, error) {
      controls[controlName]?.setErrors(<String, Object>{error: true});
    });
  }
}
