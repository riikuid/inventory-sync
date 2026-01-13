// lib/features/labeling/presentation/screens/generate_label_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_sync_apps/core/db/daos/variant_dao.dart';
import 'package:inventory_sync_apps/core/styles/text_theme.dart';

import '../../../../core/db/model/variant_detail_row.dart';
import '../../../../core/styles/app_style.dart';
import '../../../../core/styles/color_scheme.dart';
import '../../../../shared/presentation/widgets/primary_button.dart';
import '../bloc/create_labels/create_labels_cubit.dart';
import '../widget/label_counter_card.dart';
import 'preview_print_screen.dart';

class GenerateLabelsScreen extends StatefulWidget {
  final VariantDetailRow variant;
  final int userId;

  // Tambahan: Jika ini diisi, berarti kita sedang melabeli KOMPONEN SEPARATE
  final String? componentId;
  final String? componentName;
  final String? componentManuf;

  const GenerateLabelsScreen({
    super.key,

    required this.variant,
    required this.userId,
    this.componentId,
    this.componentName,
    this.componentManuf,
  });

  @override
  State<GenerateLabelsScreen> createState() => _GenerateLabelsScreenState();
}

class _GenerateLabelsScreenState extends State<GenerateLabelsScreen> {
  int _qty = 1;
  String? _selectedRackId;
  String? _selectedRackName; // optional show

  bool get isComponentMode => widget.componentId != null;
  String get targetName =>
      isComponentMode ? widget.componentName! : widget.variant.name;
  String get targetManufCode => isComponentMode
      ? widget.componentManuf ?? ''
      : widget.variant.manufCode ?? '';

  @override
  void initState() {
    super.initState();
    _selectedRackId = widget.variant.rackId;
    _selectedRackName = widget.variant.rackName;
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onGenerate() async {
    if (_qty <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Qty harus > 0')));
      return;
    }
    // if (_selectedRackId == null || _selectedRackId!.isEmpty) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text('Pilih rak terlebih dahulu')),
    //   );
    //   return;
    // }

    final cubit = context.read<CreateLabelsCubit>();

    await cubit.generate(
      variantId: widget.variant.variantId, // Tetap kirim variant ID
      companyCode: widget.variant.companyCode,
      rackId: _selectedRackId,
      itemName: targetName,
      rackName: _selectedRackName ?? '-',
      qty: _qty,
      userId: widget.userId,
      // Pass component params
      componentId: widget.componentId,
      manufCode: isComponentMode
          ? widget.componentManuf
          : widget.variant.manufCode,
    );

    final state = cubit.state;
    if (state.status == CreateLabelsStatus.generated &&
        state.items.isNotEmpty) {
      // navigate to preview
      bool result = await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: cubit,
            child: PreviewPrintScreen(
              userId: widget.userId,
              companyCode: widget.variant.companyCode,

              manufcode: isComponentMode
                  ? '${widget.componentManuf}'
                  : widget.variant.manufCode ?? '',
              rackName: _selectedRackName ?? '',
            ),
          ),
        ),
      );
      if (result == true) {
        if (mounted) Navigator.pop(context, true);
      }
    } else if (state.status == CreateLabelsStatus.failure) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(state.error ?? 'Gagal')));
    }
  }

  // placeholder rack picker — replace with your own picker navigation
  // Future<void> _openRackPicker() async {
  //   // TODO: open your rack picker screen, then set _selectedRackId/_selectedRackName
  //   // for demo I just toggle
  //   setState(() {
  //     _selectedRackId = _selectedRackId == null ? 'default-rack-1' : 'rack-2';
  //     _selectedRackName = _selectedRackId == 'rack-2' ? 'Rak B2' : 'Rak A1';
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColors.onSurface),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_rounded, color: AppColors.onSurface),
        ),
        backgroundColor: AppColors.background,
        elevation: 0.5,
        toolbarHeight: 60,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isComponentMode ? 'Label Komponen' : 'Label Unit Box',
              style: TextStyle(
                color: AppColors.onSurface,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 3),
            Text(
              widget.variant.companyCode,
              style: AppTextStyles.mono.copyWith(
                color: AppColors.primary,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.background,
          border: Border(top: BorderSide(width: 0.2, color: AppColors.border)),
        ),
        child: CustomButton(
          elevation: 0,
          radius: 40,
          height: 50,
          color: AppColors.primary,
          onPressed: _onGenerate,
          child: Text(
            'SELANJUTNYA',
            style: TextStyle(
              letterSpacing: 1.2,
              color: AppColors.surface,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(width: 1.0, color: AppColors.border),
                color: AppColors.primary.withAlpha(30),
                borderRadius: BorderRadius.circular(16),
              ),
              margin: const EdgeInsets.only(bottom: 24),
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        targetName,
                        style: AppTextStyles.mono.copyWith(
                          color: AppColors.primary,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (widget.variant.brandName != null &&
                          widget.variant.brandName!.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1.0,
                              color: AppColors.primary,
                            ),
                            color: AppColors.primary.withAlpha(50),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            widget.variant.brandName ?? '-',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                    ],
                  ),
                  Text(
                    widget.variant.companyCode,
                    style: TextStyle(
                      color: AppColors.onBackground,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                  if (targetManufCode.isNotEmpty ||
                      (widget.variant.rackName ?? '').isNotEmpty) ...[
                    SizedBox(height: 2),
                    Text(
                      // '${widget.variant.rackName}',
                      '$targetManufCode${targetManufCode.isNotEmpty && widget.variant.rackName!.isNotEmpty ? '  •  ' : ''}${widget.variant.rackName}',
                      style: TextStyle(
                        color: AppColors.onBackground,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                  ],
                  // if (isComponentMode)
                  //   Text(
                  //     'Bagian dari: ${widget.variant.name}',
                  //     style: TextStyle(fontSize: 10, color: Colors.grey),
                  //   ),
                ],
              ),
            ),
            LabelCounterCard(
              min: 1,
              max: 10,
              initialValue: _qty,
              onChanged: (val) {
                // print("Jumlah label sekarang: $val");
                setState(() {
                  _qty = val;
                });
              },
            ),
            const SizedBox(height: 12),

            // ListTile(
            //   title: Text(_selectedRackName ?? 'Pilih Rak'),
            //   subtitle: _selectedRackId != null ? Text(_selectedRackId!) : null,
            //   trailing: const Icon(Icons.arrow_forward_ios),
            //   onTap: _openRackPicker,
            // ),
            // const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
