import 'package:flutter/widgets.dart';

import '../../theme/chuk_theme.dart';
import 'chuk_switch_style.dart';

/// An on/off toggle whose track and thumb animate between states, styled
/// entirely from the [ChukThemeData]. No Material dependency.
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

    final trackWidth = s.trackWidth ?? 46;
    final trackHeight = s.trackHeight ?? 28;
    final thumbSize = s.thumbSize ?? 22;
    final pad = s.padding ?? 3;
    final disabledOpacity = s.disabledOpacity ?? 0.4;

    final trackColor = value
        ? (s.trackOnColor ?? t.colors.primary)
        : (s.trackOffColor ?? t.colors.border);

    Widget control = AnimatedContainer(
      duration: t.motion.medium,
      curve: t.motion.standard,
      width: trackWidth,
      height: trackHeight,
      padding: EdgeInsets.all(pad),
      decoration: BoxDecoration(
        color: trackColor,
        borderRadius: BorderRadius.circular(trackHeight / 2),
      ),
      child: AnimatedAlign(
        duration: t.motion.medium,
        curve: t.motion.standard,
        alignment: value ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          width: thumbSize,
          height: thumbSize,
          decoration: BoxDecoration(
            color: s.thumbColor ?? t.colors.surface,
            shape: BoxShape.circle,
            boxShadow: const [
              BoxShadow(
                color: Color(0x33000000),
                blurRadius: 4,
                offset: Offset(0, 1),
              ),
            ],
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
