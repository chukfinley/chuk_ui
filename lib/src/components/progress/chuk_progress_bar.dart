import 'dart:ui' show lerpDouble;

import 'package:flutter/widgets.dart';

import '../../shape/chuk_squircle.dart';
import '../../theme/chuk_theme.dart';

/// A thin, fully-rounded (pill) progress bar.
///
/// Two modes, chosen by [value]:
///  * **Determinate** — pass a [value] in `0..1`; an accent fill grows over a
///    [hairlineStrong]-tinted track, easing to each new value with the theme's
///    medium motion.
///  * **Indeterminate** — pass `null`; a short accent segment sweeps back and
///    forth across the track forever, driven by an [AnimationController].
///
/// The bar is purely presentational (no interaction), but reports its progress
/// to screen readers via [Semantics].
///
/// ```dart
/// const ChukProgressBar(value: 0.4)   // 40% filled
/// const ChukProgressBar()             // indeterminate sweep
/// ```
class ChukProgressBar extends StatefulWidget {
  const ChukProgressBar({
    super.key,
    this.value,
    this.height = 6,
    this.trackColor,
    this.fillColor,
    this.semanticLabel,
  }) : assert(
         value == null || (value >= 0 && value <= 1),
         'value must be null (indeterminate) or within 0..1',
       );

  /// Progress in `0..1`, or `null` for an indeterminate sweep.
  final double? value;

  /// Thickness of the bar in logical pixels.
  final double height;

  /// Track (background) color. Defaults to the theme's `hairlineStrong`.
  final Color? trackColor;

  /// Fill (progress) color. Defaults to the theme's `accent`.
  final Color? fillColor;

  /// Accessibility label announced alongside the progress percentage.
  final String? semanticLabel;

  @override
  State<ChukProgressBar> createState() => _ChukProgressBarState();
}

class _ChukProgressBarState extends State<ChukProgressBar>
    with SingleTickerProviderStateMixin {
  // One full left→right→left cycle of the indeterminate sweep.
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  );

  // Fraction of the track width occupied by the sweeping segment.
  static const double _segmentFraction = 0.35;

  bool get _indeterminate => widget.value == null;

  @override
  void initState() {
    super.initState();
    if (_indeterminate) _c.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(ChukProgressBar old) {
    super.didUpdateWidget(old);
    if (_indeterminate && !_c.isAnimating) {
      _c.repeat(reverse: true);
    } else if (!_indeterminate && _c.isAnimating) {
      _c.stop();
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.chuk;
    final trackColor = widget.trackColor ?? t.colors.hairlineStrong;
    final fillColor = widget.fillColor ?? t.colors.accent;

    // A pill radius, but never larger than half the bar so the ends stay round.
    final radius = widget.height / 2;
    final shape = SquircleBorder(
      radius: radius,
      smoothing: kAppleCornerSmoothing,
    );

    final Widget bar = ClipPath(
      clipper: ShapeBorderClipper(shape: shape),
      child: DecoratedBox(
        decoration: ShapeDecoration(color: trackColor, shape: shape),
        child: SizedBox(
          height: widget.height,
          width: double.infinity,
          child: _indeterminate
              ? _buildIndeterminate(fillColor, shape)
              : _buildDeterminate(
                  t.motion.medium,
                  t.motion.standard,
                  fillColor,
                  shape,
                ),
        ),
      ),
    );

    return Semantics(
      label: widget.semanticLabel,
      value: _indeterminate ? null : '${(widget.value! * 100).round()}%',
      child: bar,
    );
  }

  Widget _buildDeterminate(
    Duration duration,
    Curve curve,
    Color fillColor,
    OutlinedBorder shape,
  ) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: widget.value!.clamp(0.0, 1.0)),
      duration: duration,
      curve: curve,
      builder: (context, v, _) {
        return Align(
          alignment: Alignment.centerLeft,
          child: FractionallySizedBox(
            widthFactor: v,
            heightFactor: 1,
            child: DecoratedBox(
              decoration: ShapeDecoration(color: fillColor, shape: shape),
            ),
          ),
        );
      },
    );
  }

  Widget _buildIndeterminate(Color fillColor, OutlinedBorder shape) {
    final segment = DecoratedBox(
      decoration: ShapeDecoration(color: fillColor, shape: shape),
    );
    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) {
        // Ease the sweep so it decelerates at each end, then reverses.
        final eased = Curves.easeInOut.transform(_c.value);
        return Align(
          alignment: Alignment(lerpDouble(-1, 1, eased)!, 0),
          child: FractionallySizedBox(
            widthFactor: _segmentFraction,
            heightFactor: 1,
            child: segment,
          ),
        );
      },
    );
  }
}
