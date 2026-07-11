import 'dart:ui' show lerpDouble;
import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

/// The resolved visual styling of a [ChukButton] for a single interaction
/// state.
///
/// A style is deliberately *flat and value-based* (no `WidgetStateProperty`) so
/// that it is trivial to [copyWith], [merge] and [lerp]. Per-state variation is
/// expressed by the small set of optional `pressed*` / `disabled*` fields, which
/// fall back to the base values when null.
@immutable
class ChukButtonStyle {
  const ChukButtonStyle({
    this.background,
    this.foreground,
    this.borderColor,
    this.borderWidth,
    this.radius,
    this.smoothing,
    this.padding,
    this.textStyle,
    this.minHeight,
    this.pressedOverlay,
    this.hoverOverlay,
    this.disabledBackground,
    this.disabledForeground,
  });

  /// Fill color in the resting state.
  final Color? background;

  /// Content (text / icon) color.
  final Color? foreground;

  /// Border color; no border is drawn when null or [borderWidth] is 0.
  final Color? borderColor;

  /// Border thickness in logical pixels.
  final double? borderWidth;

  /// Corner radius in logical pixels.
  final double? radius;

  /// Apple-style corner smoothing, 0..1 (0 = circular, 0.6 = iOS icon look).
  final double? smoothing;

  /// Inner padding around the label.
  final EdgeInsets? padding;

  /// Text style applied to a string / [Text] child.
  final TextStyle? textStyle;

  /// Minimum tap-target height. Defaults to 44 for accessibility.
  final double? minHeight;

  /// Color blended over [background] while pressed.
  final Color? pressedOverlay;

  /// Color blended over [background] while hovered.
  final Color? hoverOverlay;

  /// Fill color while disabled; falls back to [background] when null.
  final Color? disabledBackground;

  /// Content color while disabled; falls back to [foreground] when null.
  final Color? disabledForeground;

  /// Returns a copy with the given fields replaced.
  ChukButtonStyle copyWith({
    Color? background,
    Color? foreground,
    Color? borderColor,
    double? borderWidth,
    double? radius,
    double? smoothing,
    EdgeInsets? padding,
    TextStyle? textStyle,
    double? minHeight,
    Color? pressedOverlay,
    Color? hoverOverlay,
    Color? disabledBackground,
    Color? disabledForeground,
  }) {
    return ChukButtonStyle(
      background: background ?? this.background,
      foreground: foreground ?? this.foreground,
      borderColor: borderColor ?? this.borderColor,
      borderWidth: borderWidth ?? this.borderWidth,
      radius: radius ?? this.radius,
      smoothing: smoothing ?? this.smoothing,
      padding: padding ?? this.padding,
      textStyle: textStyle ?? this.textStyle,
      minHeight: minHeight ?? this.minHeight,
      pressedOverlay: pressedOverlay ?? this.pressedOverlay,
      hoverOverlay: hoverOverlay ?? this.hoverOverlay,
      disabledBackground: disabledBackground ?? this.disabledBackground,
      disabledForeground: disabledForeground ?? this.disabledForeground,
    );
  }

  /// Returns a new style where every field set on [other] overrides this one.
  ///
  /// This is the mechanism behind the three-layer resolution
  /// (theme default → variant → per-instance override).
  ChukButtonStyle merge(ChukButtonStyle? other) {
    if (other == null) return this;
    return copyWith(
      background: other.background,
      foreground: other.foreground,
      borderColor: other.borderColor,
      borderWidth: other.borderWidth,
      radius: other.radius,
      smoothing: other.smoothing,
      padding: other.padding,
      textStyle: other.textStyle,
      minHeight: other.minHeight,
      pressedOverlay: other.pressedOverlay,
      hoverOverlay: other.hoverOverlay,
      disabledBackground: other.disabledBackground,
      disabledForeground: other.disabledForeground,
    );
  }

  /// Linearly interpolates between two button styles.
  static ChukButtonStyle lerp(ChukButtonStyle a, ChukButtonStyle b, double t) {
    return ChukButtonStyle(
      background: Color.lerp(a.background, b.background, t),
      foreground: Color.lerp(a.foreground, b.foreground, t),
      borderColor: Color.lerp(a.borderColor, b.borderColor, t),
      borderWidth: lerpDouble(a.borderWidth, b.borderWidth, t),
      radius: lerpDouble(a.radius, b.radius, t),
      smoothing: lerpDouble(a.smoothing, b.smoothing, t),
      padding: EdgeInsets.lerp(a.padding, b.padding, t),
      textStyle: TextStyle.lerp(a.textStyle, b.textStyle, t),
      minHeight: lerpDouble(a.minHeight, b.minHeight, t),
      pressedOverlay: Color.lerp(a.pressedOverlay, b.pressedOverlay, t),
      hoverOverlay: Color.lerp(a.hoverOverlay, b.hoverOverlay, t),
      disabledBackground:
          Color.lerp(a.disabledBackground, b.disabledBackground, t),
      disabledForeground:
          Color.lerp(a.disabledForeground, b.disabledForeground, t),
    );
  }

  @override
  bool operator ==(Object other) =>
      other is ChukButtonStyle &&
      other.background == background &&
      other.foreground == foreground &&
      other.borderColor == borderColor &&
      other.borderWidth == borderWidth &&
      other.radius == radius &&
      other.smoothing == smoothing &&
      other.padding == padding &&
      other.textStyle == textStyle &&
      other.minHeight == minHeight &&
      other.pressedOverlay == pressedOverlay &&
      other.hoverOverlay == hoverOverlay &&
      other.disabledBackground == disabledBackground &&
      other.disabledForeground == disabledForeground;

  @override
  int get hashCode => Object.hash(
        background,
        foreground,
        borderColor,
        borderWidth,
        radius,
        smoothing,
        padding,
        textStyle,
        minHeight,
        pressedOverlay,
        hoverOverlay,
        disabledBackground,
        disabledForeground,
      );
}
