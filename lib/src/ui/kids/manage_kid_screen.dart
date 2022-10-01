import 'package:bebe/src/ui/kids/kid_notifier.dart';
import 'package:bebe/src/ui/providers.dart';
import 'package:bebe/src/ui/shared/loading.dart';
import 'package:bebe/src/ui/shared/modal.dart';
import 'package:bebe/src/ui/shared/spacing.dart';
import 'package:bebe/src/utilities/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:reactive_date_time_picker/reactive_date_time_picker.dart';
import 'package:reactive_forms/reactive_forms.dart';

final kidProvider =
    StateNotifierProvider.autoDispose<KidNotifier, AsyncValue<KidResult?>>(
  (ref) {
    final editingKid = ref.watch(editingKidProvider);
    return KidNotifier(ref, editingKid);
  },
  dependencies: [editingKidProvider, userRepositoryProvider],
);

class ManageKidScreen extends ConsumerWidget {
  static const route = '/kids/manage';

  const ManageKidScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(kidProvider.notifier).form;
    final kid = ref.watch(kidProvider.notifier).kid;

    ref.listen<AsyncValue<KidResult?>>(kidProvider, (previous, next) {
      if (next.valueOrNull != null) {
        if (next.valueOrNull == KidResult.deleted) {
          ScaffoldMessenger.of(context)
            ..clearSnackBars()
            ..showSnackBar(
              SnackBar(
                content: Text('Removed ${kid?.name}.'),
              ),
            );
        }
        context.pop();
      } else if (next.hasError && previous?.error != next.error) {
        context.logErrorAndShowSnackbar(next.error, next.stackTrace);
      }
    });
    final isSubmitting =
        ref.watch(kidProvider.select((value) => value.isLoading));
    final canDelete = ref.watch(kidProvider.notifier).canDelete;
    final isEdit = ref.watch(kidProvider.notifier).isEdit;

    return Scaffold(
      appBar: AppBar(
        title: isEdit ? Text('Edit ${kid?.name}') : const Text('Add Kid'),
      ),
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
                  if (isEdit)
                    Text(
                      'Editing existing kid',
                      style: TextStyle(color: Colors.deepOrange.shade400),
                    ),
                  const VSpace(),
                  ListTile(
                    leading: const Icon(Icons.account_circle),
                    title: const Text('Name'),
                    subtitle: ReactiveTextField<String>(
                      formControlName: 'name',
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                  const VSpace(),
                  ListTile(
                    leading: const Icon(Icons.calendar_today),
                    title: const Text('Date of Birth'),
                    subtitle: ReactiveDateTimePicker(
                      formControlName: 'dateOfBirth',
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    ),
                  ),
                  const VSpace(),
                  ButtonBar(
                    children: [
                      TextButton(
                        onPressed: () {
                          context.pop();
                        },
                        child: const Text('Cancel'),
                      ),
                      if (canDelete)
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
                                        final model =
                                            ref.read(kidProvider.notifier);
                                        model.delete();

                                        dialogContext.closeDialog();
                                      },
                                      child: const Text('Yes'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red),
                          child: const Text('Remove'),
                        ),
                      ElevatedButton(
                        onPressed: () {
                          final model = ref.read(kidProvider.notifier);
                          model.save();
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
