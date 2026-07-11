import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import '../components/button/chuk_button_style.dart';
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
/// the tokens passed to [ChukThemeData.light] / [ChukThemeData.dark] (or build
/// your own) — no component code changes.
@immutable
class ChukThemeData {
  const ChukThemeData({
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
  });

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

  /// Default style for the ghost (transparent) button variant.
  final ChukButtonStyle ghostButton;

  /// Default style for the danger button variant.
  final ChukButtonStyle dangerButton;

  /// Default style for the switch.
  final ChukSwitchStyle switchStyle;

  /// Builds a full theme from a set of tokens, deriving every component's
  /// default style from those tokens.
  ///
  /// This is where tokens turn into component styling. If you want to change
  /// *how* a variant looks (not just the palette), override the relevant
  /// `*Button` argument.
  factory ChukThemeData.fromTokens({
    required ChukColors colors,
    ChukSpacing spacing = const ChukSpacing(),
    ChukRadii radii = const ChukRadii(),
    ChukTypography? typography,
    ChukMotion motion = const ChukMotion(),
    ChukButtonStyle? primaryButton,
    ChukButtonStyle? secondaryButton,
    ChukButtonStyle? ghostButton,
    ChukButtonStyle? dangerButton,
    ChukSwitchStyle? switchStyle,
  }) {
    final type = typography ?? ChukTypography.standard();
    final buttonPadding = EdgeInsets.symmetric(
      horizontal: spacing.lg,
      vertical: spacing.sm,
    );

    ChukButtonStyle base() => ChukButtonStyle(
          radius: radii.md,
          padding: buttonPadding,
          textStyle: type.label,
          minHeight: 44,
          borderWidth: 0,
        );

    return ChukThemeData(
      colors: colors,
      spacing: spacing,
      radii: radii,
      typography: type,
      motion: motion,
      primaryButton: base().merge(
        primaryButton ??
            ChukButtonStyle(
              background: colors.primary,
              foreground: colors.onPrimary,
              pressedOverlay: const Color(0x22000000),
              hoverOverlay: const Color(0x14FFFFFF),
              disabledBackground: colors.disabled,
              disabledForeground: colors.onDisabled,
            ),
      ),
      secondaryButton: base().merge(
        secondaryButton ??
            ChukButtonStyle(
              background: colors.surfaceMuted,
              foreground: colors.onSurface,
              pressedOverlay: const Color(0x14000000),
              hoverOverlay: const Color(0x0A000000),
              disabledBackground: colors.disabled,
              disabledForeground: colors.onDisabled,
            ),
      ),
      ghostButton: base().merge(
        ghostButton ??
            ChukButtonStyle(
              background: const Color(0x00000000),
              foreground: colors.primary,
              borderColor: colors.border,
              borderWidth: 1,
              pressedOverlay: const Color(0x14000000),
              hoverOverlay: const Color(0x0A000000),
              disabledForeground: colors.onDisabled,
            ),
      ),
      dangerButton: base().merge(
        dangerButton ??
            ChukButtonStyle(
              background: colors.danger,
              foreground: colors.onDanger,
              pressedOverlay: const Color(0x22000000),
              hoverOverlay: const Color(0x14FFFFFF),
              disabledBackground: colors.disabled,
              disabledForeground: colors.onDisabled,
            ),
      ),
      switchStyle: (switchStyle ?? const ChukSwitchStyle()).merge(
        ChukSwitchStyle(
          trackOnColor: colors.primary,
          trackOffColor: colors.border,
          thumbColor: colors.surface,
          trackWidth: 46,
          trackHeight: 28,
          thumbSize: 22,
          padding: 3,
          disabledOpacity: 0.4,
        ),
      ),
    );
  }

  /// The default light theme. Swap the tokens to rebrand.
  factory ChukThemeData.light() =>
      ChukThemeData.fromTokens(colors: ChukColors.light());

  /// The default dark theme. Swap the tokens to rebrand.
  factory ChukThemeData.dark() =>
      ChukThemeData.fromTokens(colors: ChukColors.dark());

  /// Returns a copy with the given fields replaced.
  ChukThemeData copyWith({
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
  }) {
    return ChukThemeData(
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
    );
  }

  /// Linearly interpolates between two themes, enabling animated theme
  /// switches (e.g. light ↔ dark).
  static ChukThemeData lerp(ChukThemeData a, ChukThemeData b, double t) {
    return ChukThemeData(
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
    );
  }

  @override
  bool operator ==(Object other) =>
      other is ChukThemeData &&
      other.colors == colors &&
      other.spacing == spacing &&
      other.radii == radii &&
      other.typography == typography &&
      other.motion == motion &&
      other.primaryButton == primaryButton &&
      other.secondaryButton == secondaryButton &&
      other.ghostButton == ghostButton &&
      other.dangerButton == dangerButton &&
      other.switchStyle == switchStyle;

  @override
  int get hashCode => Object.hash(
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
      );
}
