import 'dart:ui' show lerpDouble;
import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

/// The resolved visual styling of a [ChukSegmented] control.
@immutable
class ChukSegmentedStyle {
  const ChukSegmentedStyle({
    this.trackColor,
    this.highlightColor,
    this.activeColor,
    this.inactiveColor,
    this.height,
    this.radius,
    this.padding,
  });

  /// Fill of the pill track.
  final Color? trackColor;

  /// The single sliding highlight behind the active option.
  final Color? highlightColor;

  /// Label color of the active option.
  final Color? activeColor;

  /// Label color of inactive options.
  final Color? inactiveColor;

  /// Track height.
  final double? height;

  /// Corner radius of the track and highlight.
  final double? radius;

  /// Inset of the highlight from the track edge.
  final double? padding;

  /// Returns a copy with the given fields replaced.
  ChukSegmentedStyle copyWith({
    Color? trackColor,
    Color? highlightColor,
    Color? activeColor,
    Color? inactiveColor,
    double? height,
    double? radius,
    double? padding,
  }) {
    return ChukSegmentedStyle(
      trackColor: trackColor ?? this.trackColor,
      highlightColor: highlightColor ?? this.highlightColor,
      activeColor: activeColor ?? this.activeColor,
      inactiveColor: inactiveColor ?? this.inactiveColor,
      height: height ?? this.height,
      radius: radius ?? this.radius,
      padding: padding ?? this.padding,
    );
  }

  /// Returns a new style where every field set on [other] overrides this one.
  ChukSegmentedStyle merge(ChukSegmentedStyle? other) {
    if (other == null) return this;
    return copyWith(
      trackColor: other.trackColor,
      highlightColor: other.highlightColor,
      activeColor: other.activeColor,
      inactiveColor: other.inactiveColor,
      height: other.height,
      radius: other.radius,
      padding: other.padding,
    );
  }

  /// Linearly interpolates between two styles.
  static ChukSegmentedStyle lerp(
    ChukSegmentedStyle a,
    ChukSegmentedStyle b,
    double t,
  ) {
    return ChukSegmentedStyle(
      trackColor: Color.lerp(a.trackColor, b.trackColor, t),
      highlightColor: Color.lerp(a.highlightColor, b.highlightColor, t),
      activeColor: Color.lerp(a.activeColor, b.activeColor, t),
      inactiveColor: Color.lerp(a.inactiveColor, b.inactiveColor, t),
      height: lerpDouble(a.height, b.height, t),
      radius: lerpDouble(a.radius, b.radius, t),
      padding: lerpDouble(a.padding, b.padding, t),
    );
  }

  @override
  bool operator ==(Object other) =>
      other is ChukSegmentedStyle &&
      other.trackColor == trackColor &&
      other.highlightColor == highlightColor &&
      other.activeColor == activeColor &&
      other.inactiveColor == inactiveColor &&
      other.height == height &&
      other.radius == radius &&
      other.padding == padding;

  @override
  int get hashCode => Object.hash(
        trackColor,
        highlightColor,
        activeColor,
        inactiveColor,
        height,
        radius,
        padding,
      );
}
