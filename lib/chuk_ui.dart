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
export 'src/components/segmented/chuk_segmented.dart';
export 'src/components/segmented/chuk_segmented_style.dart';
export 'src/components/spinner/chuk_spinner.dart';
export 'src/components/nav/chuk_nav_bar.dart';
export 'src/components/nav/chuk_nav_style.dart';
export 'src/components/card/chuk_card.dart';
export 'src/components/search/chuk_search_bar.dart';
export 'src/components/color_picker/chuk_color_picker.dart';
export 'src/components/textfield/chuk_text_field.dart';
export 'src/components/textfield/chuk_text_field_style.dart';
export 'src/components/dropdown/chuk_dropdown.dart';
export 'src/components/dropdown/chuk_dropdown_style.dart';
export 'src/components/slider/chuk_slider.dart';
export 'src/components/slider/chuk_slider_style.dart';
export 'src/components/checkbox/chuk_checkbox.dart';
export 'src/components/checkbox/chuk_checkbox_style.dart';
export 'src/components/radio/chuk_radio.dart';
export 'src/components/radio/chuk_radio_style.dart';
export 'src/components/chip/chuk_chip.dart';
export 'src/components/stepper/chuk_stepper.dart';
export 'src/components/stepper/chuk_stepper_style.dart';
export 'src/components/tabs/chuk_tabs.dart';
export 'src/components/tabs/chuk_tabs_style.dart';
export 'src/components/list_tile/chuk_list_tile.dart';
export 'src/components/progress/chuk_progress_bar.dart';
export 'src/components/badge/chuk_badge.dart';
export 'src/components/avatar/chuk_avatar.dart';

// Shape
export 'src/shape/chuk_squircle.dart';
export 'src/shape/chuk_glass.dart';
