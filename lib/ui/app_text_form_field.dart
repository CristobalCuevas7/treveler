import 'package:flutter/material.dart';
import 'package:treveler/style/colors.dart';

class AppTextFormField extends StatefulWidget {
  final String hintText;
  final bool obscureText;
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final ValueChanged<String>? onFieldSubmitted;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final FormFieldValidator<String>? validator;

  const AppTextFormField({
    Key? key,
    this.hintText = '',
    this.obscureText = false,
    this.focusNode,
    this.controller,
    this.onFieldSubmitted,
    this.keyboardType,
    this.textInputAction,
    this.validator,
  }) : super(key: key);

  @override
  State<AppTextFormField> createState() => _AppTextFormFieldState();
}

class _AppTextFormFieldState extends State<AppTextFormField> {
  late bool _isObscureText;

  @override
  void initState() {
    super.initState();
    _isObscureText = widget.obscureText;
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isObscureText = !_isObscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: widget.focusNode,
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      onFieldSubmitted: widget.onFieldSubmitted,
      textInputAction: widget.textInputAction,
      obscureText: _isObscureText,
      validator: widget.validator,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.darkGrey,
        hintText: widget.hintText,
        errorStyle: const TextStyle(color: AppColors.error),
        hintStyle: const TextStyle(color: AppColors.subtitle),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        suffixIcon: (widget.keyboardType == TextInputType.visiblePassword)
            ? IconButton(
                icon: Icon(
                  _isObscureText ? Icons.visibility_off : Icons.visibility,
                  color: AppColors.subtitle,
                ),
                onPressed: _togglePasswordVisibility,
              )
            : null,
      ),
      style: const TextStyle(color: AppColors.text),
    );
  }
}
