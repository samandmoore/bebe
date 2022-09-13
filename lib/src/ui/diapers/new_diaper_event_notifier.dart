import 'package:bebe/src/data/events/event.dart';
import 'package:bebe/src/ui/history/providers.dart';
import 'package:bebe/src/ui/kids/providers.dart';
import 'package:bebe/src/ui/shared/forms/validators.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

class NewDiaperEventNotifier extends StateNotifier<AsyncValue<DiaperEvent?>> {
  final form = FormGroup({
    'diaperType': FormControl<DiaperType>(
      validators: [Validators.required],
    ),
    'createdAt': FormControl<DateTime>(
      validators: [Validators.required, FormValidators.dateLessThanNow],
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
