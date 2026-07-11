import 'dart:math' as math;

import 'package:flutter/physics.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../shape/chuk_glass.dart';
import '../../shape/chuk_squircle.dart';
import '../../theme/chuk_theme.dart';
import '../../theme/chuk_theme_data.dart';
import 'chuk_slider_style.dart';

/// A horizontal, draggable slider — a rounded track (inactive = hairline,
/// active = accent) with a round floating thumb you swipe with the mouse or
/// finger. Styled entirely from the [ChukThemeData]; no Material dependency.
///
/// The thumb tracks your finger smoothly while dragging. On release, if
/// [divisions] is set, it *settles* onto the nearest division with a real
/// [SpringSimulation] (a natural, slightly-bouncy snap); a continuous slider
/// simply stays where you left it. In light themes the thumb is frosted glass,
/// matching the rest of the system's raised surfaces.
///
/// Pass `onChanged: null` to disable the control. Arrow keys nudge the value
/// while focused.
///
/// ```dart
/// ChukSlider(
///   value: volume,
///   onChanged: (v) => setState(() => volume = v),
/// )
///
/// ChukSlider(
///   value: rating,
///   min: 1,
///   max: 5,
///   divisions: 4,
///   onChanged: (v) => setState(() => rating = v),
/// )
/// ```
class ChukSlider extends StatefulWidget {
  const ChukSlider({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 0.0,
    this.max = 1.0,
    this.divisions,
    this.style,
    this.autofocus = false,
    this.focusNode,
    this.semanticLabel,
    this.semanticFormatter,
  }) : assert(max > min, 'max must be greater than min'),
       assert(divisions == null || divisions > 0, 'divisions must be > 0');

  /// The current value, clamped to [[min], [max]].
  final double value;

  /// Called with the new value while dragging and on keyboard nudges. Pass
  /// `null` to disable the slider.
  final ValueChanged<double>? onChanged;

  /// The minimum value (left end). Defaults to 0.
  final double min;

  /// The maximum value (right end). Defaults to 1.
  final double max;

  /// If non-null, the slider snaps to this many equal intervals, producing
  /// `divisions + 1` selectable stops. Null means a continuous slider.
  final int? divisions;

  /// Per-instance overrides layered on top of the theme-derived defaults.
  final ChukSliderStyle? style;

  /// Whether the slider should be focused initially.
  final bool autofocus;

  /// An optional focus node.
  final FocusNode? focusNode;

  /// Accessibility label announced by screen readers.
  final String? semanticLabel;

  /// Formats the current value for screen readers. Defaults to a percentage of
  /// the [min]–[max] range.
  final String Function(double value)? semanticFormatter;

  @override
  State<ChukSlider> createState() => _ChukSliderState();
}

class _ChukSliderState extends State<ChukSlider>
    with SingleTickerProviderStateMixin {
  // Normalized thumb position, 0 (min) … 1 (max). Unbounded so the settle
  // spring can briefly overshoot for the bounce; it's clamped when painted.
  late final AnimationController _pos = AnimationController.unbounded(
    vsync: this,
    value: _fractionOf(widget.value),
  );

  // Snappy, near-critically-damped spring for the division settle.
  static const _spring = SpringDescription(
    mass: 1,
    stiffness: 500,
    damping: 28,
  );

  bool _dragging = false;
  bool _focused = false;

  bool get _enabled => widget.onChanged != null;

  double _fractionOf(double value) {
    final range = widget.max - widget.min;
    if (range <= 0) return 0;
    return ((value - widget.min) / range).clamp(0.0, 1.0);
  }

  double _valueOfFraction(double fraction) {
    final f = fraction.clamp(0.0, 1.0);
    final divisions = widget.divisions;
    final snapped = divisions == null ? f : (f * divisions).round() / divisions;
    return widget.min + snapped * (widget.max - widget.min);
  }

  @override
  void didUpdateWidget(ChukSlider old) {
    super.didUpdateWidget(old);
    // Sync the thumb to an externally-driven value change, but never fight the
    // finger while a drag is in progress.
    if (!_dragging && old.value != widget.value) {
      _pos.animateWith(
        SpringSimulation(_spring, _pos.value, _fractionOf(widget.value), 0),
      );
    }
  }

  @override
  void dispose() {
    _pos.dispose();
    super.dispose();
  }

  // Maps a local x within the track to a normalized fraction, accounting for
  // the thumb radius so the thumb stays fully inside the track at both ends.
  double _fractionFromLocal(double localX, double width, double thumbSize) {
    final travel = width - thumbSize;
    if (travel <= 0) return 0;
    return ((localX - thumbSize / 2) / travel).clamp(0.0, 1.0);
  }

  void _emit(double value) {
    if (value != widget.value) widget.onChanged?.call(value);
  }

  void _onDrag(double localX, double width, double thumbSize) {
    final fraction = _fractionFromLocal(localX, width, thumbSize);
    // Thumb follows the finger directly (smooth); the emitted value snaps.
    _pos.value = fraction;
    _emit(_valueOfFraction(fraction));
  }

  void _onDragEnd() {
    _dragging = false;
    // Settle onto the resolved (possibly snapped) value.
    _pos.animateWith(
      SpringSimulation(_spring, _pos.value, _fractionOf(widget.value), 0),
    );
  }

  void _nudge(int direction) {
    final divisions = widget.divisions;
    final range = widget.max - widget.min;
    final step = divisions == null ? range / 10 : range / divisions;
    final next = (widget.value + direction * step).clamp(
      widget.min,
      widget.max,
    );
    _emit(next.toDouble());
  }

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (!_enabled) return KeyEventResult.ignored;
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }
    final key = event.logicalKey;
    if (key == LogicalKeyboardKey.arrowLeft ||
        key == LogicalKeyboardKey.arrowDown) {
      _nudge(-1);
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.arrowRight ||
        key == LogicalKeyboardKey.arrowUp) {
      _nudge(1);
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  String _semanticValue() {
    if (widget.semanticFormatter != null) {
      return widget.semanticFormatter!(widget.value);
    }
    final pct = (_fractionOf(widget.value) * 100).round();
    return '$pct%';
  }

  @override
  Widget build(BuildContext context) {
    final t = context.chuk;
    final s = _themeDefaults(t).merge(widget.style);

    final inactive = s.inactiveTrackColor!;
    final active = s.activeTrackColor!;
    final thumbColor = s.thumbColor!;
    final trackHeight = s.trackHeight!;
    final thumbSize = s.thumbSize!;
    final trackRadius = s.trackRadius!;
    final disabledOpacity = s.disabledOpacity!;
    final thumbShadow = s.thumbShadow;

    // 44px minimum tap target regardless of the visual thumb size.
    final rowHeight = math.max(44.0, thumbSize);

    final trackShape = SquircleBorder(
      radius: trackRadius,
      smoothing: kAppleCornerSmoothing,
    );
    final thumbShape = SquircleBorder(
      radius: thumbSize / 2,
      smoothing: kAppleCornerSmoothing,
    );

    Widget thumb = t.isLight
        ? ChukGlass(
            shape: thumbShape,
            fill: thumbColor.withValues(alpha: 0.42),
            shadow: thumbShadow,
            child: SizedBox.square(dimension: thumbSize),
          )
        : DecoratedBox(
            decoration: ShapeDecoration(
              color: thumbColor,
              shape: thumbShape,
              shadows: thumbShadow,
            ),
            child: SizedBox.square(dimension: thumbSize),
          );

    // Focus ring around the thumb when keyboard-focused.
    if (_focused && _enabled) {
      thumb = DecoratedBox(
        decoration: ShapeDecoration(
          shape: thumbShape,
          shadows: [
            BoxShadow(
              color: t.colors.focusRing.withValues(alpha: 0.5),
              blurRadius: 0,
              spreadRadius: 3,
            ),
          ],
        ),
        child: thumb,
      );
    }

    Widget content = LayoutBuilder(
      builder: (context, c) {
        final width = c.maxWidth;
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onHorizontalDragStart: _enabled
              ? (d) {
                  _dragging = true;
                  _onDrag(d.localPosition.dx, width, thumbSize);
                }
              : null,
          onHorizontalDragUpdate: _enabled
              ? (d) => _onDrag(d.localPosition.dx, width, thumbSize)
              : null,
          onHorizontalDragEnd: _enabled ? (_) => _onDragEnd() : null,
          onHorizontalDragCancel: _enabled ? _onDragEnd : null,
          // A tap anywhere on the track jumps the thumb there.
          onTapDown: _enabled
              ? (d) {
                  _dragging = true;
                  _onDrag(d.localPosition.dx, width, thumbSize);
                }
              : null,
          onTapUp: _enabled ? (_) => _onDragEnd() : null,
          onTapCancel: _enabled ? _onDragEnd : null,
          child: SizedBox(
            height: rowHeight,
            width: double.infinity,
            child: AnimatedBuilder(
              animation: _pos,
              builder: (context, _) {
                final fraction = _pos.value.clamp(0.0, 1.0);
                final travel = math.max(0.0, width - thumbSize);
                final thumbCenter = thumbSize / 2 + fraction * travel;
                return Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    // Inactive track (full width).
                    DecoratedBox(
                      decoration: ShapeDecoration(
                        color: inactive,
                        shape: trackShape,
                      ),
                      child: SizedBox(
                        height: trackHeight,
                        width: double.infinity,
                      ),
                    ),
                    // Active track (left end → thumb centre).
                    DecoratedBox(
                      decoration: ShapeDecoration(
                        color: active,
                        shape: trackShape,
                      ),
                      child: SizedBox(height: trackHeight, width: thumbCenter),
                    ),
                    // Thumb.
                    Positioned(left: thumbCenter - thumbSize / 2, child: thumb),
                  ],
                );
              },
            ),
          ),
        );
      },
    );

    if (!_enabled) {
      content = Opacity(opacity: disabledOpacity, child: content);
    }

    return Semantics(
      slider: true,
      enabled: _enabled,
      label: widget.semanticLabel,
      value: _semanticValue(),
      // increased/decreased values are required alongside value + on(In|De)crease.
      increasedValue: _semanticValue(),
      decreasedValue: _semanticValue(),
      onIncrease: _enabled ? () => _nudge(1) : null,
      onDecrease: _enabled ? () => _nudge(-1) : null,
      child: Focus(
        focusNode: widget.focusNode,
        autofocus: widget.autofocus,
        onFocusChange: (f) => setState(() => _focused = f),
        onKeyEvent: _onKey,
        child: MouseRegion(
          cursor: _enabled
              ? SystemMouseCursors.click
              : SystemMouseCursors.basic,
          child: content,
        ),
      ),
    );
  }

  // The theme-derived default style: tokens become a look here, exactly once.
  ChukSliderStyle _themeDefaults(ChukThemeData t) {
    return ChukSliderStyle(
      inactiveTrackColor: t.colors.hairlineStrong,
      activeTrackColor: t.colors.accent,
      thumbColor: t.colors.surfaceRaised,
      trackHeight: 6,
      thumbSize: 22,
      trackRadius: t.radii.pill,
      disabledOpacity: 0.45,
      thumbShadow: [
        BoxShadow(
          color: Color(t.isLight ? 0x33000000 : 0x66000000),
          blurRadius: 10,
          offset: const Offset(0, 3),
        ),
      ],
    );
  }
}
