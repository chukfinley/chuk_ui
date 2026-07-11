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

  /// Fill color. Defaults to the theme's translucent chrome fill
  /// ([ChukColors.fillRaised]) so the background shows through.
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

    // A frosted-glass surface: the background behind is blurred, then the
    // chrome-translucent [ChukColors.fillRaised] tint + a bright rim are laid
    // over it. The blur is what makes it read as glass (not a flat film) and
    // keeps content legible over a busy background.
    final fill = color ?? t.colors.fillRaised;
    final glassShadow = shadow ??
        const [
          BoxShadow(color: Color(0x22000000), blurRadius: 20, offset: Offset(0, 8)),
        ];
    Widget card = ChukGlass(
      shape: shape,
      fill: fill,
      highlight: Color.fromRGBO(255, 255, 255, t.isLight ? 0.50 : 0.10),
      blurSigma: 32,
      shadow: glassShadow,
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
