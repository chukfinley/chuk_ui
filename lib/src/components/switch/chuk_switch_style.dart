import 'dart:ui' show lerpDouble;
import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

/// The resolved visual styling of a [ChukSwitch].
@immutable
class ChukSwitchStyle {
  const ChukSwitchStyle({
    this.trackOnColor,
    this.trackOffColor,
    this.thumbColor,
    this.trackWidth,
    this.trackHeight,
    this.thumbSize,
    this.padding,
    this.disabledOpacity,
  });

  /// Track fill when the switch is on.
  final Color? trackOnColor;

  /// Track fill when the switch is off.
  final Color? trackOffColor;

  /// The moving thumb color.
  final Color? thumbColor;

  /// Overall track width.
  final double? trackWidth;

  /// Overall track height.
  final double? trackHeight;

  /// Diameter of the thumb.
  final double? thumbSize;

  /// Inset of the thumb from the track edge.
  final double? padding;

  /// Opacity applied to the whole control while disabled.
  final double? disabledOpacity;

  /// Returns a copy with the given fields replaced.
  ChukSwitchStyle copyWith({
    Color? trackOnColor,
    Color? trackOffColor,
    Color? thumbColor,
    double? trackWidth,
    double? trackHeight,
    double? thumbSize,
    double? padding,
    double? disabledOpacity,
  }) {
    return ChukSwitchStyle(
      trackOnColor: trackOnColor ?? this.trackOnColor,
      trackOffColor: trackOffColor ?? this.trackOffColor,
      thumbColor: thumbColor ?? this.thumbColor,
      trackWidth: trackWidth ?? this.trackWidth,
      trackHeight: trackHeight ?? this.trackHeight,
      thumbSize: thumbSize ?? this.thumbSize,
      padding: padding ?? this.padding,
      disabledOpacity: disabledOpacity ?? this.disabledOpacity,
    );
  }

  /// Returns a new style where every field set on [other] overrides this one.
  ChukSwitchStyle merge(ChukSwitchStyle? other) {
    if (other == null) return this;
    return copyWith(
      trackOnColor: other.trackOnColor,
      trackOffColor: other.trackOffColor,
      thumbColor: other.thumbColor,
      trackWidth: other.trackWidth,
      trackHeight: other.trackHeight,
      thumbSize: other.thumbSize,
      padding: other.padding,
      disabledOpacity: other.disabledOpacity,
    );
  }

  /// Linearly interpolates between two switch styles.
  static ChukSwitchStyle lerp(ChukSwitchStyle a, ChukSwitchStyle b, double t) {
    return ChukSwitchStyle(
      trackOnColor: Color.lerp(a.trackOnColor, b.trackOnColor, t),
      trackOffColor: Color.lerp(a.trackOffColor, b.trackOffColor, t),
      thumbColor: Color.lerp(a.thumbColor, b.thumbColor, t),
      trackWidth: lerpDouble(a.trackWidth, b.trackWidth, t),
      trackHeight: lerpDouble(a.trackHeight, b.trackHeight, t),
      thumbSize: lerpDouble(a.thumbSize, b.thumbSize, t),
      padding: lerpDouble(a.padding, b.padding, t),
      disabledOpacity: lerpDouble(a.disabledOpacity, b.disabledOpacity, t),
    );
  }

  @override
  bool operator ==(Object other) =>
      other is ChukSwitchStyle &&
      other.trackOnColor == trackOnColor &&
      other.trackOffColor == trackOffColor &&
      other.thumbColor == thumbColor &&
      other.trackWidth == trackWidth &&
      other.trackHeight == trackHeight &&
      other.thumbSize == thumbSize &&
      other.padding == padding &&
      other.disabledOpacity == disabledOpacity;

  @override
  int get hashCode => Object.hash(
        trackOnColor,
        trackOffColor,
        thumbColor,
        trackWidth,
        trackHeight,
        thumbSize,
        padding,
        disabledOpacity,
      );
}
