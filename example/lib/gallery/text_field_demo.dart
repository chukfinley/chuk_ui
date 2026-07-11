import 'package:chuk_ui/chuk_ui.dart';
import 'package:flutter/material.dart' show Icons;
import 'package:flutter/widgets.dart';

/// Interactive gallery entry for [ChukTextField].
///
/// Shows the single-line field with a leading icon, live email validation
/// driving [ChukTextField.errorText], a password field with an obscure toggle,
/// a growing multiline field and a disabled field — all self-contained.
class TextFieldDemo extends StatefulWidget {
  const TextFieldDemo({super.key});

  @override
  State<TextFieldDemo> createState() => _TextFieldDemoState();
}

class _TextFieldDemoState extends State<TextFieldDemo> {
  final TextEditingController _email = TextEditingController();
  bool _obscure = true;
  String _bio = '';

  String? get _emailError {
    final v = _email.text.trim();
    if (v.isEmpty) return null;
    return v.contains('@') && v.contains('.') ? null : 'Ungültige E-Mail';
  }

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.chuk;

    return SingleChildScrollView(
      padding: EdgeInsets.all(t.spacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Text Field', style: t.typography.heading),
          SizedBox(height: t.spacing.lg),

          // Plain single-line with a leading icon.
          ChukTextField(
            label: 'Name',
            hintText: 'Wie heißt du?',
            leading: Icon(
              Icons.person_outline,
              size: 20,
              color: t.colors.textTertiary,
            ),
            onChanged: (_) => setState(() {}),
          ),
          SizedBox(height: t.spacing.lg),

          // Live-validated email: errorText flips the border to statusCritical.
          ChukTextField(
            controller: _email,
            label: 'E-Mail',
            hintText: 'you@example.com',
            keyboardType: TextInputType.emailAddress,
            leading: Icon(
              Icons.alternate_email,
              size: 20,
              color: t.colors.textTertiary,
            ),
            errorText: _emailError,
            onChanged: (_) => setState(() {}),
          ),
          SizedBox(height: t.spacing.lg),

          // Password with an obscure toggle in the trailing slot.
          ChukTextField(
            label: 'Passwort',
            hintText: '••••••••',
            obscureText: _obscure,
            leading: Icon(
              Icons.lock_outline,
              size: 20,
              color: t.colors.textTertiary,
            ),
            trailing: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => setState(() => _obscure = !_obscure),
              child: Icon(
                _obscure
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                size: 20,
                color: t.colors.textSecondary,
              ),
            ),
          ),
          SizedBox(height: t.spacing.lg),

          // Multiline: grows up to 5 lines.
          ChukTextField(
            label: 'Bio',
            hintText: 'Erzähl etwas über dich …',
            minLines: 3,
            maxLines: 5,
            onChanged: (v) => setState(() => _bio = v),
          ),
          SizedBox(height: t.spacing.xs),
          Text(
            '${_bio.length} Zeichen',
            style: t.typography.caption.copyWith(color: t.colors.textTertiary),
          ),
          SizedBox(height: t.spacing.lg),

          // Disabled.
          const ChukTextField(
            label: 'Konto-ID (gesperrt)',
            hintText: 'chuk-0001',
            enabled: false,
          ),
        ],
      ),
    );
  }
}
