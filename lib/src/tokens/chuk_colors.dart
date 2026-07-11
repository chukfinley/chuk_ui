import 'dart:ui';

import 'package:flutter/foundation.dart';

/// The semantic color palette for a [ChukThemeData].
///
/// The roles and default values mirror the reference design system: a
/// blue-grey dark canvas with a blue accent, layered surfaces, and three text
/// tiers. Components ask for a *role* ([accent], [surfaceRaised], …), never a
/// hue — swap the values in [ChukColors.dark] / [ChukColors.light] to rebrand
/// and every component follows.
@immutable
class ChukColors {
  const ChukColors({
    required this.surfaceBase,
    required this.surfaceRaised,
    required this.surfaceOverlay,
    required this.surfaceInset,
    required this.hairline,
    required this.hairlineStrong,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.accent,
    required this.accentHover,
    required this.accentMuted,
    required this.onAccent,
    required this.focusRing,
    required this.statusPositive,
    required this.statusWarning,
    required this.statusCritical,
    required this.onStatus,
  });

  /// The full-screen background canvas.
  final Color surfaceBase;

  /// Raised chrome (cards, tiles, sheets, filled secondary controls).
  final Color surfaceRaised;

  /// Overlay surfaces (menus, popovers).
  final Color surfaceOverlay;

  /// Inset / recessed surfaces (wells, disabled fills).
  final Color surfaceInset;

  /// Hairline dividers and subtle borders.
  final Color hairline;

  /// A stronger border for outlined controls.
  final Color hairlineStrong;

  /// Primary text and icons.
  final Color textPrimary;

  /// Secondary text (labels, less important content).
  final Color textSecondary;

  /// Tertiary text (hints, disabled text, captions).
  final Color textTertiary;

  /// The brand accent, used for the primary call-to-action and selection.
  final Color accent;

  /// Hovered / brighter accent.
  final Color accentHover;

  /// A muted accent tint for backgrounds behind accent content.
  final Color accentMuted;

  /// Content color that sits on top of [accent].
  final Color onAccent;

  /// Focus-ring color for keyboard focus.
  final Color focusRing;

  /// Positive / success accent.
  final Color statusPositive;

  /// Warning accent.
  final Color statusWarning;

  /// Critical / destructive accent.
  final Color statusCritical;

  /// Content color that sits on top of a filled status color.
  final Color onStatus;

  /// The reference dark palette (blue-grey canvas, blue accent). Default.
  factory ChukColors.dark() => const ChukColors(
        surfaceBase: Color(0xFF121518),
        surfaceRaised: Color(0xFF25292C),
        surfaceOverlay: Color(0xFF1C1F26),
        surfaceInset: Color(0xFF1F2229),
        hairline: Color(0xFF21304A),
        hairlineStrong: Color(0xFF2E3C57),
        textPrimary: Color(0xFFF4F6F8),
        textSecondary: Color(0xFFC8CFD8),
        textTertiary: Color(0xFF8A94A4),
        accent: Color(0xFF60A0E0),
        accentHover: Color(0xFF8FBEEC),
        accentMuted: Color(0xFF16233A),
        onAccent: Color(0xFFFFFFFF),
        focusRing: Color(0xFF60A0E0),
        statusPositive: Color(0xFF03E095),
        statusWarning: Color(0xFFF0A020),
        statusCritical: Color(0xFFE0662F),
        onStatus: Color(0xFFFFFFFF),
      );

  /// The reference light palette — a soft **sage-tinted** light scheme (not
  /// plain white), tuned to read as frosted glass over a gradient.
  factory ChukColors.light() => const ChukColors(
        surfaceBase: Color(0xFFDCE5DE),
        surfaceRaised: Color(0xFFEDF2EE),
        surfaceOverlay: Color(0xFFEDF2EE),
        surfaceInset: Color(0xFFD0DBD3),
        hairline: Color(0xFFC3CFC7),
        hairlineStrong: Color(0xFFAFBCB3),
        textPrimary: Color(0xFF1C241E),
        textSecondary: Color(0xFF4B554E),
        textTertiary: Color(0xFF7B857E),
        accent: Color(0xFF4F7A5C),
        accentHover: Color(0xFF3F6549),
        accentMuted: Color(0xFFDBE8DE),
        onAccent: Color(0xFFFFFFFF),
        focusRing: Color(0xFF4F7A5C),
        statusPositive: Color(0xFF2E9E6B),
        statusWarning: Color(0xFFC98A24),
        statusCritical: Color(0xFFC24E2E),
        onStatus: Color(0xFFFFFFFF),
      );

  /// Returns a copy of this palette with the given fields replaced.
  ChukColors copyWith({
    Color? surfaceBase,
    Color? surfaceRaised,
    Color? surfaceOverlay,
    Color? surfaceInset,
    Color? hairline,
    Color? hairlineStrong,
    Color? textPrimary,
    Color? textSecondary,
    Color? textTertiary,
    Color? accent,
    Color? accentHover,
    Color? accentMuted,
    Color? onAccent,
    Color? focusRing,
    Color? statusPositive,
    Color? statusWarning,
    Color? statusCritical,
    Color? onStatus,
  }) {
    return ChukColors(
      surfaceBase: surfaceBase ?? this.surfaceBase,
      surfaceRaised: surfaceRaised ?? this.surfaceRaised,
      surfaceOverlay: surfaceOverlay ?? this.surfaceOverlay,
      surfaceInset: surfaceInset ?? this.surfaceInset,
      hairline: hairline ?? this.hairline,
      hairlineStrong: hairlineStrong ?? this.hairlineStrong,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
      accent: accent ?? this.accent,
      accentHover: accentHover ?? this.accentHover,
      accentMuted: accentMuted ?? this.accentMuted,
      onAccent: onAccent ?? this.onAccent,
      focusRing: focusRing ?? this.focusRing,
      statusPositive: statusPositive ?? this.statusPositive,
      statusWarning: statusWarning ?? this.statusWarning,
      statusCritical: statusCritical ?? this.statusCritical,
      onStatus: onStatus ?? this.onStatus,
    );
  }

  /// Linearly interpolates between two palettes for animated theme changes.
  static ChukColors lerp(ChukColors a, ChukColors b, double t) {
    return ChukColors(
      surfaceBase: Color.lerp(a.surfaceBase, b.surfaceBase, t)!,
      surfaceRaised: Color.lerp(a.surfaceRaised, b.surfaceRaised, t)!,
      surfaceOverlay: Color.lerp(a.surfaceOverlay, b.surfaceOverlay, t)!,
      surfaceInset: Color.lerp(a.surfaceInset, b.surfaceInset, t)!,
      hairline: Color.lerp(a.hairline, b.hairline, t)!,
      hairlineStrong: Color.lerp(a.hairlineStrong, b.hairlineStrong, t)!,
      textPrimary: Color.lerp(a.textPrimary, b.textPrimary, t)!,
      textSecondary: Color.lerp(a.textSecondary, b.textSecondary, t)!,
      textTertiary: Color.lerp(a.textTertiary, b.textTertiary, t)!,
      accent: Color.lerp(a.accent, b.accent, t)!,
      accentHover: Color.lerp(a.accentHover, b.accentHover, t)!,
      accentMuted: Color.lerp(a.accentMuted, b.accentMuted, t)!,
      onAccent: Color.lerp(a.onAccent, b.onAccent, t)!,
      focusRing: Color.lerp(a.focusRing, b.focusRing, t)!,
      statusPositive: Color.lerp(a.statusPositive, b.statusPositive, t)!,
      statusWarning: Color.lerp(a.statusWarning, b.statusWarning, t)!,
      statusCritical: Color.lerp(a.statusCritical, b.statusCritical, t)!,
      onStatus: Color.lerp(a.onStatus, b.onStatus, t)!,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is ChukColors &&
      other.surfaceBase == surfaceBase &&
      other.surfaceRaised == surfaceRaised &&
      other.surfaceOverlay == surfaceOverlay &&
      other.surfaceInset == surfaceInset &&
      other.hairline == hairline &&
      other.hairlineStrong == hairlineStrong &&
      other.textPrimary == textPrimary &&
      other.textSecondary == textSecondary &&
      other.textTertiary == textTertiary &&
      other.accent == accent &&
      other.accentHover == accentHover &&
      other.accentMuted == accentMuted &&
      other.onAccent == onAccent &&
      other.focusRing == focusRing &&
      other.statusPositive == statusPositive &&
      other.statusWarning == statusWarning &&
      other.statusCritical == statusCritical &&
      other.onStatus == onStatus;

  @override
  int get hashCode => Object.hashAll([
        surfaceBase,
        surfaceRaised,
        surfaceOverlay,
        surfaceInset,
        hairline,
        hairlineStrong,
        textPrimary,
        textSecondary,
        textTertiary,
        accent,
        accentHover,
        accentMuted,
        onAccent,
        focusRing,
        statusPositive,
        statusWarning,
        statusCritical,
        onStatus,
      ]);
}
