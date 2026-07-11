# Changelog

## 0.3.1

- **`ChukSwitch`** now springs: the knob is driven by a `SpringSimulation`
  (small overshoot, clipped cleanly) instead of a linear slide.
- Example palette gains muted favourites (Sage, Olive, Steel, Taupe); Sage
  `#607C64` is the default.

## 0.3.0

- **`ChukSearchBar`** (new): floating search bar styled like `ChukNavBar`
  (translucent raised fill, squircle pill, lift shadow). Material-free input
  via `EditableText`, with a drawn search glyph — no icon font needed.
- **`ChukColorPicker`** (new): draggable HSV picker — a saturation/value field
  you swipe plus a hue slider, reporting the live color.
- **`ChukCard`** (new): squircle surface container matching the buttons.
- Example: Colors tab now has the picker, a hex readout with copy-to-clipboard,
  and a live component preview (button / ghost / switch / spinner) in the
  chosen color; the whole accent follows the picked color.

## 0.2.0

Adopt the real reference design system (from `~/git/noop/flutter_app`).

- **Colors**: `ChukColors` rebuilt on the reference token roles (layered
  surfaces, three text tiers, accent, status). Real dark + light palettes.
  **Dark is now the default.**
- **Radii**: pill = 50, card = 14, etc. **Typography**: 28/22/15/12 scale.
- **`ChukSwitch`**: rebuilt to the reference toggle — translucent pill track
  with a half-width knob that glides (340 ms), accent-tinted when on.
- **`ChukSegmented`** (new): pill track with one gliding highlight (260 ms),
  hug or expand layout — the Tag/Woche/Monat range selector.
- **`ChukSpinner`** (new): the morph-blob loading indicator, now the default.
- **`ChukNavBar`** (new): floating bottom nav pill with a gliding highlight
  (icon + label, collapsible), ported from the reference app.
- **`SquircleBorder`** (new): Apple-style continuous corner smoothing. Buttons
  now use it (smooth stadium/pill shape) via a `smoothing` style field.
- **Buttons** are now pill/stadium shaped; primary uses a mint accent
  (placeholder until the final main color is chosen).
- Example app is now an interactive multi-tab demo (counter, load spinner,
  live range value, settings toggles, and a 20-swatch live color picker).
- `ChukThemeData` gained `isLight`, `segmentedStyle` and `navStyle`.

## 0.1.0

Initial release — the token foundation and first two components.

- **Tokens**: `ChukColors`, `ChukSpacing`, `ChukRadii`, `ChukTypography`,
  `ChukMotion`, each with `copyWith` and `lerp`.
- **Theme**: `ChukThemeData` (light/dark factories, `fromTokens`, `lerp`) and
  the `ChukTheme` provider with the `context.chuk` extension. No Material
  dependency.
- **Components**: `ChukButton` (primary / secondary / ghost / danger variants,
  three-layer style resolution, hover / press / focus / disabled states,
  `Semantics`) and `ChukSwitch` (animated track + thumb).
