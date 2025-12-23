// lib/features/inventory/presentation/screens/variant_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:inventory_sync_apps/core/styles/color_scheme.dart';
import 'package:inventory_sync_apps/features/inventory/presentation/screens/component_picker_screen.dart';
import 'package:inventory_sync_apps/features/labeling/presentation/bloc/create_labels/create_labels_cubit.dart';
import 'package:inventory_sync_apps/features/labeling/presentation/screens/generate_label_screen.dart';
import 'package:inventory_sync_apps/shared/presentation/widgets/primary_button.dart';
import '../../../../core/db/app_database.dart';
import '../../../../core/db/daos/variant_dao.dart';
import '../../../../core/db/model/variant_detail_row.dart';
import '../../../../core/styles/app_style.dart';
import '../../../../core/styles/text_theme.dart';
import '../../../labeling/data/labeling_repository.dart';
import '../../../inventory/data/inventory_repository.dart';
import '../../../labeling/presentation/bloc/assembly/assembly_cubit.dart';
import '../../../labeling/presentation/screens/assembly_screen.dart';
import '../bloc/variant_detail/variant_detail_cubit.dart';

class VariantDetailScreen extends StatelessWidget {
  final String variantId;
  final String userId;

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
  final String userId;
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
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back_ios_rounded,
                  size: 18,
                  weight: 260,
                  color: AppColors.onSurface,
                ),
              ),
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
                color: AppColors.secondary,
                onPressed: () {
                  // If no in-box components => go to LabelSetScreen directly (Label Item)
                  // else -> navigate to assembly/merge flow
                  if (d.componentsInBox.where((c) => c != null).isEmpty) {
                    // direct label (variant-level)
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => BlocProvider(
                          create: (context) => CreateLabelsCubit(
                            context.read<LabelingRepository>(),
                          ),

                          child: GenerateLabelsScreen(
                            variant: d,
                            userId: userId,
                          ),
                        ),
                      ),
                    );
                  } else {
                    // open assembly flow
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider(
                          create: (context) => AssemblyCubit(
                            RepositoryProvider.of<LabelingRepository>(context),
                            d.variantId,
                            d.name,
                          ),
                          child: AssemblyScreen(
                            variantManufCode: d.manufCode ?? '',
                            rackName: d.rackName ?? '',
                            rackId: d.rackId ?? '',
                            targetComponents: d.componentsInBox,
                            variantId: d.variantId,
                            variantName: d.name,
                            companyCode: d.companyCode,
                            userId: userId,
                          ),
                        ),
                      ),
                    );
                  }
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
            ),
            body: Stack(
              children: [
                ListView(
                  padding: const EdgeInsets.all(16),

                  children: [
                    _buildDetailHeader(context, d),
                    if (d.componentsSeparate.isEmpty) ...[
                      const SizedBox(height: 20),
                      _buildBoxSection(context, d),
                    ],
                    if (d.componentsInBox.isEmpty) ...[
                      const SizedBox(height: 20),
                      _buildSeparateComponentSection(context, d),
                    ],
                    const SizedBox(height: 120), // space for bottom bar
                  ],
                ),
                if (state.isBusy)
                  Container(
                    color: Colors.black26,
                    child: const Center(child: CircularProgressIndicator()),
                  ),
              ],
            ),
            // bottomNavigationBar: _buildBottomActions(context, d),
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
                    d.totalUnits.toString(),
                    style: const TextStyle(
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
                '${d.uom}${'  •  ${d.rackName}'}',
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

                // Expanded(
                //   child: FilledButton(
                //     style: FilledButton.styleFrom(
                //       backgroundColor: AppColors.secondary,
                //       padding: const EdgeInsets.symmetric(vertical: 12),
                //     ),
                //     onPressed: () {
                //       // If no in-box components => go to LabelSetScreen directly (Label Item)
                //       // else -> navigate to assembly/merge flow
                //       if (d.componentsInBox.where((c) => c != null).isEmpty) {
                //         // direct label (variant-level)
                //         Navigator.of(context).push(
                //           MaterialPageRoute(
                //             builder: (_) => BlocProvider(
                //               create: (context) => CreateLabelsCubit(
                //                 context.read<LabelingRepository>(),
                //               ),

                //               child: GenerateLabelsScreen(
                //                 variant: d,
                //                 userId: userId,
                //               ),
                //             ),
                //           ),
                //         );
                //       } else {
                //         // open assembly flow
                //         Navigator.push(
                //           context,
                //           MaterialPageRoute(
                //             builder: (_) => BlocProvider(
                //               create: (context) => AssemblyCubit(
                //                 RepositoryProvider.of<LabelingRepository>(
                //                   context,
                //                 ),
                //                 d.variantId,
                //                 d.name,
                //               ),
                //               child: AssemblyScreen(
                //                 variantId: d.variantId,
                //                 variantName: d.name,
                //                 companyCode: d.companyCode,
                //                 userId: userId,
                //               ),
                //             ),
                //           ),
                //         );
                //       }
                //     },
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       children: [
                //         Icon(
                //           Icons.print_outlined,
                //           size: 16,
                //           color: AppColors.onBackground,
                //         ),
                //         const SizedBox(width: 8),
                //         const Text(
                //           'Cetak Label',

                //           style: TextStyle(
                //             color: AppColors.onBackground,
                //             fontSize: 15,
                //             fontWeight: FontWeight.w600,
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                // const SizedBox(width: 12),
                // FilledButton(
                //   style: FilledButton.styleFrom(
                //     backgroundColor: Colors.white,
                //     padding: const EdgeInsets.symmetric(vertical: 12),
                //     side: BorderSide(color: Colors.grey.shade300),
                //   ),

                //   onPressed: () async {
                //     final repo = context.read<InventoryRepository>();

                //     // );

                //     final result = await Navigator.push<String>(
                //       context,
                //       MaterialPageRoute(
                //         builder: (_) =>
                //             ComponentPickerScreen(type: 'IN_BOX', variant: d),
                //       ),
                //     );
                //     if (result != null) {
                //       await repo.attachComponentToVariant(
                //         componentId: result,
                //         variantId: d.variantId,
                //         // type: 'SEPARATE',
                //       );
                //     }
                //   },
                //   child: const Text(
                //     '+ Isi',
                //     style: TextStyle(color: Colors.black),
                //   ),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBoxSection(BuildContext context, VariantDetailRow d) {
    // Components that are IN_BOX -> treat as "Isi Dalam Box"
    final inBox = d.componentsInBox
        .where((c) => c != null)
        .where((c) => true)
        .toList()
        .where((c) => true)
        .toList(); // we assume VariantComponentRow has info type handled in repo
    // In your VariantDetailRow you don't have 'type', so repo must provide IN_BOX vs SEPARATE by filtering earlier.
    // For safety, show all components here (in real app filter by type).
    final hasAny = d.componentsInBox.isNotEmpty;
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
                  'ISI DALAM BOX',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
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
                        ComponentPickerScreen(type: 'IN_BOX', variant: d),
                  ),
                );
                if (result != null) {
                  await repo.attachComponentToVariant(
                    componentId: result,
                    variantId: d.variantId,
                    // type: 'SEPARATE',
                  );
                }
              },

              // icon: const Icon(Icons.add, size: 14, color: AppColors.primary),
              child: Text(
                '+ Isi',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.onAccent,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        Container(
          decoration: BoxDecoration(
            boxShadow: [AppStyle.defaultBoxShadow],
            color: Color(0xff482f23),
            borderRadius: BorderRadius.circular(18),
          ),
          padding: const EdgeInsets.all(12),
          child: hasAny
              ? Column(
                  spacing: 10,
                  children: d.componentsInBox.map((c) {
                    return Container(
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      // margin: EdgeInsets.only(bottom: 10),
                      child: ListTile(
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
                            if (c.manufCode != null && c.brandName != null)
                              Text(
                                '${c.brandName}${c.manufCode != null && c.manufCode!.isNotEmpty ? '  •  ${c.manufCode}' : ''}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
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
                          'Belum ada isi',
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
            // TextButton.icon(
            //   onPressed: () async {
            //     final repo = context.read<InventoryRepository>();

            //     // );

            //     final result = await Navigator.push<String>(
            //       context,
            //       MaterialPageRoute(
            //         builder: (_) =>
            //             ComponentPickerScreen(type: 'SEPARATE', variant: d),
            //       ),
            //     );
            //     if (result != null) {
            //       await repo.attachComponentToVariant(
            //         componentId: result,
            //         variantId: d.variantId,
            //         // type: 'SEPARATE',
            //       );
            //     }
            //   },
            //   icon: const Icon(Icons.add, size: 14, color: AppColors.primary),
            //   label: Text(
            //     'Komponen',
            //     style: TextStyle(
            //       fontSize: 14,
            //       color: AppColors.primary,
            //       fontWeight: FontWeight.w600,
            //     ),
            //   ),
            // ),
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
                        ComponentPickerScreen(type: 'SEPARATE', variant: d),
                  ),
                );
                if (result != null) {
                  await repo.attachComponentToVariant(
                    componentId: result,
                    variantId: d.variantId,
                    // type: 'SEPARATE',
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
        // const SizedBox(height: 8),
        Column(
          spacing: 10,
          children: separate.map((c) {
            return Container(
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

                              child: GenerateLabelsScreen(
                                variant: d,
                                userId: userId,
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

  // Widget _buildBottomActions(BuildContext context, VariantDetailRow d) {
  //   final isSet = d.components.isNotEmpty;
  //   return DecoratedBox(
  //     decoration: BoxDecoration(
  //       color: AppColors.background,
  //       boxShadow: [
  //         BoxShadow(
  //           color: const Color(0x10000000),
  //           blurRadius: 10,
  //           offset: const Offset(0, -1),
  //         ),
  //       ],
  //     ),
  //     child: Padding(
  //       padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
  //       child: SafeArea(
  //         top: false,
  //         child: Row(
  //           children: [
  //             Expanded(
  //               child: FilledButton(
  //                 style: FilledButton.styleFrom(
  //                   backgroundColor: AppColors.secondary,
  //                   padding: const EdgeInsets.symmetric(vertical: 14),
  //                 ),
  //                 onPressed: () {
  //                   // If variant is set -> go to LabelSetScreen; otherwise label single item
  //                   // Navigator.of(context).push(
  //                   //   MaterialPageRoute(
  //                   //     builder: (_) => BlocProvider(
  //                   //       create: (ctx) => LabelSetCubit(
  //                   //         labelingRepository: context
  //                   //             .read<LabelingRepository>(),
  //                   //         variantId: d.variantId,
  //                   //         variantName: d.name,
  //                   //         brandName: d.brandName,
  //                   //         defaultLocation: d.rackName,
  //                   //         userId: userId,
  //                   //       ),
  //                   //       child: const LabelSetScreen(),
  //                   //     ),
  //                   //   ),
  //                   // );
  //                 },
  //                 child: Text(
  //                   isSet ? 'Label as Set' : 'Label Item',
  //                   style: const TextStyle(color: Colors.black),
  //                 ),
  //               ),
  //             ),
  //             const SizedBox(width: 10),
  //             if (isSet)
  //               Expanded(
  //                 child: FilledButton.tonal(
  //                   onPressed: d.components.length < 2
  //                       ? null
  //                       : () {
  //                           // Gabungkan (Assembly) flow
  //                           // Navigator.of(context).push(
  //                           //   MaterialPageRoute(
  //                           //     builder: (_) => AssemblyScreen(
  //                           //       variantId: d.variantId,
  //                           //       variantName: d.name,
  //                           //       componentIds: d.components
  //                           //           .map((c) => c.componentId)
  //                           //           .toList(),
  //                           //       userId: userId,
  //                           //     ),
  //                           //   ),
  //                           // );
  //                         },
  //                   child: const Text('Gabungkan'),
  //                 ),
  //               )
  //             else
  //               const SizedBox.shrink(),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // Bottom sheet for adding component (existing or create new)
  Future<void> _openAddComponentSheet(
    BuildContext context,
    VariantDetailRow d,
  ) async {
    final repo = context.read<InventoryRepository>();
    final cubit = context.read<VariantDetailCubit>();

    final components = await repo.getComponentsForProduct(d.productId);
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        final searchCtrl = TextEditingController();
        List<Component> filtered = List.from(components);

        void apply(String q) {
          filtered = components.where((c) {
            final ql = q.toLowerCase();
            return c.name.toLowerCase().contains(ql) ||
                (c.manufCode ?? '').toLowerCase().contains(ql);
          }).toList();
        }

        apply('');
        return StatefulBuilder(
          builder: (ctx, setState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(ctx).viewInsets.bottom,
              ),
              child: SizedBox(
                height: 520,
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(12),
                      child: Text('Tambah Komponen'),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: TextField(
                        controller: searchCtrl,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.search),
                          hintText: 'Cari...',
                        ),
                        onChanged: (v) {
                          setState(() => apply(v));
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: ListView.builder(
                        itemCount: filtered.length + 1,
                        itemBuilder: (ctx, idx) {
                          if (idx == filtered.length) {
                            return ListTile(
                              leading: const Icon(Icons.add),
                              title: const Text('Buat komponen baru'),
                              onTap: () {
                                Navigator.of(ctx).pop();
                                _openCreateComponentDialog(context, d);
                              },
                            );
                          }
                          final c = filtered[idx];
                          return ListTile(
                            title: Text(c.name),
                            subtitle: c.manufCode != null
                                ? Text('Kode manuf: ${c.manufCode}')
                                : null,
                            onTap: () async {
                              Navigator.of(ctx).pop();
                              await cubit.addComponentFromExisting(
                                variantId: d.variantId,
                                componentId: c.id,
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _openCreateComponentDialog(
    BuildContext context,
    VariantDetailRow d,
  ) async {
    final nameCtrl = TextEditingController();
    final codeCtrl = TextEditingController();
    final specCtrl = TextEditingController();

    final repo = context.read<InventoryRepository>();
    final cubit = context.read<VariantDetailCubit>();

    final result = await showDialog<bool>(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Komponen baru'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(labelText: 'Nama komponen'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: codeCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Kode manuf (opsional)',
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: specCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Spek (opsional)',
                  ),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );

    if (result != true) return;

    final comp = await repo.createComponentForVariantProduct(
      productId: d.productId,
      brandId: d.brandId,
      name: nameCtrl.text.trim(),
      manufCode: codeCtrl.text.trim().isEmpty ? null : codeCtrl.text.trim(),
      specification: specCtrl.text.trim().isEmpty ? null : specCtrl.text.trim(),
    );

    await cubit.addComponentFromExisting(
      variantId: d.variantId,
      componentId: comp.id,
    );
  }
}
