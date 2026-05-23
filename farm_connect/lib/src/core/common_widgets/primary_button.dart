import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class PrimaryButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? trailingIcon;

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.trailingIcon,
  });

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final disabled = widget.isLoading || widget.onPressed == null;
    final isDark = AppTheme.isDark(context);
    final loaderColor = isDark ? const Color(0xFF102116) : Colors.white;

    return AnimatedScale(
      duration: const Duration(milliseconds: 110),
      scale: _pressed ? 0.985 : 1,
      child: GestureDetector(
        onTapDown: disabled ? null : (_) => setState(() => _pressed = true),
        onTapCancel: disabled ? null : () => setState(() => _pressed = false),
        onTapUp: disabled ? null : (_) => setState(() => _pressed = false),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: disabled ? null : widget.onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  isDark ? AppTheme.metallicGold : AppTheme.forestGreen,
              foregroundColor: isDark ? const Color(0xFF102116) : Colors.white,
              disabledBackgroundColor:
                  isDark ? const Color(0xFF566044) : const Color(0xFFB7C6A9),
              disabledForegroundColor:
                  isDark ? AppTheme.darkMutedText : AppTheme.lightMutedText,
              minimumSize: const Size(double.infinity, 54),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(999),
              ),
              elevation: 0,
            ),
            child: widget.isLoading
                ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: loaderColor,
                      strokeWidth: 2.2,
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.text,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.25,
                        ),
                      ),
                      if (widget.trailingIcon != null) ...[
                        const SizedBox(width: 8),
                        Icon(widget.trailingIcon, size: 18),
                      ],
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
