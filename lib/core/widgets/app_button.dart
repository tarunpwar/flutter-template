import 'package:flutter/material.dart';

enum AppButtonType { primary, secondary, outline, text }
enum AppButtonSize { small, medium, large }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = AppButtonType.primary,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
    this.icon,
    this.fullWidth = false,
    this.backgroundColor,
    this.textColor,
    this.padding,
  });

  final Color? backgroundColor;
  final bool fullWidth;
  final Widget? icon;
  final bool isLoading;
  final VoidCallback? onPressed;
  final EdgeInsetsGeometry? padding;
  final AppButtonSize size;
  final String text;
  final Color? textColor;
  final AppButtonType type;

  Widget _buildButton(BuildContext context, ThemeData theme) {
    final content = _buildContent();
    
    switch (type) {
      case AppButtonType.primary:
        return ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor ?? theme.colorScheme.primary,
            foregroundColor: textColor ?? theme.colorScheme.onPrimary,
            padding: padding ?? _getPadding(),
            textStyle: _getTextStyle(),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: content,
        );
        
      case AppButtonType.secondary:
        return ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor ?? theme.colorScheme.secondary,
            foregroundColor: textColor ?? theme.colorScheme.onSecondary,
            padding: padding ?? _getPadding(),
            textStyle: _getTextStyle(),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: content,
        );
        
      case AppButtonType.outline:
        return OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: textColor ?? theme.colorScheme.primary,
            padding: padding ?? _getPadding(),
            textStyle: _getTextStyle(),
            side: BorderSide(
              color: backgroundColor ?? theme.colorScheme.primary,
              width: 1.5,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: content,
        );
        
      case AppButtonType.text:
        return TextButton(
          onPressed: isLoading ? null : onPressed,
          style: TextButton.styleFrom(
            foregroundColor: textColor ?? theme.colorScheme.primary,
            padding: padding ?? _getPadding(),
            textStyle: _getTextStyle(),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: content,
        );
    }
  }

  Widget _buildContent() {
    if (isLoading) {
      return SizedBox(
        width: _getIconSize(),
        height: _getIconSize(),
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            textColor ?? Colors.white,
          ),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: _getIconSize(),
            height: _getIconSize(),
            child: icon,
          ),
          SizedBox(width: 8),
          Text(text),
        ],
      );
    }

    return Text(text);
  }

  double _getHeight() {
    switch (size) {
      case AppButtonSize.small:
        return 36;
      case AppButtonSize.medium:
        return 44;
      case AppButtonSize.large:
        return 52;
    }
  }

  EdgeInsetsGeometry _getPadding() {
    switch (size) {
      case AppButtonSize.small:
        return EdgeInsets.symmetric(horizontal: 12, vertical: 8);
      case AppButtonSize.medium:
        return EdgeInsets.symmetric(horizontal: 16, vertical: 12);
      case AppButtonSize.large:
        return EdgeInsets.symmetric(horizontal:20, vertical: 16);
    }
  }

  TextStyle _getTextStyle() {
    switch (size) {
      case AppButtonSize.small:
        return TextStyle(fontSize: 12, fontWeight: FontWeight.w600);
      case AppButtonSize.medium:
        return TextStyle(fontSize: 14, fontWeight: FontWeight.w600);
      case AppButtonSize.large:
        return TextStyle(fontSize: 16, fontWeight: FontWeight.w600);
    }
  }

  double _getIconSize() {
    switch (size) {
      case AppButtonSize.small:
        return 16;
      case AppButtonSize.medium:
        return 18;
      case AppButtonSize.large:
        return 20;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: fullWidth ? double.infinity : null,
      height: _getHeight(),
      child: _buildButton(context, theme),
    );
  }
}