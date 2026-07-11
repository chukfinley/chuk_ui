import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../../shape/chuk_glass.dart';
import '../../shape/chuk_squircle.dart';
import '../../theme/chuk_theme.dart';
import '../../theme/chuk_theme_data.dart';
import '../../tokens/chuk_radii.dart';
import 'chuk_dropdown_style.dart';

/// One option in a [ChukDropdown]: a [value] plus the [label] shown for it, and
/// an optional leading [icon].
@immutable
class ChukDropdownItem<T> {
  const ChukDropdownItem({required this.value, required this.label, this.icon});

  /// The value reported through `onChanged` when this option is chosen.
  final T value;

  /// The human-readable label rendered in the field and the menu.
  final String label;

  /// An optional leading icon.
  final IconData? icon;
}

/// A select control: a squircle field showing the selected item and a
/// disclosure chevron. Tapping it pops a floating menu — a frosted-glass
/// surface in light mode, a solid overlay in dark — that lists every option,
/// with the current selection highlighted in the accent color.
///
/// Fully token-driven and Material-free. Disable it with `onChanged: null` or
/// `enabled: false`, exactly like the other Chuk controls.
///
/// ```dart
/// ChukDropdown<String>(
///   value: unit,
///   hintText: 'Choose a unit',
///   items: const [
///     ChukDropdownItem(value: 'kg', label: 'Kilograms'),
///     ChukDropdownItem(value: 'lb', label: 'Pounds'),
///   ],
///   onChanged: (v) => setState(() => unit = v),
/// )
/// ```
class ChukDropdown<T> extends StatefulWidget {
  const ChukDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.hintText,
    this.enabled = true,
    this.style,
    this.autofocus = false,
    this.focusNode,
    this.semanticLabel,
  });

  /// The currently-selected value, or null to show [hintText].
  final T? value;

  /// The options, top to bottom.
  final List<ChukDropdownItem<T>> items;

  /// Called with the chosen value when a menu item is tapped. Pass `null` to
  /// disable the control.
  final ValueChanged<T>? onChanged;

  /// Placeholder shown in the field when [value] is null.
  final String? hintText;

  /// When false the control is disabled even if [onChanged] is non-null.
  final bool enabled;

  /// Per-instance style overrides layered on top of the resolved defaults.
  final ChukDropdownStyle? style;

  /// Whether the field should be focused initially.
  final bool autofocus;

  /// An optional focus node to control the field's focus.
  final FocusNode? focusNode;

  /// Accessibility label announced by screen readers.
  final String? semanticLabel;

  @override
  State<ChukDropdown<T>> createState() => _ChukDropdownState<T>();
}

class _ChukDropdownState<T> extends State<ChukDropdown<T>>
    with SingleTickerProviderStateMixin {
  final LayerLink _link = LayerLink();
  OverlayEntry? _entry;

  // Duration is refreshed from the theme's `motion.medium` on every open; the
  // literal here is only a placeholder so the field initializer never touches
  // the inherited theme (which would be illegal during dispose).
  late final AnimationController _anim = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 220),
  );

  bool _hovered = false;
  bool _focused = false;

  /// Whether the menu opens upward (not enough room below).
  bool _openUp = false;

  /// Width captured from the field so the menu matches it.
  double _fieldWidth = 0;

  bool get _open => _entry != null;

  bool get _enabled =>
      widget.enabled && widget.onChanged != null && widget.items.isNotEmpty;

  @override
  void dispose() {
    _removeEntry(immediate: true);
    _anim.dispose();
    super.dispose();
  }

  ChukDropdownItem<T>? get _selected {
    for (final item in widget.items) {
      if (item.value == widget.value) return item;
    }
    return null;
  }

  void _toggle() => _open ? _close() : _openMenu();

  void _openMenu() {
    if (_open || !_enabled) return;

    final box = context.findRenderObject() as RenderBox?;
    if (box == null) return;
    final size = box.size;
    _fieldWidth = size.width;

    // Decide whether to grow downward or flip up based on available room.
    final topLeft = box.localToGlobal(Offset.zero);
    final screen = MediaQuery.of(context).size;
    final s = _resolvedStyle;
    final gap = s.menuGap ?? 6;
    final estimated = math.min(
      s.maxMenuHeight ?? 280,
      widget.items.length * (s.itemMinHeight ?? 44) +
          (s.menuPadding?.vertical ?? 0),
    );
    final below = screen.height - (topLeft.dy + size.height) - gap;
    final above = topLeft.dy - gap;
    _openUp = below < estimated && above > below;

    _entry = OverlayEntry(builder: _buildOverlay);
    Overlay.of(context, rootOverlay: true).insert(_entry!);
    _anim
      ..duration = context.chuk.motion.medium
      ..forward(from: 0);
    setState(() {});
  }

  void _close() {
    if (!_open) return;
    _anim.reverse().whenComplete(() {
      _removeEntry();
      if (mounted) setState(() {});
    });
  }

  void _removeEntry({bool immediate = false}) {
    _entry?.remove();
    _entry = null;
    if (immediate) _anim.value = 0;
  }

  void _select(ChukDropdownItem<T> item) {
    widget.onChanged?.call(item.value);
    _close();
  }

  // -------------------------------------------------------------------------
  // Style resolution — tokens fill any gap the caller left.
  // -------------------------------------------------------------------------

  ChukDropdownStyle get _resolvedStyle {
    final t = context.chuk;
    final base = ChukDropdownStyle(
      fieldColor: t.colors.surfaceRaised,
      foreground: t.colors.textPrimary,
      hintColor: t.colors.textTertiary,
      iconColor: t.colors.textTertiary,
      borderColor: t.colors.hairlineStrong,
      borderWidth: 1,
      radius: t.radii.md,
      smoothing: kAppleCornerSmoothing,
      fieldPadding: EdgeInsets.symmetric(
        horizontal: t.spacing.lg,
        vertical: t.spacing.sm,
      ),
      textStyle: t.typography.body,
      minHeight: 44,
      menuColor: t.colors.surfaceOverlay,
      menuPadding: EdgeInsets.all(t.spacing.xs),
      itemPadding: EdgeInsets.symmetric(
        horizontal: t.spacing.md,
        vertical: t.spacing.sm,
      ),
      selectedItemColor: t.colors.accentMuted,
      selectedForeground: t.colors.accent,
      itemMinHeight: 44,
      maxMenuHeight: 280,
      menuGap: 6,
      shadow: [
        BoxShadow(
          color: Color(t.isLight ? 0x1F000000 : 0x66000000),
          blurRadius: 30,
          offset: const Offset(0, 12),
        ),
      ],
    );
    return base.merge(widget.style);
  }

  // -------------------------------------------------------------------------
  // Field (closed state)
  // -------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final t = context.chuk;
    final s = _resolvedStyle;

    final radius = s.radius ?? t.radii.md;
    final smoothing = s.smoothing ?? kAppleCornerSmoothing;
    final selected = _selected;

    final foreground = _enabled
        ? (s.foreground ?? t.colors.textPrimary)
        : t.colors.textTertiary;
    final hintColor = s.hintColor ?? t.colors.textTertiary;

    var fill = s.fieldColor ?? t.colors.surfaceRaised;
    if (_enabled && (_hovered || _open)) {
      final overlay = t.isLight
          ? const Color(0x0A000000)
          : const Color(0x14FFFFFF);
      fill = Color.alphaBlend(overlay, fill);
    }

    final borderColor = _focused && _enabled
        ? t.colors.focusRing
        : (s.borderColor ?? t.colors.hairlineStrong);
    final borderWidth = _focused && _enabled
        ? math.max(1.5, s.borderWidth ?? 1)
        : (s.borderWidth ?? 1);

    final shape = SquircleBorder(
      radius: radius,
      smoothing: smoothing,
      side: BorderSide(color: borderColor, width: borderWidth),
    );

    final Widget label = DefaultTextStyle(
      style: (s.textStyle ?? t.typography.body).copyWith(
        color: selected == null ? hintColor : foreground,
      ),
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
      child: Text(selected?.label ?? widget.hintText ?? ''),
    );

    final Widget field = AnimatedContainer(
      duration: t.motion.fast,
      curve: t.motion.standard,
      constraints: BoxConstraints(minHeight: s.minHeight ?? 44),
      padding:
          s.fieldPadding ??
          EdgeInsets.symmetric(
            horizontal: t.spacing.lg,
            vertical: t.spacing.sm,
          ),
      decoration: ShapeDecoration(color: fill, shape: shape),
      child: Row(
        children: [
          if (selected?.icon != null) ...[
            Icon(selected!.icon, size: 18, color: foreground),
            SizedBox(width: t.spacing.sm),
          ],
          Expanded(child: label),
          SizedBox(width: t.spacing.sm),
          AnimatedRotation(
            turns: _open ? 0.5 : 0,
            duration: t.motion.medium,
            curve: t.motion.standard,
            child: _Chevron(
              color: _enabled
                  ? (s.iconColor ?? t.colors.textTertiary)
                  : t.colors.textTertiary,
              size: 16,
            ),
          ),
        ],
      ),
    );

    return Semantics(
      button: true,
      enabled: _enabled,
      expanded: _open,
      label: widget.semanticLabel,
      value: selected?.label ?? widget.hintText,
      child: CompositedTransformTarget(
        link: _link,
        child: FocusableActionDetector(
          enabled: _enabled,
          focusNode: widget.focusNode,
          autofocus: widget.autofocus,
          onShowHoverHighlight: (v) => setState(() => _hovered = v),
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
            DismissIntent: CallbackAction<DismissIntent>(
              onInvoke: (_) {
                _close();
                return null;
              },
            ),
          },
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _enabled ? _toggle : null,
            child: field,
          ),
        ),
      ),
    );
  }

  // -------------------------------------------------------------------------
  // Overlay (open state)
  // -------------------------------------------------------------------------

  Widget _buildOverlay(BuildContext overlayContext) {
    final t = context.chuk;
    final s = _resolvedStyle;
    final gap = s.menuGap ?? 6;

    return Stack(
      children: [
        // Full-screen barrier: any tap outside the menu dismisses it.
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _close,
          ),
        ),
        CompositedTransformFollower(
          link: _link,
          showWhenUnlinked: false,
          targetAnchor: _openUp ? Alignment.topLeft : Alignment.bottomLeft,
          followerAnchor: _openUp ? Alignment.bottomLeft : Alignment.topLeft,
          offset: Offset(0, _openUp ? -gap : gap),
          child: Align(
            alignment: _openUp ? Alignment.bottomLeft : Alignment.topLeft,
            child: SizedBox(
              width: _fieldWidth,
              child: AnimatedBuilder(
                animation: _anim,
                builder: (context, child) {
                  final curved = t.motion.standard.transform(_anim.value);
                  return Opacity(
                    opacity: curved.clamp(0.0, 1.0),
                    child: Transform.scale(
                      scale: 0.96 + 0.04 * curved,
                      alignment: _openUp
                          ? Alignment.bottomCenter
                          : Alignment.topCenter,
                      child: child,
                    ),
                  );
                },
                child: _buildMenu(t, s),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMenu(ChukThemeData t, ChukDropdownStyle s) {
    final radius = s.radius ?? t.radii.md;
    final smoothing = s.smoothing ?? kAppleCornerSmoothing;
    final borderColor = s.borderColor ?? t.colors.hairlineStrong;
    final shape = SquircleBorder(radius: radius, smoothing: smoothing);

    final list = ConstrainedBox(
      constraints: BoxConstraints(maxHeight: s.maxMenuHeight ?? 280),
      child: Padding(
        padding: s.menuPadding ?? EdgeInsets.all(t.spacing.xs),
        child: _MenuList(
          items: widget.items,
          selectedValue: widget.value,
          style: s,
          radii: t.radii,
          fallbackForeground: t.colors.textPrimary,
          onSelected: _select,
        ),
      ),
    );

    // Light mode = frosted glass; dark mode = solid overlay surface.
    if (t.isLight) {
      return ChukGlass(
        shape: shape,
        fill: (s.menuColor ?? t.colors.surfaceOverlay).withValues(alpha: 0.72),
        shadow: s.shadow,
        child: list,
      );
    }
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: s.menuColor ?? t.colors.surfaceOverlay,
        shape: shape.copyWith(
          side: BorderSide(color: borderColor, width: s.borderWidth ?? 1),
        ),
        shadows: s.shadow,
      ),
      child: ClipPath(
        clipper: ShapeBorderClipper(shape: shape),
        child: list,
      ),
    );
  }
}

/// The scrollable list of options inside the open menu. Kept stateful so its
/// scroll position (and per-item hover) is independent of the field.
class _MenuList<T> extends StatelessWidget {
  const _MenuList({
    required this.items,
    required this.selectedValue,
    required this.style,
    required this.radii,
    required this.fallbackForeground,
    required this.onSelected,
  });

  final List<ChukDropdownItem<T>> items;
  final T? selectedValue;
  final ChukDropdownStyle style;
  final ChukRadii radii;
  final Color fallbackForeground;
  final ValueChanged<ChukDropdownItem<T>> onSelected;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemCount: items.length,
      itemBuilder: (context, i) {
        final item = items[i];
        return _MenuItem<T>(
          item: item,
          selected: item.value == selectedValue,
          style: style,
          radii: radii,
          fallbackForeground: fallbackForeground,
          onTap: () => onSelected(item),
        );
      },
    );
  }
}

/// A single tappable row in the menu; highlights on hover and when it is the
/// current selection.
class _MenuItem<T> extends StatefulWidget {
  const _MenuItem({
    required this.item,
    required this.selected,
    required this.style,
    required this.radii,
    required this.fallbackForeground,
    required this.onTap,
  });

  final ChukDropdownItem<T> item;
  final bool selected;
  final ChukDropdownStyle style;
  final ChukRadii radii;
  final Color fallbackForeground;
  final VoidCallback onTap;

  @override
  State<_MenuItem<T>> createState() => _MenuItemState<T>();
}

class _MenuItemState<T> extends State<_MenuItem<T>> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final s = widget.style;
    final foreground = widget.selected
        ? (s.selectedForeground ?? widget.fallbackForeground)
        : (s.foreground ?? widget.fallbackForeground);

    final Color? bg = widget.selected
        ? s.selectedItemColor
        : (_hovered ? s.selectedItemColor?.withValues(alpha: 0.5) : null);

    final shape = SquircleBorder(
      radius: (s.radius ?? widget.radii.md) * 0.66,
      smoothing: s.smoothing ?? kAppleCornerSmoothing,
    );

    return Semantics(
      button: true,
      selected: widget.selected,
      label: widget.item.label,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.onTap,
          child: DecoratedBox(
            decoration: ShapeDecoration(color: bg, shape: shape),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: s.itemMinHeight ?? 44),
              child: Padding(
                padding: s.itemPadding ?? const EdgeInsets.all(12),
                child: Row(
                  children: [
                    if (widget.item.icon != null) ...[
                      Icon(widget.item.icon, size: 18, color: foreground),
                      const SizedBox(width: 10),
                    ],
                    Expanded(
                      child: DefaultTextStyle(
                        style: (s.textStyle ?? const TextStyle()).copyWith(
                          color: foreground,
                          fontWeight: widget.selected
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        child: Text(widget.item.label),
                      ),
                    ),
                    if (widget.selected) _Check(color: foreground, size: 15),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A minimal down-chevron drawn with [CustomPaint] (no Material icon font).
class _Chevron extends StatelessWidget {
  const _Chevron({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(size),
      painter: _ChevronPainter(color),
    );
  }
}

class _ChevronPainter extends CustomPainter {
  const _ChevronPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.12
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final path = Path()
      ..moveTo(size.width * 0.22, size.height * 0.38)
      ..lineTo(size.width * 0.5, size.height * 0.64)
      ..lineTo(size.width * 0.78, size.height * 0.38);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_ChevronPainter old) => old.color != color;
}

/// A minimal check mark drawn with [CustomPaint] for the selected row.
class _Check extends StatelessWidget {
  const _Check({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: Size.square(size), painter: _CheckPainter(color));
  }
}

class _CheckPainter extends CustomPainter {
  const _CheckPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.14
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final path = Path()
      ..moveTo(size.width * 0.2, size.height * 0.52)
      ..lineTo(size.width * 0.42, size.height * 0.74)
      ..lineTo(size.width * 0.8, size.height * 0.28);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_CheckPainter old) => old.color != color;
}
