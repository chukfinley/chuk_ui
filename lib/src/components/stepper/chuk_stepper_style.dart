import 'dart:ui' show lerpDouble;

import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

/// The resolved visual styling of a [ChukStepper].
///
/// Like [ChukButtonStyle] this is deliberately *flat and value-based* (no
/// `WidgetStateProperty`), so it is trivial to [copyWith], [merge] and [lerp].
/// The widget resolves a sensible default from the theme tokens, then layers
/// any per-instance overrides on top with [merge].
@immutable
class ChukStepperStyle {
  const ChukStepperStyle({
    this.trackColor,
    this.glyphColor,
    this.disabledGlyphColor,
    this.valueColor,
    this.buttonOverlay,
    this.height,
    this.buttonSize,
    this.valueMinWidth,
    this.glyphSize,
    this.glyphStrokeWidth,
    this.radius,
    this.textStyle,
    this.disabledOpacity,
  });

  /// Fill color of the surrounding pill track.
  final Color? trackColor;

  /// Color of the `+` / `−` glyphs when their button is enabled.
  final Color? glyphColor;

  /// Color of a glyph whose button is disabled (a bound reached, or the whole
  /// stepper disabled).
  final Color? disabledGlyphColor;

  /// Color of the value text in the middle.
  final Color? valueColor;

  /// Translucent circle painted behind a button while it is pressed or hovered.
  final Color? buttonOverlay;

  /// Overall pill height in logical pixels.
  final double? height;

  /// Width/height of each round `+` / `−` tap target.
  final double? buttonSize;

  /// Minimum width reserved for the value column, so the pill does not resize
  /// as the number's digit count changes.
  final double? valueMinWidth;

  /// Side length of the glyph box drawn inside each button.
  final double? glyphSize;

  /// Stroke thickness of the drawn `+` / `−` glyphs.
  final double? glyphStrokeWidth;

  /// Corner radius of the pill track. Defaults to the theme's pill radius.
  final double? radius;

  /// Text style for the value. The color is taken from [valueColor].
  final TextStyle? textStyle;

  /// Opacity applied to the whole control when it is disabled.
  final double? disabledOpacity;

  /// Returns a copy with the given fields replaced.
  ChukStepperStyle copyWith({
    Color? trackColor,
    Color? glyphColor,
    Color? disabledGlyphColor,
    Color? valueColor,
    Color? buttonOverlay,
    double? height,
    double? buttonSize,
    double? valueMinWidth,
    double? glyphSize,
    double? glyphStrokeWidth,
    double? radius,
    TextStyle? textStyle,
    double? disabledOpacity,
  }) {
    return ChukStepperStyle(
      trackColor: trackColor ?? this.trackColor,
      glyphColor: glyphColor ?? this.glyphColor,
      disabledGlyphColor: disabledGlyphColor ?? this.disabledGlyphColor,
      valueColor: valueColor ?? this.valueColor,
      buttonOverlay: buttonOverlay ?? this.buttonOverlay,
      height: height ?? this.height,
      buttonSize: buttonSize ?? this.buttonSize,
      valueMinWidth: valueMinWidth ?? this.valueMinWidth,
      glyphSize: glyphSize ?? this.glyphSize,
      glyphStrokeWidth: glyphStrokeWidth ?? this.glyphStrokeWidth,
      radius: radius ?? this.radius,
      textStyle: textStyle ?? this.textStyle,
      disabledOpacity: disabledOpacity ?? this.disabledOpacity,
    );
  }

  /// Returns a new style where every field set on [other] overrides this one.
  ///
  /// This is the mechanism behind the two-layer resolution (theme-derived
  /// default → per-instance override).
  ChukStepperStyle merge(ChukStepperStyle? other) {
    if (other == null) return this;
    return copyWith(
      trackColor: other.trackColor,
      glyphColor: other.glyphColor,
      disabledGlyphColor: other.disabledGlyphColor,
      valueColor: other.valueColor,
      buttonOverlay: other.buttonOverlay,
      height: other.height,
      buttonSize: other.buttonSize,
      valueMinWidth: other.valueMinWidth,
      glyphSize: other.glyphSize,
      glyphStrokeWidth: other.glyphStrokeWidth,
      radius: other.radius,
      textStyle: other.textStyle,
      disabledOpacity: other.disabledOpacity,
    );
  }

  /// Linearly interpolates between two stepper styles.
  static ChukStepperStyle lerp(
    ChukStepperStyle a,
    ChukStepperStyle b,
    double t,
  ) {
    return ChukStepperStyle(
      trackColor: Color.lerp(a.trackColor, b.trackColor, t),
      glyphColor: Color.lerp(a.glyphColor, b.glyphColor, t),
      disabledGlyphColor: Color.lerp(
        a.disabledGlyphColor,
        b.disabledGlyphColor,
        t,
      ),
      valueColor: Color.lerp(a.valueColor, b.valueColor, t),
      buttonOverlay: Color.lerp(a.buttonOverlay, b.buttonOverlay, t),
      height: lerpDouble(a.height, b.height, t),
      buttonSize: lerpDouble(a.buttonSize, b.buttonSize, t),
      valueMinWidth: lerpDouble(a.valueMinWidth, b.valueMinWidth, t),
      glyphSize: lerpDouble(a.glyphSize, b.glyphSize, t),
      glyphStrokeWidth: lerpDouble(a.glyphStrokeWidth, b.glyphStrokeWidth, t),
      radius: lerpDouble(a.radius, b.radius, t),
      textStyle: TextStyle.lerp(a.textStyle, b.textStyle, t),
      disabledOpacity: lerpDouble(a.disabledOpacity, b.disabledOpacity, t),
    );
  }

  @override
  bool operator ==(Object other) =>
      other is ChukStepperStyle &&
      other.trackColor == trackColor &&
      other.glyphColor == glyphColor &&
      other.disabledGlyphColor == disabledGlyphColor &&
      other.valueColor == valueColor &&
      other.buttonOverlay == buttonOverlay &&
      other.height == height &&
      other.buttonSize == buttonSize &&
      other.valueMinWidth == valueMinWidth &&
      other.glyphSize == glyphSize &&
      other.glyphStrokeWidth == glyphStrokeWidth &&
      other.radius == radius &&
      other.textStyle == textStyle &&
      other.disabledOpacity == disabledOpacity;

  @override
  int get hashCode => Object.hash(
    trackColor,
    glyphColor,
    disabledGlyphColor,
    valueColor,
    buttonOverlay,
    height,
    buttonSize,
    valueMinWidth,
    glyphSize,
    glyphStrokeWidth,
    radius,
    textStyle,
    disabledOpacity,
  );
}
