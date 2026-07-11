import 'package:flutter/widgets.dart';

import '../../shape/chuk_glass.dart';
import '../../shape/chuk_squircle.dart';
import '../../theme/chuk_theme.dart';
import 'chuk_nav_style.dart';

/// One destination in a [ChukNavBar].
@immutable
class ChukNavItem {
  const ChukNavItem({
    required this.icon,
    required this.label,
    this.activeIcon,
  });

  /// Icon shown when the tab is inactive.
  final IconData icon;

  /// Icon shown when the tab is active. Falls back to [icon].
  final IconData? activeIcon;

  /// The tab label.
  final String label;
}

/// A floating bottom navigation bar: a rounded pill with a single highlight
/// that *glides* between tabs (260 ms easeOutCubic). Styled from the
/// [ChukThemeData], no Material dependency.
///
/// Ported from the reference app's nav bar. Provide the destinations and the
/// selected index; call [onChanged] to switch. Set [collapsed] true to hide the
/// labels (e.g. on scroll-down), leaving just icons.
///
/// ```dart
/// ChukNavBar(
///   index: tab,
///   onChanged: (i) => setState(() => tab = i),
///   items: const [
///     ChukNavItem(icon: Icons.today_outlined, label: 'Today'),
///     ChukNavItem(icon: Icons.trending_up, label: 'Trends'),
///     ChukNavItem(icon: Icons.settings, label: 'Settings'),
///   ],
/// )
/// ```
class ChukNavBar extends StatelessWidget {
  const ChukNavBar({
    super.key,
    required this.items,
    required this.index,
    required this.onChanged,
    this.collapsed = false,
    this.style,
    this.safeArea = true,
  });

  /// The destinations, left to right.
  final List<ChukNavItem> items;

  /// The selected index.
  final int index;

  /// Called with the tapped index.
  final ValueChanged<int> onChanged;

  /// When true, labels collapse away leaving only icons and the bar shrinks.
  final bool collapsed;

  /// Per-instance style overrides.
  final ChukNavStyle? style;

  /// Whether to pad for the bottom safe area (home indicator).
  final bool safeArea;

  @override
  Widget build(BuildContext context) {
    final t = context.chuk;
    final s = t.navStyle.merge(style);

    final n = items.length;
    final height = collapsed
        ? (s.collapsedHeight ?? 52)
        : (s.height ?? 64);
    final radius = BorderRadius.circular(s.radius ?? t.radii.pill);
    final activeColor = s.activeColor ?? t.colors.textPrimary;
    final inactiveColor = s.inactiveColor ?? t.colors.textTertiary;
    final iconSize = s.iconSize ?? 22;

    // Slot-centre alignment for the sliding highlight: -1 (first) … 1 (last).
    final alignX = n <= 1 ? 0.0 : -1 + 2 * index.clamp(0, n - 1) / (n - 1);

    Widget tab(int i) {
      final item = items[i];
      final active = i == index;
      final color = active ? activeColor : inactiveColor;
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onChanged(i),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: t.motion.medium,
              child: Icon(
                active ? (item.activeIcon ?? item.icon) : item.icon,
                key: ValueKey(active),
                size: iconSize,
                color: color,
              ),
            ),
            AnimatedSize(
              duration: t.motion.medium,
              curve: t.motion.standard,
              child: collapsed
                  ? const SizedBox(width: 0, height: 0)
                  : Padding(
                      padding: const EdgeInsets.only(top: 3),
                      child: Text(
                        item.label,
                        style: t.typography.caption.copyWith(
                          fontSize: 10,
                          fontWeight:
                              active ? FontWeight.w600 : FontWeight.w500,
                          color: color,
                        ),
                      ),
                    ),
            ),
          ],
        ),
      );
    }

    final inner = Padding(
      padding: const EdgeInsets.all(3),
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedAlign(
            alignment: Alignment(alignX, 0),
            duration: t.motion.medium,
            curve: t.motion.standard,
            child: FractionallySizedBox(
              widthFactor: 1 / n,
              heightFactor: 1,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: s.highlightColor ?? const Color(0x24FFFFFF),
                  borderRadius: radius,
                ),
              ),
            ),
          ),
          Row(
            children: [
              for (var i = 0; i < n; i++) Expanded(child: tab(i)),
            ],
          ),
        ],
      ),
    );

    final trackColor = s.trackColor ?? t.colors.surfaceRaised;

    // Light mode = frosted glass; dark mode = solid raised pill.
    Widget bar = t.isLight
        ? ChukGlass(
            shape: SquircleBorder(radius: s.radius ?? t.radii.pill),
            fill: trackColor.withValues(alpha: 0.30),
            blurSigma: 30,
            shadow: s.shadow,
            child: AnimatedSize(
              duration: t.motion.medium,
              curve: t.motion.standard,
              child: SizedBox(height: height, child: inner),
            ),
          )
        : AnimatedContainer(
            duration: t.motion.medium,
            curve: t.motion.standard,
            height: height,
            decoration: BoxDecoration(
              color: trackColor,
              borderRadius: radius,
              boxShadow: s.shadow,
            ),
            child: inner,
          );

    bar = Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 6),
      child: bar,
    );

    if (safeArea) {
      bar = SafeArea(top: false, child: bar);
    }
    return bar;
  }
}
