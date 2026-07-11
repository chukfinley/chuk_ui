import 'package:chuk_ui/chuk_ui.dart';
import 'package:flutter/widgets.dart';

void main() => runApp(const ExampleApp());

/// A Material-free host app that demonstrates the chuk_ui components.
class ExampleApp extends StatefulWidget {
  const ExampleApp({super.key});

  @override
  State<ExampleApp> createState() => _ExampleAppState();
}

class _ExampleAppState extends State<ExampleApp> {
  bool _dark = false;
  bool _notifications = true;

  @override
  Widget build(BuildContext context) {
    final theme = _dark ? ChukThemeData.dark() : ChukThemeData.light();

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
              color: t.colors.surface,
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.all(t.spacing.xl),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Chuk UI', style: t.typography.heading),
                      SizedBox(height: t.spacing.lg),
                      Wrap(
                        spacing: t.spacing.sm,
                        runSpacing: t.spacing.sm,
                        children: [
                          ChukButton.primary(
                            onPressed: () {},
                            child: const Text('Primary'),
                          ),
                          ChukButton.secondary(
                            onPressed: () {},
                            child: const Text('Secondary'),
                          ),
                          ChukButton.ghost(
                            onPressed: () {},
                            child: const Text('Ghost'),
                          ),
                          ChukButton.danger(
                            onPressed: () {},
                            child: const Text('Danger'),
                          ),
                          const ChukButton.primary(
                            onPressed: null,
                            child: Text('Disabled'),
                          ),
                        ],
                      ),
                      SizedBox(height: t.spacing.xl),
                      Row(
                        children: [
                          Text('Notifications', style: t.typography.body),
                          SizedBox(width: t.spacing.md),
                          ChukSwitch(
                            value: _notifications,
                            onChanged: (v) =>
                                setState(() => _notifications = v),
                          ),
                        ],
                      ),
                      SizedBox(height: t.spacing.xl),
                      Row(
                        children: [
                          Text('Dark mode', style: t.typography.body),
                          SizedBox(width: t.spacing.md),
                          ChukSwitch(
                            value: _dark,
                            onChanged: (v) => setState(() => _dark = v),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
