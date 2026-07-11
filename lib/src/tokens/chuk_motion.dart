import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';

/// Animation durations and curves for a [ChukThemeData].
///
/// Components read these instead of hardcoding durations, so motion stays
/// consistent and can be tuned (or disabled for reduced-motion) in one place.
@immutable
class ChukMotion {
  const ChukMotion({
    this.fast = const Duration(milliseconds: 120),
    this.medium = const Duration(milliseconds: 220),
    this.slow = const Duration(milliseconds: 350),
    this.standard = Curves.easeOutCubic,
    this.emphasized = Curves.easeInOutCubic,
  });

  /// Quick state changes — hover, press.
  final Duration fast;

  /// Standard transitions — toggles, expands.
  final Duration medium;

  /// Larger movements — sheets, page-level motion.
  final Duration slow;

  /// The default easing curve.
  final Curve standard;

  /// A more pronounced curve for emphasized motion.
  final Curve emphasized;

  /// Returns a copy with the given values replaced.
  ChukMotion copyWith({
    Duration? fast,
    Duration? medium,
    Duration? slow,
    Curve? standard,
    Curve? emphasized,
  }) {
    return ChukMotion(
      fast: fast ?? this.fast,
      medium: medium ?? this.medium,
      slow: slow ?? this.slow,
      standard: standard ?? this.standard,
      emphasized: emphasized ?? this.emphasized,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is ChukMotion &&
      other.fast == fast &&
      other.medium == medium &&
      other.slow == slow &&
      other.standard == standard &&
      other.emphasized == emphasized;

  @override
  int get hashCode => Object.hash(fast, medium, slow, standard, emphasized);
}
