import 'package:chuk_ui/chuk_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child) {
  return WidgetsApp(
    color: const Color(0xFF000000),
    debugShowCheckedModeBanner: false,
    pageRouteBuilder: <T>(settings, builder) =>
        PageRouteBuilder<T>(settings: settings, pageBuilder: (c, _, __) {
      return builder(c);
    }),
    home: ChukTheme(data: ChukThemeData.light(), child: Center(child: child)),
  );
}

void main() {
  testWidgets('ChukButton fires onPressed when enabled', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      _wrap(
        ChukButton.primary(
          onPressed: () => taps++,
          child: const Text('Tap'),
        ),
      ),
    );

    await tester.tap(find.text('Tap'));
    expect(taps, 1);
  });

  testWidgets('ChukButton is disabled when onPressed is null', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const ChukButton.primary(
          onPressed: null,
          child: Text('Nope'),
        ),
      ),
    );

    expect(
      tester.getSemantics(find.text('Nope')),
      matchesSemantics(isButton: true, isEnabled: false, hasEnabledState: true),
    );
  });

  testWidgets('ChukSwitch toggles its value', (tester) async {
    var value = false;
    await tester.pumpWidget(
      _wrap(
        StatefulBuilder(
          builder: (context, setState) => ChukSwitch(
            value: value,
            onChanged: (v) => setState(() => value = v),
          ),
        ),
      ),
    );

    await tester.tap(find.byType(ChukSwitch));
    await tester.pumpAndSettle();
    expect(value, isTrue);
  });
}
