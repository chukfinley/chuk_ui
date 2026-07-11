import 'dart:ui' show lerpDouble;
import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

/// The resolved visual styling of a [ChukSwitch].
///
/// Models the reference toggle: a translucent pill *track* with a **half-width
/// knob** that glides between the two halves — grey when off, accent-tinted
/// when on. This is deliberately not a small circular thumb.
@immutable
class ChukSwitchStyle {
  const ChukSwitchStyle({
    this.trackColor,
    this.borderColor,
    this.knobOnColor,
    this.knobOffColor,
    this.width,
    this.height,
    this.padding,
    this.radius,
    this.disabledOpacity,
    this.shadow,
  });

  /// Fill of the pill track.
  final Color? trackColor;

  /// Track border color (hairline). No border when null.
  final Color? borderColor;

  /// Knob fill when on.
  final Color? knobOnColor;

  /// Knob fill when off.
  final Color? knobOffColor;

  /// Overall track width.
  final double? width;

  /// Overall track height.
  final double? height;

  /// Inset of the knob from the track edge.
  final double? padding;

  /// Corner radius of the track and knob.
  final double? radius;

  /// Opacity applied to the whole control while disabled.
  final double? disabledOpacity;

  /// Optional drop shadow under the track.
  final List<BoxShadow>? shadow;

  /// Returns a copy with the given fields replaced.
  ChukSwitchStyle copyWith({
    Color? trackColor,
    Color? borderColor,
    Color? knobOnColor,
    Color? knobOffColor,
    double? width,
    double? height,
    double? padding,
    double? radius,
    double? disabledOpacity,
    List<BoxShadow>? shadow,
  }) {
    return ChukSwitchStyle(
      trackColor: trackColor ?? this.trackColor,
      borderColor: borderColor ?? this.borderColor,
      knobOnColor: knobOnColor ?? this.knobOnColor,
      knobOffColor: knobOffColor ?? this.knobOffColor,
      width: width ?? this.width,
      height: height ?? this.height,
      padding: padding ?? this.padding,
      radius: radius ?? this.radius,
      disabledOpacity: disabledOpacity ?? this.disabledOpacity,
      shadow: shadow ?? this.shadow,
    );
  }

  /// Returns a new style where every field set on [other] overrides this one.
  ChukSwitchStyle merge(ChukSwitchStyle? other) {
    if (other == null) return this;
    return copyWith(
      trackColor: other.trackColor,
      borderColor: other.borderColor,
      knobOnColor: other.knobOnColor,
      knobOffColor: other.knobOffColor,
      width: other.width,
      height: other.height,
      padding: other.padding,
      radius: other.radius,
      disabledOpacity: other.disabledOpacity,
      shadow: other.shadow,
    );
  }

  /// Linearly interpolates between two switch styles.
  static ChukSwitchStyle lerp(ChukSwitchStyle a, ChukSwitchStyle b, double t) {
    return ChukSwitchStyle(
      trackColor: Color.lerp(a.trackColor, b.trackColor, t),
      borderColor: Color.lerp(a.borderColor, b.borderColor, t),
      knobOnColor: Color.lerp(a.knobOnColor, b.knobOnColor, t),
      knobOffColor: Color.lerp(a.knobOffColor, b.knobOffColor, t),
      width: lerpDouble(a.width, b.width, t),
      height: lerpDouble(a.height, b.height, t),
      padding: lerpDouble(a.padding, b.padding, t),
      radius: lerpDouble(a.radius, b.radius, t),
      disabledOpacity: lerpDouble(a.disabledOpacity, b.disabledOpacity, t),
      shadow: BoxShadow.lerpList(a.shadow, b.shadow, t),
    );
  }

  @override
  bool operator ==(Object other) =>
      other is ChukSwitchStyle &&
      other.trackColor == trackColor &&
      other.borderColor == borderColor &&
      other.knobOnColor == knobOnColor &&
      other.knobOffColor == knobOffColor &&
      other.width == width &&
      other.height == height &&
      other.padding == padding &&
      other.radius == radius &&
      other.disabledOpacity == disabledOpacity &&
      listEquals(other.shadow, shadow);

  @override
  int get hashCode => Object.hash(
        trackColor,
        borderColor,
        knobOnColor,
        knobOffColor,
        width,
        height,
        padding,
        radius,
        disabledOpacity,
        Object.hashAll(shadow ?? const []),
      );
}
