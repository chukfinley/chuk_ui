import 'package:chuk_ui/chuk_ui.dart';
import 'package:flutter/widgets.dart';

/// Interactive gallery demo for [ChukTabs].
///
/// Shows the gliding accent underline moving between full-width tabs, with a
/// small content panel below that reacts to the active tab. Also renders a
/// disabled bar to show the muted state.
class TabsDemo extends StatefulWidget {
  /// Creates the tabs demo.
  const TabsDemo({super.key});

  @override
  State<TabsDemo> createState() => _TabsDemoState();
}

class _TabsDemoState extends State<TabsDemo> {
  static const _tabs = ['Overview', 'Activity', 'Members', 'Settings'];
  static const _blurbs = [
    'A snapshot of the whole project at a glance.',
    'Every recent change, most recent first.',
    'The people who can see and edit this space.',
    'Preferences, permissions and danger-zone actions.',
  ];

  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final t = context.chuk;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        ChukTabs(
          tabs: _tabs,
          index: _index,
          onChanged: (i) => setState(() => _index = i),
        ),
        SizedBox(height: t.spacing.lg),
        // Content panel reacting to the active tab.
        DecoratedBox(
          decoration: ShapeDecoration(
            color: t.colors.surfaceInset,
            shape: SquircleBorder(
              radius: t.radii.md,
              smoothing: kAppleCornerSmoothing,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(t.spacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _tabs[_index],
                  style: t.typography.title.copyWith(
                    color: t.colors.textPrimary,
                  ),
                ),
                SizedBox(height: t.spacing.xs),
                Text(
                  _blurbs[_index],
                  style: t.typography.body.copyWith(
                    color: t.colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: t.spacing.xl),
        Text(
          'Disabled',
          style: t.typography.caption.copyWith(color: t.colors.textTertiary),
        ),
        SizedBox(height: t.spacing.sm),
        const ChukTabs(
          tabs: ['One', 'Two', 'Three'],
          index: 1,
          onChanged: null,
        ),
      ],
    );
  }
}
