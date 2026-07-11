import 'dart:ui' show lerpDouble;

import 'package:flutter/physics.dart';
import 'package:flutter/widgets.dart';

import '../../theme/chuk_theme.dart';
import 'chuk_switch_style.dart';

/// An on/off toggle: a translucent pill track with a **half-width knob** that
/// springs between halves — grey when off, accent-tinted when on. Styled from
/// the [ChukThemeData], no Material dependency.
///
/// The knob is driven by a real [SpringSimulation], so it snaps with a natural,
/// slightly bouncy settle rather than a linear slide.
///
/// ```dart
/// ChukSwitch(
///   value: notifications,
///   onChanged: (v) => setState(() => notifications = v),
/// )
/// ```
class ChukSwitch extends StatefulWidget {
  const ChukSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.style,
    this.autofocus = false,
    this.focusNode,
    this.semanticLabel,
  });

  /// Whether the switch is on.
  final bool value;

  /// Called with the new value when toggled. Pass `null` to disable.
  final ValueChanged<bool>? onChanged;

  /// Per-instance overrides layered on top of the theme's switch style.
  final ChukSwitchStyle? style;

  /// Whether the switch should be focused initially.
  final bool autofocus;

  /// An optional focus node.
  final FocusNode? focusNode;

  /// Accessibility label announced by screen readers.
  final String? semanticLabel;

  @override
  State<ChukSwitch> createState() => _ChukSwitchState();
}

class _ChukSwitchState extends State<ChukSwitch>
    with SingleTickerProviderStateMixin {
  // Position of the knob: 0 = off (left), 1 = on (right). The spring can
  // briefly overshoot outside [0, 1] for the bounce.
  late final AnimationController _c = AnimationController.unbounded(
    vsync: this,
    value: widget.value ? 1 : 0,
  );

  // A snappy, (near) critically-damped spring — quick settle, no overshoot
  // past the track edge.
  static const _spring = SpringDescription(mass: 1, stiffness: 520, damping: 30);

  bool get _enabled => widget.onChanged != null;

  @override
  void didUpdateWidget(ChukSwitch old) {
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
    final s = t.switchStyle.merge(widget.style);

    final width = s.width ?? 58;
    final height = s.height ?? 30;
    final pad = s.padding ?? 3;
    final radius = BorderRadius.circular(s.radius ?? t.radii.pill);
    final disabledOpacity = s.disabledOpacity ?? 0.45;

    final onColor = s.knobOnColor ?? t.colors.accent;
    final offColor = s.knobOffColor ?? const Color(0x24FFFFFF);

    Widget control = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: s.trackColor ?? t.colors.surfaceRaised,
        borderRadius: radius,
        border: s.borderColor != null
            ? Border.all(color: s.borderColor!, width: 1)
            : null,
        boxShadow: s.shadow,
      ),
      // Clip so the spring overshoot presses cleanly against the rounded end.
      child: ClipRRect(
        borderRadius: radius,
        child: Padding(
          padding: EdgeInsets.all(pad),
          child: AnimatedBuilder(
            animation: _c,
            builder: (context, _) {
              // Clamp the knob to the track so the spring never pokes out.
              final clamped = _c.value.clamp(0.0, 1.0);
              return Align(
                alignment: Alignment(lerpDouble(-1, 1, clamped)!, 0),
                child: FractionallySizedBox(
                  widthFactor: 0.5,
                  heightFactor: 1,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Color.lerp(offColor, onColor, clamped),
                      borderRadius: radius,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );

    if (!_enabled) {
      control = Opacity(opacity: disabledOpacity, child: control);
    }

    return Semantics(
      toggled: widget.value,
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
              _toggle();
              return null;
            },
          ),
        },
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _enabled ? _toggle : null,
          child: control,
        ),
      ),
    );
  }
}
