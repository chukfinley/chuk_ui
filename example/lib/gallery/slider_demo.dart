import 'package:chuk_ui/chuk_ui.dart';
import 'package:flutter/widgets.dart';

/// Interactive gallery demo for [ChukSlider]: a continuous slider, a stepped
/// slider with divisions, and a disabled one. Manages its own state and renders
/// inside whatever [ChukTheme] the gallery already provides.
class SliderDemo extends StatefulWidget {
  const SliderDemo({super.key});

  @override
  State<SliderDemo> createState() => _SliderDemoState();
}

class _SliderDemoState extends State<SliderDemo> {
  double _volume = 0.6;
  double _rating = 3;

  @override
  Widget build(BuildContext context) {
    final t = context.chuk;

    Widget row(String label, String value, Widget slider) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: t.typography.label),
              Text(
                value,
                style: t.typography.caption.copyWith(
                  color: t.colors.textTertiary,
                ),
              ),
            ],
          ),
          SizedBox(height: t.spacing.xs),
          slider,
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        row(
          'Volume',
          '${(_volume * 100).round()}%',
          ChukSlider(
            value: _volume,
            semanticLabel: 'Volume',
            onChanged: (v) => setState(() => _volume = v),
          ),
        ),
        SizedBox(height: t.spacing.xl),
        row(
          'Rating',
          '${_rating.round()} / 5',
          ChukSlider(
            value: _rating,
            min: 1,
            max: 5,
            divisions: 4,
            semanticLabel: 'Rating',
            onChanged: (v) => setState(() => _rating = v),
          ),
        ),
        SizedBox(height: t.spacing.xl),
        row('Disabled', '40%', const ChukSlider(value: 0.4, onChanged: null)),
      ],
    );
  }
}
