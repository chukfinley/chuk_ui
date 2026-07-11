import 'package:flutter/widgets.dart';

import 'chuk_theme_data.dart';

/// Provides a [ChukThemeData] to the widget subtree.
///
/// Wrap your app (or any subtree) in a [ChukTheme]. Components look the theme
/// up with `ChukTheme.of(context)` or the `context.chuk` extension. This works
/// inside a `MaterialApp`, a `WidgetsApp`, or standalone — it does not depend
/// on Material.
///
/// It also sets a [DefaultTextStyle] from the theme's body typography, so bare
/// [Text] widgets inherit the correct font and content color.
class ChukTheme extends StatelessWidget {
  const ChukTheme({
    super.key,
    required this.data,
    required this.child,
  });

  /// The design system exposed to descendants.
  final ChukThemeData data;

  /// The subtree that can read this theme.
  final Widget child;

  /// Returns the nearest [ChukThemeData], or throws if there is none.
  ///
  /// Prefer the `context.chuk` extension for brevity.
  static ChukThemeData of(BuildContext context) {
    final inherited =
        context.dependOnInheritedWidgetOfExactType<_ChukInheritedTheme>();
    assert(
      inherited != null,
      'No ChukTheme found in context. Wrap your app in a ChukTheme(data: ...).',
    );
    return inherited!.data;
  }

  /// Returns the nearest [ChukThemeData], or null if there is none.
  static ChukThemeData? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_ChukInheritedTheme>()
        ?.data;
  }

  @override
  Widget build(BuildContext context) {
    return _ChukInheritedTheme(
      data: data,
      child: DefaultTextStyle(
        style: data.typography.body.copyWith(color: data.colors.onSurface),
        child: child,
      ),
    );
  }
}

class _ChukInheritedTheme extends InheritedWidget {
  const _ChukInheritedTheme({
    required this.data,
    required super.child,
  });

  final ChukThemeData data;

  @override
  bool updateShouldNotify(_ChukInheritedTheme oldWidget) =>
      data != oldWidget.data;
}

/// Convenience access to the current [ChukThemeData].
///
/// ```dart
/// final t = context.chuk;
/// color: t.colors.primary,
/// ```
extension ChukThemeContext on BuildContext {
  /// The nearest [ChukThemeData]. Throws if there is no [ChukTheme] ancestor.
  ChukThemeData get chuk => ChukTheme.of(this);
}
