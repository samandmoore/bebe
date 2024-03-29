import 'package:bebe/src/data/events/event.dart';
import 'package:bebe/src/ui/providers.dart';
import 'package:bebe/src/ui/shared/forms/validators.dart';
import 'package:bebe/src/utilities/extensions.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

/// A model for the diaper event screen.
/// (don't really know what to call this, but "model" seems okay)
class DiaperEventModel {
  final Ref ref;
  final FormGroup form;
  final DiaperEvent? event;

  DiaperEventModel(this.ref, this.event)
      : form = FormGroup({
          'diaperType': FormControl<DiaperType>(
            validators: [Validators.required],
            value: event?.diaperType,
          ),
          'startedAt': FormControl<DateTime>(
            validators: [Validators.required, FormValidators.dateLessThanNow],
            value: event?.startedAt.toLocal() ?? DateTime.now(),
          ),
        });

  bool get isEdit => event != null;
  bool get canDelete => event != null;

  Future<bool> save() async {
    if (!form.valid) {
      form.markAllAsTouched();
      return false;
    }

    final action = event != null ? _update : _create;
    return await action();
  }

  Future<void> delete() async {
    final repo = ref.read(eventRepositoryProvider);

    final result = await repo.delete(event!.id);
    return result.unwrapOrThrow();
  }

  Future<bool> _update() async {
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
      success: (_) => true,
      error: (e) => throw e,
      validationError: (errors) {
        form.setErrorsForControls(errors);
        return false;
      },
    );
  }

  Future<bool> _create() async {
    final currentKid = await ref.read(currentKidProvider.future);
    final repo = ref.read(eventRepositoryProvider);

    final input = DiaperEventInput(
      kidId: currentKid.id,
      diaperType: form.value['diaperType'] as DiaperType,
      startedAt: (form.value['startedAt'] as DateTime).toUtc(),
    );

    final result = await repo.createDiaperEvent(input);
    return result.map(
      success: (_) => true,
      error: (e) => throw e,
      validationError: (errors) {
        form.setErrorsForControls(errors);
        return false;
      },
    );
  }
}
