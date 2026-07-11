import 'package:flutter/widgets.dart';

import '../../shape/chuk_squircle.dart';
import '../../theme/chuk_theme.dart';
import 'chuk_tabs_style.dart';

/// A horizontal row of text tabs with a gliding accent **underline**.
///
/// The tabs sit in equal-width slots. A small accent bar rides under the active
/// label and *glides* left↔right whenever the selection changes (mirroring the
/// [ChukSegmented] highlight mechanics — same `AnimatedFoo` + `t.motion.medium`
/// / `t.motion.standard` easing — but rendered as an underline, not a pill).
/// The active label brightens to `textPrimary` and thickens; the inactive
/// labels stay `textSecondary`.
///
/// A faint full-width hairline runs behind the indicator so the bar always has
/// a track to travel along (toggle with [ChukTabsStyle.showTrack]).
///
/// ```dart
/// ChukTabs(
///   tabs: const ['Overview', 'Activity', 'Settings'],
///   index: selected,
///   onChanged: (i) => setState(() => selected = i),
/// )
/// ```
///
/// Pass `onChanged: null` to render a read-only / disabled bar.
class ChukTabs extends StatelessWidget {
  /// Creates a tab bar.
  const ChukTabs({
    super.key,
    required this.tabs,
    required this.index,
    required this.onChanged,
    this.style,
  });

  /// The tab labels, left to right.
  final List<String> tabs;

  /// The index of the currently active tab.
  final int index;

  /// Called with the tapped tab's index. When null the bar is disabled.
  final ValueChanged<int>? onChanged;

  /// Per-instance style overrides.
  final ChukTabsStyle? style;

  @override
  Widget build(BuildContext context) {
    final t = context.chuk;
    final s = const ChukTabsStyle().merge(style);

    final n = tabs.length;
    if (n == 0) return const SizedBox.shrink();

    final active = index.clamp(0, n - 1);
    final enabled = onChanged != null;

    final indicatorColor = s.indicatorColor ?? t.colors.accent;
    final activeColor = s.activeColor ?? t.colors.textPrimary;
    final inactiveColor = s.inactiveColor ?? t.colors.textSecondary;
    final trackColor = s.trackColor ?? t.colors.hairline;
    final thickness = s.indicatorThickness ?? 2.5;
    final indicatorRadius = s.indicatorRadius ?? t.radii.pill;
    final height = s.height ?? 44;
    final gap = s.gap ?? t.spacing.sm;
    final showTrack = s.showTrack ?? true;

    // The type scale used for measuring: the active weight, so the underline
    // width tracks the label at its widest rendered state.
    final labelStyle = t.typography.label;

    return LayoutBuilder(
      builder: (context, constraints) {
        // Equal slots filling the available width. When unbounded, fall back to
        // measured intrinsic widths so the bar still lands correctly.
        final hasBoundedWidth = constraints.maxWidth.isFinite;
        final labelWidths = [
          for (final label in tabs)
            _measure(label, labelStyle.copyWith(fontWeight: FontWeight.w600)),
        ];

        final slotWidths = <double>[];
        if (hasBoundedWidth) {
          final slot = constraints.maxWidth / n;
          for (var i = 0; i < n; i++) {
            slotWidths.add(slot);
          }
        } else {
          for (var i = 0; i < n; i++) {
            slotWidths.add(labelWidths[i] + gap * 2);
          }
        }

        // Left edge and width of the underline under the active tab.
        var left = 0.0;
        for (var i = 0; i < active; i++) {
          left += slotWidths[i];
        }
        final barWidth = labelWidths[active].clamp(0.0, slotWidths[active]);
        final barLeft = left + (slotWidths[active] - barWidth) / 2;

        return SizedBox(
          height: height,
          width: hasBoundedWidth
              ? null
              : slotWidths.fold<double>(0, (a, b) => a + b),
          child: Stack(
            children: [
              // Full-width hairline track the bar travels along.
              if (showTrack)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  height: 1,
                  child: DecoratedBox(
                    decoration: BoxDecoration(color: trackColor),
                  ),
                ),

              // The gliding accent underline.
              AnimatedPositioned(
                duration: t.motion.medium,
                curve: t.motion.standard,
                left: barLeft,
                bottom: 0,
                width: barWidth,
                height: thickness,
                child: DecoratedBox(
                  decoration: ShapeDecoration(
                    color: enabled
                        ? indicatorColor
                        : indicatorColor.withValues(alpha: 0.4),
                    shape: SquircleBorder(
                      radius: indicatorRadius,
                      smoothing: kAppleCornerSmoothing,
                    ),
                  ),
                ),
              ),

              // The tab labels.
              Row(
                children: [
                  for (var i = 0; i < n; i++)
                    _TabSlot(
                      label: tabs[i],
                      selected: i == active,
                      width: hasBoundedWidth ? null : slotWidths[i],
                      expand: hasBoundedWidth,
                      color: (i == active ? activeColor : inactiveColor)
                          .withValues(alpha: enabled ? 1.0 : 0.5),
                      labelStyle: labelStyle,
                      gap: gap,
                      duration: t.motion.medium,
                      curve: t.motion.standard,
                      onTap: enabled ? () => onChanged!(i) : null,
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  /// Measures the rendered width of [text] in [style].
  static double _measure(String text, TextStyle style) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout();
    return painter.width;
  }
}

/// A single tappable tab cell.
class _TabSlot extends StatelessWidget {
  const _TabSlot({
    required this.label,
    required this.selected,
    required this.width,
    required this.expand,
    required this.color,
    required this.labelStyle,
    required this.gap,
    required this.duration,
    required this.curve,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final double? width;
  final bool expand;
  final Color color;
  final TextStyle labelStyle;
  final double gap;
  final Duration duration;
  final Curve curve;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final cell = Semantics(
      button: true,
      selected: selected,
      label: label,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: gap),
          child: Center(
            child: AnimatedDefaultTextStyle(
              duration: duration,
              curve: curve,
              style: labelStyle.copyWith(
                color: color,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
              ),
              child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
            ),
          ),
        ),
      ),
    );

    if (expand) return Expanded(child: cell);
    return SizedBox(width: width, child: cell);
  }
}
