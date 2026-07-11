import 'dart:ui' show lerpDouble;

import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

/// The resolved visual styling of a [ChukRadio].
///
/// Models a bordered circle: a [ringColor] hairline ring when unselected, an
/// [selectedRingColor] ring with a [dotColor] filled dot when selected. Only
/// the fields you set on a per-instance style override the theme-derived
/// defaults (see [merge]).
@immutable
class ChukRadioStyle {
  /// Creates a radio style. Any null field falls back to the theme default
  /// resolved by [ChukRadio].
  const ChukRadioStyle({
    this.size,
    this.ringWidth,
    this.ringColor,
    this.selectedRingColor,
    this.dotColor,
    this.dotRatio,
    this.disabledOpacity,
  });

  /// Diameter of the visible ring, in logical pixels.
  final double? size;

  /// Stroke width of the ring.
  final double? ringWidth;

  /// Ring color when unselected.
  final Color? ringColor;

  /// Ring color when selected.
  final Color? selectedRingColor;

  /// Fill color of the inner dot when selected.
  final Color? dotColor;

  /// Diameter of the dot as a fraction of [size] (0–1).
  final double? dotRatio;

  /// Opacity applied to the whole control while disabled.
  final double? disabledOpacity;

  /// Returns a copy with the given fields replaced.
  ChukRadioStyle copyWith({
    double? size,
    double? ringWidth,
    Color? ringColor,
    Color? selectedRingColor,
    Color? dotColor,
    double? dotRatio,
    double? disabledOpacity,
  }) {
    return ChukRadioStyle(
      size: size ?? this.size,
      ringWidth: ringWidth ?? this.ringWidth,
      ringColor: ringColor ?? this.ringColor,
      selectedRingColor: selectedRingColor ?? this.selectedRingColor,
      dotColor: dotColor ?? this.dotColor,
      dotRatio: dotRatio ?? this.dotRatio,
      disabledOpacity: disabledOpacity ?? this.disabledOpacity,
    );
  }

  /// Returns a new style where every field set on [other] overrides this one.
  ChukRadioStyle merge(ChukRadioStyle? other) {
    if (other == null) return this;
    return copyWith(
      size: other.size,
      ringWidth: other.ringWidth,
      ringColor: other.ringColor,
      selectedRingColor: other.selectedRingColor,
      dotColor: other.dotColor,
      dotRatio: other.dotRatio,
      disabledOpacity: other.disabledOpacity,
    );
  }

  /// Linearly interpolates between two radio styles.
  static ChukRadioStyle lerp(ChukRadioStyle a, ChukRadioStyle b, double t) {
    return ChukRadioStyle(
      size: lerpDouble(a.size, b.size, t),
      ringWidth: lerpDouble(a.ringWidth, b.ringWidth, t),
      ringColor: Color.lerp(a.ringColor, b.ringColor, t),
      selectedRingColor: Color.lerp(
        a.selectedRingColor,
        b.selectedRingColor,
        t,
      ),
      dotColor: Color.lerp(a.dotColor, b.dotColor, t),
      dotRatio: lerpDouble(a.dotRatio, b.dotRatio, t),
      disabledOpacity: lerpDouble(a.disabledOpacity, b.disabledOpacity, t),
    );
  }

  @override
  bool operator ==(Object other) =>
      other is ChukRadioStyle &&
      other.size == size &&
      other.ringWidth == ringWidth &&
      other.ringColor == ringColor &&
      other.selectedRingColor == selectedRingColor &&
      other.dotColor == dotColor &&
      other.dotRatio == dotRatio &&
      other.disabledOpacity == disabledOpacity;

  @override
  int get hashCode => Object.hash(
    size,
    ringWidth,
    ringColor,
    selectedRingColor,
    dotColor,
    dotRatio,
    disabledOpacity,
  );
}
