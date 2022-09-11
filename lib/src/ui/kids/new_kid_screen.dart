import 'package:bebe/src/data/kids/kid.dart';
import 'package:bebe/src/ui/kids/providers.dart';
import 'package:bebe/src/ui/shared/layout.dart';
import 'package:bebe/src/ui/shared/loading_screen.dart';
import 'package:bebe/src/ui/shared/modal.dart';
import 'package:bebe/src/utilities/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:reactive_forms/reactive_forms.dart';

class NewKidNotifier extends StateNotifier<AsyncValue<Kid?>> {
  final form = FormGroup({
    'name': FormControl<String>(
      validators: [Validators.required],
    ),
    'birthDate': FormControl<DateTime>(
      validators: [Validators.required],
    ),
  });

  final Ref ref;

  NewKidNotifier(this.ref) : super(const AsyncValue.data(null));

  Future<void> create() async {
    if (!form.valid) {
      form.markAllAsTouched();
      return;
    }

    final repo = ref.read(kidRepositoryProvider);
    final input = KidInput(
      name: form.control('name').value as String,
      birthDate: form.control('birthDate').value as DateTime,
    );

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final kid = await repo.create(input);
      ref.invalidate(kidsProvider);
      return kid;
    });
  }
}

final modelProvider =
    StateNotifierProvider.autoDispose<NewKidNotifier, AsyncValue<Kid?>>(
  (ref) => NewKidNotifier(ref),
);

class NewKidScreen extends ConsumerWidget {
  static const route = '/kids/new';

  const NewKidScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(modelProvider.notifier).form;
    ref.listen<AsyncValue<Kid?>>(modelProvider, (previous, next) {
      if (next.valueOrNull != null) {
        context.pop();
      }
    });
    final isSubmitting =
        ref.watch(modelProvider.select((value) => value.isLoading));

    return Scaffold(
      appBar: AppBar(title: const Text('New Kid')),
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
                        onPressed: () {
                          final model = ref.read(modelProvider.notifier);
                          model.create();
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
