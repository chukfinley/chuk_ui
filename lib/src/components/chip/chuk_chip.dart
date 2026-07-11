import 'package:flutter/widgets.dart';

import '../../shape/chuk_glass.dart';
import '../../shape/chuk_squircle.dart';
import '../../theme/chuk_theme.dart';

/// A compact, pill-shaped **chip** — a filter tag, a choice token, or a
/// removable entry — whose look comes entirely from the [ChukThemeData] with no
/// Material dependency.
///
/// Two resting looks, driven by [selected]:
///  * **unselected** — a raised surface (frosted glass in light mode) with
///    primary text;
///  * **selected** — an [ChukColors.accent] fill with [ChukColors.onAccent]
///    text, exactly matching the primary button.
///
/// Pass [onPressed] to make it tappable (toggling selection is the caller's
/// job — flip [selected] in your state). Pass `onPressed: null` to disable it,
/// exactly like a Material control. An optional leading [icon] sits before the
/// label, and an optional [onDeleted] adds a trailing "✕" that removes the chip
/// without triggering [onPressed].
///
/// ```dart
/// ChukChip(
///   label: 'Strength',
///   icon: Icons.bolt,
///   selected: _selected.contains('strength'),
///   onPressed: () => setState(() => _toggle('strength')),
/// )
/// ```
class ChukChip extends StatefulWidget {
  const ChukChip({
    super.key,
    required this.label,
    this.selected = false,
    this.onPressed,
    this.onDeleted,
    this.icon,
    this.autofocus = false,
    this.focusNode,
    this.semanticLabel,
  });

  /// The visible text.
  final String label;

  /// Whether this chip reads as selected (accent fill). The caller owns this
  /// state; flip it in response to [onPressed].
  final bool selected;

  /// Called when the chip body is tapped. Pass `null` to disable the chip.
  final VoidCallback? onPressed;

  /// When non-null, a trailing "✕" affordance is shown; tapping it calls this
  /// and does **not** trigger [onPressed].
  final VoidCallback? onDeleted;

  /// An optional leading icon, drawn in the current content color.
  final IconData? icon;

  /// Whether this chip should be focused initially.
  final bool autofocus;

  /// An optional focus node to control the chip's focus.
  final FocusNode? focusNode;

  /// Accessibility label announced by screen readers. Defaults to [label].
  final String? semanticLabel;

  @override
  State<ChukChip> createState() => _ChukChipState();
}

class _ChukChipState extends State<ChukChip> {
  bool _hovered = false;
  bool _pressed = false;
  bool _focused = false;

  bool get _enabled => widget.onPressed != null;

  @override
  Widget build(BuildContext context) {
    final t = context.chuk;
    final colors = t.colors;

    // Continuously-curved pill, like the buttons and the segmented control.
    final shape = SquircleBorder(
      radius: t.radii.pill,
      smoothing: kAppleCornerSmoothing,
    );

    // Content color: accent-on for selected, primary otherwise, muted disabled.
    final Color fg = !_enabled
        ? colors.textTertiary
        : widget.selected
        ? colors.onAccent
        : colors.textPrimary;

    // Resolve the resting surface. A null [solidFill] means "render glass".
    Color? solidFill;
    var glass = false;
    if (!_enabled) {
      solidFill = colors.surfaceInset;
    } else if (widget.selected) {
      solidFill = colors.accent;
    } else if (t.isLight) {
      glass = true;
    } else {
      solidFill = colors.surfaceRaised;
    }

    // Translucent interaction overlays: white tints on dark, black on light —
    // the same values the theme bakes into the buttons.
    final pressedOverlay = t.isLight
        ? const Color(0x14000000)
        : const Color(0x1FFFFFFF);
    final hoverOverlay = t.isLight
        ? const Color(0x0A000000)
        : const Color(0x14FFFFFF);
    final overlayColor = _enabled
        ? (_pressed ? pressedOverlay : (_hovered ? hoverOverlay : null))
        : null;

    // A subtle hairline defines the unselected solid (dark) surface; the glass
    // variant brings its own bright rim, and the accent fill needs none.
    final showBorder = _enabled && !widget.selected && !glass;
    final backgroundShape = showBorder
        ? shape.copyWith(side: BorderSide(color: colors.hairline, width: 1))
        : shape;

    final Widget background = glass
        ? ChukGlass(
            shape: shape,
            fill: colors.surfaceRaised.withValues(alpha: 0.42),
            child: const SizedBox.expand(),
          )
        : DecoratedBox(
            decoration: ShapeDecoration(
              color: solidFill,
              shape: backgroundShape,
            ),
          );

    final Widget content = Padding(
      padding: EdgeInsets.only(
        left: widget.icon != null ? t.spacing.md : t.spacing.lg,
        right: widget.onDeleted != null ? t.spacing.sm : t.spacing.lg,
        top: t.spacing.xs,
        bottom: t.spacing.xs,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.icon != null) ...[
            Icon(widget.icon, size: 18, color: fg),
            SizedBox(width: t.spacing.xs + 2),
          ],
          Flexible(
            child: Text(
              widget.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: t.typography.label.copyWith(color: fg),
            ),
          ),
          if (widget.onDeleted != null) ...[
            SizedBox(width: t.spacing.xs),
            _DeleteButton(
              color: fg,
              onDeleted: widget.onDeleted,
              motion: t.motion.fast,
              curve: t.motion.standard,
            ),
          ],
        ],
      ),
    );

    // Stack: background, then the interaction overlay (clipped by the shape),
    // then the content. A min-height of 44 keeps the tap target accessible.
    final Widget pill = ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 44),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(child: background),
          if (overlayColor != null)
            Positioned.fill(
              child: DecoratedBox(
                decoration: ShapeDecoration(color: overlayColor, shape: shape),
              ),
            ),
          content,
        ],
      ),
    );

    // Focus ring drawn behind the pill, matching the button's ring.
    final Widget ringed = DecoratedBox(
      decoration: ShapeDecoration(
        shape: shape,
        shadows: _focused && _enabled
            ? [
                BoxShadow(
                  color: colors.focusRing.withValues(alpha: 0.5),
                  blurRadius: 0,
                  spreadRadius: 3,
                ),
              ]
            : null,
      ),
      child: pill,
    );

    return Semantics(
      button: true,
      enabled: _enabled,
      selected: widget.selected,
      label: widget.semanticLabel ?? widget.label,
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
          onTapCancel: _enabled ? () => setState(() => _pressed = false) : null,
          child: ringed,
        ),
      ),
    );
  }
}

/// The trailing "✕" affordance. It is its own gesture target so a tap removes
/// the chip without also firing the chip's [ChukChip.onPressed]; the gesture
/// arena resolves the inner detector as the winner.
class _DeleteButton extends StatefulWidget {
  const _DeleteButton({
    required this.color,
    required this.onDeleted,
    required this.motion,
    required this.curve,
  });

  final Color color;
  final VoidCallback? onDeleted;
  final Duration motion;
  final Curve curve;

  @override
  State<_DeleteButton> createState() => _DeleteButtonState();
}

class _DeleteButtonState extends State<_DeleteButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Remove',
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.onDeleted,
          child: AnimatedOpacity(
            duration: widget.motion,
            curve: widget.curve,
            opacity: _hovered ? 1.0 : 0.62,
            child: SizedBox(
              width: 18,
              height: 18,
              child: CustomPaint(painter: _CrossPainter(color: widget.color)),
            ),
          ),
        ),
      ),
    );
  }
}

/// Paints a rounded "✕" that scales with its box.
class _CrossPainter extends CustomPainter {
  const _CrossPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final inset = size.width * 0.28;
    canvas.drawLine(
      Offset(inset, inset),
      Offset(size.width - inset, size.height - inset),
      paint,
    );
    canvas.drawLine(
      Offset(size.width - inset, inset),
      Offset(inset, size.height - inset),
      paint,
    );
  }

  @override
  bool shouldRepaint(_CrossPainter oldDelegate) => oldDelegate.color != color;
}
