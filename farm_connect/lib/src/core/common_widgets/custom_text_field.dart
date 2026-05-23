import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final String? hint;
  final IconData? prefixIcon;
  final bool isPassword;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onFieldSubmitted;
  final int maxLines;

  const CustomTextField({
    super.key,
    required this.label,
    this.hint,
    this.prefixIcon,
    this.isPassword = false,
    this.controller,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.onFieldSubmitted,
    this.maxLines = 1,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late final FocusNode _focusNode;
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode()..addListener(_onFocusChanged);
    _obscureText = widget.isPassword;
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChanged);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final focused = _focusNode.hasFocus;
    final focusedColor =
        AppTheme.isDark(context) ? AppTheme.metallicGold : AppTheme.forestGreen;
    final textColor = AppTheme.appText(context);
    final mutedColor = AppTheme.appMutedText(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(
            color: mutedColor,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 8),
        AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              if (focused)
                BoxShadow(
                  color: focusedColor.withValues(alpha: 0.22),
                  blurRadius: 14,
                  spreadRadius: 1,
                ),
            ],
          ),
          child: TextFormField(
            controller: widget.controller,
            focusNode: _focusNode,
            obscureText: widget.isPassword ? _obscureText : false,
            validator: widget.validator,
            maxLines: widget.isPassword ? 1 : widget.maxLines,
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction,
            onFieldSubmitted: widget.onFieldSubmitted,
            style: TextStyle(color: textColor),
            cursorColor: focusedColor,
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: TextStyle(color: mutedColor.withValues(alpha: 0.72)),
              prefixIcon: widget.prefixIcon != null
                  ? Icon(widget.prefixIcon, color: mutedColor)
                  : null,
              suffixIcon: widget.isPassword
                  ? IconButton(
                      onPressed: () =>
                          setState(() => _obscureText = !_obscureText),
                      icon: Icon(
                        _obscureText
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: mutedColor,
                      ),
                    )
                  : null,
            ),
          ),
        ),
      ],
    );
  }
}
