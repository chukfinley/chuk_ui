import 'dart:ui';

import 'package:flutter/foundation.dart';

/// The semantic color palette for a [ChukThemeData].
///
/// Colors are named by *role*, not by hue — a component asks for
/// [primary] or [surface], never for "blue". Swap the values in
/// [ChukColors.light] / [ChukColors.dark] (or your own factory) and every
/// component follows automatically.
@immutable
class ChukColors {
  const ChukColors({
    required this.primary,
    required this.onPrimary,
    required this.secondary,
    required this.onSecondary,
    required this.surface,
    required this.onSurface,
    required this.surfaceMuted,
    required this.border,
    required this.danger,
    required this.onDanger,
    required this.disabled,
    required this.onDisabled,
    required this.focus,
  });

  /// Primary brand color, used for the main call-to-action.
  final Color primary;

  /// Content color that sits on top of [primary].
  final Color onPrimary;

  /// Secondary / less prominent accent.
  final Color secondary;

  /// Content color that sits on top of [secondary].
  final Color onSecondary;

  /// Default background of surfaces (cards, sheets, app background).
  final Color surface;

  /// Default content color on [surface].
  final Color onSurface;

  /// A slightly offset surface for hover states and subtle fills.
  final Color surfaceMuted;

  /// Hairline / outline color for borders and dividers.
  final Color border;

  /// Destructive / error accent.
  final Color danger;

  /// Content color that sits on top of [danger].
  final Color onDanger;

  /// Fill color for disabled controls.
  final Color disabled;

  /// Content color on top of [disabled].
  final Color onDisabled;

  /// Focus-ring color for keyboard focus.
  final Color focus;

  /// A sensible light palette. Override any value with [copyWith].
  factory ChukColors.light() => const ChukColors(
        primary: Color(0xFF4F46E5),
        onPrimary: Color(0xFFFFFFFF),
        secondary: Color(0xFF64748B),
        onSecondary: Color(0xFFFFFFFF),
        surface: Color(0xFFFFFFFF),
        onSurface: Color(0xFF0F172A),
        surfaceMuted: Color(0xFFF1F5F9),
        border: Color(0xFFE2E8F0),
        danger: Color(0xFFDC2626),
        onDanger: Color(0xFFFFFFFF),
        disabled: Color(0xFFE2E8F0),
        onDisabled: Color(0xFF94A3B8),
        focus: Color(0xFF6366F1),
      );

  /// A sensible dark palette. Override any value with [copyWith].
  factory ChukColors.dark() => const ChukColors(
        primary: Color(0xFF818CF8),
        onPrimary: Color(0xFF0F172A),
        secondary: Color(0xFF94A3B8),
        onSecondary: Color(0xFF0F172A),
        surface: Color(0xFF0F172A),
        onSurface: Color(0xFFF1F5F9),
        surfaceMuted: Color(0xFF1E293B),
        border: Color(0xFF334155),
        danger: Color(0xFFF87171),
        onDanger: Color(0xFF0F172A),
        disabled: Color(0xFF334155),
        onDisabled: Color(0xFF64748B),
        focus: Color(0xFF818CF8),
      );

  /// Returns a copy of this palette with the given fields replaced.
  ChukColors copyWith({
    Color? primary,
    Color? onPrimary,
    Color? secondary,
    Color? onSecondary,
    Color? surface,
    Color? onSurface,
    Color? surfaceMuted,
    Color? border,
    Color? danger,
    Color? onDanger,
    Color? disabled,
    Color? onDisabled,
    Color? focus,
  }) {
    return ChukColors(
      primary: primary ?? this.primary,
      onPrimary: onPrimary ?? this.onPrimary,
      secondary: secondary ?? this.secondary,
      onSecondary: onSecondary ?? this.onSecondary,
      surface: surface ?? this.surface,
      onSurface: onSurface ?? this.onSurface,
      surfaceMuted: surfaceMuted ?? this.surfaceMuted,
      border: border ?? this.border,
      danger: danger ?? this.danger,
      onDanger: onDanger ?? this.onDanger,
      disabled: disabled ?? this.disabled,
      onDisabled: onDisabled ?? this.onDisabled,
      focus: focus ?? this.focus,
    );
  }

  /// Linearly interpolates between two palettes for animated theme changes.
  static ChukColors lerp(ChukColors a, ChukColors b, double t) {
    return ChukColors(
      primary: Color.lerp(a.primary, b.primary, t)!,
      onPrimary: Color.lerp(a.onPrimary, b.onPrimary, t)!,
      secondary: Color.lerp(a.secondary, b.secondary, t)!,
      onSecondary: Color.lerp(a.onSecondary, b.onSecondary, t)!,
      surface: Color.lerp(a.surface, b.surface, t)!,
      onSurface: Color.lerp(a.onSurface, b.onSurface, t)!,
      surfaceMuted: Color.lerp(a.surfaceMuted, b.surfaceMuted, t)!,
      border: Color.lerp(a.border, b.border, t)!,
      danger: Color.lerp(a.danger, b.danger, t)!,
      onDanger: Color.lerp(a.onDanger, b.onDanger, t)!,
      disabled: Color.lerp(a.disabled, b.disabled, t)!,
      onDisabled: Color.lerp(a.onDisabled, b.onDisabled, t)!,
      focus: Color.lerp(a.focus, b.focus, t)!,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is ChukColors &&
      other.primary == primary &&
      other.onPrimary == onPrimary &&
      other.secondary == secondary &&
      other.onSecondary == onSecondary &&
      other.surface == surface &&
      other.onSurface == onSurface &&
      other.surfaceMuted == surfaceMuted &&
      other.border == border &&
      other.danger == danger &&
      other.onDanger == onDanger &&
      other.disabled == disabled &&
      other.onDisabled == onDisabled &&
      other.focus == focus;

  @override
  int get hashCode => Object.hash(
        primary,
        onPrimary,
        secondary,
        onSecondary,
        surface,
        onSurface,
        surfaceMuted,
        border,
        danger,
        onDanger,
        disabled,
        onDisabled,
        focus,
      );
}
