import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';

/// A frosted-glass surface: whatever is behind it is blurred, then a
/// translucent fill (and optional border/shadow) is laid on top, all clipped to
/// [shape].
///
/// This is what gives light mode its glass look. The blur only shows against
/// content behind it, so place glass over a gradient or scenic background for
/// the full effect.
class ChukGlass extends StatelessWidget {
  const ChukGlass({
    super.key,
    required this.shape,
    required this.child,
    this.fill = const Color(0x66FFFFFF),
    this.blurSigma = 18,
    this.shadow,
  });

  /// The clip + border shape (e.g. a `SquircleBorder`).
  final ShapeBorder shape;

  /// Content laid over the glass.
  final Widget child;

  /// Translucent fill tint on top of the blur.
  final Color fill;

  /// Gaussian blur radius applied to the backdrop.
  final double blurSigma;

  /// Optional drop shadow (drawn unclipped, behind the glass).
  final List<BoxShadow>? shadow;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      // Shadow only — drawn outside the clip so it isn't cut away.
      decoration: ShapeDecoration(shape: shape, shadows: shadow),
      child: ClipPath(
        clipper: ShapeBorderClipper(shape: shape),
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
          child: DecoratedBox(
            // Fill + border on top of the blurred backdrop.
            decoration: ShapeDecoration(color: fill, shape: shape),
            child: child,
          ),
        ),
      ),
    );
  }
}
