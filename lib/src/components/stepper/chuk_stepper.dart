import 'package:flutter/widgets.dart';

import '../../shape/chuk_squircle.dart';
import '../../theme/chuk_theme.dart';
import 'chuk_stepper_style.dart';

/// A compact numeric stepper: a pill track holding a round `−` button, the
/// current value, and a round `+` button. Styled entirely from the
/// [ChukThemeData] — no Material dependency.
///
/// The `+` / `−` glyphs are drawn with a [CustomPainter] (no icon font), so the
/// control carries no asset weight. Tapping a button nudges the value by [step],
/// clamped to `[min, max]`; the value animates in with a short slide. When a
/// bound is reached the corresponding button greys out and stops responding,
/// and passing `onChanged: null` disables the whole control.
///
/// ```dart
/// ChukStepper(
///   value: quantity,
///   min: 1,
///   max: 99,
///   onChanged: (v) => setState(() => quantity = v),
/// )
/// ```
class ChukStepper extends StatefulWidget {
  const ChukStepper({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max = 999,
    this.step = 1,
    this.style,
    this.semanticLabel,
  }) : assert(step > 0, 'step must be positive'),
       assert(min <= max, 'min must be <= max');

  /// The current value. Callers should keep this within `[min, max]`.
  final int value;

  /// Called with the new value when `+` / `−` is tapped. Pass `null` to disable
  /// the whole control.
  final ValueChanged<int>? onChanged;

  /// The smallest allowed value (inclusive).
  final int min;

  /// The largest allowed value (inclusive).
  final int max;

  /// How much each `+` / `−` tap changes the value. Must be positive.
  final int step;

  /// Per-instance overrides layered on top of the theme-derived default style.
  final ChukStepperStyle? style;

  /// Accessibility label announced by screen readers (e.g. "Quantity").
  final String? semanticLabel;

  /// Whether the whole control is interactive.
  bool get _enabled => onChanged != null;

  /// Whether the `−` button can currently act.
  bool get _canDecrement => _enabled && value > min;

  /// Whether the `+` button can currently act.
  bool get _canIncrement => _enabled && value < max;

  @override
  State<ChukStepper> createState() => _ChukStepperState();
}

class _ChukStepperState extends State<ChukStepper> {
  // Direction of the last change (+1 / -1), used to slide the value in from the
  // matching side. Starts at +1 for the first appearance.
  int _lastDir = 1;

  void _nudge(int dir) {
    final next = (widget.value + dir * widget.step).clamp(
      widget.min,
      widget.max,
    );
    if (next == widget.value) return;
    _lastDir = dir;
    widget.onChanged!(next);
  }

  /// Builds the default style from the theme tokens. Overrides from
  /// `widget.style` are merged on top of this.
  ChukStepperStyle _defaultStyle(BuildContext context) {
    final t = context.chuk;
    return ChukStepperStyle(
      trackColor: t.colors.surfaceInset,
      glyphColor: t.colors.accent,
      disabledGlyphColor: t.colors.textTertiary,
      valueColor: t.colors.textPrimary,
      buttonOverlay: t.isLight
          ? const Color(0x14000000)
          : const Color(0x1FFFFFFF),
      height: 44,
      buttonSize: 44,
      valueMinWidth: 44,
      glyphSize: 15,
      glyphStrokeWidth: 2,
      radius: t.radii.pill,
      textStyle: t.typography.label,
      disabledOpacity: 0.45,
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = context.chuk;
    final s = _defaultStyle(context).merge(widget.style);

    final height = s.height ?? 44;
    final buttonSize = s.buttonSize ?? 44;
    final radius = s.radius ?? t.radii.pill;

    final valueStyle = (s.textStyle ?? t.typography.label).copyWith(
      color: s.valueColor ?? t.colors.textPrimary,
      // Tabular figures keep the value column from jittering as digits change.
      fontFeatures: const [FontFeature.tabularFigures()],
    );

    Widget control = DecoratedBox(
      decoration: ShapeDecoration(
        color: s.trackColor ?? t.colors.surfaceInset,
        shape: SquircleBorder(radius: radius, smoothing: kAppleCornerSmoothing),
      ),
      child: SizedBox(
        height: height,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _StepperButton(
              isPlus: false,
              size: buttonSize,
              enabled: widget._canDecrement,
              glyphColor: s.glyphColor ?? t.colors.accent,
              disabledGlyphColor: s.disabledGlyphColor ?? t.colors.textTertiary,
              overlayColor: s.buttonOverlay ?? const Color(0x1FFFFFFF),
              glyphSize: s.glyphSize ?? 15,
              strokeWidth: s.glyphStrokeWidth ?? 2,
              motionDuration: t.motion.fast,
              motionCurve: t.motion.standard,
              onTap: () => _nudge(-1),
            ),
            ConstrainedBox(
              constraints: BoxConstraints(minWidth: s.valueMinWidth ?? 44),
              child: AnimatedSwitcher(
                duration: t.motion.medium,
                switchInCurve: t.motion.standard,
                switchOutCurve: t.motion.standard,
                transitionBuilder: (child, animation) {
                  final slide = Tween<Offset>(
                    begin: Offset(0, 0.4 * _lastDir),
                    end: Offset.zero,
                  ).animate(animation);
                  return ClipRect(
                    child: FadeTransition(
                      opacity: animation,
                      child: SlideTransition(position: slide, child: child),
                    ),
                  );
                },
                child: Text(
                  '${widget.value}',
                  key: ValueKey<int>(widget.value),
                  textAlign: TextAlign.center,
                  style: valueStyle,
                ),
              ),
            ),
            _StepperButton(
              isPlus: true,
              size: buttonSize,
              enabled: widget._canIncrement,
              glyphColor: s.glyphColor ?? t.colors.accent,
              disabledGlyphColor: s.disabledGlyphColor ?? t.colors.textTertiary,
              overlayColor: s.buttonOverlay ?? const Color(0x1FFFFFFF),
              glyphSize: s.glyphSize ?? 15,
              strokeWidth: s.glyphStrokeWidth ?? 2,
              motionDuration: t.motion.fast,
              motionCurve: t.motion.standard,
              onTap: () => _nudge(1),
            ),
          ],
        ),
      ),
    );

    if (!widget._enabled) {
      control = Opacity(opacity: s.disabledOpacity ?? 0.45, child: control);
    }

    return Semantics(
      container: true,
      enabled: widget._enabled,
      label: widget.semanticLabel,
      value: '${widget.value}',
      // Let assistive tech drive the value directly.
      onIncrease: widget._canIncrement ? () => _nudge(1) : null,
      onDecrease: widget._canDecrement ? () => _nudge(-1) : null,
      child: control,
    );
  }
}

/// A single round `+` / `−` tap target inside a [ChukStepper]. Paints its glyph
/// with [_GlyphPainter] and shows a translucent circular overlay while pressed
/// or hovered.
class _StepperButton extends StatefulWidget {
  const _StepperButton({
    required this.isPlus,
    required this.size,
    required this.enabled,
    required this.glyphColor,
    required this.disabledGlyphColor,
    required this.overlayColor,
    required this.glyphSize,
    required this.strokeWidth,
    required this.motionDuration,
    required this.motionCurve,
    required this.onTap,
  });

  final bool isPlus;
  final double size;
  final bool enabled;
  final Color glyphColor;
  final Color disabledGlyphColor;
  final Color overlayColor;
  final double glyphSize;
  final double strokeWidth;
  final Duration motionDuration;
  final Curve motionCurve;
  final VoidCallback onTap;

  @override
  State<_StepperButton> createState() => _StepperButtonState();
}

class _StepperButtonState extends State<_StepperButton> {
  bool _hovered = false;
  bool _pressed = false;
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final active = widget.enabled && (_pressed || _hovered);
    final glyphColor = widget.enabled
        ? widget.glyphColor
        : widget.disabledGlyphColor;

    final Widget glyph = AnimatedContainer(
      duration: widget.motionDuration,
      curve: widget.motionCurve,
      width: widget.size,
      height: widget.size,
      alignment: Alignment.center,
      decoration: ShapeDecoration(
        shape: const CircleBorder(),
        color: active ? widget.overlayColor : const Color(0x00000000),
        shadows: _focused && widget.enabled
            ? [
                BoxShadow(
                  color: widget.glyphColor.withValues(alpha: 0.45),
                  blurRadius: 0,
                  spreadRadius: 2.5,
                ),
              ]
            : null,
      ),
      child: AnimatedScale(
        scale: _pressed && widget.enabled ? 0.82 : 1,
        duration: widget.motionDuration,
        curve: widget.motionCurve,
        child: CustomPaint(
          size: Size.square(widget.glyphSize),
          painter: _GlyphPainter(
            isPlus: widget.isPlus,
            color: glyphColor,
            strokeWidth: widget.strokeWidth,
          ),
        ),
      ),
    );

    return Semantics(
      button: true,
      enabled: widget.enabled,
      label: widget.isPlus ? 'Increase' : 'Decrease',
      excludeSemantics: true,
      child: FocusableActionDetector(
        enabled: widget.enabled,
        onShowHoverHighlight: (v) => setState(() => _hovered = v),
        onShowFocusHighlight: (v) => setState(() => _focused = v),
        mouseCursor: widget.enabled
            ? SystemMouseCursors.click
            : SystemMouseCursors.basic,
        actions: {
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (_) {
              widget.onTap();
              return null;
            },
          ),
        },
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.enabled ? widget.onTap : null,
          onTapDown: widget.enabled
              ? (_) => setState(() => _pressed = true)
              : null,
          onTapUp: widget.enabled
              ? (_) => setState(() => _pressed = false)
              : null,
          onTapCancel: widget.enabled
              ? () => setState(() => _pressed = false)
              : null,
          child: glyph,
        ),
      ),
    );
  }
}

/// Paints a `+` or `−` glyph with rounded stroke caps, centered in its box.
class _GlyphPainter extends CustomPainter {
  _GlyphPainter({
    required this.isPlus,
    required this.color,
    required this.strokeWidth,
  });

  final bool isPlus;
  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    final cx = size.width / 2;
    final cy = size.height / 2;
    // Inset so the rounded caps sit inside the box.
    final half = (size.width / 2) - strokeWidth / 2;

    // Horizontal bar (shared by + and −).
    canvas.drawLine(Offset(cx - half, cy), Offset(cx + half, cy), paint);
    if (isPlus) {
      canvas.drawLine(Offset(cx, cy - half), Offset(cx, cy + half), paint);
    }
  }

  @override
  bool shouldRepaint(_GlyphPainter old) =>
      old.isPlus != isPlus ||
      old.color != color ||
      old.strokeWidth != strokeWidth;
}
