import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../shape/chuk_glass.dart';
import '../../shape/chuk_squircle.dart';
import '../../theme/chuk_theme.dart';
import '../../theme/chuk_theme_data.dart';
import 'chuk_text_field_style.dart';

/// A single-line or multiline text input, Material-free.
///
/// The input itself is a raw [EditableText]; everything around it — the squircle
/// well, the border that lifts to the [ChukColors.accent] when focused (or to
/// [ChukColors.statusCritical] on error), the optional label and error caption —
/// is drawn from the [ChukThemeData]. In light mode the well is rendered as
/// frosted glass to match [ChukCard] and [ChukNavBar].
///
/// Provide a [controller] and/or [focusNode] to drive it externally, or let it
/// manage its own. Pass `enabled: false` to make it read-only and dimmed.
///
/// ```dart
/// ChukTextField(
///   label: 'E-Mail',
///   hintText: 'you@example.com',
///   onChanged: (v) => setState(() => email = v),
/// )
/// ```
class ChukTextField extends StatefulWidget {
  const ChukTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.hintText = '',
    this.label,
    this.errorText,
    this.obscureText = false,
    this.enabled = true,
    this.leading,
    this.trailing,
    this.maxLines = 1,
    this.minLines,
    this.onChanged,
    this.onSubmitted,
    this.autofocus = false,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.style,
    this.semanticLabel,
  }) : assert(
         maxLines == null || maxLines > 0,
         'maxLines must be greater than zero or null.',
       ),
       assert(
         !obscureText || maxLines == 1,
         'obscureText fields must be single-line (maxLines: 1).',
       );

  /// External text controller. One is created internally when null.
  final TextEditingController? controller;

  /// External focus node. One is created internally when null.
  final FocusNode? focusNode;

  /// Placeholder shown while the field is empty. Rendered in
  /// [ChukColors.textTertiary].
  final String hintText;

  /// Optional label drawn above the field well.
  final String? label;

  /// When non-null the field enters its error state: the border and the caption
  /// below use [ChukColors.statusCritical].
  final String? errorText;

  /// Whether to hide the entered characters (passwords). Forces a single line.
  final bool obscureText;

  /// Whether the field accepts input. When false it is read-only and dimmed.
  final bool enabled;

  /// Optional leading adornment (e.g. an icon) inside the well.
  final Widget? leading;

  /// Optional trailing adornment (e.g. a clear button) inside the well.
  final Widget? trailing;

  /// Maximum number of lines. `1` is single-line; a larger value (or null for
  /// unbounded growth) makes the field multiline.
  final int? maxLines;

  /// Minimum number of lines the field occupies. Only meaningful when the field
  /// is multiline.
  final int? minLines;

  /// Called on every keystroke.
  final ValueChanged<String>? onChanged;

  /// Called when the user submits the field.
  final ValueChanged<String>? onSubmitted;

  /// Focus the field on first build.
  final bool autofocus;

  /// Keyboard type. Defaults to multiline when the field is multiline, else
  /// plain text.
  final TextInputType? keyboardType;

  /// The action button on the soft keyboard. Defaults sensibly per line-count.
  final TextInputAction? textInputAction;

  /// Optional input formatters applied to every edit.
  final List<TextInputFormatter>? inputFormatters;

  /// Per-instance style overrides layered on top of the theme-derived defaults.
  final ChukTextFieldStyle? style;

  /// Accessibility label announced by screen readers. Falls back to [label]
  /// then [hintText].
  final String? semanticLabel;

  @override
  State<ChukTextField> createState() => _ChukTextFieldState();
}

class _ChukTextFieldState extends State<ChukTextField> {
  TextEditingController? _ownController;
  FocusNode? _ownFocus;

  TextEditingController get _controller =>
      widget.controller ?? (_ownController ??= TextEditingController());
  FocusNode get _focus => widget.focusNode ?? (_ownFocus ??= FocusNode());

  bool _focused = false;

  bool get _multiline => widget.maxLines == null || widget.maxLines! > 1;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
    _focus.addListener(_onFocusChanged);
  }

  @override
  void didUpdateWidget(ChukTextField old) {
    super.didUpdateWidget(old);
    if (old.controller != widget.controller) {
      old.controller?.removeListener(_onTextChanged);
      _ownController?.dispose();
      _ownController = null;
      _controller.addListener(_onTextChanged);
    }
    if (old.focusNode != widget.focusNode) {
      old.focusNode?.removeListener(_onFocusChanged);
      _ownFocus?.dispose();
      _ownFocus = null;
      _focus.addListener(_onFocusChanged);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _focus.removeListener(_onFocusChanged);
    _ownController?.dispose();
    _ownFocus?.dispose();
    super.dispose();
  }

  // Rebuild so the hint shows/hides as the text empties/fills.
  void _onTextChanged() => setState(() {});

  void _onFocusChanged() => setState(() => _focused = _focus.hasFocus);

  /// Resolves the theme-derived defaults; per-instance overrides merge on top.
  ChukTextFieldStyle _defaults(ChukThemeData t) => ChukTextFieldStyle(
    fill: t.isLight ? t.colors.surfaceRaised : t.colors.surfaceInset,
    borderColor: t.colors.hairlineStrong,
    focusedBorderColor: t.colors.accent,
    errorBorderColor: t.colors.statusCritical,
    borderWidth: 1,
    focusedBorderWidth: 2,
    radius: t.radii.md,
    smoothing: kAppleCornerSmoothing,
    contentPadding: EdgeInsets.symmetric(
      horizontal: t.spacing.lg,
      vertical: t.spacing.md,
    ),
    minHeight: 48,
    gap: t.spacing.sm,
    textStyle: t.typography.body.copyWith(color: t.colors.textPrimary),
    hintStyle: t.typography.body.copyWith(color: t.colors.textTertiary),
    labelStyle: t.typography.label.copyWith(color: t.colors.textSecondary),
    errorStyle: t.typography.caption.copyWith(color: t.colors.statusCritical),
    cursorColor: t.colors.accent,
    selectionColor: t.colors.accent.withValues(alpha: 0.30),
    disabledOpacity: 0.5,
  );

  @override
  Widget build(BuildContext context) {
    final t = context.chuk;
    final s = _defaults(t).merge(widget.style);

    final bool hasError = widget.errorText != null;
    final bool enabled = widget.enabled;

    // Border resolution: error wins over focus wins over idle.
    final Color borderColor = hasError
        ? s.errorBorderColor!
        : (enabled && _focused ? s.focusedBorderColor! : s.borderColor!);
    final double borderWidth = (hasError || (enabled && _focused))
        ? s.focusedBorderWidth!
        : s.borderWidth!;

    final shape = SquircleBorder(radius: s.radius!, smoothing: s.smoothing!);

    // Placeholder shown only when there is nothing typed.
    final bool isEmpty = _controller.text.isEmpty;
    final int? effectiveMaxLines = widget.obscureText ? 1 : widget.maxLines;

    final Widget editable = EditableText(
      controller: _controller,
      focusNode: _focus,
      autofocus: widget.autofocus,
      readOnly: !enabled,
      obscureText: widget.obscureText,
      style: s.textStyle!,
      cursorColor: s.cursorColor!,
      backgroundCursorColor: t.colors.surfaceInset,
      selectionColor: s.selectionColor,
      maxLines: effectiveMaxLines,
      minLines: widget.obscureText ? 1 : widget.minLines,
      keyboardType:
          widget.keyboardType ??
          (_multiline ? TextInputType.multiline : TextInputType.text),
      textInputAction:
          widget.textInputAction ??
          (_multiline ? TextInputAction.newline : TextInputAction.done),
      inputFormatters: widget.inputFormatters,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      rendererIgnoresPointer: true,
      cursorOpacityAnimates: true,
    );

    final Widget input = Stack(
      alignment: _multiline
          ? AlignmentDirectional.topStart
          : Alignment.centerLeft,
      children: [
        if (isEmpty && widget.hintText.isNotEmpty)
          Text(
            widget.hintText,
            maxLines: _multiline ? effectiveMaxLines : 1,
            overflow: TextOverflow.ellipsis,
            style: s.hintStyle,
          ),
        editable,
      ],
    );

    final Widget row = Row(
      crossAxisAlignment: _multiline
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.center,
      children: [
        if (widget.leading != null) ...[
          widget.leading!,
          SizedBox(width: s.gap),
        ],
        Expanded(child: input),
        if (widget.trailing != null) ...[
          SizedBox(width: s.gap),
          widget.trailing!,
        ],
      ],
    );

    // Fill layer: frosted glass in light mode, a solid recessed well in dark.
    final Widget fillLayer = t.isLight
        ? ChukGlass(
            shape: shape,
            fill: s.fill!.withValues(alpha: 0.42),
            // Border is painted by the overlay below so it can animate the
            // focus/error color and 2px width; keep the glass rim transparent.
            highlight: const Color(0x00000000),
            child: const SizedBox.expand(),
          )
        : DecoratedBox(
            decoration: ShapeDecoration(color: s.fill, shape: shape),
          );

    // Border overlay: animates color + width between idle / focus / error.
    final Widget borderOverlay = IgnorePointer(
      child: AnimatedContainer(
        duration: t.motion.fast,
        curve: t.motion.standard,
        decoration: ShapeDecoration(
          shape: SquircleBorder(
            radius: s.radius!,
            smoothing: s.smoothing!,
            side: BorderSide(color: borderColor, width: borderWidth),
          ),
        ),
      ),
    );

    Widget well = ConstrainedBox(
      constraints: BoxConstraints(minHeight: s.minHeight!),
      child: Stack(
        children: [
          Positioned.fill(child: fillLayer),
          Padding(padding: s.contentPadding!, child: row),
          Positioned.fill(child: borderOverlay),
        ],
      ),
    );

    if (!enabled) {
      well = Opacity(opacity: s.disabledOpacity!, child: well);
    }

    final Widget field = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Text(widget.label!, style: s.labelStyle),
          SizedBox(height: t.spacing.xs),
        ],
        well,
        if (widget.errorText != null) ...[
          SizedBox(height: t.spacing.xs),
          Text(widget.errorText!, style: s.errorStyle),
        ],
      ],
    );

    return Semantics(
      textField: true,
      enabled: enabled,
      label: widget.semanticLabel ?? widget.label ?? widget.hintText,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: enabled ? _focus.requestFocus : null,
        child: field,
      ),
    );
  }
}
