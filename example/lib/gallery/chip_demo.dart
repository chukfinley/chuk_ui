import 'package:chuk_ui/chuk_ui.dart';
import 'package:flutter/material.dart' show Icons;
import 'package:flutter/widgets.dart';

/// An interactive gallery entry for [ChukChip].
///
/// Shows a row of filter chips whose selection toggles, plus a set of removable
/// "input" chips that disappear when their ✕ is tapped and can be reset. Also
/// includes a disabled chip so the muted state is visible. Renders inside the
/// surrounding [ChukTheme]; it manages its own state.
class ChipDemo extends StatefulWidget {
  const ChipDemo({super.key});

  @override
  State<ChipDemo> createState() => _ChipDemoState();
}

class _ChipDemoState extends State<ChipDemo> {
  static const List<(String, IconData)> _filters = [
    ('Strength', Icons.fitness_center),
    ('Cardio', Icons.directions_run),
    ('Mobility', Icons.self_improvement),
    ('Recovery', Icons.bedtime),
  ];

  final Set<String> _selected = {'Strength'};

  static const List<String> _allTags = [
    'High protein',
    'Under 30 min',
    'No equipment',
    'Beginner',
  ];
  late List<String> _tags = List.of(_allTags);

  @override
  Widget build(BuildContext context) {
    final t = context.chuk;

    Widget label(String text) => Padding(
      padding: EdgeInsets.only(bottom: t.spacing.sm),
      child: Text(
        text,
        style: t.typography.caption.copyWith(color: t.colors.textTertiary),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        label('FILTER CHIPS (icon + toggle selection)'),
        Wrap(
          spacing: t.spacing.sm,
          runSpacing: t.spacing.sm,
          children: [
            for (final (name, icon) in _filters)
              ChukChip(
                label: name,
                icon: icon,
                selected: _selected.contains(name),
                onPressed: () => setState(() {
                  if (!_selected.add(name)) _selected.remove(name);
                }),
              ),
          ],
        ),
        SizedBox(height: t.spacing.xl),
        label('REMOVABLE CHIPS (tap ✕ to delete)'),
        Wrap(
          spacing: t.spacing.sm,
          runSpacing: t.spacing.sm,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            for (final tag in _tags)
              ChukChip(
                label: tag,
                onPressed: () {},
                onDeleted: () => setState(() => _tags.remove(tag)),
              ),
            if (_tags.length < _allTags.length)
              ChukChip(
                label: 'Reset',
                icon: Icons.refresh,
                selected: true,
                onPressed: () => setState(() => _tags = List.of(_allTags)),
              ),
          ],
        ),
        SizedBox(height: t.spacing.xl),
        label('STATES'),
        Wrap(
          spacing: t.spacing.sm,
          runSpacing: t.spacing.sm,
          children: const [
            ChukChip(label: 'Selected', selected: true, onPressed: _noop),
            ChukChip(label: 'Unselected', onPressed: _noop),
            ChukChip(label: 'Disabled'),
          ], // const OK: _noop is a top-level tear-off
        ),
      ],
    );
  }
}

void _noop() {}
