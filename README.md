# Chuk UI

A standalone, **token-driven** UI component library for Flutter. Build your own
design system — your colors, your spacing, your motion — without inheriting the
Material look. Components work inside a `MaterialApp`, a `WidgetsApp`, or fully
standalone.

> Status: **0.1.0**, early. API may move before 1.0. Consumed via Git dependency
> (see below) until it stabilises on pub.dev.

## Install (Git dependency)

```yaml
dependencies:
  chuk_ui:
    git:
      url: https://github.com/chukfinley/chuk_ui.git
      ref: v0.1.0   # pin to a tag — bump this to update
```

Then `flutter pub get`.

For local development against the package, override with a path:

```yaml
dependency_overrides:
  chuk_ui:
    path: ../chuk_ui
```

## Usage

```dart
import 'package:chuk_ui/chuk_ui.dart';
import 'package:flutter/widgets.dart';

ChukTheme(
  data: ChukThemeData.light(),      // or .dark()
  child: Builder(
    builder: (context) => ChukButton.primary(
      onPressed: () {},
      child: const Text('Save'),
    ),
  ),
);
```

## Rebranding

Everything is driven by tokens. To make it yours, change the values in **one**
place — no component code is touched:

```dart
final theme = ChukThemeData.fromTokens(
  colors: ChukColors.light().copyWith(
    primary: const Color(0xFFFF6B00),
  ),
  radii: const ChukRadii(md: 4),
  typography: ChukTypography.standard(fontFamily: 'Inter'),
);
```

## Components

| Component     | Status |
| ------------- | ------ |
| `ChukButton`  | ✅     |
| `ChukSwitch`  | ✅     |

See [`ROADMAP.md`](ROADMAP.md) for the full planned set.

## License

MIT
