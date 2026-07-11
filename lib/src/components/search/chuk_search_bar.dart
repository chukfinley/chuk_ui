import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../shape/chuk_squircle.dart';
import '../../theme/chuk_theme.dart';

/// A floating search bar styled to match [ChukNavBar]: the same translucent
/// raised fill, the same Apple-squircle pill shape and the same lift shadow.
///
/// Material-free — the input is a raw [EditableText]. Provide a [controller]
/// and/or [focusNode] to drive it externally, or let it manage its own.
///
/// ```dart
/// ChukSearchBar(
///   hintText: 'Suchen',
///   onChanged: (q) => setState(() => query = q),
/// )
/// ```
class ChukSearchBar extends StatefulWidget {
  const ChukSearchBar({
    super.key,
    this.controller,
    this.focusNode,
    this.hintText = 'Suchen',
    this.onChanged,
    this.onSubmitted,
    this.leading,
    this.trailing,
    this.autofocus = false,
    this.height = 52,
    this.enabled = true,
  });

  /// External text controller. One is created internally when null.
  final TextEditingController? controller;

  /// External focus node. One is created internally when null.
  final FocusNode? focusNode;

  /// Placeholder shown while the field is empty.
  final String hintText;

  /// Called on every keystroke.
  final ValueChanged<String>? onChanged;

  /// Called when the user submits (search action).
  final ValueChanged<String>? onSubmitted;

  /// Leading widget (defaults to a drawn search glyph).
  final Widget? leading;

  /// Optional trailing widget (e.g. a clear button).
  final Widget? trailing;

  /// Focus the field on first build.
  final bool autofocus;

  /// Bar height.
  final double height;

  /// Whether the field accepts input.
  final bool enabled;

  @override
  State<ChukSearchBar> createState() => _ChukSearchBarState();
}

class _ChukSearchBarState extends State<ChukSearchBar> {
  TextEditingController? _ownController;
  FocusNode? _ownFocus;

  TextEditingController get _controller =>
      widget.controller ?? (_ownController ??= TextEditingController());
  FocusNode get _focus => widget.focusNode ?? (_ownFocus ??= FocusNode());

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onChanged);
    _ownController?.dispose();
    _ownFocus?.dispose();
    super.dispose();
  }

  void _onChanged() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final t = context.chuk;
    final radius = t.radii.pill;
    final shape = SquircleBorder(radius: radius, smoothing: kAppleCornerSmoothing);
    final isEmpty = _controller.text.isEmpty;

    final leading = widget.leading ??
        _SearchGlyph(color: t.colors.textTertiary, size: 18);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.enabled ? _focus.requestFocus : null,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: t.colors.surfaceRaised.withValues(alpha: 0.93),
          shape: shape,
          shadows: const [
            BoxShadow(
              color: Color(0x57000000),
              blurRadius: 28,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: SizedBox(
          height: widget.height,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: t.spacing.lg),
            child: Row(
              children: [
                leading,
                SizedBox(width: t.spacing.md),
                Expanded(
                  child: Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      if (isEmpty)
                        Text(
                          widget.hintText,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: t.typography.body
                              .copyWith(color: t.colors.textTertiary),
                        ),
                      EditableText(
                        controller: _controller,
                        focusNode: _focus,
                        autofocus: widget.autofocus,
                        readOnly: !widget.enabled,
                        style: t.typography.body
                            .copyWith(color: t.colors.textPrimary),
                        cursorColor: t.colors.accent,
                        backgroundCursorColor: t.colors.surfaceInset,
                        selectionColor: t.colors.accent.withValues(alpha: 0.30),
                        maxLines: 1,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.search,
                        inputFormatters: const <TextInputFormatter>[],
                        onChanged: widget.onChanged,
                        onSubmitted: widget.onSubmitted,
                        rendererIgnoresPointer: true,
                      ),
                    ],
                  ),
                ),
                if (widget.trailing != null) ...[
                  SizedBox(width: t.spacing.sm),
                  widget.trailing!,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A minimal search (magnifier) glyph drawn with a painter, so the component
/// needs no icon font.
class _SearchGlyph extends StatelessWidget {
  const _SearchGlyph({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: CustomPaint(painter: _SearchGlyphPainter(color)),
    );
  }
}

class _SearchGlyphPainter extends CustomPainter {
  _SearchGlyphPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.11
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    final r = size.width * 0.32;
    final center = Offset(size.width * 0.42, size.height * 0.42);
    canvas.drawCircle(center, r, paint);
    // Handle.
    final start = center + Offset(r * 0.72, r * 0.72);
    final end = Offset(size.width * 0.9, size.height * 0.9);
    canvas.drawLine(start, end, paint);
  }

  @override
  bool shouldRepaint(_SearchGlyphPainter old) => old.color != color;
}
