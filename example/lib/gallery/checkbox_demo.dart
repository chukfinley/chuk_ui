import 'package:chuk_ui/chuk_ui.dart';
import 'package:flutter/widgets.dart';

/// Interactive gallery demo for [ChukCheckbox]: a small task list with a
/// "select all" row, a disabled checked example, and live state.
class CheckboxDemo extends StatefulWidget {
  /// Creates the checkbox demo.
  const CheckboxDemo({super.key});

  @override
  State<CheckboxDemo> createState() => _CheckboxDemoState();
}

class _CheckboxDemoState extends State<CheckboxDemo> {
  static const _labels = <String>[
    'Warm up (5 min)',
    'Strength set',
    'Cardio finisher',
    'Cool down + stretch',
  ];

  final List<bool> _done = <bool>[true, false, false, false];

  bool get _allDone => _done.every((v) => v);

  void _setAll(bool v) => setState(() {
    for (var i = 0; i < _done.length; i++) {
      _done[i] = v;
    }
  });

  @override
  Widget build(BuildContext context) {
    final t = context.chuk;

    Widget row({
      required bool value,
      required ValueChanged<bool>? onChanged,
      required String label,
      TextStyle? textStyle,
    }) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onChanged == null ? null : () => onChanged(!value),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: t.spacing.xs),
          child: Row(
            children: [
              ChukCheckbox(
                value: value,
                onChanged: onChanged,
                semanticLabel: label,
              ),
              SizedBox(width: t.spacing.sm),
              Expanded(
                child: Text(
                  label,
                  style: (textStyle ?? t.typography.body).copyWith(
                    color: value ? t.colors.textTertiary : t.colors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        row(
          value: _allDone,
          onChanged: _setAll,
          label: 'Select all',
          textStyle: t.typography.label,
        ),
        SizedBox(height: t.spacing.xs),
        Container(height: 1, color: t.colors.hairline),
        SizedBox(height: t.spacing.xs),
        for (var i = 0; i < _labels.length; i++)
          row(
            value: _done[i],
            onChanged: (v) => setState(() => _done[i] = v),
            label: _labels[i],
          ),
        SizedBox(height: t.spacing.sm),
        row(
          value: true,
          onChanged: null,
          label: 'Locked (disabled, checked)',
          textStyle: t.typography.caption,
        ),
        row(
          value: false,
          onChanged: null,
          label: 'Locked (disabled, unchecked)',
          textStyle: t.typography.caption,
        ),
      ],
    );
  }
}
