import 'dart:ui' show lerpDouble;
import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

/// The resolved visual styling of a [ChukNavBar].
@immutable
class ChukNavStyle {
  const ChukNavStyle({
    this.trackColor,
    this.highlightColor,
    this.activeColor,
    this.inactiveColor,
    this.height,
    this.collapsedHeight,
    this.radius,
    this.iconSize,
    this.shadow,
  });

  /// Fill of the floating pill bar.
  final Color? trackColor;

  /// The single sliding highlight behind the active tab.
  final Color? highlightColor;

  /// Icon/label color of the active tab.
  final Color? activeColor;

  /// Icon/label color of inactive tabs.
  final Color? inactiveColor;

  /// Bar height with labels shown.
  final double? height;

  /// Bar height when collapsed (labels hidden).
  final double? collapsedHeight;

  /// Corner radius of the bar and highlight.
  final double? radius;

  /// Tab icon size.
  final double? iconSize;

  /// Drop shadow that lifts the floating bar.
  final List<BoxShadow>? shadow;

  /// Returns a copy with the given fields replaced.
  ChukNavStyle copyWith({
    Color? trackColor,
    Color? highlightColor,
    Color? activeColor,
    Color? inactiveColor,
    double? height,
    double? collapsedHeight,
    double? radius,
    double? iconSize,
    List<BoxShadow>? shadow,
  }) {
    return ChukNavStyle(
      trackColor: trackColor ?? this.trackColor,
      highlightColor: highlightColor ?? this.highlightColor,
      activeColor: activeColor ?? this.activeColor,
      inactiveColor: inactiveColor ?? this.inactiveColor,
      height: height ?? this.height,
      collapsedHeight: collapsedHeight ?? this.collapsedHeight,
      radius: radius ?? this.radius,
      iconSize: iconSize ?? this.iconSize,
      shadow: shadow ?? this.shadow,
    );
  }

  /// Returns a new style where every field set on [other] overrides this one.
  ChukNavStyle merge(ChukNavStyle? other) {
    if (other == null) return this;
    return copyWith(
      trackColor: other.trackColor,
      highlightColor: other.highlightColor,
      activeColor: other.activeColor,
      inactiveColor: other.inactiveColor,
      height: other.height,
      collapsedHeight: other.collapsedHeight,
      radius: other.radius,
      iconSize: other.iconSize,
      shadow: other.shadow,
    );
  }

  /// Linearly interpolates between two styles.
  static ChukNavStyle lerp(ChukNavStyle a, ChukNavStyle b, double t) {
    return ChukNavStyle(
      trackColor: Color.lerp(a.trackColor, b.trackColor, t),
      highlightColor: Color.lerp(a.highlightColor, b.highlightColor, t),
      activeColor: Color.lerp(a.activeColor, b.activeColor, t),
      inactiveColor: Color.lerp(a.inactiveColor, b.inactiveColor, t),
      height: lerpDouble(a.height, b.height, t),
      collapsedHeight: lerpDouble(a.collapsedHeight, b.collapsedHeight, t),
      radius: lerpDouble(a.radius, b.radius, t),
      iconSize: lerpDouble(a.iconSize, b.iconSize, t),
      shadow: BoxShadow.lerpList(a.shadow, b.shadow, t),
    );
  }

  @override
  bool operator ==(Object other) =>
      other is ChukNavStyle &&
      other.trackColor == trackColor &&
      other.highlightColor == highlightColor &&
      other.activeColor == activeColor &&
      other.inactiveColor == inactiveColor &&
      other.height == height &&
      other.collapsedHeight == collapsedHeight &&
      other.radius == radius &&
      other.iconSize == iconSize &&
      listEquals(other.shadow, shadow);

  @override
  int get hashCode => Object.hash(
        trackColor,
        highlightColor,
        activeColor,
        inactiveColor,
        height,
        collapsedHeight,
        radius,
        iconSize,
        Object.hashAll(shadow ?? const []),
      );
}
