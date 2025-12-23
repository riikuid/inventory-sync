import 'package:flutter/material.dart';

import '../../../core/styles/color_scheme.dart';

enum DialogType { info, warning, custom }

class AppDialog {
  static Future<void> show({
    required BuildContext context,
    DialogType type = DialogType.warning,
    String? title,
    String? description,
    String? confirmText,
    String? cancelText,
    Function(String? value)?
    onConfirm, // sekarang bisa nerima value dari textfield
    VoidCallback? onCancel,
    IconData? icon,
    Color? color,

    // 🔹 parameter tambahan untuk text field
    bool showTextField = false,
    String? textFieldLabel,
    String? textFieldHint,
    TextEditingController? textController,
  }) {
    // default state
    final controller = textController ?? TextEditingController();

    // ===== Default Behavior berdasarkan type =====
    String defaultTitle = 'Are you sure?';
    String defaultDescription = 'Are you sure you want to do this action?';
    IconData defaultIcon = Icons.warning_amber_rounded;
    Color defaultColor = Colors.redAccent;

    if (type == DialogType.info) {
      defaultTitle = 'Information';
      defaultDescription = 'This is an informational message.';
      defaultIcon = Icons.info_outline_rounded;
      defaultColor = AppColors.primary;
    }

    // untuk custom — override
    final usedIcon = icon ?? defaultIcon;
    final usedColor = color ?? defaultColor;

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext ctx) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 5,
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ===== Icon bulat di atas =====
                CircleAvatar(
                  radius: 30,
                  backgroundColor: usedColor.withOpacity(0.1),
                  child: Icon(usedIcon, size: 36, color: usedColor),
                ),
                const SizedBox(height: 20),
                // ===== Title =====
                Text(
                  title ?? defaultTitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: usedColor,
                  ),
                ),
                const SizedBox(height: 12),
                // ===== Description =====
                Text(
                  description ?? defaultDescription,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.onSecondary,
                    height: 1.4,
                  ),
                ),

                // ===== Optional TextField =====
                if (showTextField) ...[
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      textFieldLabel ?? 'Reason',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: controller,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: textFieldHint ?? 'Enter reason here...',
                      filled: true,
                      fillColor: AppColors.surface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: AppColors.border),
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 25),
                // ===== Buttons =====
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: AppColors.surface,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(ctx);
                          if (onCancel != null) onCancel();
                        },
                        child: Text(
                          cancelText ?? 'Cancel',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.onSurface,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: usedColor,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(ctx);
                          if (onConfirm != null)
                            onConfirm(controller.text.trim());
                        },
                        child: Text(
                          confirmText ?? 'Confirm',
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
