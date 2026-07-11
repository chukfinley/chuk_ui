# Chuk UI — Roadmap

The full component set for a "complete" library, grouped by layer. We implement
these piece by piece. `[x]` done · `[~]` in progress · `[ ]` planned.

Priority order for the near term is driven by the reference app
(`~/git/noop/flutter_app`): **navigation → settings rows → segmented control**
next, because those designs already exist and are approved.

## Foundation (tokens & theme)

- [x] Color tokens (`ChukColors`)
- [x] Spacing tokens (`ChukSpacing`)
- [x] Radii tokens (`ChukRadii`)
- [x] Typography tokens (`ChukTypography`)
- [x] Motion tokens (`ChukMotion`)
- [x] Theme data + provider (`ChukThemeData`, `ChukTheme`, `context.chuk`)
- [ ] Elevation / shadow tokens
- [ ] Icon set strategy (bundled monochrome vector icons, no Material Icons)
- [ ] Breakpoint tokens (responsive: mobile / tablet / desktop)
- [ ] Reduced-motion support (respect `MediaQuery.disableAnimations`)
- [ ] Optional `ChukApp` (WidgetsApp wrapper: theme + routing-ready host)

## Atoms — controls

- [x] Button (primary / secondary / ghost / danger)
- [x] Switch / Toggle
- [ ] Icon button
- [ ] Checkbox
- [ ] Radio / radio group
- [ ] Slider
- [ ] Segmented control  ← **next** (Tag/Woche/Monat animation from noop)
- [ ] Chip / tag (selectable, removable)
- [ ] Badge / counter
- [ ] Avatar
- [ ] Spinner / progress indicator (circular + linear)
- [ ] Skeleton / shimmer loader
- [ ] Divider
- [ ] Tooltip

## Atoms — text & input

- [ ] Text field / input
- [ ] Text area
- [ ] Search field
- [ ] Dropdown / select
- [ ] Multi-select
- [ ] Date picker
- [ ] Time picker
- [ ] Stepper (numeric +/-)
- [ ] Form field wrapper (label + hint + error)

## Molecules — surfaces & grouping

- [ ] Card
- [ ] List tile / row (settings-style row)  ← **next** (from noop settings)
- [ ] List section (grouped, with header)
- [ ] Accordion / expansion panel
- [ ] Tabs
- [ ] Banner / inline alert (info / success / warn / error)
- [ ] Toast / snackbar
- [ ] Progress steps / wizard header

## Organisms — navigation

- [ ] Bottom navigation bar  ← **next** (from noop app shell)
- [ ] Navigation rail (desktop/tablet)
- [ ] App bar / top bar
- [ ] Drawer / side sheet
- [ ] Breadcrumbs
- [ ] Pagination

## Organisms — overlays

- [ ] Dialog / modal
- [ ] Bottom sheet
- [ ] Popover / menu
- [ ] Context menu
- [ ] Command palette

## Data display

- [ ] Table / data grid
- [ ] Stat / metric tile
- [ ] Empty state
- [ ] Chart primitives (or a documented bring-your-own approach)

## Layout helpers

- [ ] Responsive scaffold / adaptive layout
- [ ] Stack / spacing helpers (`ChukGap`)
- [ ] Grid
- [ ] Safe-area aware page wrapper

## Cross-cutting quality

- [ ] Golden tests per component (light + dark)
- [ ] Widgetbook catalog (deploy as web docs)
- [ ] `example/` covering every component
- [ ] Full dartdoc on all public API
- [ ] `llms-full.txt` for AI-assisted adoption
- [ ] GitHub Actions: CI (analyze + test + goldens)
- [ ] GitHub Actions: tag-triggered publish (when moving to pub.dev)
