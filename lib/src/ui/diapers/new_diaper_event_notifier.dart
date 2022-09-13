import 'package:bebe/src/data/events/event.dart';
import 'package:bebe/src/ui/history/providers.dart';
import 'package:bebe/src/ui/kids/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

class CustomValidationMessage {
  static const String dateLessThanNow = 'dateLessThaNow';
}

class CustomValidationMessageDefaults {
  static const String dateLessThanNow = 'must be less than or equal to today';
}

class CustomFormValidators {
  static Map<String, Object?>? dateLessThanNow(
      AbstractControl<Object?> control) {
    final value = control.value as DateTime?;

    if (value != null && value.isAfter(DateTime.now())) {
      return {CustomValidationMessage.dateLessThanNow: true};
    }
    return null;
  }
}

class NewDiaperEventNotifier extends StateNotifier<AsyncValue<DiaperEvent?>> {
  final form = FormGroup({
    'diaperType': FormControl<DiaperType>(
      validators: [Validators.required],
    ),
    'createdAt': FormControl<DateTime>(
      validators: [Validators.required, CustomFormValidators.dateLessThanNow],
      value: DateTime.now(),
    ),
  });

  final Ref ref;

  NewDiaperEventNotifier(this.ref) : super(const AsyncValue.data(null));

  Future<void> create() async {
    if (!form.valid) {
      form.markAllAsTouched();
      return;
    }

    final currentKid = await ref.read(currentKidProvider.future);
    final repo = ref.read(eventRepositoryProvider);

    final input = DiaperEventInput(
      kidId: currentKid.id,
      diaperType: form.value['diaperType'] as DiaperType,
      createdAt: form.value['createdAt'] as DateTime,
    );

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => repo.createDiaperEvent(input),
    );
  }
}
