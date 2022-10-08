import 'package:bebe/src/data/events/event.dart';
import 'package:bebe/src/ui/diapers/diaper_event_model.dart';
import 'package:bebe/src/ui/providers.dart';
import 'package:bebe/src/ui/shared/hooks/use_mutation.dart';
import 'package:bebe/src/ui/shared/loading.dart';
import 'package:bebe/src/ui/shared/modal.dart';
import 'package:bebe/src/ui/shared/spacing.dart';
import 'package:bebe/src/utilities/extensions.dart';
import 'package:bebe/src/utilities/jitter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reactive_date_time_picker/reactive_date_time_picker.dart';
import 'package:reactive_forms/reactive_forms.dart';

class DiaperEventScreen extends HookConsumerWidget {
  static const route = '/events/diapers/new';

  const DiaperEventScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final event = ref.watch(editingDiaperEventProvider);
    final model = useMemoized(() => DiaperEventModel(ref, event));
    final form = model.form;
    final canDelete = model.canDelete;
    final isEdit = model.isEdit;

    final deleteMutation = useMutation(model.delete);
    final saveMutation = useMutation(() async {
      // you can do whatever...
      await jitter();
      await model.save();
      // ...you want in here.
    });

    return Scaffold(
      appBar: AppBar(),
      body: Modal(
        visible:
            deleteMutation.result.isLoading || saveMutation.result.isLoading,
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
                    formControlName: 'startedAt',
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
                                    onPressed: () async {
                                      await deleteMutation.run();
                                      if (dialogContext.mounted) {
                                        dialogContext.closeDialog();
                                      }
                                      if (context.mounted) {
                                        context.pop();
                                      }
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
                        await saveMutation.run();
                        if (context.mounted) {
                          context.pop();
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
