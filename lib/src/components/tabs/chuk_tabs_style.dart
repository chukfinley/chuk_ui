import 'dart:ui' show lerpDouble;

import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

/// The resolved visual styling of a [ChukTabs] control.
///
/// Every field is optional; anything left null falls back to a sensible,
/// token-derived default resolved from the current [ChukThemeData] at build
/// time. Pass an instance to [ChukTabs.style] to override per-instance.
@immutable
class ChukTabsStyle {
  /// Creates a tabs style. All fields are optional overrides.
  const ChukTabsStyle({
    this.indicatorColor,
    this.activeColor,
    this.inactiveColor,
    this.trackColor,
    this.indicatorThickness,
    this.indicatorRadius,
    this.height,
    this.gap,
    this.showTrack,
  });

  /// Color of the gliding underline bar. Defaults to `colors.accent`.
  final Color? indicatorColor;

  /// Label color of the active tab. Defaults to `colors.textPrimary`.
  final Color? activeColor;

  /// Label color of inactive tabs. Defaults to `colors.textSecondary`.
  final Color? inactiveColor;

  /// Color of the full-width hairline track behind the indicator. Defaults to
  /// `colors.hairline`. Only drawn when [showTrack] is true.
  final Color? trackColor;

  /// Thickness of the underline bar in logical pixels. Defaults to 2.5.
  final double? indicatorThickness;

  /// Corner radius of the underline bar. Defaults to `radii.pill`.
  final double? indicatorRadius;

  /// Overall height of the tab row (also the tap-target height). Defaults to 44.
  final double? height;

  /// Horizontal padding applied inside each tab slot. Defaults to `spacing.sm`.
  final double? gap;

  /// Whether to draw the full-width hairline track behind the indicator.
  /// Defaults to true.
  final bool? showTrack;

  /// Returns a copy with the given fields replaced.
  ChukTabsStyle copyWith({
    Color? indicatorColor,
    Color? activeColor,
    Color? inactiveColor,
    Color? trackColor,
    double? indicatorThickness,
    double? indicatorRadius,
    double? height,
    double? gap,
    bool? showTrack,
  }) {
    return ChukTabsStyle(
      indicatorColor: indicatorColor ?? this.indicatorColor,
      activeColor: activeColor ?? this.activeColor,
      inactiveColor: inactiveColor ?? this.inactiveColor,
      trackColor: trackColor ?? this.trackColor,
      indicatorThickness: indicatorThickness ?? this.indicatorThickness,
      indicatorRadius: indicatorRadius ?? this.indicatorRadius,
      height: height ?? this.height,
      gap: gap ?? this.gap,
      showTrack: showTrack ?? this.showTrack,
    );
  }

  /// Returns a new style where every field set on [other] overrides this one.
  ChukTabsStyle merge(ChukTabsStyle? other) {
    if (other == null) return this;
    return copyWith(
      indicatorColor: other.indicatorColor,
      activeColor: other.activeColor,
      inactiveColor: other.inactiveColor,
      trackColor: other.trackColor,
      indicatorThickness: other.indicatorThickness,
      indicatorRadius: other.indicatorRadius,
      height: other.height,
      gap: other.gap,
      showTrack: other.showTrack,
    );
  }

  /// Linearly interpolates between two styles.
  static ChukTabsStyle lerp(ChukTabsStyle a, ChukTabsStyle b, double t) {
    return ChukTabsStyle(
      indicatorColor: Color.lerp(a.indicatorColor, b.indicatorColor, t),
      activeColor: Color.lerp(a.activeColor, b.activeColor, t),
      inactiveColor: Color.lerp(a.inactiveColor, b.inactiveColor, t),
      trackColor: Color.lerp(a.trackColor, b.trackColor, t),
      indicatorThickness: lerpDouble(
        a.indicatorThickness,
        b.indicatorThickness,
        t,
      ),
      indicatorRadius: lerpDouble(a.indicatorRadius, b.indicatorRadius, t),
      height: lerpDouble(a.height, b.height, t),
      gap: lerpDouble(a.gap, b.gap, t),
      showTrack: t < 0.5 ? a.showTrack : b.showTrack,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is ChukTabsStyle &&
      other.indicatorColor == indicatorColor &&
      other.activeColor == activeColor &&
      other.inactiveColor == inactiveColor &&
      other.trackColor == trackColor &&
      other.indicatorThickness == indicatorThickness &&
      other.indicatorRadius == indicatorRadius &&
      other.height == height &&
      other.gap == gap &&
      other.showTrack == showTrack;

  @override
  int get hashCode => Object.hash(
    indicatorColor,
    activeColor,
    inactiveColor,
    trackColor,
    indicatorThickness,
    indicatorRadius,
    height,
    gap,
    showTrack,
  );
}
