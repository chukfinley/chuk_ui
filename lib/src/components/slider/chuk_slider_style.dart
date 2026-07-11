import 'dart:ui' show lerpDouble;

import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

/// The resolved visual styling of a [ChukSlider].
///
/// Every field is optional; unset fields fall back to values derived from the
/// [ChukThemeData] tokens inside the widget. Layer per-instance overrides on top
/// of the theme-derived defaults with [merge].
@immutable
class ChukSliderStyle {
  const ChukSliderStyle({
    this.inactiveTrackColor,
    this.activeTrackColor,
    this.thumbColor,
    this.trackHeight,
    this.thumbSize,
    this.trackRadius,
    this.disabledOpacity,
    this.thumbShadow,
  });

  /// Fill of the inactive (right-of-thumb) portion of the track.
  final Color? inactiveTrackColor;

  /// Fill of the active (left-of-thumb) portion of the track.
  final Color? activeTrackColor;

  /// Fill of the round thumb. In light themes this is used as the frosted-glass
  /// tint instead of a solid fill.
  final Color? thumbColor;

  /// Thickness of the track bar.
  final double? trackHeight;

  /// Diameter of the round thumb.
  final double? thumbSize;

  /// Corner radius of the track. Defaults to a fully-rounded pill.
  final double? trackRadius;

  /// Opacity applied to the whole control while disabled.
  final double? disabledOpacity;

  /// Drop shadow cast by the thumb.
  final List<BoxShadow>? thumbShadow;

  /// Returns a copy with the given fields replaced.
  ChukSliderStyle copyWith({
    Color? inactiveTrackColor,
    Color? activeTrackColor,
    Color? thumbColor,
    double? trackHeight,
    double? thumbSize,
    double? trackRadius,
    double? disabledOpacity,
    List<BoxShadow>? thumbShadow,
  }) {
    return ChukSliderStyle(
      inactiveTrackColor: inactiveTrackColor ?? this.inactiveTrackColor,
      activeTrackColor: activeTrackColor ?? this.activeTrackColor,
      thumbColor: thumbColor ?? this.thumbColor,
      trackHeight: trackHeight ?? this.trackHeight,
      thumbSize: thumbSize ?? this.thumbSize,
      trackRadius: trackRadius ?? this.trackRadius,
      disabledOpacity: disabledOpacity ?? this.disabledOpacity,
      thumbShadow: thumbShadow ?? this.thumbShadow,
    );
  }

  /// Returns a new style where every field set on [other] overrides this one.
  ChukSliderStyle merge(ChukSliderStyle? other) {
    if (other == null) return this;
    return copyWith(
      inactiveTrackColor: other.inactiveTrackColor,
      activeTrackColor: other.activeTrackColor,
      thumbColor: other.thumbColor,
      trackHeight: other.trackHeight,
      thumbSize: other.thumbSize,
      trackRadius: other.trackRadius,
      disabledOpacity: other.disabledOpacity,
      thumbShadow: other.thumbShadow,
    );
  }

  /// Linearly interpolates between two slider styles.
  static ChukSliderStyle lerp(ChukSliderStyle a, ChukSliderStyle b, double t) {
    return ChukSliderStyle(
      inactiveTrackColor: Color.lerp(
        a.inactiveTrackColor,
        b.inactiveTrackColor,
        t,
      ),
      activeTrackColor: Color.lerp(a.activeTrackColor, b.activeTrackColor, t),
      thumbColor: Color.lerp(a.thumbColor, b.thumbColor, t),
      trackHeight: lerpDouble(a.trackHeight, b.trackHeight, t),
      thumbSize: lerpDouble(a.thumbSize, b.thumbSize, t),
      trackRadius: lerpDouble(a.trackRadius, b.trackRadius, t),
      disabledOpacity: lerpDouble(a.disabledOpacity, b.disabledOpacity, t),
      thumbShadow: BoxShadow.lerpList(a.thumbShadow, b.thumbShadow, t),
    );
  }

  @override
  bool operator ==(Object other) =>
      other is ChukSliderStyle &&
      other.inactiveTrackColor == inactiveTrackColor &&
      other.activeTrackColor == activeTrackColor &&
      other.thumbColor == thumbColor &&
      other.trackHeight == trackHeight &&
      other.thumbSize == thumbSize &&
      other.trackRadius == trackRadius &&
      other.disabledOpacity == disabledOpacity &&
      listEquals(other.thumbShadow, thumbShadow);

  @override
  int get hashCode => Object.hash(
    inactiveTrackColor,
    activeTrackColor,
    thumbColor,
    trackHeight,
    thumbSize,
    trackRadius,
    disabledOpacity,
    Object.hashAll(thumbShadow ?? const []),
  );
}
