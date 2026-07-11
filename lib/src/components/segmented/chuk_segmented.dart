import 'package:flutter/widgets.dart';

import '../../theme/chuk_theme.dart';
import 'chuk_segmented_style.dart';

/// One option in a [ChukSegmented] control: a value, a label and an optional
/// leading icon.
@immutable
class ChukSegment<T> {
  const ChukSegment(this.value, this.label, {this.icon});

  /// The value reported through `onChanged` when this option is selected.
  final T value;

  /// The visible label. May be empty for an icon-only option.
  final String label;

  /// An optional leading icon.
  final IconData? icon;
}

/// The app-wide **segmented control** — a translucent, fully-rounded pill track
/// with a single highlight that *glides* left↔right between options (260 ms
/// easeOutCubic). The active label brightens; the highlight does the moving.
///
/// Ported from the reference app so every choice-of-N reads as a sibling of the
/// nav bar. Two layouts:
///  * [expand] off — the track hugs its widest label (inline in a row/tile);
///  * [expand] on — equal slots filling the width (top-of-screen range picker).
///
/// ```dart
/// ChukSegmented<String>(
///   value: range,
///   expand: true,
///   segments: const [
///     ChukSegment('d', 'Tag'),
///     ChukSegment('w', 'Woche'),
///     ChukSegment('m', 'Monat'),
///   ],
///   onChanged: (v) => setState(() => range = v),
/// )
/// ```
class ChukSegmented<T> extends StatelessWidget {
  const ChukSegmented({
    super.key,
    required this.segments,
    required this.value,
    required this.onChanged,
    this.expand = false,
    this.height,
    this.style,
  });

  /// The options, left to right.
  final List<ChukSegment<T>> segments;

  /// The currently selected value.
  final T value;

  /// Called when a different option is tapped.
  final ValueChanged<T> onChanged;

  /// Fill the available width with equal slots. When false the track hugs its
  /// widest label.
  final bool expand;

  /// Track height. Defaults to the theme's segmented height (32).
  final double? height;

  /// Per-instance style overrides.
  final ChukSegmentedStyle? style;

  @override
  Widget build(BuildContext context) {
    final t = context.chuk;
    final s = t.segmentedStyle.merge(style);

    final radius = BorderRadius.circular(s.radius ?? t.radii.pill);
    final trackHeight = height ?? s.height ?? 32;
    final captionStyle = t.typography.caption;
    final activeColor = s.activeColor ?? t.colors.textPrimary;
    final inactiveColor = s.inactiveColor ?? t.colors.textSecondary;

    final n = segments.length;
    final idx = segments.indexWhere((seg) => seg.value == value).clamp(0, n - 1);
    // Slot-centre alignment for the sliding highlight: -1 (first) … 1 (last).
    final alignX = n <= 1 ? 0.0 : -1 + 2 * idx / (n - 1);

    // Hugging variant: size every slot to the widest option.
    var slotW = 0.0;
    if (!expand) {
      for (final seg in segments) {
        final tp = TextPainter(
          text: TextSpan(text: seg.label, style: captionStyle),
          textDirection: TextDirection.ltr,
        )..layout();
        var w = tp.width + t.spacing.md * 2;
        if (seg.icon != null) w += 22;
        if (w > slotW) slotW = w;
      }
    }

    Widget slot(int i) {
      final seg = segments[i];
      final active = i == idx;
      final color = active ? activeColor : inactiveColor;
      return GestureDetector(
        onTap: () => onChanged(seg.value),
        behavior: HitTestBehavior.opaque,
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (seg.icon != null) Icon(seg.icon, size: 16, color: color),
              if (seg.icon != null && seg.label.isNotEmpty)
                const SizedBox(width: 6),
              if (seg.label.isNotEmpty)
                AnimatedDefaultTextStyle(
                  duration: t.motion.medium,
                  curve: t.motion.standard,
                  style: captionStyle.copyWith(
                    color: color,
                    fontWeight: active ? FontWeight.w600 : FontWeight.w500,
                  ),
                  child: Text(seg.label),
                ),
            ],
          ),
        ),
      );
    }

    return Container(
      padding: EdgeInsets.all(s.padding ?? 3),
      decoration: BoxDecoration(
        color: s.trackColor ?? t.colors.surfaceInset,
        borderRadius: radius,
      ),
      child: SizedBox(
        height: trackHeight,
        width: expand ? double.infinity : slotW * n,
        child: Stack(
          children: [
            AnimatedAlign(
              alignment: Alignment(alignX, 0),
              duration: t.motion.medium,
              curve: t.motion.standard,
              child: FractionallySizedBox(
                widthFactor: 1 / n,
                heightFactor: 1,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: s.highlightColor ??
                        (t.isLight
                            ? const Color(0x0F000000)
                            : const Color(0x24FFFFFF)),
                    borderRadius: radius,
                  ),
                ),
              ),
            ),
            Row(
              children: [
                for (var i = 0; i < n; i++)
                  expand
                      ? Expanded(child: slot(i))
                      : SizedBox(width: slotW, child: slot(i)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
