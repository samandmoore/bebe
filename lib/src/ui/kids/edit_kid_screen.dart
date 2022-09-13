import 'package:bebe/src/data/kids/kid.dart';
import 'package:bebe/src/ui/kids/delete_kid_notifier.dart';
import 'package:bebe/src/ui/kids/edit_kid_notifier.dart';
import 'package:bebe/src/ui/kids/providers.dart';
import 'package:bebe/src/ui/shared/loading.dart';
import 'package:bebe/src/ui/shared/modal.dart';
import 'package:bebe/src/ui/shared/spacing.dart';
import 'package:bebe/src/utilities/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:reactive_date_time_picker/reactive_date_time_picker.dart';
import 'package:reactive_forms/reactive_forms.dart';

final editKidProvider =
    StateNotifierProvider.autoDispose<EditKidNotifier, AsyncValue<Kid?>>(
  (ref) {
    final editingKid = ref.watch(editingKidProvider)!;
    return EditKidNotifier(ref, kid: editingKid);
  },
  dependencies: [editingKidProvider, kidRepositoryProvider],
);

final deleteKidProvider =
    StateNotifierProvider.autoDispose<DeleteKidNotifier, AsyncValue<String?>>(
  (ref) => DeleteKidNotifier(ref, kid: ref.watch(editingKidProvider)!),
  dependencies: [editingKidProvider, kidRepositoryProvider],
);

class EditKidScreen extends ConsumerWidget {
  static const route = '/kids/edit';

  const EditKidScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(editKidProvider.notifier).form;
    final kid = ref.watch(editKidProvider.notifier).kid;

    ref.listen<AsyncValue<Kid?>>(editKidProvider, (previous, next) {
      if (next.valueOrNull != null) {
        context.pop();
      }
    });
    final isEditSubmitting =
        ref.watch(editKidProvider.select((value) => value.isLoading));

    final isDeleteSubmitting =
        ref.watch(deleteKidProvider.select((value) => value.isLoading));

    ref.listen<AsyncValue<String?>>(deleteKidProvider, (previous, next) {
      if (next.valueOrNull != null) {
        ScaffoldMessenger.of(context)
          ..clearSnackBars()
          ..showSnackBar(
            SnackBar(
              content: Text('Removed ${kid.name}.'),
            ),
          );

        context.pop();
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Kid')),
      body: Modal(
        visible: isEditSubmitting || isDeleteSubmitting,
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
                      formControlName: 'birthDate',
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
                                      final deleteKid =
                                          ref.read(deleteKidProvider.notifier);
                                      deleteKid.delete();

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
                          final editKid = ref.read(editKidProvider.notifier);
                          editKid.update();
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
