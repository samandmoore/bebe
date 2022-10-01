import 'package:bebe/src/data/events/event.dart';
import 'package:bebe/src/ui/providers.dart';
import 'package:bebe/src/ui/shared/forms/validators.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

enum DiaperEventResult { created, updated, deleted }

class DiaperEventNotifier
    extends StateNotifier<AsyncValue<DiaperEventResult?>> {
  final FormGroup form;
  final Ref ref;
  final DiaperEvent? event;

  DiaperEventNotifier(this.ref, this.event)
      : form = FormGroup({
          'diaperType': FormControl<DiaperType>(
            validators: [Validators.required],
            value: event?.diaperType,
          ),
          'startedAt': FormControl<DateTime>(
            validators: [Validators.required, FormValidators.dateLessThanNow],
            value: event?.startedAt.toLocal() ?? DateTime.now(),
          ),
        }),
        super(const AsyncValue.data(null));

  bool get isEdit => event != null;

  bool get canDelete => event != null;

  Future<void> save() async {
    if (!form.valid) {
      form.markAllAsTouched();
      return;
    }

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final action = event != null ? _update : _create;
      return await action();
    });
  }

  Future<void> delete() async {
    final repo = ref.read(eventRepositoryProvider);

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final result = await repo.delete(event!.id);
      return result.map(
        success: (_) => DiaperEventResult.deleted,
        error: (e) => throw e,
        validationError: (e) => throw e,
      );
    });
  }

  Future<DiaperEventResult> _update() async {
    final repo = ref.read(eventRepositoryProvider);

    final event = this.event!;

    final input = DiaperEventUpdate(
      id: event.id,
      kidId: event.kidId,
      diaperType: form.value['diaperType'] as DiaperType,
      startedAt: (form.value['startedAt'] as DateTime).toUtc(),
    );

    final result = await repo.updateDiaperEvent(input);

    return result.map(
      success: (_) => DiaperEventResult.updated,
      error: (e) => throw e,
      validationError: (e) => throw e,
    );
  }

  Future<DiaperEventResult> _create() async {
    final currentKid = await ref.read(currentKidProvider.future);
    final repo = ref.read(eventRepositoryProvider);

    final input = DiaperEventInput(
      kidId: currentKid.id,
      diaperType: form.value['diaperType'] as DiaperType,
      startedAt: (form.value['startedAt'] as DateTime).toUtc(),
    );

    final result = await repo.createDiaperEvent(input);
    return result.map(
      success: (_) => DiaperEventResult.created,
      error: (e) => throw e,
      validationError: (e) => throw e,
    );
  }
}
