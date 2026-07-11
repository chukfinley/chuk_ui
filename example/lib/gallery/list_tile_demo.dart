import 'package:chuk_ui/chuk_ui.dart';
import 'package:flutter/material.dart' show Icons;
import 'package:flutter/widgets.dart';

/// Interactive gallery demo for [ChukListTile].
///
/// Shows a plain tappable list, tiles with leading/trailing widgets, a static
/// (non-tappable) tile and the `card: true` variant. Tapping a row updates the
/// selection banner so the tap feedback is observable.
class ListTileDemo extends StatefulWidget {
  const ListTileDemo({super.key});

  @override
  State<ListTileDemo> createState() => _ListTileDemoState();
}

class _ListTileDemoState extends State<ListTileDemo> {
  String _selected = 'nothing yet';
  bool _wifi = true;

  @override
  Widget build(BuildContext context) {
    final t = context.chuk;

    Widget icon(IconData data) => Icon(data, size: 22);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Last tapped: $_selected', style: t.typography.caption),
        SizedBox(height: t.spacing.md),

        // A grouped list of tappable rows.
        ChukListTile(
          leading: icon(Icons.person_outline),
          title: const Text('Account'),
          subtitle: const Text('name@example.com'),
          trailing: icon(Icons.chevron_right),
          onTap: () => setState(() => _selected = 'Account'),
        ),
        ChukListTile(
          leading: icon(Icons.notifications_outlined),
          title: const Text('Notifications'),
          subtitle: const Text('Push, email and in-app alerts'),
          trailing: icon(Icons.chevron_right),
          onTap: () => setState(() => _selected = 'Notifications'),
        ),

        // Trailing switch — the tile row toggles it.
        ChukListTile(
          leading: icon(Icons.wifi),
          title: const Text('Wi-Fi'),
          subtitle: Text(_wifi ? 'Connected' : 'Off'),
          trailing: ChukSwitch(
            value: _wifi,
            onChanged: (v) => setState(() => _wifi = v),
          ),
          onTap: () => setState(() {
            _wifi = !_wifi;
            _selected = 'Wi-Fi (${_wifi ? 'on' : 'off'})';
          }),
        ),

        // A static, non-interactive row.
        ChukListTile(
          leading: icon(Icons.info_outline),
          title: const Text('Version'),
          trailing: const Text('1.0.0'),
        ),

        SizedBox(height: t.spacing.lg),
        Text('card: true', style: t.typography.label),
        SizedBox(height: t.spacing.sm),

        // The card variant wraps the tile in a ChukCard surface.
        ChukListTile(
          card: true,
          leading: icon(Icons.workspace_premium_outlined),
          title: const Text('Upgrade to Pro'),
          subtitle: const Text('Unlock every feature'),
          trailing: icon(Icons.chevron_right),
          onTap: () => setState(() => _selected = 'Upgrade to Pro'),
        ),
      ],
    );
  }
}
