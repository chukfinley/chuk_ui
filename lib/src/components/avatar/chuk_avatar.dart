import 'package:flutter/widgets.dart';

import '../../theme/chuk_theme.dart';

/// A circular avatar: either an [image] clipped to a circle, or uppercase
/// [initials] centred on an accent-tinted fill. Styled from the [ChukThemeData],
/// no Material dependency.
///
/// When an [image] is given it always wins; otherwise the [initials] are shown
/// in [ChukTypography.label] (sized to the avatar) using the theme's `onAccent`
/// content color over [background] (which defaults to the brand `accent`). If
/// neither is supplied the avatar is a plain filled circle.
///
/// The circle carries a subtle hairline ring so image avatars stay defined
/// against any backdrop.
///
/// ```dart
/// ChukAvatar(initials: 'CF')                 // "CF" on accent
/// ChukAvatar(image: NetworkImage(photoUrl))  // circular photo
/// ChukAvatar(initials: 'AB', background: context.chuk.colors.accentMuted)
/// ```
class ChukAvatar extends StatelessWidget {
  const ChukAvatar({
    super.key,
    this.size = 40,
    this.image,
    this.initials,
    this.background,
    this.semanticLabel,
  }) : assert(size > 0);

  /// Diameter of the circle in logical pixels. Defaults to 40.
  final double size;

  /// The image to display, clipped to a circle. Takes precedence over
  /// [initials] when set.
  final ImageProvider? image;

  /// Fallback text shown when there is no [image]. Rendered uppercase.
  final String? initials;

  /// Fill color behind the [initials] (and beneath a transparent image).
  /// Defaults to the theme's `accent` so the `onAccent` text reads clearly.
  final Color? background;

  /// Accessibility label announced by screen readers. Defaults to the
  /// [initials] when null.
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final t = context.chuk;
    final fill = background ?? t.colors.accent;

    Widget content;
    if (image != null) {
      content = Image(
        image: image!,
        width: size,
        height: size,
        fit: BoxFit.cover,
      );
    } else if (initials != null && initials!.trim().isNotEmpty) {
      content = Center(
        child: Text(
          initials!.toUpperCase(),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.clip,
          style: t.typography.label.copyWith(
            // Scale the glyphs to the circle so they read at any size.
            fontSize: size * 0.4,
            color: t.colors.onAccent,
            height: 1,
          ),
        ),
      );
    } else {
      content = const SizedBox.shrink();
    }

    final avatar = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: fill,
        shape: BoxShape.circle,
        border: Border.all(color: t.colors.hairline, width: 1),
      ),
      // Clip the image (and its ripple-free content) to the circle, inset by
      // the ring so the border stays crisp on top.
      child: ClipOval(child: content),
    );

    return Semantics(
      image: image != null,
      label: semanticLabel ?? initials,
      child: avatar,
    );
  }
}
