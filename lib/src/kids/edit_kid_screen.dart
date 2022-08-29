import 'package:bebe/src/kids/kid.dart';
import 'package:bebe/src/kids/providers.dart';
import 'package:bebe/src/shared/extensions.dart';
import 'package:bebe/src/shared/layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:reactive_forms/reactive_forms.dart';

final _formProvider = Provider.autoDispose((ref) {
  final selectedKid = ref.watch(editingKidProvider);

  return FormGroup({
    'name': FormControl<String>(
      validators: [Validators.required],
      value: selectedKid?.name,
    ),
    'birthDate': FormControl<DateTime>(
      validators: [Validators.required],
      value: selectedKid?.birthDate,
    ),
  });
});

class EditKidScreen extends ConsumerWidget {
  static const route = '/kids/edit';

  const EditKidScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kid = ref.watch(editingKidProvider);
    final form = ref.watch(_formProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Kid')),
      body: SafeArea(
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
                            }.get(picker.control.errors.keys.first, 'Invalid'),
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
                                        .delete(kid!.id);
                                    ref.invalidate(kidsProvider);

                                    ScaffoldMessenger.of(context)
                                      ..clearSnackBars()
                                      ..showSnackBar(
                                        SnackBar(
                                          content: Text('Removed ${kid.name}.'),
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
                        if (form.valid) {
                          final repo = ref.read(kidRepositoryProvider);
                          repo.update(
                            Kid(
                              id: kid!.id,
                              name: form.control('name').value as String,
                              birthDate:
                                  form.control('birthDate').value as DateTime,
                            ),
                          );
                          ref
                            ..invalidate(kidsProvider)
                            ..invalidate(selectedKidProvider);
                          context.pop();
                        } else {
                          form.markAllAsTouched();
                        }
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
    );
  }
}
