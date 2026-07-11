import 'package:flutter/widgets.dart';

import '../../theme/chuk_theme.dart';
import 'chuk_switch_style.dart';

/// An on/off toggle: a translucent pill track with a **half-width knob** that
/// glides between halves — grey when off, accent-tinted when on. Styled from
/// the [ChukThemeData], no Material dependency.
///
/// Ported from the reference app's toggle (58×30, 340 ms easeOutCubic slide).
///
/// ```dart
/// ChukSwitch(
///   value: notifications,
///   onChanged: (v) => setState(() => notifications = v),
/// )
/// ```
class ChukSwitch extends StatelessWidget {
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

  bool get _enabled => onChanged != null;

  void _toggle() => onChanged?.call(!value);

  @override
  Widget build(BuildContext context) {
    final t = context.chuk;
    final s = t.switchStyle.merge(style);

    final width = s.width ?? 58;
    final height = s.height ?? 30;
    final pad = s.padding ?? 3;
    final radius = BorderRadius.circular(s.radius ?? t.radii.pill);
    final disabledOpacity = s.disabledOpacity ?? 0.45;

    final knobColor = value
        ? (s.knobOnColor ?? t.colors.accent.withValues(alpha: 0.60))
        : (s.knobOffColor ?? const Color(0x24FFFFFF));

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
      child: Padding(
        padding: EdgeInsets.all(pad),
        child: AnimatedAlign(
          alignment: value ? const Alignment(1, 0) : const Alignment(-1, 0),
          duration: t.motion.slow,
          curve: t.motion.standard,
          child: FractionallySizedBox(
            widthFactor: 0.5,
            heightFactor: 1,
            child: AnimatedContainer(
              duration: t.motion.slow,
              curve: t.motion.standard,
              decoration: BoxDecoration(color: knobColor, borderRadius: radius),
            ),
          ),
        ),
      ),
    );

    if (!_enabled) {
      control = Opacity(opacity: disabledOpacity, child: control);
    }

    return Semantics(
      toggled: value,
      enabled: _enabled,
      label: semanticLabel,
      child: FocusableActionDetector(
        enabled: _enabled,
        focusNode: focusNode,
        autofocus: autofocus,
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
