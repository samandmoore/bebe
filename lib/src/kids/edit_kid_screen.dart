import 'package:bebe/src/kids/kid.dart';
import 'package:bebe/src/kids/providers.dart';
import 'package:bebe/src/shared/extensions.dart';
import 'package:bebe/src/shared/layout.dart';
import 'package:bebe/src/shared/loading_screen.dart';
import 'package:bebe/src/shared/modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:reactive_forms/reactive_forms.dart';

class EditKidNotifier extends StateNotifier<AsyncValue<Kid?>> {
  final FormGroup form;
  final Ref ref;
  final Kid kid;

  EditKidNotifier(this.ref, {required this.kid})
      : form = FormGroup({
          'name': FormControl<String>(
            validators: [Validators.required],
            value: kid.name,
          ),
          'birthDate': FormControl<DateTime>(
            validators: [Validators.required],
            value: kid.birthDate,
          ),
        }),
        super(const AsyncValue.data(null));

  Future<void> update() async {
    if (!form.valid) {
      form.markAllAsTouched();
      return;
    }

    final repo = ref.read(kidRepositoryProvider);
    final input = Kid(
      id: kid.id,
      name: form.control('name').value as String,
      birthDate: form.control('birthDate').value as DateTime,
    );

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await repo.update(input);
      ref.invalidate(kidsProvider);
      return input;
    });
  }
}

final modelProvider =
    StateNotifierProvider.autoDispose<EditKidNotifier, AsyncValue<Kid?>>(
  (ref) {
    final editingKid = ref.watch(editingKidProvider)!;
    return EditKidNotifier(ref, kid: editingKid);
  },
  dependencies: [editingKidProvider, kidRepositoryProvider],
);

class EditKidScreen extends ConsumerWidget {
  static const route = '/kids/edit';

  const EditKidScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kid = ref.watch(editingKidProvider)!;
    final form = ref.watch(modelProvider.notifier).form;
    ref.listen<AsyncValue<Kid?>>(modelProvider, (previous, next) {
      if (next.valueOrNull != null) {
        context.pop();
      }
    });
    final isSubmitting =
        ref.watch(modelProvider.select((value) => value.isLoading));

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Kid')),
      body: Modal(
        visible: isSubmitting,
        modal: LoadingIndicator.white(),
        child: SafeArea(
          child: SingleChildScrollView(
            child: ReactiveForm(
              formGroup: form,
              child: Column(
                children: [
                  const VSpace(),
                  const Text('New Kid'),
                  const VSpace(),
                  ReactiveTextField(
                    formControlName: 'name',
                    validationMessages: (control) => {
                      ValidationMessage.required: 'Name is required',
                    },
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                    ),
                    textInputAction: TextInputAction.next,
                  ),
                  ReactiveDatePicker(
                    formControlName: 'birthDate',
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                    builder: (context, picker, child) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextButton(
                            onPressed: picker.showPicker,
                            child: Row(
                              children: [
                                const Icon(Icons.date_range),
                                if (picker.value != null)
                                  Text(picker.value!.toIso8601String()),
                                if (picker.value == null)
                                  const Text('Select Birthdate'),
                              ],
                            ),
                          ),
                          if (picker.control.hasErrors &&
                              picker.control.touched) ...[
                            const HSpace(),
                            Text(
                              {
                                ValidationMessage.required:
                                    'Birthdate is required',
                              }.get(
                                  picker.control.errors.keys.first, 'Invalid'),
                              style: const TextStyle(color: Colors.red),
                            ),
                          ]
                        ],
                      );
                    },
                  ),
                  ButtonBar(
                    children: [
                      TextButton(
                        onPressed: () {
                          context.pop();
                        },
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          showDialog<bool>(
                            context: context,
                            builder: (dialogContext) {
                              return AlertDialog(
                                content: const Text(
                                    'Are you sure you want to remove this kid?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      dialogContext.closeDialog();
                                    },
                                    child: const Text('No'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      ref
                                          .read(kidRepositoryProvider)
                                          .delete(kid.id);
                                      ref.invalidate(kidsProvider);

                                      ScaffoldMessenger.of(context)
                                        ..clearSnackBars()
                                        ..showSnackBar(
                                          SnackBar(
                                            content:
                                                Text('Removed ${kid.name}.'),
                                          ),
                                        );

                                      dialogContext.closeDialog();
                                      context.pop();
                                    },
                                    child: const Text('Yes'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(primary: Colors.red),
                        child: const Text('Remove'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          final model = ref.read(modelProvider.notifier);
                          model.update();
                        },
                        child: const Text('Save'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
