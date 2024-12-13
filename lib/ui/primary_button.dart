import 'package:flutter/material.dart';
import 'package:treveler/style/colors.dart';
import 'package:treveler/style/dimensions.dart';

class PrimaryButton extends StatefulWidget {
  final Function? onPressed;
  final String text;
  final bool withLoading;
  final bool enabled;
  final double? width;

  const PrimaryButton(
      {super.key,
      required this.text,
      required this.onPressed,
      this.withLoading = false,
      this.enabled = true,
      this.width});

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
          minimumSize: Size(widget.width ?? 0, AppSizes.buttonHeight),
          backgroundColor: AppColors.primary,
          disabledBackgroundColor: AppColors.primaryDisabled,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.radius))),
      onPressed: _isLoading
          ? null
          : widget.enabled
              ? () async {
                  if (widget.withLoading) {
                    setState(() {
                      _isLoading = true;
                    });
                  }
                  await widget.onPressed?.call();
                  if (widget.withLoading) {
                    setState(() {
                      _isLoading = false;
                    });
                  }
                }
              : null,
      child: _isLoading
          ? const SizedBox(
              width: 24.0,
              height: 24.0,
              child: Center(
                  child: CircularProgressIndicator(
                color: Colors.white,
              )),
            )
          : Text(widget.text, style: const TextStyle(color: Colors.white, fontSize: 16)),
    );
  }
}
