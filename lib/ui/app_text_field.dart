import 'package:flutter/material.dart';
import 'package:treveler/style/colors.dart';
import 'package:treveler/style/dimensions.dart'; // Import your custom colors file

class AppTextField extends StatefulWidget {
  final String hintText;
  final bool obscureText;
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;

  const AppTextField({
    Key? key,
    this.hintText = '',
    this.obscureText = false,
    this.focusNode,
    this.controller,
    this.keyboardType,
    this.textInputAction,
    this.onSubmitted,
  }) : super(key: key);

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
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
    return TextField(
      focusNode: widget.focusNode,
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      obscureText: _isObscureText,
      onSubmitted: widget.onSubmitted,
      decoration: InputDecoration(
        filled: true,
        suffixIcon: (widget.keyboardType == TextInputType.visiblePassword) ? IconButton(
          icon: Icon(
            _isObscureText ? Icons.visibility_off : Icons.visibility,
            color: AppColors.subtitle,
          ),
          onPressed: _togglePasswordVisibility,
        ) : null,
        fillColor: AppColors.darkGrey,
        hintText: widget.hintText,
        hintStyle: const TextStyle(color: AppColors.subtitle),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radius),
          borderSide: BorderSide.none, // No border
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), // Padding inside the text field
      ),
      style: const TextStyle(color: AppColors.text), // Text color inside the text field
    );
  }
}
