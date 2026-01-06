import 'package:flutter/material.dart';

import '../../../core/styles/color_scheme.dart';

class SearchFieldWidget extends StatelessWidget {
  final TextEditingController? controller;
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
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 6, right: 16, top: 4, bottom: 4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.onSurface.withOpacity(0.04),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          // SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: AppColors.primary,
            child: Icon(Icons.search_rounded, color: AppColors.surface),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
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
