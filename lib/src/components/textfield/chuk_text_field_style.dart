import 'dart:ui' show lerpDouble;

import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

/// The resolved visual styling of a [ChukTextField].
///
/// Like [ChukButtonStyle] this is a *flat, value-based* type (no
/// `WidgetStateProperty`) so [copyWith], [merge] and [lerp] stay trivial.
/// Per-state variation (focused / error) is expressed by the dedicated
/// `focused*` / `error*` fields rather than by state objects — the widget picks
/// the right pair at build time.
///
/// Every field is optional: [ChukTextField] fills the nulls from the current
/// [ChukThemeData] tokens, then merges any per-instance overrides on top.
@immutable
class ChukTextFieldStyle {
  const ChukTextFieldStyle({
    this.fill,
    this.borderColor,
    this.focusedBorderColor,
    this.errorBorderColor,
    this.borderWidth,
    this.focusedBorderWidth,
    this.radius,
    this.smoothing,
    this.contentPadding,
    this.minHeight,
    this.gap,
    this.textStyle,
    this.hintStyle,
    this.labelStyle,
    this.errorStyle,
    this.cursorColor,
    this.selectionColor,
    this.disabledOpacity,
  });

  /// Resting fill of the field well. In light mode the widget applies a low
  /// alpha to this color and renders it as frosted glass.
  final Color? fill;

  /// Border color while idle (not focused, no error).
  final Color? borderColor;

  /// Border color while focused.
  final Color? focusedBorderColor;

  /// Border color while [ChukTextField.errorText] is set. Takes precedence over
  /// the focused color.
  final Color? errorBorderColor;

  /// Border thickness while idle.
  final double? borderWidth;

  /// Border thickness while focused or in error.
  final double? focusedBorderWidth;

  /// Corner radius of the field well.
  final double? radius;

  /// Apple-style corner smoothing, 0..1.
  final double? smoothing;

  /// Inner padding around the row of leading / input / trailing.
  final EdgeInsets? contentPadding;

  /// Minimum height of the field well (tap target). Defaults to 48.
  final double? minHeight;

  /// Horizontal gap between the input and the [leading] / [trailing] adornments.
  final double? gap;

  /// Text style of the editable content.
  final TextStyle? textStyle;

  /// Text style of the placeholder / hint.
  final TextStyle? hintStyle;

  /// Text style of the field [ChukTextField.label] above the well.
  final TextStyle? labelStyle;

  /// Text style of the [ChukTextField.errorText] below the well.
  final TextStyle? errorStyle;

  /// Caret color.
  final Color? cursorColor;

  /// Selection highlight color.
  final Color? selectionColor;

  /// Opacity applied to the whole field while disabled. Defaults to 0.5.
  final double? disabledOpacity;

  /// Returns a copy with the given fields replaced.
  ChukTextFieldStyle copyWith({
    Color? fill,
    Color? borderColor,
    Color? focusedBorderColor,
    Color? errorBorderColor,
    double? borderWidth,
    double? focusedBorderWidth,
    double? radius,
    double? smoothing,
    EdgeInsets? contentPadding,
    double? minHeight,
    double? gap,
    TextStyle? textStyle,
    TextStyle? hintStyle,
    TextStyle? labelStyle,
    TextStyle? errorStyle,
    Color? cursorColor,
    Color? selectionColor,
    double? disabledOpacity,
  }) {
    return ChukTextFieldStyle(
      fill: fill ?? this.fill,
      borderColor: borderColor ?? this.borderColor,
      focusedBorderColor: focusedBorderColor ?? this.focusedBorderColor,
      errorBorderColor: errorBorderColor ?? this.errorBorderColor,
      borderWidth: borderWidth ?? this.borderWidth,
      focusedBorderWidth: focusedBorderWidth ?? this.focusedBorderWidth,
      radius: radius ?? this.radius,
      smoothing: smoothing ?? this.smoothing,
      contentPadding: contentPadding ?? this.contentPadding,
      minHeight: minHeight ?? this.minHeight,
      gap: gap ?? this.gap,
      textStyle: textStyle ?? this.textStyle,
      hintStyle: hintStyle ?? this.hintStyle,
      labelStyle: labelStyle ?? this.labelStyle,
      errorStyle: errorStyle ?? this.errorStyle,
      cursorColor: cursorColor ?? this.cursorColor,
      selectionColor: selectionColor ?? this.selectionColor,
      disabledOpacity: disabledOpacity ?? this.disabledOpacity,
    );
  }

  /// Returns a new style where every field set on [other] overrides this one.
  ///
  /// This is the mechanism behind the two-layer resolution
  /// (theme-derived defaults → per-instance override).
  ChukTextFieldStyle merge(ChukTextFieldStyle? other) {
    if (other == null) return this;
    return copyWith(
      fill: other.fill,
      borderColor: other.borderColor,
      focusedBorderColor: other.focusedBorderColor,
      errorBorderColor: other.errorBorderColor,
      borderWidth: other.borderWidth,
      focusedBorderWidth: other.focusedBorderWidth,
      radius: other.radius,
      smoothing: other.smoothing,
      contentPadding: other.contentPadding,
      minHeight: other.minHeight,
      gap: other.gap,
      textStyle: other.textStyle,
      hintStyle: other.hintStyle,
      labelStyle: other.labelStyle,
      errorStyle: other.errorStyle,
      cursorColor: other.cursorColor,
      selectionColor: other.selectionColor,
      disabledOpacity: other.disabledOpacity,
    );
  }

  /// Linearly interpolates between two text-field styles.
  static ChukTextFieldStyle lerp(
    ChukTextFieldStyle a,
    ChukTextFieldStyle b,
    double t,
  ) {
    return ChukTextFieldStyle(
      fill: Color.lerp(a.fill, b.fill, t),
      borderColor: Color.lerp(a.borderColor, b.borderColor, t),
      focusedBorderColor: Color.lerp(
        a.focusedBorderColor,
        b.focusedBorderColor,
        t,
      ),
      errorBorderColor: Color.lerp(a.errorBorderColor, b.errorBorderColor, t),
      borderWidth: lerpDouble(a.borderWidth, b.borderWidth, t),
      focusedBorderWidth: lerpDouble(
        a.focusedBorderWidth,
        b.focusedBorderWidth,
        t,
      ),
      radius: lerpDouble(a.radius, b.radius, t),
      smoothing: lerpDouble(a.smoothing, b.smoothing, t),
      contentPadding: EdgeInsets.lerp(a.contentPadding, b.contentPadding, t),
      minHeight: lerpDouble(a.minHeight, b.minHeight, t),
      gap: lerpDouble(a.gap, b.gap, t),
      textStyle: TextStyle.lerp(a.textStyle, b.textStyle, t),
      hintStyle: TextStyle.lerp(a.hintStyle, b.hintStyle, t),
      labelStyle: TextStyle.lerp(a.labelStyle, b.labelStyle, t),
      errorStyle: TextStyle.lerp(a.errorStyle, b.errorStyle, t),
      cursorColor: Color.lerp(a.cursorColor, b.cursorColor, t),
      selectionColor: Color.lerp(a.selectionColor, b.selectionColor, t),
      disabledOpacity: lerpDouble(a.disabledOpacity, b.disabledOpacity, t),
    );
  }

  @override
  bool operator ==(Object other) =>
      other is ChukTextFieldStyle &&
      other.fill == fill &&
      other.borderColor == borderColor &&
      other.focusedBorderColor == focusedBorderColor &&
      other.errorBorderColor == errorBorderColor &&
      other.borderWidth == borderWidth &&
      other.focusedBorderWidth == focusedBorderWidth &&
      other.radius == radius &&
      other.smoothing == smoothing &&
      other.contentPadding == contentPadding &&
      other.minHeight == minHeight &&
      other.gap == gap &&
      other.textStyle == textStyle &&
      other.hintStyle == hintStyle &&
      other.labelStyle == labelStyle &&
      other.errorStyle == errorStyle &&
      other.cursorColor == cursorColor &&
      other.selectionColor == selectionColor &&
      other.disabledOpacity == disabledOpacity;

  @override
  int get hashCode => Object.hash(
    fill,
    borderColor,
    focusedBorderColor,
    errorBorderColor,
    borderWidth,
    focusedBorderWidth,
    radius,
    smoothing,
    contentPadding,
    minHeight,
    gap,
    textStyle,
    hintStyle,
    labelStyle,
    errorStyle,
    cursorColor,
    selectionColor,
    disabledOpacity,
  );
}
