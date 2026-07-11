import 'package:flutter/widgets.dart';

import '../../shape/chuk_glass.dart';
import '../../shape/chuk_squircle.dart';
import '../../theme/chuk_theme.dart';

/// A surface container with Apple-style continuously-curved corners.
///
/// Uses [SquircleBorder] so its rounding matches the buttons. Reads its fill,
/// radius and padding from the [ChukThemeData] unless overridden. Optionally
/// tappable.
///
/// ```dart
/// ChukCard(
///   child: Text('Ø Weight  71.6 kg'),
/// )
/// ```
class ChukCard extends StatelessWidget {
  const ChukCard({
    super.key,
    required this.child,
    this.padding,
    this.color,
    this.radius,
    this.smoothing = kAppleCornerSmoothing,
    this.border,
    this.onTap,
    this.width,
    this.shadow,
  });

  /// The card content.
  final Widget child;

  /// Inner padding. Defaults to the theme's large spacing.
  final EdgeInsets? padding;

  /// Fill color. Defaults to the theme's raised surface.
  final Color? color;

  /// Corner radius. Defaults to the theme's medium (card) radius.
  final double? radius;

  /// Apple-style corner smoothing, 0..1.
  final double smoothing;

  /// Optional border.
  final BorderSide? border;

  /// If non-null, the card becomes tappable.
  final VoidCallback? onTap;

  /// Optional fixed width. Defaults to filling the horizontal constraints.
  final double? width;

  /// Optional drop shadow.
  final List<BoxShadow>? shadow;

  @override
  Widget build(BuildContext context) {
    final t = context.chuk;
    final shape = SquircleBorder(
      radius: radius ?? t.radii.md,
      smoothing: smoothing,
      side: border ?? BorderSide.none,
    );

    final content = Padding(
      padding: padding ?? EdgeInsets.all(t.spacing.lg),
      child: child,
    );

    // Light mode = frosted glass; dark mode = solid raised surface.
    Widget card = t.isLight
        ? ChukGlass(
            shape: shape,
            fill: (color ?? t.colors.surfaceRaised).withValues(alpha: 0.42),
            shadow: shadow ??
                const [
                  BoxShadow(
                    color: Color(0x1A000000),
                    blurRadius: 20,
                    offset: Offset(0, 8),
                  ),
                ],
            child: content,
          )
        : DecoratedBox(
            decoration: ShapeDecoration(
              color: color ?? t.colors.surfaceRaised,
              shape: shape,
              shadows: shadow,
            ),
            child: content,
          );

    card = SizedBox(width: width ?? double.infinity, child: card);

    if (onTap != null) {
      card = GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: ClipPath(
          clipper: ShapeBorderClipper(shape: shape),
          child: card,
        ),
      );
    }

    return card;
  }
}
