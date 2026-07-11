import 'dart:ui' show lerpDouble;

import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

/// The resolved visual styling of a [ChukCheckbox].
///
/// Models a small squircle box: a `hairlineStrong` border over a transparent
/// fill when unchecked, and an `accent` fill with an `onAccent` tick when
/// checked. Every field is optional; unset fields fall back to sensible
/// token-derived defaults inside the widget.
@immutable
class ChukCheckboxStyle {
  /// Creates a checkbox style. All fields are optional overrides.
  const ChukCheckboxStyle({
    this.size,
    this.radius,
    this.smoothing,
    this.borderWidth,
    this.strokeWidth,
    this.borderColor,
    this.fillColor,
    this.checkColor,
    this.disabledOpacity,
  });

  /// Side length of the (square) box in logical pixels.
  final double? size;

  /// Corner radius of the box.
  final double? radius;

  /// Apple-style corner smoothing, 0..1.
  final double? smoothing;

  /// Width of the box outline while unchecked.
  final double? borderWidth;

  /// Stroke width of the tick mark.
  final double? strokeWidth;

  /// Outline color while unchecked.
  final Color? borderColor;

  /// Box fill color while checked.
  final Color? fillColor;

  /// Color of the tick mark drawn on the checked fill.
  final Color? checkColor;

  /// Opacity applied to the whole control while disabled.
  final double? disabledOpacity;

  /// Returns a copy with the given fields replaced.
  ChukCheckboxStyle copyWith({
    double? size,
    double? radius,
    double? smoothing,
    double? borderWidth,
    double? strokeWidth,
    Color? borderColor,
    Color? fillColor,
    Color? checkColor,
    double? disabledOpacity,
  }) {
    return ChukCheckboxStyle(
      size: size ?? this.size,
      radius: radius ?? this.radius,
      smoothing: smoothing ?? this.smoothing,
      borderWidth: borderWidth ?? this.borderWidth,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      borderColor: borderColor ?? this.borderColor,
      fillColor: fillColor ?? this.fillColor,
      checkColor: checkColor ?? this.checkColor,
      disabledOpacity: disabledOpacity ?? this.disabledOpacity,
    );
  }

  /// Returns a new style where every field set on [other] overrides this one.
  ChukCheckboxStyle merge(ChukCheckboxStyle? other) {
    if (other == null) return this;
    return copyWith(
      size: other.size,
      radius: other.radius,
      smoothing: other.smoothing,
      borderWidth: other.borderWidth,
      strokeWidth: other.strokeWidth,
      borderColor: other.borderColor,
      fillColor: other.fillColor,
      checkColor: other.checkColor,
      disabledOpacity: other.disabledOpacity,
    );
  }

  /// Linearly interpolates between two checkbox styles.
  static ChukCheckboxStyle lerp(
    ChukCheckboxStyle a,
    ChukCheckboxStyle b,
    double t,
  ) {
    return ChukCheckboxStyle(
      size: lerpDouble(a.size, b.size, t),
      radius: lerpDouble(a.radius, b.radius, t),
      smoothing: lerpDouble(a.smoothing, b.smoothing, t),
      borderWidth: lerpDouble(a.borderWidth, b.borderWidth, t),
      strokeWidth: lerpDouble(a.strokeWidth, b.strokeWidth, t),
      borderColor: Color.lerp(a.borderColor, b.borderColor, t),
      fillColor: Color.lerp(a.fillColor, b.fillColor, t),
      checkColor: Color.lerp(a.checkColor, b.checkColor, t),
      disabledOpacity: lerpDouble(a.disabledOpacity, b.disabledOpacity, t),
    );
  }

  @override
  bool operator ==(Object other) =>
      other is ChukCheckboxStyle &&
      other.size == size &&
      other.radius == radius &&
      other.smoothing == smoothing &&
      other.borderWidth == borderWidth &&
      other.strokeWidth == strokeWidth &&
      other.borderColor == borderColor &&
      other.fillColor == fillColor &&
      other.checkColor == checkColor &&
      other.disabledOpacity == disabledOpacity;

  @override
  int get hashCode => Object.hash(
    size,
    radius,
    smoothing,
    borderWidth,
    strokeWidth,
    borderColor,
    fillColor,
    checkColor,
    disabledOpacity,
  );
}
