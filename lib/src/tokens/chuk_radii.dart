import 'dart:ui' show lerpDouble;
import 'package:flutter/foundation.dart';

/// A corner-radius scale, in logical pixels.
@immutable
class ChukRadii {
  const ChukRadii({
    this.sm = 10,
    this.md = 14,
    this.lg = 20,
    this.pill = 50,
  });

  /// Small radius — 10 by default (chips, small controls).
  final double sm;

  /// Medium / card radius — 14 by default.
  final double md;

  /// Large radius — 20 by default (list groups, section cards).
  final double lg;

  /// Fully rounded (pill / toggle / nav bar) — 50 by default.
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
