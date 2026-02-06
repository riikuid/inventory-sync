// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final bool? isLoading;
  final bool? isEnabled;
  final Color? color;
  final double? width;
  final double? height;
  final double? elevation;
  final Color? borderColor;
  final Color? foregroundColor;
  final bool? reverseLoading;
  final double? borderWidth;
  final double? radius;
  final EdgeInsetsGeometry? padding;
  const CustomButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.isLoading = false,
    this.reverseLoading = false,
    this.isEnabled = true,
    this.color,
    this.width,
    this.height,
    this.elevation,
    this.borderColor,
    this.borderWidth,
    this.radius,
    this.padding,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isEnabled!
          ? !isLoading!
                ? onPressed
                : () {}
          : () {},
      style: ElevatedButton.styleFrom(
        elevation: elevation ?? 1,
        padding: padding ?? EdgeInsets.symmetric(horizontal: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(radius ?? 6)),
          side: borderColor != null
              ? BorderSide(color: borderColor!, width: borderWidth ?? 1)
              : BorderSide.none,
        ),
        backgroundColor: isEnabled!
            ? !isLoading!
                  ? color ?? Theme.of(context).colorScheme.primary
                  : reverseLoading!
                  ? Colors.white
                  : Colors.grey
            : Colors.grey,
        foregroundColor:
            foregroundColor ??
            Theme.of(context).colorScheme.primary.withOpacity(0.3),
        shadowColor: elevation != 0 ? null : Colors.transparent,
        minimumSize: Size(width ?? double.infinity, height ?? 40),
      ),
      child: !isLoading!
          ? child
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 15,
                  width: 15,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    color: reverseLoading!
                        ? Theme.of(context).colorScheme.primary
                        : Colors.white,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  "Loading",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: reverseLoading!
                        ? Theme.of(context).colorScheme.primary
                        : Colors.white,
                  ),
                ),
              ],
            ),
    );
  }
}
