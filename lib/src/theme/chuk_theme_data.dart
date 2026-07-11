import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import '../components/button/chuk_button_style.dart';
import '../components/nav/chuk_nav_style.dart';
import '../components/segmented/chuk_segmented_style.dart';
import '../components/switch/chuk_switch_style.dart';
import '../tokens/chuk_colors.dart';
import '../tokens/chuk_motion.dart';
import '../tokens/chuk_radii.dart';
import '../tokens/chuk_spacing.dart';
import '../tokens/chuk_typography.dart';

/// The complete design system: raw tokens plus the resolved default styles for
/// every component.
///
/// This is the single source of truth. To rebrand the whole library you change
/// the tokens passed to [ChukThemeData.dark] / [ChukThemeData.light] (or build
/// your own with [ChukThemeData.fromTokens]) — no component code changes.
@immutable
class ChukThemeData {
  const ChukThemeData({
    required this.isLight,
    required this.colors,
    required this.spacing,
    required this.radii,
    required this.typography,
    required this.motion,
    required this.primaryButton,
    required this.secondaryButton,
    required this.ghostButton,
    required this.dangerButton,
    required this.switchStyle,
    required this.segmentedStyle,
    required this.navStyle,
  });

  /// Whether this is a light theme. Controls the sign of translucent overlays
  /// (dark uses white tints, light uses black tints).
  final bool isLight;

  /// Semantic color palette.
  final ChukColors colors;

  /// Spacing scale.
  final ChukSpacing spacing;

  /// Corner-radius scale.
  final ChukRadii radii;

  /// Type scale.
  final ChukTypography typography;

  /// Motion tokens.
  final ChukMotion motion;

  /// Default style for the primary button variant.
  final ChukButtonStyle primaryButton;

  /// Default style for the secondary button variant.
  final ChukButtonStyle secondaryButton;

  /// Default style for the ghost (outlined) button variant.
  final ChukButtonStyle ghostButton;

  /// Default style for the danger button variant.
  final ChukButtonStyle dangerButton;

  /// Default style for the switch.
  final ChukSwitchStyle switchStyle;

  /// Default style for the segmented control.
  final ChukSegmentedStyle segmentedStyle;

  /// Default style for the bottom navigation bar.
  final ChukNavStyle navStyle;

  /// Builds a full theme from a set of tokens, deriving every component's
  /// default style. This is the single place where a token becomes a look.
  factory ChukThemeData.fromTokens({
    required ChukColors colors,
    required bool isLight,
    ChukSpacing spacing = const ChukSpacing(),
    ChukRadii radii = const ChukRadii(),
    ChukTypography? typography,
    ChukMotion motion = const ChukMotion(),
    ChukButtonStyle? primaryButton,
    ChukButtonStyle? secondaryButton,
    ChukButtonStyle? ghostButton,
    ChukButtonStyle? dangerButton,
    ChukSwitchStyle? switchStyle,
    ChukSegmentedStyle? segmentedStyle,
    ChukNavStyle? navStyle,
  }) {
    final type = typography ?? ChukTypography.standard();
    final buttonPadding = EdgeInsets.symmetric(
      horizontal: spacing.lg,
      vertical: spacing.sm,
    );

    // Translucent overlays: white tints on dark, black tints on light.
    final pressedOverlay =
        isLight ? const Color(0x14000000) : const Color(0x1FFFFFFF);
    final hoverOverlay =
        isLight ? const Color(0x0A000000) : const Color(0x14FFFFFF);

    ChukButtonStyle base() => ChukButtonStyle(
          radius: radii.md,
          padding: buttonPadding,
          textStyle: type.label,
          minHeight: 44,
          borderWidth: 0,
        );

    return ChukThemeData(
      isLight: isLight,
      colors: colors,
      spacing: spacing,
      radii: radii,
      typography: type,
      motion: motion,
      primaryButton: base().merge(
        primaryButton ??
            ChukButtonStyle(
              background: colors.accent,
              foreground: colors.onAccent,
              pressedOverlay: pressedOverlay,
              hoverOverlay: hoverOverlay,
              disabledBackground: colors.surfaceInset,
              disabledForeground: colors.textTertiary,
            ),
      ),
      secondaryButton: base().merge(
        secondaryButton ??
            ChukButtonStyle(
              background: colors.surfaceRaised,
              foreground: colors.textPrimary,
              pressedOverlay: pressedOverlay,
              hoverOverlay: hoverOverlay,
              disabledBackground: colors.surfaceInset,
              disabledForeground: colors.textTertiary,
            ),
      ),
      ghostButton: base().merge(
        ghostButton ??
            ChukButtonStyle(
              background: const Color(0x00000000),
              foreground: colors.accent,
              borderColor: colors.hairlineStrong,
              borderWidth: 1,
              pressedOverlay: pressedOverlay,
              hoverOverlay: hoverOverlay,
              disabledForeground: colors.textTertiary,
            ),
      ),
      dangerButton: base().merge(
        dangerButton ??
            ChukButtonStyle(
              background: colors.statusCritical,
              foreground: colors.onStatus,
              pressedOverlay: pressedOverlay,
              hoverOverlay: hoverOverlay,
              disabledBackground: colors.surfaceInset,
              disabledForeground: colors.textTertiary,
            ),
      ),
      switchStyle: (switchStyle ?? const ChukSwitchStyle()).merge(
        ChukSwitchStyle(
          trackColor: colors.surfaceRaised.withValues(alpha: 0.9),
          borderColor: colors.hairlineStrong.withValues(alpha: 0.5),
          // Full accent so the "on" knob matches the primary button exactly
          // (the old 0.60 alpha made it look washed-out / dark).
          knobOnColor: colors.accent,
          knobOffColor:
              isLight ? const Color(0x1A000000) : const Color(0x24FFFFFF),
          width: 58,
          height: 30,
          padding: 3,
          radius: radii.pill,
          disabledOpacity: 0.45,
          shadow: const [
            BoxShadow(
              color: Color(0x57000000),
              blurRadius: 14,
              offset: Offset(0, 5),
            ),
          ],
        ),
      ),
      segmentedStyle: (segmentedStyle ?? const ChukSegmentedStyle()).merge(
        ChukSegmentedStyle(
          trackColor: colors.surfaceInset,
          highlightColor:
              isLight ? const Color(0x0F000000) : const Color(0x24FFFFFF),
          activeColor: colors.textPrimary,
          inactiveColor: colors.textSecondary,
          height: 32,
          radius: radii.pill,
          padding: 3,
        ),
      ),
      navStyle: (navStyle ?? const ChukNavStyle()).merge(
        ChukNavStyle(
          // Translucent chrome fill (like the reference `_barFill`) so the
          // scenic background genuinely shows through the floating pill.
          trackColor: colors.fillRaised,
          // Stronger highlight + more legible inactive tabs so every
          // destination reads, not just the selected one.
          highlightColor:
              isLight ? const Color(0x1F000000) : const Color(0x33FFFFFF),
          activeColor: colors.textPrimary,
          inactiveColor: colors.textSecondary,
          height: 64,
          collapsedHeight: 52,
          radius: radii.pill,
          iconSize: 22,
          shadow: [
            BoxShadow(
              color: Color(isLight ? 0x1A000000 : 0x57000000),
              blurRadius: 28,
              offset: const Offset(0, 10),
            ),
          ],
        ),
      ),
    );
  }

  /// The default dark theme (blue-grey canvas, blue accent). Swap tokens to
  /// rebrand.
  factory ChukThemeData.dark() =>
      ChukThemeData.fromTokens(colors: ChukColors.dark(), isLight: false);

  /// The default light theme. Swap tokens to rebrand.
  factory ChukThemeData.light() =>
      ChukThemeData.fromTokens(colors: ChukColors.light(), isLight: true);

  /// Returns a copy with the given fields replaced.
  ChukThemeData copyWith({
    bool? isLight,
    ChukColors? colors,
    ChukSpacing? spacing,
    ChukRadii? radii,
    ChukTypography? typography,
    ChukMotion? motion,
    ChukButtonStyle? primaryButton,
    ChukButtonStyle? secondaryButton,
    ChukButtonStyle? ghostButton,
    ChukButtonStyle? dangerButton,
    ChukSwitchStyle? switchStyle,
    ChukSegmentedStyle? segmentedStyle,
    ChukNavStyle? navStyle,
  }) {
    return ChukThemeData(
      isLight: isLight ?? this.isLight,
      colors: colors ?? this.colors,
      spacing: spacing ?? this.spacing,
      radii: radii ?? this.radii,
      typography: typography ?? this.typography,
      motion: motion ?? this.motion,
      primaryButton: primaryButton ?? this.primaryButton,
      secondaryButton: secondaryButton ?? this.secondaryButton,
      ghostButton: ghostButton ?? this.ghostButton,
      dangerButton: dangerButton ?? this.dangerButton,
      switchStyle: switchStyle ?? this.switchStyle,
      segmentedStyle: segmentedStyle ?? this.segmentedStyle,
      navStyle: navStyle ?? this.navStyle,
    );
  }

  /// Linearly interpolates between two themes, enabling animated theme
  /// switches (e.g. light ↔ dark).
  static ChukThemeData lerp(ChukThemeData a, ChukThemeData b, double t) {
    return ChukThemeData(
      isLight: t < 0.5 ? a.isLight : b.isLight,
      colors: ChukColors.lerp(a.colors, b.colors, t),
      spacing: ChukSpacing.lerp(a.spacing, b.spacing, t),
      radii: ChukRadii.lerp(a.radii, b.radii, t),
      typography: ChukTypography.lerp(a.typography, b.typography, t),
      // Motion (durations/curves) is not meaningfully interpolatable; snap.
      motion: t < 0.5 ? a.motion : b.motion,
      primaryButton: ChukButtonStyle.lerp(a.primaryButton, b.primaryButton, t),
      secondaryButton:
          ChukButtonStyle.lerp(a.secondaryButton, b.secondaryButton, t),
      ghostButton: ChukButtonStyle.lerp(a.ghostButton, b.ghostButton, t),
      dangerButton: ChukButtonStyle.lerp(a.dangerButton, b.dangerButton, t),
      switchStyle: ChukSwitchStyle.lerp(a.switchStyle, b.switchStyle, t),
      segmentedStyle:
          ChukSegmentedStyle.lerp(a.segmentedStyle, b.segmentedStyle, t),
      navStyle: ChukNavStyle.lerp(a.navStyle, b.navStyle, t),
    );
  }

  @override
  bool operator ==(Object other) =>
      other is ChukThemeData &&
      other.isLight == isLight &&
      other.colors == colors &&
      other.spacing == spacing &&
      other.radii == radii &&
      other.typography == typography &&
      other.motion == motion &&
      other.primaryButton == primaryButton &&
      other.secondaryButton == secondaryButton &&
      other.ghostButton == ghostButton &&
      other.dangerButton == dangerButton &&
      other.switchStyle == switchStyle &&
      other.segmentedStyle == segmentedStyle &&
      other.navStyle == navStyle;

  @override
  int get hashCode => Object.hash(
        isLight,
        colors,
        spacing,
        radii,
        typography,
        motion,
        primaryButton,
        secondaryButton,
        ghostButton,
        dangerButton,
        switchStyle,
        segmentedStyle,
        navStyle,
      );
}
