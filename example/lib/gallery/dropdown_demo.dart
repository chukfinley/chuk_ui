import 'package:chuk_ui/chuk_ui.dart';
import 'package:flutter/material.dart' show Icons;
import 'package:flutter/widgets.dart';

/// Interactive gallery entry for [ChukDropdown].
///
/// Shows a plain select, an icon-decorated select and a disabled one, all
/// managing their own state and echoing the current selection.
class DropdownDemo extends StatefulWidget {
  const DropdownDemo({super.key});

  @override
  State<DropdownDemo> createState() => _DropdownDemoState();
}

class _DropdownDemoState extends State<DropdownDemo> {
  String? _unit = 'kg';
  String? _sort;
  int? _speed = 1;

  static const _units = <ChukDropdownItem<String>>[
    ChukDropdownItem(value: 'kg', label: 'Kilograms'),
    ChukDropdownItem(value: 'lb', label: 'Pounds'),
    ChukDropdownItem(value: 'st', label: 'Stone'),
  ];

  static const _sorts = <ChukDropdownItem<String>>[
    ChukDropdownItem(value: 'new', label: 'Newest first', icon: Icons.schedule),
    ChukDropdownItem(value: 'old', label: 'Oldest first', icon: Icons.history),
    ChukDropdownItem(value: 'az', label: 'Name A–Z', icon: Icons.sort_by_alpha),
    ChukDropdownItem(value: 'fav', label: 'Favourites', icon: Icons.star),
  ];

  static const _speeds = <ChukDropdownItem<int>>[
    ChukDropdownItem(value: 1, label: '1× (normal)'),
    ChukDropdownItem(value: 2, label: '1.5×'),
    ChukDropdownItem(value: 3, label: '2×'),
  ];

  @override
  Widget build(BuildContext context) {
    final t = context.chuk;

    Widget labelled(String caption, Widget field) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            caption,
            style: t.typography.caption.copyWith(color: t.colors.textSecondary),
          ),
          SizedBox(height: t.spacing.xs),
          field,
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        labelled(
          'Weight unit',
          ChukDropdown<String>(
            value: _unit,
            items: _units,
            hintText: 'Choose a unit',
            onChanged: (v) => setState(() => _unit = v),
          ),
        ),
        SizedBox(height: t.spacing.lg),
        labelled(
          'Sort order (with icons, starts empty)',
          ChukDropdown<String>(
            value: _sort,
            items: _sorts,
            hintText: 'Select a sort order…',
            onChanged: (v) => setState(() => _sort = v),
          ),
        ),
        SizedBox(height: t.spacing.lg),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: labelled(
                'Playback speed',
                ChukDropdown<int>(
                  value: _speed,
                  items: _speeds,
                  onChanged: (v) => setState(() => _speed = v),
                ),
              ),
            ),
            SizedBox(width: t.spacing.md),
            Expanded(
              child: labelled(
                'Disabled',
                const ChukDropdown<String>(
                  value: 'kg',
                  items: _units,
                  enabled: false,
                  onChanged: null,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: t.spacing.xl),
        Text(
          'Selection: unit=${_unit ?? '—'}  ·  sort=${_sort ?? '—'}  ·  '
          'speed=${_speed ?? '—'}',
          style: t.typography.body.copyWith(color: t.colors.textSecondary),
        ),
      ],
    );
  }
}
