import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldWidget extends StatelessWidget {
  final String? label;
  final String? hintText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool required;
  final bool readonly;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextStyle? errorStyle;
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
  const TextFieldWidget({
    super.key,
    this.controller,
    this.hintText,
    this.fontWeight,
    this.textAlign,
    this.labelColor,
    this.errorStyle,
    this.maxLines = 1,
    this.maxCharValidation,
    this.label,
    this.fillColor,
    this.border,
    this.validator,
    this.focusNode,
    this.onChanged,
    this.minLines,
    this.readonly = false,
    this.inputFormatters,
    this.suffixIcon,
    this.keyboardType,
    this.color,
    this.obscureText = false,
    this.required = false,
    this.minCharValidation,
    this.formFieldKey,
    this.scrollAnchorKey,
    this.autovalidateMode,
  });

  @override
  Widget build(BuildContext context) {
    Color defaultColor = Theme.of(context).colorScheme.primary;

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
            margin: const EdgeInsets.only(bottom: 6),
            child: Text(
              '${label ?? ''}${required ? ' *' : ''}',
              style: TextStyle(color: labelColor ?? defaultColor),
            ),
          ),
        TextFormField(
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
                  return 'Kolom ${(label ?? 'input').toLowerCase()} wajib diisi.';
                }

                if (minCharValidation != null &&
                    normalized.length < minCharValidation!) {
                  return 'Minimal $minCharValidation huruf.';
                }

                if (maxCharValidation != null &&
                    normalized.length > maxCharValidation!) {
                  return 'Tidak boleh lebih dari $maxCharValidation huruf.';
                }

                return null;
              },
          textAlign: textAlign ?? TextAlign.start,
          style: TextStyle(
            color: color ?? defaultColor,
            fontWeight: fontWeight ?? FontWeight.bold,
          ),
          decoration: InputDecoration(
            isDense: true,
            suffixIcon: suffixIcon,
            hintText: hintText,
            errorStyle: errorStyle,
            fillColor: fillColor ?? Colors.grey.shade200,
            filled: true,
            hintStyle: TextStyle(color: Colors.grey.shade500),
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
