import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:inventory_sync_apps/core/styles/color_scheme.dart';
import 'package:inventory_sync_apps/features/inventory/data/inventory_repository.dart';

import '../../../labeling/data/labeling_repository.dart';
import '../../../labeling/presentation/bloc/label_set/label_state_cubit.dart';
import '../../../labeling/presentation/bloc/setup_company_item/setup_company_item_cubit.dart';
import '../../../labeling/presentation/screens/label_set_screen.dart';
import '../../../labeling/presentation/screens/set_up_company_item_screen.dart';
import '../bloc/company_item_detail/company_item_detail_cubit.dart';

class CompanyItemDetailScreen extends StatelessWidget {
  final String companyItemId;

  const CompanyItemDetailScreen({super.key, required this.companyItemId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final repo = RepositoryProvider.of<InventoryRepository>(context);
        final cubit = CompanyItemDetailCubit(repo);
        cubit.loadDetail(companyItemId);
        return cubit;
      },
      child: const _CompanyItemDetailView(),
    );
  }
}

class _CompanyItemDetailView extends StatelessWidget {
  const _CompanyItemDetailView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<CompanyItemDetailCubit, CompanyItemDetailState>(
          builder: (context, state) {
            if (state is CompanyItemDetailLoaded) {
              return Text(
                '${state.detail.companyCode} • ${state.detail.productName}',
                overflow: TextOverflow.ellipsis,
              );
            }
            return const Text('Item Detail');
          },
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: BlocBuilder<CompanyItemDetailCubit, CompanyItemDetailState>(
        builder: (context, state) {
          if (state is CompanyItemDetailLoading ||
              state is CompanyItemDetailInitial) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CompanyItemDetailError) {
            return Center(child: Text('Error: ${state.message}'));
          } else if (state is CompanyItemDetailLoaded) {
            final detail = state.detail;
            return _buildLoaded(context, detail); // ⬅️ pakai ini
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildLoaded(BuildContext context, CompanyItemDetail detail) {
    return RefreshIndicator(
      onRefresh: () => context.read<CompanyItemDetailCubit>().loadDetail(
        detail.companyItemId,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(detail),
                const SizedBox(height: 12),
                _buildSetupBanner(context, detail),
                const SizedBox(height: 12),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildVariantList(detail),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(CompanyItemDetail detail) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${detail.companyCode} — ${detail.productName}',
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        ),
        const SizedBox(height: 4),
      ],
    );
  }

  Widget _buildSetupBanner(BuildContext context, CompanyItemDetail detail) {
    final isInitialized = detail.isSet != null && detail.hasComponents != null;

    if (isInitialized && detail.variants.isNotEmpty) {
      // Sudah ada konfigurasi + minimal 1 variant
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            detail.isSet == true ? 'Item ini tipe SET' : 'Item ini tipe SINGLE',
            style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
          ),
          TextButton.icon(
            onPressed: () => _openSetupAddVariant(context, detail),
            icon: const Icon(Icons.add),
            label: const Text('Tambah Variant'),
          ),
        ],
      );
    }

    // Belum di-setup → banner warning + tombol Setup pertama kali
    return Card(
      color: Colors.orange.shade50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(Icons.info_outline, color: Colors.orange.shade700),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Item ini belum di-setup.\nTentukan tipe (set/single), brand, dan foto sebelum labeling.',
                style: TextStyle(fontSize: 13, color: Colors.orange.shade800),
              ),
            ),
            const SizedBox(width: 8),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
              onPressed: () => _openSetupFirstTime(context, detail),
              child: const Text(
                'Setup',
                style: TextStyle(fontSize: 13, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openSetupFirstTime(
    BuildContext context,
    CompanyItemDetail detail,
  ) async {
    final userId = 'CURRENT_USER_ID'; // TODO: dari AuthCubit

    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (ctx) => SetupCompanyItemCubit(
            inventoryRepo: ctx.read<InventoryRepository>(),
            labelingRepo: ctx.read<LabelingRepository>(),
          )..loadInitial(detail.companyItemId),
          child: SetupCompanyItemScreen(
            companyItemId: detail.companyItemId,
            productId: detail.productId,
            userId: userId,
          ),
        ),
      ),
    );

    if (result == true) {
      // ignore: use_build_context_synchronously
      context.read<CompanyItemDetailCubit>().loadDetail(detail.companyItemId);
    }
  }

  void _openSetupAddVariant(
    BuildContext context,
    CompanyItemDetail detail,
  ) async {
    final userId = 'CURRENT_USER_ID'; // TODO: dari AuthCubit

    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (ctx) => SetupCompanyItemCubit(
            inventoryRepo: ctx.read<InventoryRepository>(),
            labelingRepo: ctx.read<LabelingRepository>(),
          )..loadInitial(detail.companyItemId),
          child: SetupCompanyItemScreen(
            companyItemId: detail.companyItemId,
            productId: detail.productId,
            userId: userId,
          ),
        ),
      ),
    );

    if (result == true) {
      // setelah nambah variant baru, reload detail
      // ignore: use_build_context_synchronously
      context.read<CompanyItemDetailCubit>().loadDetail(detail.companyItemId);
    }
  }

  void _openSetup(BuildContext context, CompanyItemDetail detail) async {
    // TODO: ambil userId dari AuthCubit
    final userId = 'CURRENT_USER_ID'; // sementara

    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (ctx) => SetupCompanyItemCubit(
            inventoryRepo: ctx.read<InventoryRepository>(),
            labelingRepo: ctx.read<LabelingRepository>(),
          )..loadInitial(detail.companyItemId),
          child: SetupCompanyItemScreen(
            companyItemId: detail.companyItemId,
            productId: detail.productId,
            userId: userId,
          ),
        ),
      ),
    );

    if (result == true) {
      // setelah selesai setup, reload detail
      // ignore: use_build_context_synchronously
      context.read<CompanyItemDetailCubit>().loadDetail(detail.companyItemId);
    }
  }

  Widget _buildSummaryCard(CompanyItemDetail detail, BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.secondary.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                detail.companyCode,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                detail.productName,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVariantList(CompanyItemDetail detail) {
    if (detail.variants.isEmpty) {
      return const Center(child: Text('Belum ada variant untuk item ini.'));
    }

    return ListView.separated(
      itemCount: detail.variants.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final v = detail.variants[index];
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 10,
                  height: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: v.stock > 0
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey.shade400,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        v.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          if (v.brandName != null) ...[
                            Icon(
                              Icons.sell_outlined,
                              size: 14,
                              color: Colors.grey.shade600,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              v.brandName!,
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontSize: 12,
                              ),
                            ),
                          ],
                          if (v.defaultLocation != null) ...[
                            const SizedBox(width: 12),
                            Icon(
                              Icons.location_on_outlined,
                              size: 14,
                              color: Colors.grey.shade600,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              v.defaultLocation!,
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontSize: 12,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                // TODO: ambil userId dari AuthCubit atau model user yang kamu punya
                                final userId =
                                    'CURRENT_USER_ID'; // sementara hardcode, nanti ganti

                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => BlocProvider(
                                      create: (ctx) => LabelSetCubit(
                                        labelingRepository: ctx
                                            .read<LabelingRepository>(),
                                        variantId: v.variantId,
                                        variantName: v.name,
                                        brandName: v.brandName,
                                        defaultLocation: v.defaultLocation,
                                        userId: userId,
                                      ),
                                      child: const LabelSetScreen(),
                                    ),
                                  ),
                                );
                              },
                              child: const Text('Label as Set'),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      v.stock.toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'unit',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
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

  // Widget _buildVariantList(CompanyItemDetail detail) {
  //   if (detail.variants.isEmpty) {
  //     return const Expanded(
  //       child: Center(child: Text('Belum ada variant untuk item ini.')),
  //     );
  //   }

  //   return Expanded(
  //     child: ListView.separated(
  //       itemCount: detail.variants.length,
  //       separatorBuilder: (_, __) => const SizedBox(height: 8),
  //       itemBuilder: (context, index) {
  //         final v = detail.variants[index];
  //         return Card(
  //           shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.circular(12),
  //           ),
  //           child: Padding(
  //             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  //             child: Row(
  //               children: [
  //                 // indicator stok
  //                 Container(
  //                   width: 10,
  //                   height: 48,
  //                   decoration: BoxDecoration(
  //                     borderRadius: BorderRadius.circular(4),
  //                     color: v.stock > 0
  //                         ? Theme.of(context).colorScheme.primary
  //                         : Colors.grey.shade400,
  //                   ),
  //                 ),
  //                 const SizedBox(width: 12),
  //                 Expanded(
  //                   child: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Text(
  //                         v.name,
  //                         style: const TextStyle(
  //                           fontWeight: FontWeight.w600,
  //                           fontSize: 15,
  //                         ),
  //                       ),
  //                       const SizedBox(height: 4),
  //                       Row(
  //                         children: [
  //                           if (v.brandName != null) ...[
  //                             Icon(
  //                               Icons.sell_outlined,
  //                               size: 14,
  //                               color: Colors.grey.shade600,
  //                             ),
  //                             const SizedBox(width: 4),
  //                             Text(
  //                               v.brandName!,
  //                               style: TextStyle(
  //                                 color: Colors.grey.shade700,
  //                                 fontSize: 12,
  //                               ),
  //                             ),
  //                           ],
  //                           if (v.defaultLocation != null) ...[
  //                             const SizedBox(width: 12),
  //                             Icon(
  //                               Icons.location_on_outlined,
  //                               size: 14,
  //                               color: Colors.grey.shade600,
  //                             ),
  //                             const SizedBox(width: 4),
  //                             Text(
  //                               v.defaultLocation!,
  //                               style: TextStyle(
  //                                 color: Colors.grey.shade700,
  //                                 fontSize: 12,
  //                               ),
  //                             ),
  //                             TextButton(
  //                               onPressed: () {
  //                                 // TODO: ambil userId dari AuthCubit atau model user yang kamu punya
  //                                 final userId =
  //                                     'CURRENT_USER_ID'; // sementara hardcode, nanti ganti

  //                                 Navigator.of(context).push(
  //                                   MaterialPageRoute(
  //                                     builder: (_) => BlocProvider(
  //                                       create: (ctx) => LabelSetCubit(
  //                                         labelingRepository: ctx
  //                                             .read<LabelingRepository>(),
  //                                         variantId: v.variantId,
  //                                         variantName: v.name,
  //                                         brandName: v.brandName,
  //                                         defaultLocation: v.defaultLocation,
  //                                         userId: userId,
  //                                       ),
  //                                       child: const LabelSetScreen(),
  //                                     ),
  //                                   ),
  //                                 );
  //                               },
  //                               child: const Text('Label as Set'),
  //                             ),
  //                           ],
  //                         ],
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //                 const SizedBox(width: 12),
  //                 Column(
  //                   crossAxisAlignment: CrossAxisAlignment.end,
  //                   children: [
  //                     Text(
  //                       v.stock.toString(),
  //                       style: const TextStyle(
  //                         fontWeight: FontWeight.bold,
  //                         fontSize: 16,
  //                       ),
  //                     ),
  //                     Text(
  //                       'unit',
  //                       style: TextStyle(
  //                         color: Colors.grey.shade600,
  //                         fontSize: 12,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ],
  //             ),
  //           ),
  //         );
  //       },
  //     ),
  //   );
  // }
}
