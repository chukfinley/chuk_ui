import 'package:flutter/widgets.dart';

import '../../shape/chuk_squircle.dart';
import '../../theme/chuk_theme.dart';
import 'chuk_button_style.dart';

/// The visual variants a [ChukButton] can take. Each maps to a default style
/// on the theme, so `ChukButton.primary` and `ChukButton.ghost` look right
/// out of the box.
enum ChukButtonVariant {
  /// The main call-to-action.
  primary,

  /// A lower-emphasis filled button.
  secondary,

  /// A transparent, outlined button.
  ghost,

  /// A destructive action.
  danger,
}

/// A pressable button whose look comes entirely from the [ChukThemeData] —
/// no Material dependency.
///
/// Style is resolved in three layers: the theme's default for the [variant],
/// then any [style] passed here, then per-interaction state (hover / pressed /
/// disabled). Pass `onPressed: null` to disable it, exactly like a Material
/// button.
///
/// ```dart
/// ChukButton.primary(
///   onPressed: () => save(),
///   child: const Text('Save'),
/// )
/// ```
class ChukButton extends StatefulWidget {
  const ChukButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.variant = ChukButtonVariant.primary,
    this.style,
    this.expand = false,
    this.autofocus = false,
    this.focusNode,
    this.semanticLabel,
  });

  /// A primary button.
  const ChukButton.primary({
    super.key,
    required this.onPressed,
    required this.child,
    this.style,
    this.expand = false,
    this.autofocus = false,
    this.focusNode,
    this.semanticLabel,
  }) : variant = ChukButtonVariant.primary;

  /// A secondary button.
  const ChukButton.secondary({
    super.key,
    required this.onPressed,
    required this.child,
    this.style,
    this.expand = false,
    this.autofocus = false,
    this.focusNode,
    this.semanticLabel,
  }) : variant = ChukButtonVariant.secondary;

  /// A ghost (outlined, transparent) button.
  const ChukButton.ghost({
    super.key,
    required this.onPressed,
    required this.child,
    this.style,
    this.expand = false,
    this.autofocus = false,
    this.focusNode,
    this.semanticLabel,
  }) : variant = ChukButtonVariant.ghost;

  /// A destructive button.
  const ChukButton.danger({
    super.key,
    required this.onPressed,
    required this.child,
    this.style,
    this.expand = false,
    this.autofocus = false,
    this.focusNode,
    this.semanticLabel,
  }) : variant = ChukButtonVariant.danger;

  /// Called when the button is tapped. Pass `null` to disable the button.
  final VoidCallback? onPressed;

  /// The button's content. A bare [Text] inherits the resolved label style.
  final Widget child;

  /// Which default style to start from.
  final ChukButtonVariant variant;

  /// Per-instance overrides layered on top of the variant's theme style.
  final ChukButtonStyle? style;

  /// When true, the button stretches to fill its horizontal constraints.
  final bool expand;

  /// Whether this button should be focused initially.
  final bool autofocus;

  /// An optional focus node to control the button's focus.
  final FocusNode? focusNode;

  /// Accessibility label announced by screen readers. Defaults to the child's
  /// own semantics when null.
  final String? semanticLabel;

  @override
  State<ChukButton> createState() => _ChukButtonState();
}

class _ChukButtonState extends State<ChukButton> {
  bool _hovered = false;
  bool _pressed = false;
  bool _focused = false;

  bool get _enabled => widget.onPressed != null;

  ChukButtonStyle _variantStyle(BuildContext context) {
    final t = context.chuk;
    switch (widget.variant) {
      case ChukButtonVariant.primary:
        return t.primaryButton;
      case ChukButtonVariant.secondary:
        return t.secondaryButton;
      case ChukButtonVariant.ghost:
        return t.ghostButton;
      case ChukButtonVariant.danger:
        return t.dangerButton;
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.chuk;
    final s = _variantStyle(context).merge(widget.style);

    final background = _enabled
        ? (s.background ?? const Color(0x00000000))
        : (s.disabledBackground ?? s.background ?? const Color(0x00000000));
    final foreground = _enabled
        ? (s.foreground ?? t.colors.textPrimary)
        : (s.disabledForeground ?? s.foreground ?? t.colors.textTertiary);

    // Blend the interaction overlay over the resting background.
    var fill = background;
    if (_enabled) {
      if (_pressed && s.pressedOverlay != null) {
        fill = Color.alphaBlend(s.pressedOverlay!, fill);
      } else if (_hovered && s.hoverOverlay != null) {
        fill = Color.alphaBlend(s.hoverOverlay!, fill);
      }
    }

    final showBorder = (s.borderWidth ?? 0) > 0 && s.borderColor != null;

    // Apple-style continuously-curved corners. A large default radius reads as
    // a smooth stadium/pill; smoothing softens the seam.
    final shape = SquircleBorder(
      radius: s.radius ?? t.radii.pill,
      smoothing: s.smoothing ?? kAppleCornerSmoothing,
      side: showBorder
          ? BorderSide(color: s.borderColor!, width: s.borderWidth!)
          : BorderSide.none,
    );

    final Widget content = DefaultTextStyle.merge(
      style: (s.textStyle ?? t.typography.label).copyWith(color: foreground),
      child: IconTheme.merge(
        data: IconThemeData(color: foreground),
        child: widget.child,
      ),
    );

    final Widget button = AnimatedContainer(
      duration: t.motion.fast,
      curve: t.motion.standard,
      constraints: BoxConstraints(minHeight: s.minHeight ?? 44),
      padding: s.padding ?? EdgeInsets.all(t.spacing.md),
      decoration: ShapeDecoration(
        color: fill,
        shape: shape,
        shadows: _focused && _enabled
            ? [
                BoxShadow(
                  color: t.colors.focusRing.withValues(alpha: 0.5),
                  blurRadius: 0,
                  spreadRadius: 3,
                ),
              ]
            : null,
      ),
      child: Align(
        // Shrink-wrap the label unless the button is asked to expand.
        widthFactor: widget.expand ? null : 1.0,
        child: content,
      ),
    );

    return Semantics(
      button: true,
      enabled: _enabled,
      label: widget.semanticLabel,
      child: FocusableActionDetector(
        enabled: _enabled,
        focusNode: widget.focusNode,
        autofocus: widget.autofocus,
        onShowHoverHighlight: (v) => setState(() => _hovered = v),
        onShowFocusHighlight: (v) => setState(() => _focused = v),
        actions: {
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (_) {
              widget.onPressed?.call();
              return null;
            },
          ),
        },
        mouseCursor: _enabled
            ? SystemMouseCursors.click
            : SystemMouseCursors.basic,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _enabled ? widget.onPressed : null,
          onTapDown: _enabled ? (_) => setState(() => _pressed = true) : null,
          onTapUp: _enabled ? (_) => setState(() => _pressed = false) : null,
          onTapCancel:
              _enabled ? () => setState(() => _pressed = false) : null,
          child: button,
        ),
      ),
    );
  }
}
