import 'package:bebe/src/events/event.dart';
import 'package:bebe/src/events/providers.dart';
import 'package:bebe/src/kids/providers.dart';
import 'package:bebe/src/shared/extensions.dart';
import 'package:bebe/src/shared/layout.dart';
import 'package:bebe/src/shared/loading_screen.dart';
import 'package:bebe/src/shared/modal.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:reactive_forms/reactive_forms.dart';

class DiaperEventState extends Equatable {
  final AsyncValue<DiaperEvent?> result;

  const DiaperEventState({this.result = const AsyncValue.data(null)});

  @override
  List<Object?> get props => [result];
}

class DiaperEventNotifier extends StateNotifier<DiaperEventState> {
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

  DiaperEventNotifier(this.ref, super.state);

  Future<void> create() async {
    if (!form.valid) {
      form.markAllAsTouched();
      return;
    }

    final selectedKid = await ref.read(selectedKidProvider.future);

    final repo = ref.read(eventRepositoryProvider);
    final input = DiaperEventInput(
      kidId: selectedKid.id,
      diaperType: form.value['diaperType'] as DiaperType,
      createdAt: form.value['createdAt'] as DateTime,
    );

    state = const DiaperEventState(result: AsyncValue.loading());
    final result = await AsyncValue.guard(
      () => repo.createDiaperEvent(input),
    );
    state = DiaperEventState(result: result);
  }
}

final modelProvider =
    StateNotifierProvider.autoDispose<DiaperEventNotifier, DiaperEventState>(
        (ref) {
  return DiaperEventNotifier(ref, const DiaperEventState());
});

class NewDiaperEventScreen extends ConsumerWidget {
  static const route = '/events/diapers/new';

  const NewDiaperEventScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(modelProvider.notifier).form;
    ref.listen<DiaperEventState>(modelProvider, (previous, next) {
      if (next.result.valueOrNull != null) {
        context.pop();
      }
    });
    final isSubmitting =
        ref.watch(modelProvider.select((value) => value.result.isLoading));

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
