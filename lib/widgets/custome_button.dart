import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final IconData? icon;
  final double? width;
  final double? height;
  final double? fontSize;
  final Gradient? gradient;
  final Color? textColor;
  final bool isLoading;
  final Border? border;

  const CustomButton({
    super.key,
    required this.text,
    required this.onTap,
    this.icon,
    this.width,
    this.height = 50,
    this.fontSize = 16,
    this.gradient,
    this.textColor,
    this.isLoading = false,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(12),
      elevation: 3,
      child: Ink(
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(12),
          border: border,
          color: gradient == null ? Colors.indigo : null,
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: isLoading ? null : onTap,
          child: Container(
            width: width ?? double.infinity,
            height: height,
            alignment: Alignment.center,
            child: isLoading
                ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2.5,
              ),
            )
                : Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(icon, color: textColor ?? Colors.white),
                  const SizedBox(width: 8),
                ],
                Text(
                  text,
                  style: TextStyle(
                    color: textColor ?? Colors.white,
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
