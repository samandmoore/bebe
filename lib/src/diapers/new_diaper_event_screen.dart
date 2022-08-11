import 'package:bebe/src/events/event.dart';
import 'package:bebe/src/events/providers.dart';
import 'package:bebe/src/kids/providers.dart';
import 'package:bebe/src/shared/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../shared/layout.dart';

final _formProvider = Provider.autoDispose((ref) {
  return FormGroup({
    'diaperType': FormControl<DiaperType>(
      validators: [Validators.required],
    ),
    'createdAt': FormControl<DateTime>(
      validators: [Validators.required],
      value: DateTime.now(),
    ),
  });
});

class NewDiaperEventScreen extends ConsumerWidget {
  static const route = '/events/diapers/new';

  const NewDiaperEventScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(_formProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('New Diaper Event'),
      ),
      body: SafeArea(
        child: ReactiveForm(
          formGroup: form,
          child: Column(
            children: [
              const VSpace(),
              ReactiveDatePicker(
                formControlName: 'createdAt',
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
                            if (picker.value == null) const Text('Event time'),
                          ],
                        ),
                      ),
                      if (picker.control.hasErrors &&
                          picker.control.touched) ...[
                        const HSpace(),
                        Text(
                          {
                            ValidationMessage.required:
                                'Event time is required',
                          }.get(picker.control.errors.keys.first, 'Invalid'),
                          style: const TextStyle(color: Colors.red),
                        ),
                      ]
                    ],
                  );
                },
              ),
              ReactiveDropdownField(
                formControlName: 'diaperType',
                items: [
                  for (final unit in DiaperType.values)
                    DropdownMenuItem(
                      value: unit,
                      child: Text(unit.name),
                    ),
                ],
                decoration: const InputDecoration(
                  labelText: 'Diaper type',
                  border: OutlineInputBorder(),
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
                      if (form.valid) {
                        final repo = ref.read(eventRepositoryProvider);
                        final input = DiaperEventInput(
                          kidId: ref.read(selectedKidProvider)!.id,
                          diaperType: form.value['diaperType'] as DiaperType,
                          createdAt: form.value['createdAt'] as DateTime,
                        );

                        await repo.createDiaperEvent(input);

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
    );
  }
}
