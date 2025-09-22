import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    this.label,
    this.hint,
    this.initialValue,
    this.controller,
    this.validator,
    this.onChanged,
    this.onTap,
    this.onSubmitted,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.done,
    this.obscureText = false,
    this.readOnly = false,
    this.enabled = true,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.prefixIcon,
    this.suffixIcon,
    this.inputFormatters,
    this.focusNode,
    this.contentPadding,
    this.autofocus = false,
  });

  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final void Function(String)? onSubmitted;
  final bool autofocus;
  final EdgeInsetsGeometry? contentPadding;
  final TextEditingController? controller;
  final bool enabled;
  final FocusNode? focusNode;
  final String? hint;
  final String? initialValue;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType keyboardType;
  final String? label;
  final int? maxLength;
  final int? maxLines;
  final int? minLines;
  final bool obscureText;
  final Widget? prefixIcon;
  final bool readOnly;
  final Widget? suffixIcon;
  final TextInputAction textInputAction;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  Widget? _buildSuffixIcon() {
    if (widget.obscureText) {
      return IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility_off : Icons.visibility,
          size: 20,
        ),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      );
    }

    return widget.suffixIcon;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Text(widget.label!, style: Theme.of(context).textTheme.labelMedium),
          SizedBox(height: 8),
        ],
        TextFormField(
          controller: widget.controller,
          initialValue: widget.initialValue,
          validator: widget.validator,
          onChanged: widget.onChanged,
          onTap: widget.onTap,
          onFieldSubmitted: widget.onSubmitted,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          obscureText: _obscureText,
          readOnly: widget.readOnly,
          enabled: widget.enabled,
          maxLines: widget.maxLines,
          minLines: widget.minLines,
          maxLength: widget.maxLength,
          inputFormatters: widget.inputFormatters,
          focusNode: widget.focusNode,
          autofocus: widget.autofocus,
          decoration: InputDecoration(
            hintText: widget.hint,
            prefixIcon: widget.prefixIcon,
            suffixIcon: _buildSuffixIcon(),
            contentPadding: widget.contentPadding ?? EdgeInsets.all(16),
          ),
        ),
      ],
    );
  }
}
