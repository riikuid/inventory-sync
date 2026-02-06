// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/styles/color_scheme.dart';

class TextFieldWidget extends StatelessWidget {
  final String? label;
  final String? hintText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool required;
  final bool readonly;
  final bool obscureText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final TextStyle? errorStyle;
  final TextStyle? hintStyle;
  final int? maxLines;
  final int? minLines;
  final FontWeight? fontWeight;
  final Color? color;
  final int? maxCharValidation;
  final int? minCharValidation;
  final Color? fillColor;
  final TextAlign? textAlign;
  final Color? labelColor;
  final InputBorder? border;
  final Function(String value)? onChanged;
  final FocusNode? focusNode;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final AutovalidateMode? autovalidateMode;
  final GlobalKey<FormFieldState>? formFieldKey;
  final GlobalKey? scrollAnchorKey;
  final VoidCallback? onFieldTap;
  final EdgeInsetsGeometry? contentPadding;
  final String? requiredMark;
  final TextInputAction? textInputAction;
  const TextFieldWidget({
    super.key,
    this.label,
    this.hintText,
    this.controller,
    this.validator,
    required this.required,
    this.readonly = false,
    this.obscureText = false,
    this.suffixIcon,
    this.errorStyle,
    this.hintStyle,
    this.maxLines = 1,
    this.minLines,
    this.fontWeight,
    this.color,
    this.maxCharValidation,
    this.minCharValidation,
    this.fillColor,
    this.textAlign,
    this.labelColor,
    this.border,
    this.onChanged,
    this.focusNode,
    this.inputFormatters,
    this.keyboardType,
    this.autovalidateMode,
    this.formFieldKey,
    this.scrollAnchorKey,
    this.onFieldTap,
    this.contentPadding,
    this.requiredMark,
    this.prefixIcon,
    this.textInputAction,
  });

  @override
  Widget build(BuildContext context) {
    Color defaultColor = AppColors.onSurface;

    // InputBorder? inputBorder = OutlineInputBorder(
    //   borderRadius: const BorderRadius.all(Radius.circular(15)),
    //   borderSide: BorderSide(color: defaultColor, width: 1),
    // );
    InputBorder? inputBorder =
        border ??
        OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          borderSide: BorderSide.none,
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Container(
            key: scrollAnchorKey,
            margin: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Text(
                  label ?? '',
                  style: TextStyle(
                    color: labelColor ?? defaultColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                Text(
                  requiredMark ?? (required ? ' *' : ''),
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ],
            ),
          ),
        TextFormField(
          maxLength: maxCharValidation,
          maxLengthEnforcement: MaxLengthEnforcement.enforced,

          textInputAction: textInputAction,
          onTap: onFieldTap,
          key: formFieldKey,
          controller: controller,
          obscureText: obscureText,
          focusNode: focusNode,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          onChanged: onChanged,
          maxLines: maxLines,
          readOnly: readonly,
          minLines: minLines,
          autovalidateMode: autovalidateMode,
          validator:
              validator ??
              (value) {
                final normalized = normalizeSpaces(value);

                if (normalized.isEmpty && required) {
                  return '${(label ?? 'input')} field is required.';
                }

                if (minCharValidation != null &&
                    normalized.length < minCharValidation!) {
                  return 'Must be at least $minCharValidation characters.';
                }

                if (maxCharValidation != null &&
                    normalized.length > maxCharValidation!) {
                  return 'Must not exceed $maxCharValidation characters.';
                }

                return null;
              },
          textAlign: textAlign ?? TextAlign.start,
          style: TextStyle(
            color: color ?? defaultColor,
            fontSize: 16,
            fontWeight: fontWeight ?? FontWeight.w600,
          ),
          decoration: InputDecoration(
            contentPadding: contentPadding,
            counterText: '',
            isDense: true,
            suffixIcon: suffixIcon,
            prefixIcon: prefixIcon,
            hintText: hintText,
            errorStyle: errorStyle,
            fillColor: fillColor ?? Colors.grey.shade200,
            filled: true,
            hintStyle: hintStyle ?? TextStyle(color: Colors.grey.shade500),
            focusedBorder: inputBorder,
            errorBorder: inputBorder,
            focusedErrorBorder: inputBorder,
            enabledBorder: inputBorder,
          ),
        ),
      ],
    );
  }

  String normalizeSpaces(String? input) {
    if (input == null) return '';
    return input
        .trim() // hapus spasi depan & belakang
        .replaceAll(RegExp(r'\s+'), ' '); // jadikan spasi antar kata = 1
  }
}
