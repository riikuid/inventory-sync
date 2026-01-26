import 'package:flutter/material.dart';

import '../../../core/styles/color_scheme.dart';

class SearchFieldWidget extends StatelessWidget {
  final TextEditingController? controller;
  final bool? enabled;
  final String? hintText;
  final FocusNode? focusNode;
  final Function(String)? onSubmitted;
  final Function(String)? onChanged;
  final VoidCallback? onClear;
  const SearchFieldWidget({
    super.key,
    this.controller,
    this.onSubmitted,
    this.onChanged,
    this.onClear,
    this.focusNode,
    this.hintText,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 4, right: 16, top: 4, bottom: 4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.onSurface.withAlpha(30),
            blurRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // SizedBox(width: 8),
          const SizedBox(width: 10),
          // CircleAvatar(
          //   backgroundColor: AppColors.background,
          //   child:
          // ),
          Icon(Icons.search_rounded, color: AppColors.onSecondary),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              enabled: enabled,
              controller: controller,
              focusNode: focusNode,
              textInputAction: TextInputAction.search,
              onSubmitted: onSubmitted,
              onChanged: onChanged,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 10,
                ),
                hintText:
                    hintText ??
                    'Cari kode / nama barang (mis. 030, Bearing...)',
                border: InputBorder.none,
                isDense: true,
                hintStyle: TextStyle(
                  color: AppColors.onSurface.withOpacity(0.45),
                  fontSize: 14,
                ),
              ),
              style: const TextStyle(fontSize: 14),
            ),
          ),
          if (controller != null && controller!.text.isNotEmpty)
            GestureDetector(
              onTap: onClear,
              child: Icon(
                Icons.close_rounded,
                size: 18,
                color: AppColors.onSurface.withOpacity(0.5),
              ),
            ),
        ],
      ),
    );
  }
}
