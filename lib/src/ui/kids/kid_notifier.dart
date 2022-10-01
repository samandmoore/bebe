import 'package:bebe/src/data/user/kid.dart';
import 'package:bebe/src/data/user/user_repository.dart';
import 'package:bebe/src/ui/shared/forms/validators.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

enum KidResult { created, updated, deleted }

class KidNotifier extends StateNotifier<AsyncValue<KidResult?>> {
  final FormGroup form;
  final Ref ref;
  final Kid? kid;

  KidNotifier(this.ref, this.kid)
      : form = FormGroup({
          'name': FormControl<String>(
            validators: [Validators.required],
            value: kid?.name,
          ),
          'dateOfBirth': FormControl<DateTime>(
            validators: [Validators.required, FormValidators.dateLessThanNow],
            value: kid?.dateOfBirth,
          ),
        }),
        super(const AsyncValue.data(null));

  bool get isEdit => kid != null;

  bool get canDelete => kid != null;

  Future<void> save() async {
    if (!form.valid) {
      form.markAllAsTouched();
      return;
    }

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final action = kid != null ? _update : _create;
      return await action();
    });
  }

  Future<void> delete() async {
    final repo = ref.read(userRepositoryProvider);

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final result = await repo.deleteKid(kid!.id);
      return result.map(
        success: (_) => KidResult.deleted,
        error: (error) => throw error,
        validationError: (errors) => throw errors,
      );
    });
  }

  Future<KidResult> _update() async {
    final repo = ref.read(userRepositoryProvider);

    final kid = this.kid!;

    final input = KidInput(
      name: form.control('name').value as String,
      dateOfBirth: form.control('dateOfBirth').value as DateTime,
    );

    final result = await repo.updateKid(kid.id, input);
    return result.map(
      success: (_) => KidResult.updated,
      error: (error) => throw error,
      validationError: (errors) => throw errors,
    );
  }

  Future<KidResult> _create() async {
    final repo = ref.read(userRepositoryProvider);

    final input = KidInput(
      name: form.control('name').value as String,
      dateOfBirth: form.control('dateOfBirth').value as DateTime,
    );

    final result = await repo.createKid(input);
    return result.map(
      success: (_) => KidResult.created,
      error: (error) => throw error,
      validationError: (errors) => throw errors,
    );
  }
}
