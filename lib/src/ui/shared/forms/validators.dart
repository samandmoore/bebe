import 'package:reactive_forms/reactive_forms.dart';

class FormValidationMessage {
  static const String dateLessThanNow = 'dateLessThaNow';
}

class FormValidationMessageDefaults {
  static const String dateLessThanNow = 'must be less than or equal to today';
}

class FormValidators {
  static Map<String, Object?>? dateLessThanNow(
      AbstractControl<Object?> control) {
    final value = control.value as DateTime?;

    if (value != null && value.isAfter(DateTime.now())) {
      return {FormValidationMessage.dateLessThanNow: true};
    }
    return null;
  }
}
