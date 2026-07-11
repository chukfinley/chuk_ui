import 'package:chuk_ui/chuk_ui.dart';
import 'package:flutter/widgets.dart';

/// Interactive gallery demo for [ChukProgressBar].
///
/// Shows a determinate bar the viewer can scrub with +/- controls, plus a
/// permanently indeterminate sweep. Self-contained: manages its own state and
/// relies on an ambient [ChukTheme].
class ProgressBarDemo extends StatefulWidget {
  const ProgressBarDemo({super.key});

  @override
  State<ProgressBarDemo> createState() => _ProgressBarDemoState();
}

class _ProgressBarDemoState extends State<ProgressBarDemo> {
  double _value = 0.35;

  void _nudge(double delta) {
    setState(() => _value = (_value + delta).clamp(0.0, 1.0));
  }

  @override
  Widget build(BuildContext context) {
    final t = context.chuk;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Determinate', style: t.typography.label),
        SizedBox(height: t.spacing.sm),
        ChukProgressBar(value: _value, semanticLabel: 'Download'),
        SizedBox(height: t.spacing.sm),
        Row(
          children: [
            Text(
              '${(_value * 100).round()}%',
              style: t.typography.caption.copyWith(
                color: t.colors.textSecondary,
              ),
            ),
            const Spacer(),
            ChukButton.secondary(
              onPressed: () => _nudge(-0.1),
              child: const Text('-10%'),
            ),
            SizedBox(width: t.spacing.sm),
            ChukButton.primary(
              onPressed: () => _nudge(0.1),
              child: const Text('+10%'),
            ),
          ],
        ),
        SizedBox(height: t.spacing.xl),
        Text('Indeterminate', style: t.typography.label),
        SizedBox(height: t.spacing.sm),
        const ChukProgressBar(semanticLabel: 'Loading'),
        SizedBox(height: t.spacing.xl),
        Text('Thicker (height: 12)', style: t.typography.label),
        SizedBox(height: t.spacing.sm),
        ChukProgressBar(value: _value, height: 12),
      ],
    );
  }
}
