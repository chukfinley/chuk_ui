import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:chuk_ui/chuk_ui.dart';
import 'package:flutter/widgets.dart';

/// Interactive gallery demo for [ChukAvatar].
///
/// Shows initials avatars at several sizes plus a resizable one you can grow
/// and shrink, and a toggle that swaps the big avatar between its initials and
/// a (procedurally generated, self-contained) photo.
class AvatarDemo extends StatefulWidget {
  const AvatarDemo({super.key});

  @override
  State<AvatarDemo> createState() => _AvatarDemoState();
}

class _AvatarDemoState extends State<AvatarDemo> {
  double _size = 64;
  bool _showPhoto = false;
  ImageProvider? _photo;

  @override
  void initState() {
    super.initState();
    _makePhoto();
  }

  /// Paints a small gradient bitmap so the image branch works without any
  /// network or asset dependency.
  Future<void> _makePhoto() async {
    const dim = 220;
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final rect = Rect.fromLTWH(0, 0, dim.toDouble(), dim.toDouble());
    canvas.drawRect(
      rect,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF60A0E0), Color(0xFF03E095)],
        ).createShader(rect),
    );
    final image = await recorder.endRecording().toImage(dim, dim);
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    if (data == null || !mounted) return;
    setState(() => _photo = MemoryImage(Uint8List.view(data.buffer)));
  }

  @override
  Widget build(BuildContext context) {
    final t = context.chuk;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // A size ramp of initials avatars.
        const Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ChukAvatar(size: 28, initials: 'ab'),
            SizedBox(width: 12),
            ChukAvatar(size: 40, initials: 'CF'),
            SizedBox(width: 12),
            ChukAvatar(size: 56, initials: 'mz'),
          ],
        ),
        SizedBox(height: t.spacing.md),
        // A muted-background variant beside a photo avatar.
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ChukAvatar(
              size: 48,
              initials: 'DM',
              background: t.colors.accentMuted,
            ),
            SizedBox(width: t.spacing.sm),
            if (_photo != null) ChukAvatar(size: 48, image: _photo),
          ],
        ),
        SizedBox(height: t.spacing.lg),
        // Interactive: resize + swap between initials and photo.
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ChukAvatar(
              size: _size,
              initials: 'CF',
              image: _showPhoto ? _photo : null,
            ),
            SizedBox(width: t.spacing.lg),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    ChukButton.secondary(
                      onPressed: _size <= 32
                          ? null
                          : () => setState(() => _size -= 8),
                      child: const Text('−'),
                    ),
                    SizedBox(width: t.spacing.sm),
                    ChukButton.secondary(
                      onPressed: _size >= 96
                          ? null
                          : () => setState(() => _size += 8),
                      child: const Text('+'),
                    ),
                    SizedBox(width: t.spacing.md),
                    Text(
                      '${_size.round()} px',
                      style: t.typography.caption.copyWith(
                        color: t.colors.textSecondary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: t.spacing.md),
                Row(
                  children: [
                    ChukSwitch(
                      value: _showPhoto,
                      onChanged: _photo == null
                          ? null
                          : (v) => setState(() => _showPhoto = v),
                      semanticLabel: 'Show photo',
                    ),
                    SizedBox(width: t.spacing.sm),
                    Text('Show photo', style: t.typography.body),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
