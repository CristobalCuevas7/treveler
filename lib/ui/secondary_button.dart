import 'package:flutter/material.dart';
import 'package:treveler/style/colors.dart';
import 'package:treveler/style/dimensions.dart';

class SecondaryButton extends StatefulWidget {
  final Function onPressed;
  final String text;
  final bool withLoading;
  final bool enabled;
  final double? width;

  const SecondaryButton(
      {super.key,
      required this.text,
      required this.onPressed,
      this.withLoading = false,
      this.enabled = true,
      this.width});

  @override
  State<SecondaryButton> createState() => _SecondaryButtonState();
}

class _SecondaryButtonState extends State<SecondaryButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith<Color?>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.disabled)) {
              return AppColors.lightGrey;
            }
            return AppColors.white;
          },
        ),
        minimumSize: WidgetStateProperty.all(
            Size(widget.width ?? 0, AppSizes.buttonHeight)),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radius),
          ),
        ),
        side: WidgetStateProperty.resolveWith<BorderSide>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.disabled)) {
              return const BorderSide(color: AppColors.darkGrey);
            }
            return const BorderSide(color: AppColors.primary);
          },
        ),
      ),
      onPressed: _isLoading
          ? null
          : widget.enabled
              ? () async {
                  if (widget.withLoading) {
                    setState(() {
                      _isLoading = true;
                    });
                  }
                  await widget.onPressed.call();
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
                color: AppColors.primary,
              )),
            )
          : Text(widget.text,
              style: TextStyle(
                  color:
                      widget.enabled ? AppColors.primary : AppColors.darkGrey,
                  fontSize: 16)),
    );
  }
}
