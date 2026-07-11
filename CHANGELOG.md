# Changelog

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
