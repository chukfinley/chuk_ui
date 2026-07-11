import 'package:chuk_ui/chuk_ui.dart';
import 'package:flutter/widgets.dart';

/// Interactive gallery demo for [ChukRadio].
///
/// Shows a group of radios sharing one [groupValue], plus a disabled row, so
/// you can watch the accent ring crossfade and the dot spring in on selection.
class RadioDemo extends StatefulWidget {
  const RadioDemo({super.key});

  @override
  State<RadioDemo> createState() => _RadioDemoState();
}

enum _Plan { free, pro, team }

class _RadioDemoState extends State<RadioDemo> {
  _Plan _plan = _Plan.pro;

  @override
  Widget build(BuildContext context) {
    final t = context.chuk;

    Widget row(_Plan value, String label) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => setState(() => _plan = value),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: t.spacing.xs),
          child: Row(
            children: [
              ChukRadio<_Plan>(
                value: value,
                groupValue: _plan,
                onChanged: (v) => setState(() => _plan = v),
                semanticLabel: label,
              ),
              SizedBox(width: t.spacing.sm),
              Text(label, style: t.typography.body),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        row(_Plan.free, 'Free'),
        row(_Plan.pro, 'Pro'),
        row(_Plan.team, 'Team'),
        SizedBox(height: t.spacing.md),
        // A disabled group: pre-selected and non-interactive.
        Row(
          children: [
            const ChukRadio<bool>(
              value: true,
              groupValue: true,
              onChanged: null,
              semanticLabel: 'Locked option',
            ),
            SizedBox(width: t.spacing.sm),
            Text(
              'Disabled (selected)',
              style: t.typography.body.copyWith(color: t.colors.textTertiary),
            ),
          ],
        ),
      ],
    );
  }
}
