import 'dart:ui' show lerpDouble;

import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

/// The resolved visual styling of a [ChukDropdown]: the field it renders when
/// closed and the overlay menu it pops open.
///
/// Like every Chuk style this is deliberately *flat and value-based* (no
/// `WidgetStateProperty`) so it is trivial to [copyWith], [merge] and [lerp].
/// Any field left null falls back to a sensible token from the theme at build
/// time, so the smallest useful override is a single property.
@immutable
class ChukDropdownStyle {
  const ChukDropdownStyle({
    this.fieldColor,
    this.foreground,
    this.hintColor,
    this.iconColor,
    this.borderColor,
    this.borderWidth,
    this.radius,
    this.smoothing,
    this.fieldPadding,
    this.textStyle,
    this.minHeight,
    this.menuColor,
    this.menuPadding,
    this.itemPadding,
    this.selectedItemColor,
    this.selectedForeground,
    this.itemMinHeight,
    this.maxMenuHeight,
    this.menuGap,
    this.shadow,
  });

  /// Resting fill of the closed field.
  final Color? fieldColor;

  /// Color of the selected item's label shown in the field, and of item labels
  /// in the menu.
  final Color? foreground;

  /// Color of the placeholder shown when no value is selected.
  final Color? hintColor;

  /// Color of the disclosure chevron.
  final Color? iconColor;

  /// Field / menu border color.
  final Color? borderColor;

  /// Field / menu border width in logical pixels.
  final double? borderWidth;

  /// Corner radius of the field and menu.
  final double? radius;

  /// Apple-style corner smoothing, 0..1.
  final double? smoothing;

  /// Inner padding of the closed field.
  final EdgeInsets? fieldPadding;

  /// Text style for the selected value and the menu items.
  final TextStyle? textStyle;

  /// Minimum height of the field. Defaults to 44 for accessibility.
  final double? minHeight;

  /// Fill of the popup menu surface.
  final Color? menuColor;

  /// Padding around the list of items inside the menu.
  final EdgeInsets? menuPadding;

  /// Inner padding of each menu item.
  final EdgeInsets? itemPadding;

  /// Background tint of the currently-selected item in the menu.
  final Color? selectedItemColor;

  /// Label color of the currently-selected item in the menu.
  final Color? selectedForeground;

  /// Minimum height of each menu item. Defaults to 44 for accessibility.
  final double? itemMinHeight;

  /// Maximum height of the menu before its item list scrolls.
  final double? maxMenuHeight;

  /// Vertical gap between the field and the menu when open.
  final double? menuGap;

  /// Drop shadow cast by the open menu.
  final List<BoxShadow>? shadow;

  /// Returns a copy with the given fields replaced.
  ChukDropdownStyle copyWith({
    Color? fieldColor,
    Color? foreground,
    Color? hintColor,
    Color? iconColor,
    Color? borderColor,
    double? borderWidth,
    double? radius,
    double? smoothing,
    EdgeInsets? fieldPadding,
    TextStyle? textStyle,
    double? minHeight,
    Color? menuColor,
    EdgeInsets? menuPadding,
    EdgeInsets? itemPadding,
    Color? selectedItemColor,
    Color? selectedForeground,
    double? itemMinHeight,
    double? maxMenuHeight,
    double? menuGap,
    List<BoxShadow>? shadow,
  }) {
    return ChukDropdownStyle(
      fieldColor: fieldColor ?? this.fieldColor,
      foreground: foreground ?? this.foreground,
      hintColor: hintColor ?? this.hintColor,
      iconColor: iconColor ?? this.iconColor,
      borderColor: borderColor ?? this.borderColor,
      borderWidth: borderWidth ?? this.borderWidth,
      radius: radius ?? this.radius,
      smoothing: smoothing ?? this.smoothing,
      fieldPadding: fieldPadding ?? this.fieldPadding,
      textStyle: textStyle ?? this.textStyle,
      minHeight: minHeight ?? this.minHeight,
      menuColor: menuColor ?? this.menuColor,
      menuPadding: menuPadding ?? this.menuPadding,
      itemPadding: itemPadding ?? this.itemPadding,
      selectedItemColor: selectedItemColor ?? this.selectedItemColor,
      selectedForeground: selectedForeground ?? this.selectedForeground,
      itemMinHeight: itemMinHeight ?? this.itemMinHeight,
      maxMenuHeight: maxMenuHeight ?? this.maxMenuHeight,
      menuGap: menuGap ?? this.menuGap,
      shadow: shadow ?? this.shadow,
    );
  }

  /// Returns a new style where every field set on [other] overrides this one.
  ///
  /// This is the mechanism behind three-layer resolution
  /// (theme default → variant → per-instance override).
  ChukDropdownStyle merge(ChukDropdownStyle? other) {
    if (other == null) return this;
    return copyWith(
      fieldColor: other.fieldColor,
      foreground: other.foreground,
      hintColor: other.hintColor,
      iconColor: other.iconColor,
      borderColor: other.borderColor,
      borderWidth: other.borderWidth,
      radius: other.radius,
      smoothing: other.smoothing,
      fieldPadding: other.fieldPadding,
      textStyle: other.textStyle,
      minHeight: other.minHeight,
      menuColor: other.menuColor,
      menuPadding: other.menuPadding,
      itemPadding: other.itemPadding,
      selectedItemColor: other.selectedItemColor,
      selectedForeground: other.selectedForeground,
      itemMinHeight: other.itemMinHeight,
      maxMenuHeight: other.maxMenuHeight,
      menuGap: other.menuGap,
      shadow: other.shadow,
    );
  }

  /// Linearly interpolates between two dropdown styles.
  static ChukDropdownStyle lerp(
    ChukDropdownStyle a,
    ChukDropdownStyle b,
    double t,
  ) {
    return ChukDropdownStyle(
      fieldColor: Color.lerp(a.fieldColor, b.fieldColor, t),
      foreground: Color.lerp(a.foreground, b.foreground, t),
      hintColor: Color.lerp(a.hintColor, b.hintColor, t),
      iconColor: Color.lerp(a.iconColor, b.iconColor, t),
      borderColor: Color.lerp(a.borderColor, b.borderColor, t),
      borderWidth: lerpDouble(a.borderWidth, b.borderWidth, t),
      radius: lerpDouble(a.radius, b.radius, t),
      smoothing: lerpDouble(a.smoothing, b.smoothing, t),
      fieldPadding: EdgeInsets.lerp(a.fieldPadding, b.fieldPadding, t),
      textStyle: TextStyle.lerp(a.textStyle, b.textStyle, t),
      minHeight: lerpDouble(a.minHeight, b.minHeight, t),
      menuColor: Color.lerp(a.menuColor, b.menuColor, t),
      menuPadding: EdgeInsets.lerp(a.menuPadding, b.menuPadding, t),
      itemPadding: EdgeInsets.lerp(a.itemPadding, b.itemPadding, t),
      selectedItemColor: Color.lerp(
        a.selectedItemColor,
        b.selectedItemColor,
        t,
      ),
      selectedForeground: Color.lerp(
        a.selectedForeground,
        b.selectedForeground,
        t,
      ),
      itemMinHeight: lerpDouble(a.itemMinHeight, b.itemMinHeight, t),
      maxMenuHeight: lerpDouble(a.maxMenuHeight, b.maxMenuHeight, t),
      menuGap: lerpDouble(a.menuGap, b.menuGap, t),
      shadow: BoxShadow.lerpList(a.shadow, b.shadow, t),
    );
  }

  @override
  bool operator ==(Object other) =>
      other is ChukDropdownStyle &&
      other.fieldColor == fieldColor &&
      other.foreground == foreground &&
      other.hintColor == hintColor &&
      other.iconColor == iconColor &&
      other.borderColor == borderColor &&
      other.borderWidth == borderWidth &&
      other.radius == radius &&
      other.smoothing == smoothing &&
      other.fieldPadding == fieldPadding &&
      other.textStyle == textStyle &&
      other.minHeight == minHeight &&
      other.menuColor == menuColor &&
      other.menuPadding == menuPadding &&
      other.itemPadding == itemPadding &&
      other.selectedItemColor == selectedItemColor &&
      other.selectedForeground == selectedForeground &&
      other.itemMinHeight == itemMinHeight &&
      other.maxMenuHeight == maxMenuHeight &&
      other.menuGap == menuGap &&
      listEquals(other.shadow, shadow);

  @override
  int get hashCode => Object.hash(
    fieldColor,
    foreground,
    hintColor,
    iconColor,
    borderColor,
    borderWidth,
    radius,
    smoothing,
    fieldPadding,
    textStyle,
    minHeight,
    menuColor,
    menuPadding,
    itemPadding,
    selectedItemColor,
    selectedForeground,
    itemMinHeight,
    maxMenuHeight,
    menuGap,
    Object.hashAll(shadow ?? const <BoxShadow>[]),
  );
}
