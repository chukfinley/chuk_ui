import 'package:chuk_ui/chuk_ui.dart';
import 'package:flutter/widgets.dart';

/// Interactive showcase for [ChukStepper].
///
/// Drives three independent steppers — a bounded quantity, a stepped value, and
/// a disabled one — plus a live readout, all inside the ambient [ChukTheme].
class StepperDemo extends StatefulWidget {
  const StepperDemo({super.key});

  @override
  State<StepperDemo> createState() => _StepperDemoState();
}

class _StepperDemoState extends State<StepperDemo> {
  int _quantity = 1;
  int _volume = 40;
  int _guests = 2;

  @override
  Widget build(BuildContext context) {
    final t = context.chuk;

    Widget row(String label, String hint, Widget stepper) {
      return Padding(
        padding: EdgeInsets.only(bottom: t.spacing.md),
        child: ChukCard(
          padding: EdgeInsets.symmetric(
            horizontal: t.spacing.lg,
            vertical: t.spacing.md,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: t.typography.body),
                    SizedBox(height: t.spacing.xs),
                    Text(
                      hint,
                      style: t.typography.caption.copyWith(
                        color: t.colors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: t.spacing.md),
              stepper,
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        row(
          'Quantity',
          'clamped to 1 – 10',
          ChukStepper(
            value: _quantity,
            min: 1,
            max: 10,
            semanticLabel: 'Quantity',
            onChanged: (v) => setState(() => _quantity = v),
          ),
        ),
        row(
          'Volume',
          'steps of 5, 0 – 100',
          ChukStepper(
            value: _volume,
            min: 0,
            max: 100,
            step: 5,
            semanticLabel: 'Volume',
            onChanged: (v) => setState(() => _volume = v),
          ),
        ),
        row(
          'Guests',
          'accent-tinted glyphs',
          ChukStepper(
            value: _guests,
            min: 0,
            max: 8,
            semanticLabel: 'Guests',
            onChanged: (v) => setState(() => _guests = v),
          ),
        ),
        row(
          'Disabled',
          'onChanged == null',
          const ChukStepper(value: 3, onChanged: null),
        ),
        SizedBox(height: t.spacing.sm),
        Text(
          'Quantity $_quantity  ·  Volume $_volume  ·  Guests $_guests',
          style: t.typography.caption.copyWith(color: t.colors.textSecondary),
        ),
      ],
    );
  }
}
