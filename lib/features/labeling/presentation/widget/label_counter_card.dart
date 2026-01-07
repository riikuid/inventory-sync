import 'package:flutter/material.dart';

import '../../../../core/styles/app_style.dart';
import '../../../../core/styles/color_scheme.dart';

class LabelCounterCard extends StatefulWidget {
  final int initialValue;
  final int min;
  final int max;
  final Function(int) onChanged;

  const LabelCounterCard({
    Key? key,
    this.initialValue = 1,
    this.min = 1,
    this.max = 10,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<LabelCounterCard> createState() => _LabelCounterCardState();
}

class _LabelCounterCardState extends State<LabelCounterCard> {
  late int _currentValue;

  // Warna diambil dari gambar (approx)
  final Color _goldColor = const Color(0xFFA69363);
  final Color _greyBtnColor = const Color(0xFFF4F4F4);
  final Color _textGrey = const Color(0xFF757575);

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialValue;
  }

  void _decrement() {
    if (_currentValue > widget.min) {
      setState(() {
        _currentValue--;
      });
      widget.onChanged(_currentValue);
    }
  }

  void _increment() {
    if (_currentValue < widget.max) {
      setState(() {
        _currentValue++;
      });
      widget.onChanged(_currentValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        border: Border.all(width: 1.0, color: AppColors.border),
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [AppStyle.defaultBoxShadow],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Bagian Kiri: Teks
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Jumlah Label",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Tentukan berapa label yang akan dicetak",
                  style: TextStyle(fontSize: 14, color: _textGrey, height: 1.3),
                ),
              ],
            ),
          ),

          const SizedBox(width: 16),

          // Bagian Kanan: Counter Controls
          Row(
            children: [
              // Tombol Minus
              _buildButton(
                icon: Icons.remove,
                bgColor: _greyBtnColor,
                iconColor: Colors.black54,
                onTap: _currentValue > widget.min ? _decrement : null,
                isActive: _currentValue > widget.min,
              ),

              // Angka Value
              Container(
                constraints: const BoxConstraints(minWidth: 40),
                alignment: Alignment.center,
                child: Text(
                  '$_currentValue',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // Tombol Plus
              _buildButton(
                icon: Icons.add,
                bgColor: AppColors.secondary,
                iconColor: AppColors.onSurface,
                onTap: _currentValue < widget.max ? _increment : null,
                isActive: _currentValue < widget.max,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required IconData icon,
    required Color bgColor,
    required Color iconColor,
    required VoidCallback? onTap,
    required bool isActive,
  }) {
    return Material(
      color: isActive ? bgColor : bgColor.withOpacity(0.5),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          child: Icon(
            icon,
            color: isActive ? iconColor : iconColor.withOpacity(0.5),
            size: 20,
          ),
        ),
      ),
    );
  }
}
