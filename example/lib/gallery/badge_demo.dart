import 'package:chuk_ui/chuk_ui.dart';
import 'package:flutter/widgets.dart';

/// Interactive gallery demo for [ChukBadge].
///
/// Lets you bump a count up and down (watch the pill spring in, grow past 99+,
/// and pop out at zero), toggle a plain dot badge, and see a badge with a custom
/// accent color — all anchored to different corners.
class BadgeDemo extends StatefulWidget {
  const BadgeDemo({super.key});

  @override
  State<BadgeDemo> createState() => _BadgeDemoState();
}

class _BadgeDemoState extends State<BadgeDemo> {
  int _count = 3;
  bool _dot = true;

  @override
  Widget build(BuildContext context) {
    final t = context.chuk;

    // A simple square anchor tile so the badge has something to hug.
    Widget tile({Color? color}) => SizedBox(
      width: 52,
      height: 52,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: color ?? t.colors.surfaceRaised,
          shape: SquircleBorder(
            radius: t.radii.md,
            smoothing: kAppleCornerSmoothing,
            side: BorderSide(color: t.colors.hairlineStrong),
          ),
        ),
      ),
    );

    Widget stepButton(String glyph, VoidCallback onTap) =>
        ChukButton.secondary(onPressed: onTap, child: Text(glyph));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Live count pill with +/- steppers.
        Row(
          children: [
            ChukBadge(count: _count, child: tile()),
            SizedBox(width: t.spacing.xl),
            stepButton(
              '–',
              () => setState(() => _count = (_count - 1).clamp(0, 999)),
            ),
            SizedBox(width: t.spacing.sm),
            stepButton(
              '+',
              () => setState(() => _count = (_count + 1).clamp(0, 999)),
            ),
            SizedBox(width: t.spacing.md),
            Text(
              'count: $_count',
              style: t.typography.body.copyWith(color: t.colors.textSecondary),
            ),
          ],
        ),
        SizedBox(height: t.spacing.xl),
        // A row of static examples: dot, high count, custom accent color.
        Row(
          children: [
            ChukBadge(show: _dot, child: tile()),
            SizedBox(width: t.spacing.xl),
            ChukBadge(count: 128, child: tile()),
            SizedBox(width: t.spacing.xl),
            ChukBadge(
              count: 7,
              color: t.colors.accent,
              child: tile(color: t.colors.accentMuted),
            ),
            SizedBox(width: t.spacing.xl),
            ChukBadge(
              count: 5,
              alignment: Alignment.bottomLeft,
              color: t.colors.statusPositive,
              child: tile(),
            ),
          ],
        ),
        SizedBox(height: t.spacing.lg),
        // Toggle the dot on/off to see the spring pop.
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => setState(() => _dot = !_dot),
          child: Text(
            _dot ? 'Tap to hide the dot' : 'Tap to show the dot',
            style: t.typography.body.copyWith(color: t.colors.accent),
          ),
        ),
      ],
    );
  }
}
