// lib/features/labeling/presentation/screens/generate_label_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_sync_apps/core/db/model/variant_component_row.dart';
import 'package:inventory_sync_apps/core/styles/text_theme.dart';
import 'package:inventory_sync_apps/core/user_storage.dart';
import 'package:inventory_sync_apps/core/utils/custom_back_button.dart';
import 'package:inventory_sync_apps/core/utils/custom_toast.dart';
import 'package:inventory_sync_apps/features/auth/models/user.dart';
import 'package:inventory_sync_apps/features/labeling/data/labeling_repository.dart';
import 'package:inventory_sync_apps/features/labeling/presentation/bloc/set_item/assembly_cubit.dart';
import 'package:inventory_sync_apps/features/labeling/presentation/screens/set_print_screen.dart';

import 'package:inventory_sync_apps/core/db/app_database.dart';
import 'package:inventory_sync_apps/features/purchase_order/bloc/receiving_session/receiving_session_cubit.dart';
import 'package:inventory_sync_apps/features/purchase_order/screen/purchase_order_detail_screen.dart';
import 'package:inventory_sync_apps/shared/presentation/widgets/receiving_session_banner.dart';
import 'package:inventory_sync_apps/shared/presentation/widgets/text_field_widget.dart';
import '../../../../core/db/model/variant_detail_row.dart';
import '../../../../core/styles/color_scheme.dart';
import '../../../../shared/presentation/widgets/primary_button.dart';
import '../bloc/single_item/create_labels_cubit.dart';
import '../widget/label_counter_card.dart';
import 'single_print_screen.dart';
import '../../../../shared/presentation/widgets/uom_picker_sheet.dart';

class LabelSetupScreen extends StatefulWidget {
  final VariantDetailRow variant;
  // final int userId;

  // Tambahan: Jika ini diisi, berarti kita sedang melabeli KOMPONEN SEPARATE
  final List<VariantComponentRow>? components;
  final String? componentId;
  final String? componentName;
  final String? componentManuf;

  const LabelSetupScreen({
    super.key,
    required this.variant,
    // required this.userId,
    this.components,
    this.componentId,
    this.componentName,
    this.componentManuf,
  });

  @override
  State<LabelSetupScreen> createState() => _LabelSetupScreenState();
}

class _LabelSetupScreenState extends State<LabelSetupScreen> {
  int _qty = 1;
  String? _selectedRackId;
  String? _selectedRackName; // optional show

  bool get isComponentMode => widget.componentId != null;
  String get targetName =>
      isComponentMode ? widget.componentName! : widget.variant.name;
  String get targetManufCode => isComponentMode
      ? widget.componentManuf ?? ''
      : widget.variant.manufCode ?? '';

  final TextEditingController _contentQtyController = TextEditingController(
    text: "1",
  );

  @override
  void initState() {
    super.initState();
    _selectedRackId = widget.variant.rackId;
    _selectedRackName = widget.variant.rackName;
    context.read<CreateLabelsCubit>().loadUoms(
      defaultUomId: widget.variant.uomId,
    );

    // Listen to changes to update cubit
    _contentQtyController.addListener(() {
      final text = _contentQtyController.text;
      final n = int.tryParse(text) ?? 1;
      context.read<CreateLabelsCubit>().setContentQty(n < 1 ? 1 : n);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onGenerateSingleItem({String? poNumber, int? setPrice}) async {
    User _user = (await UserStorage.getUser())!;
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
      price: setPrice,
      variantId: widget.variant.variantId, // Tetap kirim variant ID
      companyCode: widget.variant.companyCode,
      rackId: _selectedRackId,
      itemName: targetName,
      rackName: _selectedRackName ?? '-',
      qty: _qty,
      userId: _user.id!,
      // Pass component params
      componentId: widget.componentId,
      manufCode: widget.variant.manufCode,
      // Pass default variant UOM
      variantUomId: widget.variant.uomId,
      variantUomName: widget.variant.uom,
      poNumber: poNumber,
    );

    final state = cubit.state;
    if (state.status == CreateLabelsStatus.generated &&
        state.items.isNotEmpty) {
      // navigate to preview
      bool result = await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: cubit,
            child: SinglePrintScreen(
              userId: _user.id!,
              companyCode: widget.variant.companyCode,
              userPurchasingId: _user.purchasingAppId,
              manufcode: isComponentMode
                  ? '${widget.componentManuf}'
                  : widget.variant.manufCode ?? '-',
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

  void _onGenerateSetItem({String? poNumber, int? setPrice}) async {
    User _user = (await UserStorage.getUser())!;

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

    bool? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (context) => AssemblyCubit(
            RepositoryProvider.of<LabelingRepository>(context),
            widget.variant.variantId,
            widget.variant.name,
          ),
          child: SetPrintScreen(
            userPurchasingId: _user.purchasingAppId,
            variantManufCode: widget.variant.manufCode ?? '',
            rackName: widget.variant.rackName ?? '',
            rackId: widget.variant.rackId ?? '',
            targetComponents: widget.variant.componentsInBox,
            variantId: widget.variant.variantId,
            variantName: widget.variant.name,
            companyCode: widget.variant.companyCode,
            userId: _user.id!,
            quantity: _qty,
            poNumber: poNumber,
            variantRow: widget.variant,
            setPrice: setPrice,
          ),
        ),
      ),
    );

    if (result == true) {
      if (mounted) Navigator.pop(context, true);
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
    return BlocBuilder<ReceivingSessionCubit, ReceivingSessionState>(
      builder: (context, sessionState) {
        bool isValidPO() {
          if (!sessionState.isActive) return true; // Normal flow

          int batchQty = _qty;
          int contentQty = int.tryParse(_contentQtyController.text) ?? 1;
          int totalRequest = batchQty * contentQty;

          return totalRequest <= sessionState.qtyRemaining;
        }

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            iconTheme: IconThemeData(color: AppColors.onSurface),
            leading: CustomBackButton(),
            backgroundColor: AppColors.background,
            elevation: 0.5,
            bottom: const PreferredSize(
              preferredSize: Size.fromHeight(1),
              child: Divider(height: 1, thickness: 1),
            ),
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
              border: Border(
                top: BorderSide(width: 0.2, color: AppColors.border),
              ),
            ),
            child: CustomButton(
              elevation: 0,
              radius: 40,
              height: 50,
              color: AppColors.primary,
              onPressed: () {
                if (sessionState.isActive && !isValidPO()) {
                  CustomToast.error(
                    context,
                    title: 'Gagal',
                    description: 'Jumlah total melebihi sisa PO!',
                  );
                  return;
                }

                if (widget.components != null &&
                    widget.components!.isNotEmpty) {
                  _onGenerateSetItem(
                    poNumber: sessionState.poNumber,
                    setPrice: sessionState.setPrice,
                  );
                } else {
                  _onGenerateSingleItem(
                    poNumber: sessionState.poNumber,
                    setPrice: sessionState.setPrice,
                  );
                }
              },

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
          body: SingleChildScrollView(
            controller: ScrollController(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (sessionState.isActive) ...[
                    ReceivingSessionBanner(state: sessionState),
                    SizedBox(height: 12),
                  ],
                  if (sessionState.isActive)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Builder(
                        builder: (context) {
                          //  int batch = int.tryParse(_batchQtyController.text) ?? 1;
                          int batch = _qty;
                          int content =
                              int.tryParse(_contentQtyController.text) ?? 1;
                          int total = batch * content;
                          int sisa = sessionState.qtyRemaining;
                          bool isOver = total > sisa;

                          return Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: isOver
                                  ? Colors.red.shade50
                                  : Colors.blue.shade50,
                              border: Border.all(
                                color: isOver ? Colors.red : Colors.blue,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              "Total Barang: $total (Sisa PO: $sisa)",
                              style: TextStyle(
                                color: isOver
                                    ? Colors.red
                                    : Colors.blue.shade900,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
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
                          spacing: 10,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                targetName,
                                style: AppTextStyles.mono.copyWith(
                                  color: AppColors.primary,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
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
                            '$targetManufCode ${targetManufCode.isNotEmpty && (widget.variant.rackName != null && widget.variant.rackName!.isNotEmpty) ? '  •  ' : ''}${widget.variant.rackName ?? ''}',
                            style: TextStyle(
                              color: AppColors.onBackground,
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                          ),
                        ],
                        // if (widget.components != null &&
                        //     widget.components!.isNotEmpty) ...[
                        //   // SizedBox(height: 5),
                        //   ...widget.components!.map((e) {
                        //     return Container(
                        //       margin: EdgeInsets.only(top: 5),
                        //       decoration: BoxDecoration(
                        //         color: AppColors.surface.withAlpha(150),
                        //         borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        //       ),
                        //       child: Row(children: [Text(e.name)]),
                        //     );
                        //   }),
                        // ],

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

                  // ----------- NEW FEATURE: CONTENT CONFIG -----------
                  if (widget.components == null || widget.components!.isEmpty)
                    BlocBuilder<CreateLabelsCubit, CreateLabelsState>(
                      builder: (context, state) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              width: 1.0,
                              color: AppColors.border,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CheckboxListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Text(
                                  "1 LABEL MEMILIKI ISI?",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.onSurface,
                                  ),
                                ),
                                subtitle: Text(
                                  "Aktifkan jika label mewakili banyak item",
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 12,
                                  ),
                                ),
                                value: state.isMultiContent,
                                onChanged: (val) {
                                  context
                                      .read<CreateLabelsCubit>()
                                      .toggleMultiContent(val ?? false);
                                },
                              ),
                              if (state.isMultiContent) ...[
                                Divider(),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: TextFieldWidget(
                                        label: 'Jumlah Isi',
                                        controller: _contentQtyController,
                                        keyboardType: TextInputType.number,
                                        required: true,
                                        // onChanged handled by listener
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      flex: 2,
                                      child: TextFieldWidget(
                                        label: 'Satuan',
                                        hintText: 'Pilih Satuan',
                                        controller: TextEditingController(
                                          text: state.contentUom?.name ?? '',
                                        ),
                                        readonly: true,
                                        // suffixIcon: Icon(
                                        //   Icons.keyboard_arrow_down,
                                        // ),
                                        required: false,
                                        // onFieldTap: () async {
                                        //   final selected =
                                        //       await showModalBottomSheet<Uom>(
                                        //         context: context,
                                        //         isScrollControlled: true,
                                        //         backgroundColor: Colors.white,
                                        //         shape:
                                        //             const RoundedRectangleBorder(
                                        //               borderRadius:
                                        //                   BorderRadius.vertical(
                                        //                     top:
                                        //                         Radius.circular(
                                        //                           20,
                                        //                         ),
                                        //                   ),
                                        //             ),
                                        //         builder: (ctx) =>
                                        //             UomPickerSheet(
                                        //               uoms: state.uomList,
                                        //             ),
                                        //       );
                                        // if (selected != null) {
                                        //   context
                                        //       .read<CreateLabelsCubit>()
                                        //       .setContentUom(selected);
                                        // }
                                        // },
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  width: double.infinity,
                                  margin: const EdgeInsets.only(bottom: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: Colors.blue.withOpacity(0.3),
                                    ),
                                  ),
                                  child: Text(
                                    "Preview: 1 label = ${state.contentQty} ${state.contentUom?.name ?? 'pcs'}",
                                    style: TextStyle(
                                      color: Colors.blue.shade800,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        );
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
          ),
        );
      },
    );
  }
}
