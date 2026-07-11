# Chuk UI — Build Rules

A standalone, token-driven Flutter component library published as a **Git
dependency** (later pub.dev). These rules keep it consistent and keep the path
to pub.dev open. Follow them for every new component.

## Focus & experimental status

**Dark mode is the supported, primary theme — focus all polish there.** The
**light mode + frosted glass** (`ChukGlass`, `ChukColors.surfaceOpacity` /
`fillRaised`, the sage light palette, the example's image backdrop) is
**EXPERIMENTAL** (marked `@experimental`) and may change or be replaced by a
real shader-based "liquid glass" (see `flutter_shaders`; reference:
github.com/sdegenaar/liquid_glass_widgets). Do not treat the glass look as
stable. Nav/card/search use `ChukGlass` only as the current experimental take.

## Non-negotiables

1. **No Material.** Import `package:flutter/widgets.dart`, never
   `package:flutter/material.dart`. No `Theme.of(context)`, no `Material`,
   `Scaffold`, `InkWell`, `MaterialState*`. Use `widgets`-layer primitives:
   `GestureDetector`, `FocusableActionDetector`, `AnimatedContainer`,
   `Semantics`, `DefaultTextStyle`. (`WidgetState`/`WidgetStateProperty` are
   allowed — they live in the widgets layer.)
2. **Zero runtime dependencies.** Only `flutter` (sdk). Every dependency is an
   update risk for consumers *and* blocks pub.dev if it's a Git dep. Build small
   things (icons, animations) yourself or keep them optional.
3. **Tokens before components.** No hardcoded hex, no magic numbers in a widget.
   A component reads colors/spacing/radii/typography/motion from
   `context.chuk`. If a value isn't a token yet, add it to a token class first.
4. **Everything public is forever.** Only what `lib/chuk_ui.dart` exports is
   API. Everything under `lib/src/` is private and can change freely. Add a new
   component's exports to the barrel.

## Token classes (`lib/src/tokens/`)

Each token class is an `@immutable` value type and MUST have:
`const` constructor · `copyWith` · static `lerp` · `operator ==` · `hashCode`.
`lerp` is what makes animated theme switches (light ↔ dark) work — don't skip
it. Colors lerp with `Color.lerp`, doubles with `lerpDouble`, text with
`TextStyle.lerp`. Motion (durations/curves) can't interpolate — snap at t<0.5.

## Theme (`lib/src/theme/`)

- `ChukThemeData` bundles tokens **and** the resolved default style per
  component variant. `fromTokens(...)` is where tokens become component styles —
  that's the single place a value turns into a look.
- `ChukTheme` is the `InheritedWidget`. Access via `context.chuk`. It also sets
  `DefaultTextStyle` so bare `Text` inherits font + `onSurface` color.

## Component rules (`lib/src/components/<name>/`)

Every component is a folder with two files:
`<name>.dart` (the widget) and `<name>_style.dart` (its style value class).

- **Style value class**: flat, value-based (no `WidgetStateProperty` fields —
  keeps `merge`/`lerp` trivial). Must have `copyWith`, `merge` (every set field
  on `other` wins), `lerp`, `==`, `hashCode`. Per-state variation via optional
  `pressed*` / `disabled*` fields that fall back to the base value.
- **Three-layer style resolution**, always in this order:
  `theme default for variant` → `.merge(widget.style)` → per-interaction state
  (hover / pressed / focused / disabled).
- **Variants are enums with named constructors.** `ChukButton.primary(...)`,
  not `ChukButton(variant: 'primary')`. `onPressed: null` == disabled, exactly
  like Material — keep that contract.
- **`const` constructors** wherever possible. Consumers expect it.
- **Accessibility is not optional.** Wrap in `Semantics` (`button: true`,
  `enabled:`, `toggled:` as appropriate), support keyboard activation via
  `FocusableActionDetector` + `ActivateIntent`, min tap target 44px, show a
  focus ring. Material did this for you; here you do it.
- **Animate from motion tokens.** `AnimatedContainer(duration: t.motion.fast)`
  — never a hardcoded `Duration`.

## Design source

Real designs (nav bar, settings layout, toggle look+animation, segmented
control) are cloned from the reference app at `~/git/noop/flutter_app`
(`lib/core/theme/` for tokens, `lib/features/**` for widgets). When porting:
extract the *values* into tokens and the *behavior* into a widget — do not copy
Material widgets over. The dark-mode toggle and the Tag/Woche/Monat segmented
control animation in that app are the approved targets.

## Testing

- Every component gets a widget test (interaction + disabled + semantics).
- Add golden tests (`matchesGoldenFile`) per variant once the look is locked —
  a golden is the only real guard against a token change silently breaking a
  component in one theme.
- CI must pass `flutter analyze` (zero issues) and `flutter test`.

## Release / versioning

Semver via Git tags. To ship an update:

1. Bump `version:` in `pubspec.yaml`.
2. Add a `CHANGELOG.md` entry matching that version.
3. `git commit`, then `git tag vX.Y.Z && git push --tags`.

Consumers bump their `ref: vX.Y.Z`. Under 1.0.0, minor versions may break;
after 1.0.0 they may not. Keep the package dependency-free so the eventual
`dart pub publish` is a no-code-change step.
