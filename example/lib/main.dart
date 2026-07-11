import 'dart:async';

import 'package:chuk_ui/chuk_ui.dart';
import 'package:flutter/material.dart' show Icons;
import 'package:flutter/services.dart' show Clipboard, ClipboardData;
import 'package:flutter/widgets.dart';

void main() => runApp(const ExampleApp());

/// A Material-free host app that shows the chuk_ui components doing real work:
/// tabs switch content, buttons mutate state, the segmented control drives a
/// value, and the primary "load" button shows the spinner.
class ExampleApp extends StatefulWidget {
  const ExampleApp({super.key});

  @override
  State<ExampleApp> createState() => _ExampleAppState();
}

class _ExampleAppState extends State<ExampleApp> {
  bool _dark = true;
  int _tab = 0;

  /// The live primary color, chosen from the palette tab.
  Color _primary = const Color(0xFF607C64);

  /// Candidate main colors, judged as real buttons on the dark canvas.
  /// The first three are the user's favourites (muted / understated).
  static const List<(String, Color)> _palette = [
    ('Sage', Color(0xFF607C64)),
    ('Olive', Color(0xFF7E7E52)),
    ('Steel', Color(0xFF526F7E)),
    ('Taupe', Color(0xFF49453F)),
    ('Mint', Color(0xFF03E095)),
    ('Emerald', Color(0xFF12B981)),
    ('Teal', Color(0xFF14B8A6)),
    ('Aqua', Color(0xFF22C3D6)),
    ('Sky', Color(0xFF38A8E8)),
    ('Azure', Color(0xFF4C7EF0)),
    ('Indigo', Color(0xFF6366F1)),
    ('Iris', Color(0xFF7C74F2)),
    ('Violet', Color(0xFF9575F0)),
    ('Lilac', Color(0xFFB08AF0)),
    ('Orchid', Color(0xFFC77DD9)),
    ('Pink', Color(0xFFE86FA6)),
    ('Rose', Color(0xFFF2708C)),
    ('Coral', Color(0xFFFB7563)),
    ('Amber', Color(0xFFF0A85A)),
    ('Gold', Color(0xFFE6C34C)),
    ('Lime', Color(0xFFAFD65A)),
    ('Moss', Color(0xFF86B58C)),
    ('Sand', Color(0xFFCBAA80)),
    ('Slate', Color(0xFF7C93AD)),
  ];

  /// Dark or white label depending on the swatch's luminance.
  Color _onColor(Color c) =>
      c.computeLuminance() > 0.55 ? const Color(0xFF0B1424) : const Color(0xFFFFFFFF);

  // Interactive state, shared across tabs.
  int _count = 0;
  String _range = 'w';
  bool _loading = false;
  bool _notifications = true;
  bool _sync = false;
  bool _previewSwitch = true;
  String _lastAction = 'Noch nichts gedrückt';

  void _act(String msg) => setState(() => _lastAction = msg);

  Future<void> _simulateLoad() async {
    setState(() => _loading = true);
    _act('Lädt …');
    await Future<void>.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;
    setState(() => _loading = false);
    _act('Fertig geladen ✓');
  }

  @override
  Widget build(BuildContext context) {
    // The chosen main color replaces the whole accent — so buttons, toggles,
    // the spinner, the focus ring and ghost text all follow it.
    final isLight = !_dark;
    final palette = (_dark ? ChukColors.dark() : ChukColors.light())
        .copyWith(accent: _primary, focusRing: _primary);
    final base = ChukThemeData.fromTokens(colors: palette, isLight: isLight);
    // Ensure readable label color on the primary button for light swatches.
    final theme = base.copyWith(
      primaryButton: base.primaryButton.copyWith(foreground: _onColor(_primary)),
    );

    return WidgetsApp(
      color: const Color(0xFF000000),
      debugShowCheckedModeBanner: false,
      pageRouteBuilder: <T>(settings, builder) =>
          PageRouteBuilder<T>(settings: settings, pageBuilder: (c, _, __) {
        return builder(c);
      }),
      home: ChukTheme(
        data: theme,
        child: Builder(
          builder: (context) {
            final t = context.chuk;
            return Container(
              color: t.colors.surfaceBase,
              child: Column(
                children: [
                  Expanded(
                    child: SafeArea(
                      bottom: false,
                      child: IndexedStack(
                        index: _tab,
                        children: [
                          _todayTab(t),
                          _trendsTab(t),
                          _colorsTab(t),
                          _settingsTab(t),
                        ],
                      ),
                    ),
                  ),
                  ChukNavBar(
                    index: _tab,
                    onChanged: (i) => setState(() => _tab = i),
                    items: const [
                      ChukNavItem(
                        icon: Icons.today_outlined,
                        activeIcon: Icons.today_rounded,
                        label: 'Today',
                      ),
                      ChukNavItem(
                        icon: Icons.trending_up_outlined,
                        activeIcon: Icons.trending_up_rounded,
                        label: 'Trends',
                      ),
                      ChukNavItem(
                        icon: Icons.palette_outlined,
                        activeIcon: Icons.palette_rounded,
                        label: 'Colors',
                      ),
                      ChukNavItem(
                        icon: Icons.settings_outlined,
                        activeIcon: Icons.settings_rounded,
                        label: 'Settings',
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _page(ChukThemeData t, String title, List<Widget> children) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(t.spacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: t.typography.heading),
          SizedBox(height: t.spacing.lg),
          ...children,
        ],
      ),
    );
  }

  Widget _card(ChukThemeData t, {required Widget child}) {
    return Padding(
      padding: EdgeInsets.only(bottom: t.spacing.md),
      child: ChukCard(child: child),
    );
  }

  // ── Today ──────────────────────────────────────────────────────────────
  Widget _todayTab(ChukThemeData t) {
    return _page(t, 'Today', [
      ChukSearchBar(
        hintText: 'Suchen …',
        onChanged: (q) => _act('Suche: "$q"'),
      ),
      SizedBox(height: t.spacing.lg),
      _card(t,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Counter', style: t.typography.title),
              SizedBox(height: t.spacing.xs),
              Text('$_count',
                  style: t.typography.heading.copyWith(fontSize: 48)),
              SizedBox(height: t.spacing.md),
              Wrap(
                spacing: t.spacing.sm,
                runSpacing: t.spacing.sm,
                children: [
                  ChukButton.primary(
                    onPressed: () {
                      setState(() => _count++);
                      _act('+1 → $_count');
                    },
                    child: const Text('+1'),
                  ),
                  ChukButton.secondary(
                    onPressed: () {
                      setState(() => _count--);
                      _act('−1 → $_count');
                    },
                    child: const Text('−1'),
                  ),
                  ChukButton.ghost(
                    onPressed: _count == 0
                        ? null
                        : () {
                            setState(() => _count = 0);
                            _act('Zurückgesetzt');
                          },
                    child: const Text('Reset'),
                  ),
                ],
              ),
            ],
          )),
      _card(t,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Laden', style: t.typography.title),
              SizedBox(height: t.spacing.md),
              Row(
                children: [
                  ChukButton.primary(
                    onPressed: _loading ? null : _simulateLoad,
                    child: const Text('Simulate load'),
                  ),
                  SizedBox(width: t.spacing.lg),
                  if (_loading) const ChukSpinner(size: 32),
                ],
              ),
            ],
          )),
      Text(_lastAction,
          style: t.typography.caption.copyWith(color: t.colors.textTertiary)),
    ]);
  }

  // ── Trends ─────────────────────────────────────────────────────────────
  Widget _trendsTab(ChukThemeData t) {
    const values = {
      'd': '72 kg',
      'w': '71.6 kg',
      'm': '71.2 kg',
      'q': '70.4 kg',
      'y': '68.9 kg',
    };
    return _page(t, 'Trends', [
      ChukSegmented<String>(
        value: _range,
        expand: true,
        segments: const [
          ChukSegment('d', 'Tag'),
          ChukSegment('w', 'Woche'),
          ChukSegment('m', 'Monat'),
          ChukSegment('q', '3 Monate'),
          ChukSegment('y', 'Jahr'),
        ],
        onChanged: (v) {
          setState(() => _range = v);
          _act('Zeitraum: $v');
        },
      ),
      SizedBox(height: t.spacing.xl),
      _card(t,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Ø Gewicht',
                  style: t.typography.caption
                      .copyWith(color: t.colors.textSecondary)),
              SizedBox(height: t.spacing.xs),
              AnimatedSwitcher(
                duration: t.motion.medium,
                child: Text(
                  values[_range]!,
                  key: ValueKey(_range),
                  style: t.typography.heading.copyWith(fontSize: 40),
                ),
              ),
            ],
          )),
    ]);
  }

  // ── Colors ─────────────────────────────────────────────────────────────
  Widget _colorsTab(ChukThemeData t) {
    return _page(t, 'Hauptfarbe', [
      Text(
        'Tippe eine Farbe — sie wird sofort überall als Primary übernommen. '
        'Alles echt in Flutter gerendert (Squircle-Buttons, Spinner).',
        style: t.typography.body.copyWith(color: t.colors.textSecondary),
      ),
      SizedBox(height: t.spacing.md),
      ChukColorPicker(
        color: _primary,
        onChanged: (c) => setState(() => _primary = c),
      ),
      SizedBox(height: t.spacing.md),
      // Hex + copy.
      Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _primary,
              borderRadius: BorderRadius.circular(t.radii.sm),
            ),
          ),
          SizedBox(width: t.spacing.md),
          Text(
            _hex(_primary),
            style: t.typography.title.copyWith(
              fontFeatures: const [],
              color: t.colors.textPrimary,
            ),
          ),
          const Spacer(),
          ChukButton.ghost(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: _hex(_primary)));
              _act('${_hex(_primary)} kopiert');
            },
            child: const Text('Copy'),
          ),
        ],
      ),
      SizedBox(height: t.spacing.lg),
      // Live preview of components in the chosen color.
      _card(t,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Live-Vorschau',
                  style: t.typography.caption
                      .copyWith(color: t.colors.textSecondary)),
              SizedBox(height: t.spacing.md),
              Wrap(
                spacing: t.spacing.sm,
                runSpacing: t.spacing.sm,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  ChukButton.primary(
                    onPressed: () => _act('Primary'),
                    child: const Text('Primary'),
                  ),
                  ChukButton.ghost(
                    onPressed: () => _act('Ghost'),
                    child: const Text('Ghost'),
                  ),
                  ChukSwitch(
                    value: _previewSwitch,
                    onChanged: (v) => setState(() => _previewSwitch = v),
                  ),
                  const ChukSpinner(size: 28),
                ],
              ),
            ],
          )),
      SizedBox(height: t.spacing.sm),
      Text('Presets',
          style: t.typography.title.copyWith(color: t.colors.textSecondary)),
      SizedBox(height: t.spacing.sm),
      Wrap(
        spacing: t.spacing.sm,
        runSpacing: t.spacing.sm,
        children: [
          for (final (name, color) in _palette)
            _swatch(t, name, color),
        ],
      ),
    ]);
  }

  Widget _swatch(ChukThemeData t, String name, Color color) {
    final selected = color.toARGB32() == _primary.toARGB32();
    return SizedBox(
      width: 150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ChukButton.primary(
            expand: true,
            style: ChukButtonStyle(
              background: color,
              foreground: _onColor(color),
            ),
            onPressed: () {
              setState(() => _primary = color);
              _act('Primary: $name');
            },
            child: Text(selected ? '$name ✓' : name),
          ),
          SizedBox(height: t.spacing.xs),
          Text(
            _hex(color),
            style: t.typography.caption.copyWith(color: t.colors.textTertiary),
          ),
        ],
      ),
    );
  }

  String _hex(Color c) =>
      '#${c.toARGB32().toRadixString(16).substring(2).toUpperCase()}';

  // ── Settings ───────────────────────────────────────────────────────────
  Widget _settingsTab(ChukThemeData t) {
    return _page(t, 'Settings', [
      _settingsRow(
        t,
        'Benachrichtigungen',
        ChukSwitch(
          value: _notifications,
          onChanged: (v) {
            setState(() => _notifications = v);
            _act('Benachrichtigungen ${v ? "an" : "aus"}');
          },
        ),
      ),
      _settingsRow(
        t,
        'Cloud-Sync',
        ChukSwitch(
          value: _sync,
          onChanged: (v) {
            setState(() => _sync = v);
            _act('Sync ${v ? "an" : "aus"}');
          },
        ),
      ),
      _settingsRow(
        t,
        'Dark mode',
        ChukSwitch(
          value: _dark,
          onChanged: (v) => setState(() => _dark = v),
        ),
      ),
      SizedBox(height: t.spacing.lg),
      ChukButton.danger(
        expand: true,
        onPressed: () {
          setState(() {
            _count = 0;
            _notifications = true;
            _sync = false;
            _range = 'w';
          });
          _act('Alles zurückgesetzt');
        },
        child: const Text('Reset all'),
      ),
    ]);
  }

  Widget _settingsRow(ChukThemeData t, String label, Widget trailing) {
    return Padding(
      padding: EdgeInsets.only(bottom: t.spacing.sm),
      child: ChukCard(
        padding: EdgeInsets.symmetric(
          horizontal: t.spacing.lg,
          vertical: t.spacing.md,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: t.typography.body),
            trailing,
          ],
        ),
      ),
    );
  }
}
