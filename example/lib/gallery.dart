import 'package:flutter/widgets.dart';

import 'gallery/avatar_demo.dart';
import 'gallery/badge_demo.dart';
import 'gallery/checkbox_demo.dart';
import 'gallery/chip_demo.dart';
import 'gallery/dropdown_demo.dart';
import 'gallery/list_tile_demo.dart';
import 'gallery/progress_bar_demo.dart';
import 'gallery/radio_demo.dart';
import 'gallery/slider_demo.dart';
import 'gallery/stepper_demo.dart';
import 'gallery/tabs_demo.dart';
import 'gallery/text_field_demo.dart';

/// (title, demo widget) for every component built by the fan-out.
List<(String, Widget)> galleryEntries() => [
      ('Text Field', const TextFieldDemo()),
      ('Dropdown', const DropdownDemo()),
      ('Slider', const SliderDemo()),
      ('Checkbox', const CheckboxDemo()),
      ('Radio', const RadioDemo()),
      ('Chip', const ChipDemo()),
      ('Stepper', const StepperDemo()),
      ('Tabs', const TabsDemo()),
      ('List Tile', const ListTileDemo()),
      ('Progress', const ProgressBarDemo()),
      ('Badge', const BadgeDemo()),
      ('Avatar', const AvatarDemo()),
    ];
