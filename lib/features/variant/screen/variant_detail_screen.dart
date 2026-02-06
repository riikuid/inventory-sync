// lib/features/inventory/presentation/screens/variant_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_sync_apps/core/constant.dart';

import 'package:inventory_sync_apps/core/styles/color_scheme.dart';
import 'package:inventory_sync_apps/core/utils/custom_back_button.dart';
import 'package:inventory_sync_apps/core/utils/custom_toast.dart';
import 'package:inventory_sync_apps/core/utils/loading_overlay.dart';
import 'package:inventory_sync_apps/features/inventory/presentation/screens/component_picker_screen.dart';
import 'package:inventory_sync_apps/features/labeling/presentation/bloc/single_item/create_labels_cubit.dart';
import 'package:inventory_sync_apps/features/labeling/presentation/screens/label_setup_screen.dart';
import 'package:inventory_sync_apps/features/purchase_order/bloc/receiving_session/receiving_session_cubit.dart';
import 'package:inventory_sync_apps/features/purchase_order/screen/purchase_order_detail_screen.dart';
import 'package:inventory_sync_apps/features/unit/screen/variant_unit_list_screen.dart';
import 'package:inventory_sync_apps/shared/presentation/widgets/primary_button.dart';
import 'package:inventory_sync_apps/shared/presentation/widgets/receiving_session_banner.dart';
import '../../../core/db/model/variant_detail_row.dart';
import '../../../core/styles/app_style.dart';
import '../../../core/styles/text_theme.dart';
import '../../../shared/presentation/widgets/image_carousel.dart';
import '../../labeling/data/labeling_repository.dart';
import '../../inventory/data/inventory_repository.dart';
import '../../labeling/presentation/bloc/set_item/assembly_cubit.dart';
import '../../labeling/presentation/screens/set_print_screen.dart';
import '../bloc/variant_detail/variant_detail_cubit.dart';
import '../widget/quantity_setter_modal.dart';
import 'edit_variant_screen.dart';

class VariantDetailScreen extends StatelessWidget {
  final String variantId;
  final int userId;

  const VariantDetailScreen({
    super.key,
    required this.variantId,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    final repo = context.read<InventoryRepository>();
    final labelingRepo = context.read<LabelingRepository>();

    return BlocProvider(
      create: (_) {
        final cubit = VariantDetailCubit(
          repo: repo,
          labelingRepo: labelingRepo,
        );
        cubit.watchDetail(variantId);
        return cubit;
      },
      child: _VariantDetailView(userId: userId),
    );
  }
}

class _VariantDetailView extends StatelessWidget {
  final int userId;
  const _VariantDetailView({required this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VariantDetailCubit, VariantDetailState>(
      listener: (ctx, state) {
        if (state is VariantDetailLoaded && state.errorMessage != null) {
          ScaffoldMessenger.of(
            ctx,
          ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
        } else if (state is VariantDetailError) {
          ScaffoldMessenger.of(
            ctx,
          ).showSnackBar(SnackBar(content: Text('Error: ${state.message}')));
        }
      },
      builder: (ctx, state) {
        if (state is VariantDetailLoading || state is VariantDetailInitial) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (state is VariantDetailError) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(child: Text('Error: ${state.message}')),
          );
        }
        if (state is VariantDetailLoaded) {
          final d = state.detail;
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              iconTheme: IconThemeData(color: AppColors.onSurface),
              backgroundColor: AppColors.background,
              leading: CustomBackButton(),
              title: Text(
                d.companyCode,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.mono.copyWith(
                  color: AppColors.onSurface,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              foregroundColor: Colors.transparent,
              bottom: const PreferredSize(
                preferredSize: Size.fromHeight(1),
                child: Divider(height: 1, thickness: 1),
              ),
              elevation: 1,
              actions: [
                // Menu Edit
                PopupMenuButton<String>(
                  icon: Icon(Icons.more_vert, color: AppColors.onSurface),
                  onSelected: (value) {
                    if (value == 'edit') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EditVariantScreen(
                            variantId: d.variantId,
                            userId: userId,
                            companyCode: d.companyCode,
                            productName: d.name,
                            hasStock: false,
                            // hasStock: _hasStock(d),
                          ),
                        ),
                      ).then((result) {
                        // Refresh jika berhasil edit
                        if (result == true) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Variant berhasil diperbarui'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      });
                      // Cek apakah variant sudah punya stok
                      // if (_hasStock(d)) {
                      //   // Tampilkan warning jika sudah ada stok
                      //   showDialog(
                      //     context: context,
                      //     builder: (ctx) => AlertDialog(
                      //       title: Text(
                      //         "Tidak Dapat Mengedit",
                      //         style: AppTextStyles.mono.copyWith(
                      //           color: AppColors.onSurface,
                      //           fontSize: 18,
                      //           fontWeight: FontWeight.w600,
                      //         ),
                      //       ),
                      //       content: Text(
                      //         "Variant yang sudah memiliki stok tidak dapat diedit untuk menjaga konsistensi data.",
                      //         style: TextStyle(
                      //           color: AppColors.onBackground,
                      //           fontSize: 14,
                      //           fontWeight: FontWeight.w400,
                      //         ),
                      //       ),
                      //       actions: [
                      //         TextButton(
                      //           onPressed: () => Navigator.pop(ctx),
                      //           child: Text(
                      //             "Mengerti",
                      //             style: TextStyle(
                      //               color: AppColors.primary,
                      //               fontSize: 16,
                      //               fontWeight: FontWeight.w600,
                      //             ),
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   );
                      // } else {
                      //   // Navigate ke EditVariantScreen
                      //   Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (_) => EditVariantScreen(
                      //         variantId: d.variantId,
                      //         userId: userId,
                      //         companyCode: d.companyCode,
                      //         productName: d.name,
                      //       ),
                      //     ),
                      //   ).then((result) {
                      //     // Refresh jika berhasil edit
                      //     if (result == true) {
                      //       ScaffoldMessenger.of(context).showSnackBar(
                      //         SnackBar(
                      //           content: Text('Variant berhasil diperbarui'),
                      //           backgroundColor: Colors.green,
                      //         ),
                      //       );
                      //     }
                      //   });
                      // }
                    }
                  },
                  itemBuilder: (BuildContext context) => [
                    PopupMenuItem<String>(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(
                            Icons.edit_outlined,
                            size: 18,
                            color: AppColors.onBackground,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Edit Variant',
                            style: TextStyle(
                              color: AppColors.onBackground,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),

            bottomNavigationBar:
                BlocBuilder<ReceivingSessionCubit, ReceivingSessionState>(
                  builder: (context, sessionState) {
                    final bool isLocked =
                        sessionState.isActive && sessionState.qtyRemaining <= 0;
                    return Container(
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
                        color: AppColors.secondary,
                        onPressed: isLocked
                            ? () => CustomToast.error(
                                context,
                                title: 'Kuota PO sudah terpenuhi.',
                                description: 'Tidak dapat mencetak label baru',
                              )
                            : () {
                                _verifyComponentCount(context, d, () {
                                  // if (d.componentsInBox.where((c) => c != null).isEmpty) {
                                  if (d.componentsInBox.isEmpty) {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => BlocProvider(
                                          create: (context) =>
                                              CreateLabelsCubit(
                                                context
                                                    .read<LabelingRepository>(),
                                              ),

                                          child: LabelSetupScreen(variant: d),
                                        ),
                                      ),
                                    );
                                  } else {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => BlocProvider(
                                          create: (context) =>
                                              CreateLabelsCubit(
                                                context
                                                    .read<LabelingRepository>(),
                                              ),

                                          child: LabelSetupScreen(
                                            variant: d,
                                            components: d.componentsInBox,
                                          ),
                                        ),
                                      ),
                                    );
                                    // _openAssemblyWithBatch(context, d, userId);
                                  }
                                });
                              },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          spacing: 10,
                          children: [
                            Icon(
                              Icons.print_outlined,
                              size: 18,
                              color: AppColors.onSurface,
                            ),
                            Text(
                              'CETAK LABEL',
                              style: TextStyle(
                                color: AppColors.onSurface,
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
            body: Stack(
              children: [
                BlocBuilder<ReceivingSessionCubit, ReceivingSessionState>(
                  builder: (context, sessionState) {
                    return ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        if (sessionState.isActive) ...[
                          ReceivingSessionBanner(state: sessionState),
                          SizedBox(height: 12),
                        ],
                        _buildDetailHeader(context, d),
                        if (!(d.componentsInBox.isEmpty &&
                            d.componentsSeparate.isEmpty &&
                            d.totalUnits > 0)) ...[
                          if (d.componentsSeparate.isEmpty) ...[
                            const SizedBox(height: 20),
                            _buildInBoxSection(context, d),
                          ],
                        ],
                        const SizedBox(height: 120),
                      ],
                    );
                  },
                ),
                if (state.isBusy)
                  Container(
                    color: Colors.black26,
                    child: const Center(child: CircularProgressIndicator()),
                  ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildDetailHeader(BuildContext context, VariantDetailRow d) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(width: 1.2, color: AppColors.border),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [AppStyle.defaultBoxShadow],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // top row: code and badge stock
            Row(
              children: [
                Expanded(
                  child: Text(
                    d.name,
                    style: AppTextStyles.mono.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                      fontSize: 22,
                    ),
                  ),
                ),

                CustomButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VariantUnitListScreen(variant: d),
                    ),
                  ),
                  height: 20,
                  width: 20,
                  color: AppColors.secondary,
                  borderColor: AppColors.onSecondary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),

                  child: Text(
                    d.totalUnits.toString(),
                    style: const TextStyle(
                      color: AppColors.onSurface,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            // const SizedBox(height: 6),
            Text(
              d.companyCode,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: 2),
            // ignore: unnecessary_null_comparison
            if ((d.rackName != null) || (d.uom != null))
              Text(
                '${d.uom} ${d.rackName == null ? '' : '  •  ${d.rackName}'}',
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),

            if (d.specification != null && d.specification!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  d.specification!,
                  style: TextStyle(color: Colors.grey.shade700),
                ),
              ),
            ],
            const SizedBox(height: 10),
            Row(
              spacing: 10,
              children: [
                if (d.brandName != null && d.brandName!.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      border: Border.all(width: 1.0, color: AppColors.border),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      d.brandName ?? '-',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                if (d.manufCode != null && d.manufCode!.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      border: Border.all(width: 1.0, color: AppColors.border),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      d.manufCode ?? '-',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 20),
            AspectRatio(
              aspectRatio: 1,
              child: ImageCarousel(
                photos: d.photos, // Mengirim List<PhotoRow>
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInBoxSection(BuildContext context, VariantDetailRow d) {
    final inBox = d.componentsInBox.where((c) => c != null).toList();

    final hasAny = d.componentsInBox.isNotEmpty;
    final isLocked = _hasStock(d);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          spacing: 10,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  Icons.archive_outlined,
                  size: 14,
                  color: AppColors.primary,
                ),
                SizedBox(width: 6),
                Text(
                  'KOMPONEN',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            if (!isLocked)
              CustomButton(
                elevation: 0,
                height: 25,
                width: 60,
                radius: 1000,
                color: AppColors.secondary.withAlpha(70),
                borderColor: AppColors.secondary,
                onPressed: () async {
                  final repo = context.read<InventoryRepository>();
                  final result = await Navigator.push<String>(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          ComponentPickerScreen(type: inBoxType, variant: d),
                    ),
                  );
                  if (result != null) {
                    List<String> compIds = d.componentsInBox
                        .map((e) => e.componentId)
                        .toList();

                    if (compIds.contains(result)) {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: Text(
                            "Komponen Sama",
                            style: AppTextStyles.mono.copyWith(
                              color: AppColors.onSurface,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          content: Text(
                            "Anda sudah menambahkan komponen yang sama pada varian ini",
                            style: TextStyle(
                              color: AppColors.onBackground,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx),
                              child: Text(
                                "Oke",
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      await repo.attachComponentToVariant(
                        componentId: result,
                        variantId: d.variantId,
                      );
                    }
                  }
                },
                child: Text(
                  '+ Tambah',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.onAccent,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
        ),
        if (isLocked) SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            boxShadow: [AppStyle.defaultBoxShadow],
            color: Color.fromARGB(255, 53, 67, 139),
            borderRadius: BorderRadius.circular(18),
          ),
          padding: const EdgeInsets.all(12),
          child: hasAny
              ? Column(
                  spacing: 10,
                  children: d.componentsInBox.map((c) {
                    return Row(
                      spacing: 10,
                      children: [
                        GestureDetector(
                          onTap: isLocked
                              ? null
                              : () {
                                  showDialog(
                                    context: context,
                                    builder: (ctx) => QuantitySetterModal(
                                      componentName: c.name,
                                      initialQuantity: c.quantity,
                                      onSave: (newQty) {
                                        context
                                            .read<VariantDetailCubit>()
                                            .updateComponentQuantity(
                                              variantId: d.variantId,
                                              componentId: c.componentId,
                                              newQuantity: newQty,
                                            );
                                      },
                                    ),
                                  );
                                },
                          child: Column(
                            spacing: 5,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: isLocked
                                      ? Colors.grey.shade300
                                      : AppColors.surface,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isLocked
                                        ? Colors.grey.shade400
                                        : AppColors.border,
                                    width: 1.5,
                                  ),
                                ),
                                child: Text(
                                  '${c.quantity}', // 👈 Quantity dari DB
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: isLocked
                                        ? Colors.grey.shade700
                                        : AppColors.onSurface,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              if (!isLocked)
                                Text(
                                  'Edit',
                                  style: TextStyle(
                                    color: AppColors.surface,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                            ],
                          ),
                        ),

                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: ListTile(
                              onLongPress: () {
                                if (!isLocked) {
                                  _detachComponent(
                                    context,
                                    d.variantId,
                                    c.componentId,
                                  );
                                }
                              },
                              tileColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              title: Text(
                                c.name,
                                style: AppTextStyles.mono.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                  color: AppColors.primary,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if ((c.brandName != null) ||
                                      (c.manufCode != null))
                                    Row(
                                      children: [
                                        if ((c.brandName != null))
                                          Text(
                                            '${c.brandName}',
                                            style: TextStyle(
                                              color: AppColors.onSurface,
                                              fontSize: 14,
                                            ),
                                          ),
                                        if ((c.brandName != null) &&
                                            (c.manufCode != null))
                                          Text(
                                            ' - ',
                                            style: TextStyle(
                                              color: AppColors.onSurface,
                                              fontSize: 14,
                                            ),
                                          ),
                                        if ((c.manufCode != null))
                                          Text(
                                            '${c.manufCode}',
                                            style: TextStyle(
                                              color: AppColors.onSurface,
                                              fontSize: 14,
                                            ),
                                          ),
                                      ],
                                    ),
                                ],
                              ),
                              trailing: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.secondary,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '${c.totalUnits}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.onSurface,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                )
              : SizedBox(
                  height: 80,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.archive_outlined,
                          size: 40,
                          color: const Color.fromARGB(255, 194, 194, 194),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Belum ada komponen',
                          style: TextStyle(
                            color: const Color.fromARGB(255, 194, 194, 194),
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildSeparateComponentSection(
    BuildContext context,
    VariantDetailRow d,
  ) {
    // Ideally filter components by type == SEPARATE; repo currently returns components list
    // We'll display same components as sample; in real impl repo should split by type
    final separate = d.componentsSeparate; // assume already filtered
    final isLocked = _hasStock(d);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.layers_outlined, size: 14, color: AppColors.primary),
            SizedBox(width: 6),
            Expanded(
              child: Text(
                'PISAH PER KEMASAN',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: AppColors.primary,
                ),
              ),
            ),
            SizedBox(width: 10),

            if (!isLocked)
              CustomButton(
                elevation: 0,
                height: 25,
                width: 110,
                radius: 1000,
                color: AppColors.secondary.withAlpha(70),
                borderColor: AppColors.secondary,
                onPressed: () async {
                  final repo = context.read<InventoryRepository>();

                  // );

                  final result = await Navigator.push<String>(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          ComponentPickerScreen(type: separateType, variant: d),
                    ),
                  );
                  if (result != null) {
                    await repo.attachComponentToVariant(
                      componentId: result,
                      variantId: d.variantId,
                      // type: separateType,
                    );
                  }
                },

                // icon: const Icon(Icons.add, size: 14, color: AppColors.primary),
                child: Text(
                  '+ Komponen',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.onAccent,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
        ),
        if (isLocked) SizedBox(height: 10),
        Column(
          spacing: 10,
          children: separate.map((c) {
            return GestureDetector(
              onLongPress: () {
                if (!isLocked) {
                  _detachComponent(context, d.variantId, c.componentId);
                } else {}
              },
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [AppStyle.defaultBoxShadow],
                  border: Border.all(width: 1.0, color: AppColors.border),
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(24),
                ),

                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.grey.shade200,
                        child: Text(
                          c.name.isNotEmpty ? c.name[0].toUpperCase() : '?',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              c.name,
                              style: AppTextStyles.mono.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                color: AppColors.primary,
                              ),
                            ),

                            if ((c.brandName != null) ||
                                (c.manufCode != null)) ...[
                              SizedBox(height: 3),
                              Text(
                                '${c.brandName}${c.manufCode != null && c.manufCode!.isNotEmpty ? '  •  ${c.manufCode}' : ''}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.secondary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${c.totalUnits}',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.onSurface,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      CustomButton(
                        elevation: 0.2,
                        width: 30,
                        radius: 15,
                        color: AppColors.surface,
                        borderColor: AppColors.border,

                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => BlocProvider(
                                create: (context) => CreateLabelsCubit(
                                  context.read<LabelingRepository>(),
                                ),

                                child: LabelSetupScreen(
                                  variant: d,
                                  componentId: c.componentId,
                                  componentName: c.name,
                                  componentManuf: c.manufCode,
                                ),
                              ),
                            ),
                          );
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.print_outlined,
                              size: 14,
                              color: AppColors.onBackground,
                            ),
                            SizedBox(width: 5),
                            Text(
                              'Cetak',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.onBackground,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        if (separate.isEmpty)
          Container(
            decoration: BoxDecoration(
              boxShadow: [AppStyle.defaultBoxShadow],
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(24),
            ),
            child: SizedBox(
              height: 120,
              child: Center(
                child: Text(
                  'Belum ada komponen terpisah',
                  style: TextStyle(color: AppColors.onSurface, fontSize: 14),
                ),
              ),
            ),
          ),
      ],
    );
  }

  // Bottom sheet for adding component (existing or create new)

  // Helper 1: Cek apakah Varian ini sudah "terkunci" karena ada stok
  bool _hasStock(VariantDetailRow d) {
    // Cek stok parent
    if (d.totalUnits > 0) return true;

    // Cek stok komponen in box
    if (d.componentsInBox.any((c) => c.totalUnits > 0)) return true;

    // Cek stok komponen separate
    if (d.componentsSeparate.any((c) => c.totalUnits > 0)) return true;

    return false;
  }

  // Helper 2: Modal Warning jika komponen cuma 1
  void _detachComponent(
    BuildContext context,
    String variantId,
    String componentId,
  ) {
    // Jika punya komponen TAPI jumlahnya cuma 1 -> Tampilkan Warning
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          "Lepas Komponen?",
          style: AppTextStyles.mono.copyWith(
            color: AppColors.onSurface,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          "Apakah anda yakin ingin melepas komponen dari varian ini?",
          style: TextStyle(
            color: AppColors.onBackground,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              "Tidak",
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              LoadingOverlay.show(context);
              final repo = context.read<InventoryRepository>();

              repo
                  .detachComponentFromVariant(
                    variantId: variantId,
                    componentId: componentId,
                  )
                  .then((value) => LoadingOverlay.hide());
            },
            child: const Text(
              "Ya, Lanjut",
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _verifyComponentCount(
    BuildContext context,
    VariantDetailRow d,
    VoidCallback onProceed,
  ) {
    final totalComps = d.componentsInBox.length + d.componentsSeparate.length;

    // Jika punya komponen TAPI jumlahnya cuma 1 -> Tampilkan Warning
    if (totalComps == 1) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(
            "Varian Hanya Memiliki 1 Komponen!",
            style: AppTextStyles.mono.copyWith(
              color: AppColors.onSurface,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
            "Biasanya varian memiliki minimal 2 komponen atau part. "
            "Apakah Anda yakin datanya sudah benar?",
            style: TextStyle(
              color: AppColors.onBackground,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                "Cek Lagi",
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                onProceed();
              },
              child: const Text(
                "Ya, Lanjut",
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      // Jika 0 (polos) atau > 1 (aman), langsung jalan
      onProceed();
    }
  }
}
