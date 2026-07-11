import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';

/// A frosted-glass surface: whatever is behind it is blurred, then a translucent
/// fill, a bright edge highlight and an optional shadow are laid on top, all
/// clipped to [shape].
///
/// The blur only shows against content behind it, so place glass over a gradient
/// or scenic background for the full effect. A low [fill] alpha plus a strong
/// [blurSigma] and the [highlight] edge are what make the glass read clearly.
class ChukGlass extends StatelessWidget {
  const ChukGlass({
    super.key,
    required this.shape,
    required this.child,
    this.fill = const Color(0x40FFFFFF),
    this.highlight = const Color(0x66FFFFFF),
    this.blurSigma = 26,
    this.shadow,
  });

  /// The clip + border shape (e.g. a `SquircleBorder`).
  final OutlinedBorder shape;

  /// Content laid over the glass.
  final Widget child;

  /// Translucent fill tint over the blur. Keep the alpha low (~0.3–0.45) so the
  /// blurred backdrop stays visible.
  final Color fill;

  /// Bright hairline edge that gives the glass its rim of light.
  final Color highlight;

  /// Gaussian blur radius applied to the backdrop. Higher = frostier.
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
            // Translucent fill + a bright edge highlight on top of the blur.
            decoration: ShapeDecoration(
              color: fill,
              shape: shape.copyWith(
                side: BorderSide(color: highlight, width: 1),
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
