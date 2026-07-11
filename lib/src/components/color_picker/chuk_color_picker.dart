import 'package:flutter/widgets.dart';

import '../../shape/chuk_squircle.dart';
import '../../theme/chuk_theme.dart';

/// A draggable HSV color picker: a saturation/value field you swipe around with
/// the mouse or finger, plus a hue slider below it. Reports the live color as
/// you drag. Material-free.
///
/// ```dart
/// ChukColorPicker(
///   color: primary,
///   onChanged: (c) => setState(() => primary = c),
/// )
/// ```
class ChukColorPicker extends StatefulWidget {
  const ChukColorPicker({
    super.key,
    required this.color,
    required this.onChanged,
    this.fieldHeight = 180,
    this.hueHeight = 22,
  });

  /// The current color.
  final Color color;

  /// Called continuously while dragging with the new color.
  final ValueChanged<Color> onChanged;

  /// Height of the saturation/value field.
  final double fieldHeight;

  /// Height of the hue slider.
  final double hueHeight;

  @override
  State<ChukColorPicker> createState() => _ChukColorPickerState();
}

class _ChukColorPickerState extends State<ChukColorPicker> {
  late HSVColor _hsv;

  @override
  void initState() {
    super.initState();
    _hsv = HSVColor.fromColor(widget.color);
  }

  @override
  void didUpdateWidget(ChukColorPicker old) {
    super.didUpdateWidget(old);
    // Keep in sync if the color is changed from the outside, but ignore the
    // round-trip of our own emitted color (same RGB → keep our hue/sat).
    if (widget.color.toARGB32() != _hsv.toColor().toARGB32()) {
      _hsv = HSVColor.fromColor(widget.color);
    }
  }

  void _emit() => widget.onChanged(_hsv.toColor());

  void _updateSV(Offset local, Size size) {
    final s = (local.dx / size.width).clamp(0.0, 1.0);
    final v = (1 - local.dy / size.height).clamp(0.0, 1.0);
    setState(() => _hsv = _hsv.withSaturation(s).withValue(v));
    _emit();
  }

  void _updateHue(Offset local, double width) {
    final h = (local.dx / width).clamp(0.0, 1.0) * 360.0;
    setState(() => _hsv = _hsv.withHue(h));
    _emit();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.chuk;
    final radius = t.radii.md;
    final hueColor = HSVColor.fromAHSV(1, _hsv.hue, 1, 1).toColor();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ── Saturation / Value field ──────────────────────────────────
        ClipPath(
          clipper: ShapeBorderClipper(
            shape: SquircleBorder(radius: radius),
          ),
          child: SizedBox(
            height: widget.fieldHeight,
            child: LayoutBuilder(
              builder: (context, c) {
                final size = Size(c.maxWidth, c.maxHeight);
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onPanDown: (d) => _updateSV(d.localPosition, size),
                  onPanUpdate: (d) => _updateSV(d.localPosition, size),
                  child: Stack(
                    children: [
                      // Base hue → white (saturation, left to right).
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [const Color(0xFFFFFFFF), hueColor],
                          ),
                        ),
                        child: const SizedBox.expand(),
                      ),
                      // Value overlay (transparent → black, top to bottom).
                      const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Color(0x00000000), Color(0xFF000000)],
                          ),
                        ),
                        child: SizedBox.expand(),
                      ),
                      // Thumb.
                      Positioned(
                        left: _hsv.saturation * size.width - 9,
                        top: (1 - _hsv.value) * size.height - 9,
                        child: _Thumb(color: _hsv.toColor()),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        SizedBox(height: t.spacing.md),
        // ── Hue slider ────────────────────────────────────────────────
        ClipPath(
          clipper: ShapeBorderClipper(
            shape: SquircleBorder(radius: widget.hueHeight / 2),
          ),
          child: SizedBox(
            height: widget.hueHeight,
            child: LayoutBuilder(
              builder: (context, c) {
                final width = c.maxWidth;
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onPanDown: (d) => _updateHue(d.localPosition, width),
                  onPanUpdate: (d) => _updateHue(d.localPosition, width),
                  child: Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFFFF0000),
                              Color(0xFFFFFF00),
                              Color(0xFF00FF00),
                              Color(0xFF00FFFF),
                              Color(0xFF0000FF),
                              Color(0xFFFF00FF),
                              Color(0xFFFF0000),
                            ],
                          ),
                        ),
                        child: SizedBox.expand(),
                      ),
                      Positioned(
                        left: _hsv.hue / 360 * width - 9,
                        child: _Thumb(color: hueColor),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

/// The draggable knob: a white ring showing the current color inside.
class _Thumb extends StatelessWidget {
  const _Thumb({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFFFFFFF), width: 3),
        boxShadow: const [
          BoxShadow(color: Color(0x66000000), blurRadius: 4),
        ],
      ),
    );
  }
}
