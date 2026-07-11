import 'dart:ui' show lerpDouble;
import 'package:flutter/foundation.dart';

/// A spacing scale, in logical pixels.
///
/// Use these named steps instead of magic numbers so that padding, gaps and
/// insets stay consistent across every component. The default scale follows a
/// 4pt grid.
@immutable
class ChukSpacing {
  const ChukSpacing({
    this.xs = 4,
    this.sm = 8,
    this.md = 12,
    this.lg = 16,
    this.xl = 24,
    this.xxl = 32,
  });

  /// Extra small — 4 by default.
  final double xs;

  /// Small — 8 by default.
  final double sm;

  /// Medium — 12 by default.
  final double md;

  /// Large — 16 by default.
  final double lg;

  /// Extra large — 24 by default.
  final double xl;

  /// Double extra large — 32 by default.
  final double xxl;

  /// Returns a copy with the given steps replaced.
  ChukSpacing copyWith({
    double? xs,
    double? sm,
    double? md,
    double? lg,
    double? xl,
    double? xxl,
  }) {
    return ChukSpacing(
      xs: xs ?? this.xs,
      sm: sm ?? this.sm,
      md: md ?? this.md,
      lg: lg ?? this.lg,
      xl: xl ?? this.xl,
      xxl: xxl ?? this.xxl,
    );
  }

  /// Linearly interpolates between two spacing scales.
  static ChukSpacing lerp(ChukSpacing a, ChukSpacing b, double t) {
    return ChukSpacing(
      xs: lerpDouble(a.xs, b.xs, t)!,
      sm: lerpDouble(a.sm, b.sm, t)!,
      md: lerpDouble(a.md, b.md, t)!,
      lg: lerpDouble(a.lg, b.lg, t)!,
      xl: lerpDouble(a.xl, b.xl, t)!,
      xxl: lerpDouble(a.xxl, b.xxl, t)!,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is ChukSpacing &&
      other.xs == xs &&
      other.sm == sm &&
      other.md == md &&
      other.lg == lg &&
      other.xl == xl &&
      other.xxl == xxl;

  @override
  int get hashCode => Object.hash(xs, sm, md, lg, xl, xxl);
}
