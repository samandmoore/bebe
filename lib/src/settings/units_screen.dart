import 'package:bebe/src/settings/providers.dart';
import 'package:bebe/src/shared/layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:reactive_forms/reactive_forms.dart';

final _formProvider = Provider.autoDispose((ref) {
  final currentLiquidUnit = ref.read(liquidUnitProvider);

  return FormGroup({
    'liquidUnit': FormControl<LiquidUnit>(
      validators: [Validators.required],
      value: currentLiquidUnit,
    ),
  });
});

class UnitsScreen extends ConsumerWidget {
  static const route = '/settings/units';

  const UnitsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(_formProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Units'),
      ),
      body: SafeArea(
        child: ReactiveForm(
          formGroup: form,
          child: Column(
            children: [
              const VSpace(),
              ReactiveDropdownField(
                formControlName: 'liquidUnit',
                items: [
                  for (final unit in LiquidUnit.values)
                    DropdownMenuItem(
                      value: unit,
                      child: Text(unit.name),
                    ),
                ],
                decoration: const InputDecoration(
                  labelText: 'Liquid unit',
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
                    onPressed: () {
                      if (form.valid) {
                        final currentLiquidUnitSetter =
                            ref.read(liquidUnitProvider.notifier);

                        currentLiquidUnitSetter.state =
                            form.value['liquidUnit'] as LiquidUnit;

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
