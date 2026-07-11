import 'dart:ui' show PathMetric;

import 'package:flutter/physics.dart';
import 'package:flutter/widgets.dart';

import '../../shape/chuk_squircle.dart';
import '../../theme/chuk_theme.dart';
import 'chuk_checkbox_style.dart';

/// A small squircle checkbox, styled entirely from the [ChukThemeData] — no
/// Material dependency.
///
/// Unchecked it is a transparent box with a `hairlineStrong` outline; checked
/// it fills with `accent` and stamps an `onAccent` tick. The tick is drawn with
/// a [CustomPainter] and animated on with a real [SpringSimulation], so it
/// draws in and pops with a natural, slightly bouncy settle rather than a
/// linear fade. Pass `onChanged: null` to disable it, exactly like a Material
/// checkbox.
///
/// ```dart
/// ChukCheckbox(
///   value: agreed,
///   onChanged: (v) => setState(() => agreed = v),
///   semanticLabel: 'Accept terms',
/// )
/// ```
class ChukCheckbox extends StatefulWidget {
  /// Creates a checkbox.
  const ChukCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.style,
    this.autofocus = false,
    this.focusNode,
    this.semanticLabel,
  });

  /// Whether the box is checked.
  final bool value;

  /// Called with the new value when toggled. Pass `null` to disable.
  final ValueChanged<bool>? onChanged;

  /// Per-instance overrides layered on top of the token-derived defaults.
  final ChukCheckboxStyle? style;

  /// Whether the checkbox should be focused initially.
  final bool autofocus;

  /// An optional focus node.
  final FocusNode? focusNode;

  /// Accessibility label announced by screen readers.
  final String? semanticLabel;

  @override
  State<ChukCheckbox> createState() => _ChukCheckboxState();
}

class _ChukCheckboxState extends State<ChukCheckbox>
    with SingleTickerProviderStateMixin {
  // Check progress: 0 = unchecked, 1 = checked. The spring can briefly
  // overshoot past 1 for the tick "pop".
  late final AnimationController _c = AnimationController.unbounded(
    vsync: this,
    value: widget.value ? 1 : 0,
  );

  // A snappy spring with a touch of bounce so the tick pops on its way in.
  static const _spring = SpringDescription(
    mass: 1,
    stiffness: 500,
    damping: 22,
  );

  bool _focused = false;

  bool get _enabled => widget.onChanged != null;

  @override
  void didUpdateWidget(ChukCheckbox old) {
    super.didUpdateWidget(old);
    if (old.value != widget.value) {
      final target = widget.value ? 1.0 : 0.0;
      _c.animateWith(SpringSimulation(_spring, _c.value, target, _c.velocity));
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  void _toggle() => widget.onChanged?.call(!widget.value);

  @override
  Widget build(BuildContext context) {
    final t = context.chuk;
    final s = (widget.style ?? const ChukCheckboxStyle());

    final size = s.size ?? 22.0;
    final radius = s.radius ?? 7.0;
    final smoothing = s.smoothing ?? kAppleCornerSmoothing;
    final borderWidth = s.borderWidth ?? 2.0;
    final strokeWidth = s.strokeWidth ?? size * 0.11;
    final borderColor = s.borderColor ?? t.colors.hairlineStrong;
    final fillColor = s.fillColor ?? t.colors.accent;
    final checkColor = s.checkColor ?? t.colors.onAccent;
    final disabledOpacity = s.disabledOpacity ?? 0.45;

    Widget box = AnimatedBuilder(
      animation: _c,
      builder: (context, _) {
        // Draw fraction stays inside [0, 1]; the pop scale rides the raw
        // spring so it can overshoot slightly past full size.
        final draw = _c.value.clamp(0.0, 1.0);
        final pop = _c.value.clamp(0.0, 1.12);

        // Border tracks toward the fill color so it disappears into the fill
        // once fully checked (a seamless accent box).
        final resolvedBorder = Color.lerp(borderColor, fillColor, draw)!;
        final resolvedFill = Color.lerp(
          const Color(0x00000000),
          fillColor,
          draw,
        )!;

        return DecoratedBox(
          decoration: ShapeDecoration(
            color: resolvedFill,
            shape: SquircleBorder(
              radius: radius,
              smoothing: smoothing,
              side: BorderSide(color: resolvedBorder, width: borderWidth),
            ),
          ),
          child: SizedBox.square(
            dimension: size,
            child: draw <= 0
                ? null
                : Transform.scale(
                    scale: pop,
                    child: CustomPaint(
                      painter: _CheckPainter(
                        progress: draw,
                        color: checkColor,
                        strokeWidth: strokeWidth,
                      ),
                    ),
                  ),
          ),
        );
      },
    );

    if (_focused && _enabled) {
      box = DecoratedBox(
        decoration: ShapeDecoration(
          shape: SquircleBorder(
            radius: radius + 3,
            smoothing: smoothing,
            side: BorderSide(
              color: t.colors.focusRing.withValues(alpha: 0.5),
              width: 2,
            ),
          ),
        ),
        child: Padding(padding: const EdgeInsets.all(3), child: box),
      );
    }

    if (!_enabled) {
      box = Opacity(opacity: disabledOpacity, child: box);
    }

    return Semantics(
      checked: widget.value,
      enabled: _enabled,
      label: widget.semanticLabel,
      child: FocusableActionDetector(
        enabled: _enabled,
        focusNode: widget.focusNode,
        autofocus: widget.autofocus,
        onShowFocusHighlight: (v) => setState(() => _focused = v),
        mouseCursor: _enabled
            ? SystemMouseCursors.click
            : SystemMouseCursors.basic,
        actions: {
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (_) {
              _toggle();
              return null;
            },
          ),
        },
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _enabled ? _toggle : null,
          // 44px minimum hit target, centered on the visible box.
          child: Center(
            widthFactor: 1,
            heightFactor: 1,
            child: SizedBox(
              width: size < 44 ? 44 : size,
              height: size < 44 ? 44 : size,
              child: Center(child: box),
            ),
          ),
        ),
      ),
    );
  }
}

/// Paints a checkmark whose stroke is drawn from the start up to [progress]
/// (0..1) of its total length, giving an "unrolling" tick.
class _CheckPainter extends CustomPainter {
  _CheckPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
  });

  /// Fraction of the tick path to draw, 0..1.
  final double progress;

  /// Tick color.
  final Color color;

  /// Tick stroke width.
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final p = progress.clamp(0.0, 1.0);
    if (p <= 0) return;

    final w = size.width;
    final h = size.height;

    // A checkmark: down-stroke into the corner, then up to the top-right.
    final full = Path()
      ..moveTo(w * 0.24, h * 0.52)
      ..lineTo(w * 0.42, h * 0.70)
      ..lineTo(w * 0.76, h * 0.30);

    final metrics = full.computeMetrics().toList();
    var total = 0.0;
    for (final m in metrics) {
      total += m.length;
    }
    final target = total * p;

    final drawn = Path();
    var consumed = 0.0;
    for (final PathMetric m in metrics) {
      final remaining = target - consumed;
      if (remaining <= 0) break;
      final take = remaining < m.length ? remaining : m.length;
      drawn.addPath(m.extractPath(0, take), Offset.zero);
      consumed += m.length;
    }

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(drawn, paint);
  }

  @override
  bool shouldRepaint(covariant _CheckPainter old) =>
      old.progress != progress ||
      old.color != color ||
      old.strokeWidth != strokeWidth;
}
