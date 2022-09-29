import 'package:bebe/src/ui/kids/new_kid_notifier.dart';
import 'package:bebe/src/ui/shared/loading.dart';
import 'package:bebe/src/ui/shared/modal.dart';
import 'package:bebe/src/ui/shared/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:reactive_date_time_picker/reactive_date_time_picker.dart';
import 'package:reactive_forms/reactive_forms.dart';

final newKidProvider = StateNotifierProvider.autoDispose<NewKidNotifier,
    AsyncValue<NewKidResult?>>(
  (ref) => NewKidNotifier(ref),
);

class NewKidScreen extends ConsumerWidget {
  static const route = '/kids/new';

  const NewKidScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(newKidProvider.notifier).form;
    ref.listen<AsyncValue<NewKidResult?>>(newKidProvider, (previous, next) {
      if (next.valueOrNull != null) {
        context.pop();
      }
    });
    final isSubmitting =
        ref.watch(newKidProvider.select((value) => value.isLoading));

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
                  ListTile(
                    leading: const Icon(Icons.account_circle),
                    title: const Text('Name'),
                    subtitle: ReactiveTextField<String>(
                      formControlName: 'name',
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.calendar_today),
                    title: const Text('Date of Birth'),
                    subtitle: ReactiveDateTimePicker(
                      formControlName: 'dateOfBirth',
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    ),
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
                          final model = ref.read(newKidProvider.notifier);
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
