import 'package:flutter/physics.dart';
import 'package:flutter/widgets.dart';

import '../../theme/chuk_theme.dart';
import 'chuk_radio_style.dart';

/// A single radio button in a group: a circle with a [hairlineStrong]-style
/// ring when unselected, and an accent ring with an accent-filled dot when
/// selected. Styled from the [ChukThemeData], with no Material dependency.
///
/// Selection is expressed the standard way: a set of radios share a
/// [groupValue], and each carries its own [value]. The one whose [value] equals
/// [groupValue] is selected. Tapping a radio calls [onChanged] with its
/// [value]; wire that to `setState` to move the selection.
///
/// The inner dot springs in with a real [SpringSimulation] — it scales up from
/// nothing with a slight settle rather than a linear fade, and the ring color
/// crossfades to the accent in step.
///
/// ```dart
/// ChukRadio<Size>(
///   value: Size.medium,
///   groupValue: _selected,
///   onChanged: (v) => setState(() => _selected = v),
/// )
/// ```
class ChukRadio<T> extends StatefulWidget {
  /// Creates a radio button. Pass `onChanged: null` (or `enabled: false`) to
  /// disable it.
  const ChukRadio({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.enabled = true,
    this.style,
    this.autofocus = false,
    this.focusNode,
    this.semanticLabel,
  });

  /// The value this radio represents within its group.
  final T value;

  /// The currently-selected value of the group. This radio is selected when
  /// [groupValue] equals [value].
  final T? groupValue;

  /// Called with [value] when this radio is tapped while unselected. Pass
  /// `null` to disable.
  final ValueChanged<T>? onChanged;

  /// Whether the radio is interactive. When `false` the control is dimmed and
  /// ignores input, regardless of [onChanged].
  final bool enabled;

  /// Per-instance overrides layered on top of the theme-derived defaults.
  final ChukRadioStyle? style;

  /// Whether the radio should be focused initially.
  final bool autofocus;

  /// An optional focus node.
  final FocusNode? focusNode;

  /// Accessibility label announced by screen readers.
  final String? semanticLabel;

  @override
  State<ChukRadio<T>> createState() => _ChukRadioState<T>();
}

class _ChukRadioState<T> extends State<ChukRadio<T>>
    with SingleTickerProviderStateMixin {
  // Dot presence: 0 = absent (unselected), 1 = fully shown. The spring may
  // briefly overshoot past 1 for a subtle pop; the paint clamps scale to keep
  // the dot inside the ring.
  late final AnimationController _c = AnimationController.unbounded(
    vsync: this,
    value: _selected ? 1 : 0,
  );

  // A lively, lightly under-damped spring so the dot pops in with a small
  // settle.
  static const _spring = SpringDescription(
    mass: 1,
    stiffness: 500,
    damping: 22,
  );

  bool get _selected => widget.value == widget.groupValue;

  bool get _enabled => widget.enabled && widget.onChanged != null;

  @override
  void didUpdateWidget(ChukRadio<T> old) {
    super.didUpdateWidget(old);
    final wasSelected = old.value == old.groupValue;
    if (wasSelected != _selected) {
      final target = _selected ? 1.0 : 0.0;
      _c.animateWith(SpringSimulation(_spring, _c.value, target, _c.velocity));
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  void _select() {
    if (!_selected) widget.onChanged?.call(widget.value);
  }

  @override
  Widget build(BuildContext context) {
    final t = context.chuk;
    final s = widget.style;

    final size = s?.size ?? 22.0;
    final ringWidth = s?.ringWidth ?? 2.0;
    final ringColor = s?.ringColor ?? t.colors.hairlineStrong;
    final selectedRingColor = s?.selectedRingColor ?? t.colors.accent;
    final dotColor = s?.dotColor ?? t.colors.accent;
    final dotRatio = s?.dotRatio ?? 0.5;
    final disabledOpacity = s?.disabledOpacity ?? 0.45;

    Widget control = AnimatedBuilder(
      animation: _c,
      builder: (context, _) {
        final v = _c.value.clamp(0.0, 1.0);
        return CustomPaint(
          size: Size.square(size),
          painter: _RadioPainter(
            progress: v,
            ringWidth: ringWidth,
            ringColor: ringColor,
            selectedRingColor: selectedRingColor,
            dotColor: dotColor,
            dotRatio: dotRatio,
          ),
        );
      },
    );

    if (!_enabled) {
      control = Opacity(opacity: disabledOpacity, child: control);
    }

    // Keep the visible ring centered inside a >=44px hit target.
    control = Center(
      widthFactor: 1,
      heightFactor: 1,
      child: SizedBox.square(dimension: size, child: control),
    );

    return Semantics(
      inMutuallyExclusiveGroup: true,
      checked: _selected,
      enabled: _enabled,
      label: widget.semanticLabel,
      child: FocusableActionDetector(
        enabled: _enabled,
        focusNode: widget.focusNode,
        autofocus: widget.autofocus,
        mouseCursor: _enabled
            ? SystemMouseCursors.click
            : SystemMouseCursors.basic,
        actions: {
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (_) {
              _select();
              return null;
            },
          ),
        },
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _enabled ? _select : null,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
            child: control,
          ),
        ),
      ),
    );
  }
}

/// Paints the ring + spring-scaled dot for a [ChukRadio].
class _RadioPainter extends CustomPainter {
  const _RadioPainter({
    required this.progress,
    required this.ringWidth,
    required this.ringColor,
    required this.selectedRingColor,
    required this.dotColor,
    required this.dotRatio,
  });

  /// Selection progress, 0 (unselected) → 1 (selected).
  final double progress;
  final double ringWidth;
  final Color ringColor;
  final Color selectedRingColor;
  final Color dotColor;
  final double dotRatio;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final ringRadius = (size.shortestSide - ringWidth) / 2;

    final ring = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = ringWidth
      ..color = Color.lerp(ringColor, selectedRingColor, progress)!;
    canvas.drawCircle(center, ringRadius, ring);

    if (progress <= 0) return;

    // Scale the dot in with the (already spring-eased) progress.
    final dotRadius = (size.shortestSide * dotRatio / 2) * progress;
    final dot = Paint()
      ..style = PaintingStyle.fill
      ..color = dotColor;
    canvas.drawCircle(center, dotRadius, dot);
  }

  @override
  bool shouldRepaint(_RadioPainter old) =>
      old.progress != progress ||
      old.ringWidth != ringWidth ||
      old.ringColor != ringColor ||
      old.selectedRingColor != selectedRingColor ||
      old.dotColor != dotColor ||
      old.dotRatio != dotRatio;
}
