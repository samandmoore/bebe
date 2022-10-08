import 'package:bebe/src/data/liquid_unit.dart';
import 'package:bebe/src/ui/providers.dart';
import 'package:bebe/src/ui/shared/spacing.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
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
              ListTile(
                leading: const Icon(Icons.science),
                title: const Text('Type'),
                subtitle: ReactiveDropdownField(
                  formControlName: 'liquidUnit',
                  items: [
                    for (final unit in LiquidUnit.values)
                      DropdownMenuItem(
                        value: unit,
                        child: Text(unit.name),
                      ),
                  ],
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
