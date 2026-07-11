/// Chuk UI — a standalone, token-driven Flutter component library.
///
/// Import everything from this one file:
///
/// ```dart
/// import 'package:chuk_ui/chuk_ui.dart';
/// ```
///
/// Wrap your app in a [ChukTheme], then use components like [ChukButton] and
/// [ChukSwitch]. The library does not depend on Material — it works inside a
/// `MaterialApp`, a `WidgetsApp`, or fully standalone.
library;

// Tokens
export 'src/tokens/chuk_colors.dart';
export 'src/tokens/chuk_spacing.dart';
export 'src/tokens/chuk_radii.dart';
export 'src/tokens/chuk_typography.dart';
export 'src/tokens/chuk_motion.dart';

// Theme
export 'src/theme/chuk_theme_data.dart';
export 'src/theme/chuk_theme.dart';

// Components
export 'src/components/button/chuk_button.dart';
export 'src/components/button/chuk_button_style.dart';
export 'src/components/switch/chuk_switch.dart';
export 'src/components/switch/chuk_switch_style.dart';
