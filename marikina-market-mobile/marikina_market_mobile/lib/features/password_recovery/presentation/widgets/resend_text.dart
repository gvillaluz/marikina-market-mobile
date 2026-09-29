import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:marikina_market_mobile/core/constants/app_colors.dart';

class ResendText extends StatefulWidget {
  final int cooldownSeconds;
  final bool isSending;
  final VoidCallback onResend;

  const ResendText({
    required this.cooldownSeconds,
    required this.isSending,
    required this.onResend,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _ResentTextState();
}

class _ResentTextState extends State<ResendText> {
  final _recognizer = TapGestureRecognizer();

  String _format(int totalSeconds) {
    final m = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final s = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final baseStyle = Theme.of(
      context,
    ).textTheme.bodyMedium?.copyWith(fontSize: 14);

    if (widget.isSending) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Didn't receive the code? ", style: baseStyle),
          const SizedBox(
            width: 12,
            height: 12,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ],
      );
    }

    final canResend = widget.cooldownSeconds <= 0;
    _recognizer.onTap = canResend ? widget.onResend : null;

    return RichText(
      text: TextSpan(
        style: baseStyle,
        children: [
          const TextSpan(text: "Didn't receive the code? "),
          TextSpan(
            text: 'Resend',
            recognizer: _recognizer,
            style: TextStyle(
              color: canResend ? AppColors.primary : Colors.grey,
              fontWeight: FontWeight.w700,
              decoration: canResend
                  ? TextDecoration.underline
                  : TextDecoration.none,
              decorationColor: AppColors.primary,
            ),
          ),
          if (!canResend)
            TextSpan(
              text: ' in ${_format(widget.cooldownSeconds)}',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
        ],
      ),
    );
  }
}
