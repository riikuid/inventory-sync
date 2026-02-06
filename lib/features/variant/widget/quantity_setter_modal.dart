// lib/shared/presentation/widgets/quantity_setter_modal.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inventory_sync_apps/core/utils/custom_toast.dart';
import '../../../core/styles/color_scheme.dart';
import '../../../core/styles/text_theme.dart';

class QuantitySetterModal extends StatefulWidget {
  final String componentName;
  final int initialQuantity;
  final Function(int) onSave;
  final int? maxQty;

  const QuantitySetterModal({
    super.key,
    required this.componentName,
    this.initialQuantity = 1,
    required this.onSave,
    this.maxQty,
  });

  @override
  State<QuantitySetterModal> createState() => _QuantitySetterModalState();
}

class _QuantitySetterModalState extends State<QuantitySetterModal> {
  late int _quantity;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();

    _quantity = widget.initialQuantity;

    if (widget.maxQty != null && _quantity > widget.maxQty!) {
      _quantity = widget.maxQty!;
    }
    _controller = TextEditingController(text: _quantity.toString());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _increment() {
    if (widget.maxQty != null && _quantity >= widget.maxQty!) {
      CustomToast.warning(
        context,
        title: 'Tidak bisa menambah jumlah',
        description: 'Maksimal jumlah dari PO adalah ${widget.maxQty}',
      );
      return;
    }

    // Validasi Hard Limit (misal max 10 per batch utk printer)
    if (_quantity >= 10) {
      CustomToast.warning(
        context,
        title: 'Tidak bisa menambah jumlah',
        description: 'Maksimal 10 label per batch.',
      );
      return;
    }
    if (_quantity < 999) {
      setState(() {
        _quantity++;
        _controller.text = _quantity.toString();
      });
    }
  }

  void _decrement() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
        _controller.text = _quantity.toString();
      });
    }
  }

  void _onTextChanged(String value) {
    int? parsed = int.tryParse(value);
    if (parsed == null) return;

    if (widget.maxQty != null && parsed > widget.maxQty!) {
      parsed = widget.maxQty!;
      _controller.text = parsed.toString();
      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length),
      ); // Cursor di akhir
      CustomToast.warning(
        context,
        title: 'Tidak bisa menambah jumlah',
        description: 'Maksimal jumlah dari PO adalah $parsed',
      );
    } else if (parsed > 10) {
      parsed = 10; // Hard limit printer
      _controller.text = parsed.toString();
      CustomToast.warning(
        context,
        title: 'Tidak bisa menambah jumlah',
        description: 'Maksimal 10 label per batch.',
      );
    }
    if (parsed != null && parsed >= 1 && parsed <= 999) {
      setState(() {
        _quantity = parsed!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            Text(
              'Set Jumlah Komponen',
              style: AppTextStyles.mono.copyWith(
                color: AppColors.primary,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),

            // Component Name
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                widget.componentName,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Label
            Text(
              'Jumlah komponen yang dibutuhkan dalam 1 set:',
              style: TextStyle(
                color: AppColors.onBackground,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),

            // Stepper
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Minus Button
                IconButton(
                  onPressed: _decrement,
                  icon: const Icon(Icons.remove_circle_outline),
                  iconSize: 40,
                  color: _quantity > 1 ? AppColors.primary : Colors.grey,
                ),

                const SizedBox(width: 20),

                // TextField Quantity
                SizedBox(
                  width: 80,
                  child: TextField(
                    controller: _controller,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(3),
                    ],
                    style: AppTextStyles.mono.copyWith(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: AppColors.border,
                          width: 2,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: AppColors.primary,
                          width: 2,
                        ),
                      ),
                    ),
                    onChanged: _onTextChanged,
                  ),
                ),

                const SizedBox(width: 20),

                // Plus Button
                IconButton(
                  onPressed: _increment,
                  icon: const Icon(Icons.add_circle_outline),
                  iconSize: 40,
                  color: _quantity < 999 ? AppColors.primary : Colors.grey,
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Range hint
            Text(
              'Min: 1  •  Max: 999',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),

            const SizedBox(height: 24),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: BorderSide(color: AppColors.border),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Batal',
                      style: TextStyle(
                        color: AppColors.onBackground,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      widget.onSave(_quantity);
                      Navigator.pop(context);
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Simpan',
                      style: TextStyle(
                        color: AppColors.onSurface,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
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
  }
}
