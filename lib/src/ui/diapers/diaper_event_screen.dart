import 'package:bebe/src/data/events/event.dart';
import 'package:bebe/src/ui/diapers/diaper_event_notifier.dart';
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

final diaperEventProvider = StateNotifierProvider.autoDispose<
    DiaperEventNotifier, AsyncValue<DiaperEventResult?>>((ref) {
  final event = ref.watch(editingDiaperEventProvider);
  return DiaperEventNotifier(ref, event);
}, dependencies: [
  editingDiaperEventProvider,
  eventRepositoryProvider,
  currentKidProvider.future,
]);

class DiaperEventScreen extends ConsumerWidget {
  static const route = '/events/diapers/new';

  const DiaperEventScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(diaperEventProvider.notifier).form;
    ref.listen<AsyncValue<DiaperEventResult?>>(diaperEventProvider,
        (previous, next) {
      if (next.valueOrNull != null) {
        context.pop();
      } else if (next.hasError && previous?.error != next.error) {
        context.logErrorAndShowSnackbar(next.error, next.stackTrace);
      }
    });
    final isSubmitting =
        ref.watch(diaperEventProvider.select((value) => value.isLoading));
    final canDelete = ref.watch(diaperEventProvider.notifier).canDelete;
    final isEdit = ref.watch(diaperEventProvider.notifier).isEdit;

    return Scaffold(
      appBar: AppBar(),
      body: Modal(
        visible: isSubmitting,
        modal: LoadingIndicator.white(),
        child: SafeArea(
          child: ReactiveForm(
            formGroup: form,
            child: Column(
              children: [
                const VSpace(),
                ListTile(
                  title: const Text('Diaper'),
                  subtitle: isEdit
                      ? Text(
                          'Editing existing event',
                          style: TextStyle(color: Colors.deepOrange.shade400),
                        )
                      : const Text('Add new'),
                ),
                const VSpace(),
                ListTile(
                  leading: const Icon(Icons.access_time),
                  title: const Text('Time'),
                  subtitle: ReactiveDateTimePicker(
                    formControlName: 'createdAt',
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                    type: ReactiveDatePickerFieldType.dateTime,
                  ),
                ),
                const VSpace(),
                ListTile(
                  leading: const Icon(Icons.wc),
                  title: const Text('Type'),
                  subtitle: ReactiveDropdownField(
                    formControlName: 'diaperType',
                    items: [
                      for (final type in DiaperType.values)
                        DropdownMenuItem(
                          value: type,
                          child: Text(type.name),
                        ),
                    ],
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
                                    'Are you sure you want to remove this event?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      dialogContext.closeDialog();
                                    },
                                    child: const Text('No'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      final model = ref
                                          .read(diaperEventProvider.notifier);
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
                      onPressed: () async {
                        final model = ref.read(diaperEventProvider.notifier);
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
    );
  }
}
