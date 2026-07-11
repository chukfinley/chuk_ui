import 'dart:ui' show lerpDouble;
import 'package:flutter/foundation.dart';

/// A corner-radius scale, in logical pixels.
@immutable
class ChukRadii {
  const ChukRadii({
    this.sm = 6,
    this.md = 10,
    this.lg = 16,
    this.pill = 999,
  });

  /// Small radius — 6 by default.
  final double sm;

  /// Medium radius — 10 by default.
  final double md;

  /// Large radius — 16 by default.
  final double lg;

  /// Fully rounded (pill / circle) — 999 by default.
  final double pill;

  /// Returns a copy with the given steps replaced.
  ChukRadii copyWith({double? sm, double? md, double? lg, double? pill}) {
    return ChukRadii(
      sm: sm ?? this.sm,
      md: md ?? this.md,
      lg: lg ?? this.lg,
      pill: pill ?? this.pill,
    );
  }

  /// Linearly interpolates between two radius scales.
  static ChukRadii lerp(ChukRadii a, ChukRadii b, double t) {
    return ChukRadii(
      sm: lerpDouble(a.sm, b.sm, t)!,
      md: lerpDouble(a.md, b.md, t)!,
      lg: lerpDouble(a.lg, b.lg, t)!,
      pill: lerpDouble(a.pill, b.pill, t)!,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is ChukRadii &&
      other.sm == sm &&
      other.md == md &&
      other.lg == lg &&
      other.pill == pill;

  @override
  int get hashCode => Object.hash(sm, md, lg, pill);
}
