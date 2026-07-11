import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

/// The type scale for a [ChukThemeData].
///
/// These are raw [TextStyle]s with no color — components apply the correct
/// content color from [ChukColors] at build time, so the same style works on
/// any background.
@immutable
class ChukTypography {
  const ChukTypography({
    required this.heading,
    required this.title,
    required this.body,
    required this.label,
    required this.caption,
  });

  /// Large heading — page and section titles.
  final TextStyle heading;

  /// Title — card and dialog headers.
  final TextStyle title;

  /// Body — default running text.
  final TextStyle body;

  /// Label — button and form-control text.
  final TextStyle label;

  /// Caption — helper and secondary text.
  final TextStyle caption;

  /// A default type scale. Pass [fontFamily] to brand it in one line.
  factory ChukTypography.standard({String? fontFamily}) {
    return ChukTypography(
      heading: TextStyle(
        fontFamily: fontFamily,
        fontSize: 28,
        height: 1.2,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
      ),
      title: TextStyle(
        fontFamily: fontFamily,
        fontSize: 18,
        height: 1.3,
        fontWeight: FontWeight.w600,
      ),
      body: TextStyle(
        fontFamily: fontFamily,
        fontSize: 15,
        height: 1.5,
        fontWeight: FontWeight.w400,
      ),
      label: TextStyle(
        fontFamily: fontFamily,
        fontSize: 14,
        height: 1.2,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
      ),
      caption: TextStyle(
        fontFamily: fontFamily,
        fontSize: 12,
        height: 1.4,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  /// Returns a copy with the given styles replaced.
  ChukTypography copyWith({
    TextStyle? heading,
    TextStyle? title,
    TextStyle? body,
    TextStyle? label,
    TextStyle? caption,
  }) {
    return ChukTypography(
      heading: heading ?? this.heading,
      title: title ?? this.title,
      body: body ?? this.body,
      label: label ?? this.label,
      caption: caption ?? this.caption,
    );
  }

  /// Linearly interpolates between two type scales.
  static ChukTypography lerp(ChukTypography a, ChukTypography b, double t) {
    return ChukTypography(
      heading: TextStyle.lerp(a.heading, b.heading, t)!,
      title: TextStyle.lerp(a.title, b.title, t)!,
      body: TextStyle.lerp(a.body, b.body, t)!,
      label: TextStyle.lerp(a.label, b.label, t)!,
      caption: TextStyle.lerp(a.caption, b.caption, t)!,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is ChukTypography &&
      other.heading == heading &&
      other.title == title &&
      other.body == body &&
      other.label == label &&
      other.caption == caption;

  @override
  int get hashCode => Object.hash(heading, title, body, label, caption);
}
