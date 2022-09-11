import 'package:bebe/src/data/events/event.dart';
import 'package:bebe/src/ui/history/providers.dart';
import 'package:bebe/src/ui/kids/providers.dart';
import 'package:bebe/src/ui/shared/layout.dart';
import 'package:bebe/src/ui/shared/loading_screen.dart';
import 'package:bebe/src/ui/shared/modal.dart';
import 'package:bebe/src/utilities/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:reactive_forms/reactive_forms.dart';

class DiaperEventNotifier extends StateNotifier<AsyncValue<DiaperEvent?>> {
  final form = FormGroup({
    'diaperType': FormControl<DiaperType>(
      validators: [Validators.required],
    ),
    'createdAt': FormControl<DateTime>(
      validators: [Validators.required],
      value: DateTime.now(),
    ),
  });

  final Ref ref;

  DiaperEventNotifier(this.ref) : super(const AsyncValue.data(null));

  Future<void> create() async {
    if (!form.valid) {
      form.markAllAsTouched();
      return;
    }

    final currentKid = await ref.read(currentKidProvider.future);

    final repo = ref.read(eventRepositoryProvider);
    final input = DiaperEventInput(
      kidId: currentKid.id,
      diaperType: form.value['diaperType'] as DiaperType,
      createdAt: form.value['createdAt'] as DateTime,
    );

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => repo.createDiaperEvent(input),
    );
  }
}

final modelProvider = StateNotifierProvider.autoDispose<DiaperEventNotifier,
    AsyncValue<DiaperEvent?>>((ref) {
  return DiaperEventNotifier(ref);
});

class NewDiaperEventScreen extends ConsumerWidget {
  static const route = '/events/diapers/new';

  const NewDiaperEventScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(modelProvider.notifier).form;
    ref.listen<AsyncValue<DiaperEvent?>>(modelProvider, (previous, next) {
      if (next.valueOrNull != null) {
        context.pop();
      }
    });
    final isSubmitting =
        ref.watch(modelProvider.select((value) => value.isLoading));

    return Scaffold(
      appBar: AppBar(
        title: const Text('New Diaper Event'),
      ),
      body: Modal(
        visible: isSubmitting,
        modal: LoadingIndicator.white(),
        child: SafeArea(
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
                              if (picker.value == null)
                                const Text('Event time'),
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
    );
  }
}
