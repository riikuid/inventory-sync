import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_sync_apps/core/styles/app_style.dart';

import 'package:inventory_sync_apps/core/styles/color_scheme.dart';
import 'package:inventory_sync_apps/core/styles/text_theme.dart';
import 'package:inventory_sync_apps/features/inventory/data/inventory_repository.dart';
import '../../../variant/presentation/screen/create_variant_screen.dart';
import '../bloc/company_item_detail/company_item_detail_cubit.dart';

class CompanyItemDetailScreen extends StatefulWidget {
  final String companyItemId;

  const CompanyItemDetailScreen({super.key, required this.companyItemId});

  @override
  State<CompanyItemDetailScreen> createState() =>
      _CompanyItemDetailScreenState();
}

class _CompanyItemDetailScreenState extends State<CompanyItemDetailScreen> {
  late final CompanyItemDetailCubit _cubit;

  @override
  void initState() {
    super.initState();
    final repo = context.read<InventoryRepository>();
    _cubit = CompanyItemDetailCubit(repo);
    // start watching immediately
    _cubit.watchDetail(widget.companyItemId);
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          iconTheme: IconThemeData(color: AppColors.onSurface),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              weight: 260,
              color: AppColors.onSurface,
            ),
          ),
          backgroundColor: AppColors.background,
          foregroundColor: Colors.transparent,
          elevation: 0.5,

          title: BlocBuilder<CompanyItemDetailCubit, CompanyItemDetailState>(
            builder: (context, state) {
              if (state is CompanyItemDetailLoaded) {
                return Text(
                  '${state.detail.companyCode} • ${state.detail.productName}',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.onSurface,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                );
              }
              return const Text('Item Detail');
            },
          ),
        ),
        body: BlocBuilder<CompanyItemDetailCubit, CompanyItemDetailState>(
          builder: (context, state) {
            if (state is CompanyItemDetailLoading ||
                state is CompanyItemDetailInitial) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is CompanyItemDetailError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Terjadi kesalahan:\n${state.message}',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () =>
                            _cubit.watchDetail(widget.companyItemId),
                        child: const Text('Coba lagi'),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (state is CompanyItemDetailLoaded) {
              final detail = state.detail;
              return RefreshIndicator(
                onRefresh: () => _cubit.loadDetail(widget.companyItemId),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      16,
                      16,
                      16,
                      96,
                    ), // bottom padding for FAB
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeaderCard(detail),
                        const SizedBox(height: 12),
                        _buildSetupBanner(detail),
                        const SizedBox(height: 16),
                        _buildSectionTitle(
                          'Daftar Variant',
                          '${detail.variants.length} variant',
                        ),
                        const SizedBox(height: 12),
                        _buildVariantList(detail),
                      ],
                    ),
                  ),
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
        floatingActionButton: _buildAddVariantFab(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  Widget _buildHeaderCard(CompanyItemDetail detail) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.onError,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [AppStyle.defaultBoxShadow],
      ),
      // elevation: 1,
      // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // top row: badge + title + rack
            Row(
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    // show last segment or short code from companyCode
                    detail.companyCode.split('-').last,
                    style: AppStyle.monoTextStyle.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: AppColors.primaryDark,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        detail.productName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            size: 14,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              detail.variants.isNotEmpty &&
                                      detail.variants.first.rackName != null
                                  ? detail.variants.first.rackName!
                                  : 'Tidak ada lokasi',
                              style: TextStyle(color: Colors.grey.shade700),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // const SizedBox(height: 12),
            // info box (description / specification)
            if (detail.variants.isNotEmpty &&
                detail.variants.first.specification != null) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(top: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.grey.shade700),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        detail.variants.first.specification ?? '',
                        style: TextStyle(color: Colors.grey.shade800),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSetupBanner(CompanyItemDetail detail) {
    final isInitialized = detail.variants.isNotEmpty;
    if (isInitialized) {
      return const SizedBox.shrink();
    }

    return Card(
      color: AppColors.primaryLight.withOpacity(0.6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(Icons.info_outline, color: AppColors.primaryDark),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Item ini belum di-setup. Tentukan tipe, brand, lokasi, dan foto agar bisa dilabel.',
                style: TextStyle(color: AppColors.primaryDark.withOpacity(0.9)),
              ),
            ),
            const SizedBox(width: 8),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateVariantScreen(
                      companyItemId: detail.companyItemId,
                      userId: 'SDWDSD',
                    ),
                  ),
                ),
              },
              // onPressed: () => _openSetupScreen(),
              child: const Text('Setup', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, String subtitle) {
    return Row(
      children: [
        Text(
          title.toUpperCase(),
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),
        const Spacer(),
        Text(
          subtitle,
          style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildVariantList(CompanyItemDetail detail) {
    if (detail.variants.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 36),
          child: Text(
            'Belum ada variant untuk item ini.',
            style: TextStyle(color: Colors.grey.shade700),
          ),
        ),
      );
    }

    return Column(
      children: detail.variants.map((v) => _buildVariantCard(v)).toList(),
    );
  }

  Widget _buildVariantCard(VariantSummary v) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [AppStyle.defaultBoxShadow],
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
      ),
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // buka detail variant (jika ada)
          // Navigator.of(context).push(
          //   MaterialPageRoute(
          //     builder: (_) => VariantDetailScreen(variantId: v.variantId),
          //   ),
          // );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      v.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        if (v.manufCode != null) ...[
                          Text(
                            v.manufCode!,
                            style: TextStyle(color: Colors.grey.shade700),
                          ),
                        ],
                        if ((v.rackName != null) && (v.manufCode != null)) ...[
                          const SizedBox(width: 6),
                          Text(
                            '•',
                            style: TextStyle(color: Colors.grey.shade700),
                          ),
                          const SizedBox(width: 6),
                        ],
                        if (v.rackName != null) ...[
                          Text(
                            v.rackName!,
                            style: TextStyle(color: Colors.grey.shade700),
                          ),
                        ],
                      ],
                    ),
                    SizedBox(height: 3),
                    Text(
                      '${v.stock.toString()} unit aktif',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),
              Column(
                children: [
                  if (v.brandName != null) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        '${v.brandName}',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryDark,
                        ),
                      ),
                    ),
                  ],
                  OutlinedButton.icon(
                    onPressed: () {
                      // TODO: implement print action
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Print action')),
                      );
                    },
                    icon: const Icon(Icons.print, size: 16),
                    label: const Text('Print'),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      side: BorderSide(color: Colors.grey.shade300),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddVariantFab() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: ElevatedButton.icon(
        onPressed: () => {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateVariantScreen(
                companyItemId: widget.companyItemId,
                userId: 'SDWDSD',
              ),
            ),
          ),
        },
        icon: const Icon(Icons.add),
        label: const Text('Tambah Variant'),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  // void _openSetupScreen() async {
  //   // open existing SetupCompanyItemScreen using SetupCompanyItemCubit
  //   final inventoryRepo = context.read<InventoryRepository>();
  //   final labelingRepo = context.read<LabelingRepository>();

  //   final result = await Navigator.of(context).push<bool>(
  //     MaterialPageRoute(
  //       builder: (_) => BlocProvider(
  //         create: (ctx) => SetupCompanyItemCubit(
  //           inventoryRepo: inventoryRepo,
  //           labelingRepo: labelingRepo,
  //         )..loadInitial(widget.companyItemId),
  //         child: SetupCompanyItemScreen(
  //           companyItemId: widget.companyItemId,
  //           productId: '', // repo.getCompanyItemDetail provides productId, but Setup screen also fetches from cubit
  //           userId: 'CURRENT_USER', // replace with real user id from AuthCubit when available
  //         ),
  //       ),
  //     ),
  //   );

  //   // jika berhasil menambah variant (screen pop true), reload detail
  //   if (result == true) {
  //     _cubit.loadDetail(widget.companyItemId);
  //   }
  // }
}
