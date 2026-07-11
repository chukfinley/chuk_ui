import 'package:flutter/widgets.dart';

import '../../shape/chuk_squircle.dart';
import '../../theme/chuk_theme.dart';
import '../card/chuk_card.dart';

/// A single horizontal row: an optional [leading] widget, a [title] with an
/// optional [subtitle], and an optional [trailing] widget — the standard
/// building block for lists, settings screens and menus.
///
/// Everything is token-driven and Material-free. The title uses
/// `typography.body`, the subtitle `typography.caption` in the secondary text
/// color. Comfortable padding comes from `spacing.lg` (horizontal) and
/// `spacing.md` (vertical).
///
/// When [onTap] is non-null the whole row becomes tappable (with hover / press
/// feedback and a merged [Semantics] node) and honours the 44px minimum target.
/// Pass `onTap: null` to render a static, non-interactive row.
///
/// Set [card] to `true` to wrap the tile in a [ChukCard] — a frosted-glass
/// surface in light mode, a solid raised surface in dark mode.
///
/// ```dart
/// ChukListTile(
///   leading: Icon(Icons.person),
///   title: const Text('Account'),
///   subtitle: const Text('name@example.com'),
///   trailing: Icon(Icons.chevron_right),
///   onTap: () => openAccount(),
/// )
/// ```
class ChukListTile extends StatefulWidget {
  const ChukListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.card = false,
    this.padding,
    this.gap,
    this.semanticLabel,
  });

  /// The primary content, styled with `typography.body`.
  final Widget title;

  /// Optional secondary line below the title, styled with `typography.caption`
  /// in the secondary text color.
  final Widget? subtitle;

  /// Optional widget shown before the title (icon, avatar, thumbnail …).
  final Widget? leading;

  /// Optional widget shown after the title (chevron, switch, value …).
  final Widget? trailing;

  /// Called when the row is tapped. When `null` the row is inert (no hover /
  /// press feedback, not focusable).
  final VoidCallback? onTap;

  /// When true, the tile is wrapped in a [ChukCard] surface.
  final bool card;

  /// Inner padding. Defaults to `spacing.lg` horizontal, `spacing.md` vertical.
  final EdgeInsets? padding;

  /// Horizontal gap between the leading, text block and trailing. Defaults to
  /// `spacing.md`.
  final double? gap;

  /// Accessibility label announced by screen readers. Defaults to the tile's
  /// own text content when null.
  final String? semanticLabel;

  @override
  State<ChukListTile> createState() => _ChukListTileState();
}

class _ChukListTileState extends State<ChukListTile> {
  bool _hovered = false;
  bool _pressed = false;
  bool _focused = false;

  bool get _enabled => widget.onTap != null;

  @override
  Widget build(BuildContext context) {
    final t = context.chuk;
    final gap = widget.gap ?? t.spacing.md;
    final padding =
        widget.padding ??
        EdgeInsets.symmetric(horizontal: t.spacing.lg, vertical: t.spacing.md);

    final title = DefaultTextStyle.merge(
      style: t.typography.body.copyWith(color: t.colors.textPrimary),
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
      child: IconTheme.merge(
        data: IconThemeData(color: t.colors.textPrimary),
        child: widget.title,
      ),
    );

    Widget textBlock = title;
    if (widget.subtitle != null) {
      textBlock = Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          title,
          SizedBox(height: t.spacing.xs),
          DefaultTextStyle.merge(
            style: t.typography.caption.copyWith(color: t.colors.textSecondary),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            child: widget.subtitle!,
          ),
        ],
      );
    }

    final row = Row(
      children: [
        if (widget.leading != null) ...[
          IconTheme.merge(
            data: IconThemeData(color: t.colors.textSecondary),
            child: widget.leading!,
          ),
          SizedBox(width: gap),
        ],
        Expanded(child: textBlock),
        if (widget.trailing != null) ...[
          SizedBox(width: gap),
          IconTheme.merge(
            data: IconThemeData(color: t.colors.textTertiary),
            child: DefaultTextStyle.merge(
              style: t.typography.caption.copyWith(
                color: t.colors.textTertiary,
              ),
              child: widget.trailing!,
            ),
          ),
        ],
      ],
    );

    // The row content with padding and a minimum 44px target height.
    final Widget content = ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 44),
      child: Padding(
        padding: padding,
        child: Center(child: row),
      ),
    );

    if (widget.card) {
      // ChukCard owns the surface, shape, tap and focus feedback.
      return ChukCard(
        padding: padding,
        onTap: widget.onTap,
        child: Center(child: row),
      );
    }

    // Non-card: an interactive row gets a squircle hover / press / focus
    // overlay; a static row is returned as-is.
    if (!_enabled) {
      return Semantics(
        label: widget.semanticLabel,
        container: true,
        child: content,
      );
    }

    final shape = SquircleBorder(
      radius: t.radii.md,
      smoothing: kAppleCornerSmoothing,
    );

    final overlay = _pressed
        ? (t.isLight ? const Color(0x14000000) : const Color(0x1FFFFFFF))
        : _hovered
        ? (t.isLight ? const Color(0x0A000000) : const Color(0x14FFFFFF))
        : const Color(0x00000000);

    final decorated = AnimatedContainer(
      duration: t.motion.fast,
      curve: t.motion.standard,
      decoration: ShapeDecoration(
        color: overlay,
        shape: shape,
        shadows: _focused
            ? [
                BoxShadow(
                  color: t.colors.focusRing.withValues(alpha: 0.5),
                  blurRadius: 0,
                  spreadRadius: 2,
                ),
              ]
            : null,
      ),
      child: content,
    );

    return Semantics(
      button: true,
      enabled: true,
      label: widget.semanticLabel,
      child: FocusableActionDetector(
        onShowHoverHighlight: (v) => setState(() => _hovered = v),
        onShowFocusHighlight: (v) => setState(() => _focused = v),
        actions: {
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (_) {
              widget.onTap?.call();
              return null;
            },
          ),
        },
        mouseCursor: SystemMouseCursors.click,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.onTap,
          onTapDown: (_) => setState(() => _pressed = true),
          onTapUp: (_) => setState(() => _pressed = false),
          onTapCancel: () => setState(() => _pressed = false),
          child: decorated,
        ),
      ),
    );
  }
}
