import 'package:flutter/widgets.dart';

import '../../shape/chuk_squircle.dart';
import '../../theme/chuk_theme.dart';

/// Overlays a small status badge on the top-right corner of [child].
///
/// The badge is either a **dot** (when [count] is `null`) or a **count pill**
/// (when [count] is provided). It fills with [color] — the theme's critical
/// status color by default — and draws its number in [textColor] using a
/// tabular [caption] so digits never jitter as the value changes. A hairline
/// ring in [ringColor] separates the badge from whatever sits beneath it, the
/// way an iOS notification badge does.
///
/// The badge scales in and out with a springy pop whenever [show] flips, so it
/// never appears or vanishes abruptly. It is purely an overlay — [child]'s own
/// layout and semantics are untouched.
///
/// ```dart
/// ChukBadge(
///   count: 3,
///   child: Icon(Icons.notifications),
/// )
/// ```
///
/// Pass `count: null` for a plain dot (e.g. an "unread" indicator), or
/// `show: false` to keep the slot but hide the badge:
///
/// ```dart
/// ChukBadge(
///   show: hasUnread,
///   child: AvatarThumb(),
/// )
/// ```
class ChukBadge extends StatelessWidget {
  /// Creates a badge overlaid on [child].
  const ChukBadge({
    super.key,
    required this.child,
    this.count,
    this.color,
    this.textColor,
    this.ringColor,
    this.show = true,
    this.maxCount = 99,
    this.alignment = Alignment.topRight,
    this.semanticLabel,
  }) : assert(maxCount > 0, 'maxCount must be positive');

  /// The widget the badge is attached to.
  final Widget child;

  /// The number shown in the badge. When `null`, a small dot is drawn instead
  /// of a numeric pill.
  final int? count;

  /// The badge fill color. Defaults to the theme's critical status color.
  final Color? color;

  /// The color of the number. Defaults to the theme's on-status content color.
  final Color? textColor;

  /// The color of the hairline ring around the badge that separates it from the
  /// content beneath. Defaults to the theme's base surface.
  final Color? ringColor;

  /// Whether the badge is visible. When it flips, the badge springs in or out
  /// rather than popping instantly. A `count` of `0` also hides the badge.
  final bool show;

  /// The largest number shown verbatim; anything above renders as `maxCount+`
  /// (for example `99+`). Only applies when [count] is non-null.
  final int maxCount;

  /// Which corner of [child] the badge hugs. Defaults to the top-right.
  final AlignmentGeometry alignment;

  /// The accessibility label announced for the badge. When omitted a sensible
  /// default is derived from [count] (e.g. `"3 new items"`).
  final String? semanticLabel;

  /// Whether the badge should currently be painted at full size.
  bool get _visible => show && (count == null || count! > 0);

  @override
  Widget build(BuildContext context) {
    final t = context.chuk;

    final fill = color ?? t.colors.statusCritical;
    final onFill = textColor ?? t.colors.onStatus;
    final ring = ringColor ?? t.colors.surfaceBase;

    Widget marker;
    if (count == null) {
      // A plain dot.
      marker = SizedBox(
        width: 12,
        height: 12,
        child: DecoratedBox(
          decoration: ShapeDecoration(
            color: fill,
            shape: SquircleBorder(
              radius: t.radii.pill,
              smoothing: kAppleCornerSmoothing,
              side: BorderSide(color: ring, width: 1.5),
            ),
          ),
        ),
      );
    } else {
      final label = count! > maxCount ? '$maxCount+' : '$count';
      marker = Container(
        constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
        padding: EdgeInsets.symmetric(horizontal: t.spacing.xs + 1),
        alignment: Alignment.center,
        decoration: ShapeDecoration(
          color: fill,
          shape: SquircleBorder(
            radius: t.radii.pill,
            smoothing: kAppleCornerSmoothing,
            side: BorderSide(color: ring, width: 1.5),
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: t.typography.caption.copyWith(
            color: onFill,
            height: 1,
            fontWeight: FontWeight.w700,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
      );
    }

    // Announce the badge to screen readers without disturbing the child's own
    // semantics.
    final String announced =
        semanticLabel ??
        (count == null ? 'New' : '$count new item${count == 1 ? '' : 's'}');
    marker = Semantics(label: announced, container: true, child: marker);

    // Pop in / out from the anchored corner so the scale reads as growing out
    // of that corner rather than the badge center.
    final Widget animated = AnimatedScale(
      scale: _visible ? 1 : 0,
      duration: t.motion.medium,
      curve: t.motion.emphasized,
      alignment: Alignment.center,
      child: AnimatedOpacity(
        opacity: _visible ? 1 : 0,
        duration: t.motion.fast,
        curve: t.motion.standard,
        child: marker,
      ),
    );

    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        Positioned.fill(
          child: Align(
            alignment: alignment,
            // Nudge the badge so it straddles the corner of the child, growing
            // slightly beyond its bounds like a classic notification badge.
            child: FractionalTranslation(
              translation: _overhang(alignment),
              child: animated,
            ),
          ),
        ),
      ],
    );
  }

  /// How far, as a fraction of the badge's own size, to push it past the
  /// anchored corner so it overhangs the child.
  Offset _overhang(AlignmentGeometry alignment) {
    final Alignment a = alignment.resolve(TextDirection.ltr);
    return Offset(a.x * 0.4, a.y * 0.4);
  }
}
