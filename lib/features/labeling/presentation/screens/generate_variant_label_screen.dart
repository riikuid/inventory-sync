import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_sync_apps/core/db/daos/variant_dao.dart';

import '../../../../core/styles/app_style.dart';
import '../../../../core/styles/color_scheme.dart';
import '../../../../shared/presentation/widgets/primary_button.dart';
import '../bloc/create_labels/create_labels_cubit.dart';
import '../widget/label_counter_card.dart';
import 'preview_print_screen.dart';

class GenerateLabelsScreen extends StatefulWidget {
  final VariantDetailRow variant;
  final String userId;

  const GenerateLabelsScreen({
    super.key,
    // required this.variantId,
    // required this.variantName,
    // required this.companyCode,
    // required this.defaultRackId,
    // required this.defaultRackName,
    required this.variant,
    required this.userId,
  });

  @override
  State<GenerateLabelsScreen> createState() => _GenerateLabelsScreenState();
}

class _GenerateLabelsScreenState extends State<GenerateLabelsScreen> {
  int _qty = 1;
  String? _selectedRackId;
  String? _selectedRackName; // optional show

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
    if (_selectedRackId == null || _selectedRackId!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih rak terlebih dahulu')),
      );
      return;
    }

    final cubit = context.read<CreateLabelsCubit>();
    await cubit.generate(
      variantId: widget.variant.variantId,
      companyCode: widget.variant.companyCode,
      rackId: _selectedRackId!,
      qty: _qty,
      userId: widget.userId,
    );

    final state = cubit.state;
    if (state.status == CreateLabelsStatus.generated &&
        state.items.isNotEmpty) {
      // navigate to preview
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: cubit,
            child: PreviewPrintScreen(
              userId: widget.userId,
              name: widget.variant.name,
            ),
          ),
        ),
      );
    } else if (state.status == CreateLabelsStatus.failure) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(state.error ?? 'Gagal')));
    }
  }

  // placeholder rack picker — replace with your own picker navigation
  Future<void> _openRackPicker() async {
    // TODO: open your rack picker screen, then set _selectedRackId/_selectedRackName
    // for demo I just toggle
    setState(() {
      _selectedRackId = _selectedRackId == null ? 'default-rack-1' : 'rack-2';
      _selectedRackName = _selectedRackId == 'rack-2' ? 'Rak B2' : 'Rak A1';
    });
  }

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
              'Label Box untuk Varian',
              style: AppStyle.poppinsTextSStyle.copyWith(
                color: AppColors.onSurface,
                fontSize: 15,
                fontWeight: FontWeight.w900,
              ),
            ),
            SizedBox(height: 3),
            Text(
              widget.variant.companyCode,
              style: AppStyle.monoTextStyle.copyWith(
                color: AppColors.primaryDark,
                fontSize: 12,
                fontWeight: FontWeight.w600,
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
          border: Border(
            top: BorderSide(width: 0.3, color: AppColors.secondaryLight),
          ),
        ),
        child: CustomButton(
          elevation: 0,
          radius: 40,
          height: 50,
          color: AppColors.primaryDark,
          onPressed: _onGenerate,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.save_outlined, color: AppColors.surface),
              SizedBox(width: 8),
              Text(
                'Selanjutnya',
                style: AppStyle.poppinsTextSStyle.copyWith(
                  color: AppColors.surface,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
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
                color: AppColors.primaryDark.withAlpha(30),
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
                        widget.variant.companyCode,
                        style: AppStyle.monoTextStyle.copyWith(
                          color: AppColors.secondary,
                          fontSize: 16,
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
                            color: AppColors.primaryLight,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            widget.variant.brandName ?? '-',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryDark,
                            ),
                          ),
                        ),
                    ],
                  ),
                  Text(
                    '${widget.variant.name}${widget.variant.manufCode != null && widget.variant.manufCode!.isNotEmpty ? '  •  ${widget.variant.manufCode}' : ''}',
                    style: AppStyle.poppinsTextSStyle.copyWith(
                      color: AppColors.primaryDark,
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            LabelCounterCard(
              min: 1,
              max: 10,
              initialValue: _qty,
              onChanged: (val) {
                print("Jumlah label sekarang: $val");
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
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _onGenerate,
                child: const Text('Buat & Pratinjau'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
