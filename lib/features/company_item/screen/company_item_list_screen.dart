import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:inventory_sync_apps/core/config.dart';
import 'package:inventory_sync_apps/core/db/app_database.dart' hide Section;
import 'package:inventory_sync_apps/core/styles/color_scheme.dart';
import 'package:inventory_sync_apps/core/utils/custom_back_button.dart';
import 'package:inventory_sync_apps/core/utils/custom_toast.dart';
import 'package:inventory_sync_apps/core/utils/loading_overlay.dart';
import 'package:inventory_sync_apps/features/auth/models/user.dart'
    as auth_user;
import 'package:inventory_sync_apps/features/company_item/bloc/qr_scan/qr_scan_cubit.dart';
import 'package:inventory_sync_apps/features/company_item/widget/company_item_card.dart';
import 'package:inventory_sync_apps/features/company_item/widget/qr_scanner_modal.dart';

import 'package:inventory_sync_apps/features/inventory/data/inventory_repository.dart';
import 'package:inventory_sync_apps/features/labeling/data/labeling_repository.dart';
import 'package:inventory_sync_apps/features/sync/bloc/sync_cubit.dart';
import 'package:inventory_sync_apps/features/sync/services/database_recovery_service.dart';
import 'package:inventory_sync_apps/features/unit/screen/unit_detail_screen.dart';
import 'package:inventory_sync_apps/features/variant/screen/variant_detail_screen.dart';
import 'package:inventory_sync_apps/shared/presentation/widgets/primary_button.dart';
import 'package:inventory_sync_apps/shared/presentation/widgets/search_field_widget.dart';

import '../../../../core/user_storage.dart';
import '../bloc/company_item_list/company_item_list_cubit.dart';
// import 'company_item_detail_screen.dart'; // TODO: ganti dengan screen detail-mu

class CompanyItemListScreen extends StatelessWidget {
  const CompanyItemListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (ctx) =>
              CompanyItemListCubit(ctx.read<InventoryRepository>()),
        ),
        BlocProvider<QrScanCubit>(
          create: (context) => QrScanCubit(context.read<LabelingRepository>()),
        ),
      ],
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatefulWidget {
  const _HomeView();

  @override
  State<_HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<_HomeView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Di dalam _HomeViewState
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: cs.background,
        foregroundColor: cs.onBackground,
        centerTitle: false,
        leading: CustomBackButton(),
        title: Hero(
          tag: 'mp-title',
          child: Material(
            child: const Text(
              'Labeling Item',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        actions: [
          BlocBuilder<SyncCubit, SyncState>(
            builder: (context, state) {
              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.sync),
                    onPressed: () => _showSyncDetails(context, state.details),
                  ),
                  if (state.details.displayTotal != 0)
                    Positioned(
                      right: 8,
                      top: 10,
                      // height: 10,
                      // width: 10,
                      child: CircleAvatar(
                        radius: 6,
                        backgroundColor: Colors.orangeAccent,
                        child: Icon(
                          Icons.priority_high,
                          color: Colors.white,
                          size: 8,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<CompanyItemListCubit, CompanyItemListState>(
          builder: (context, state) {
            if (state is CompanyItemListLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is CompanyItemListError) {
              dev.log('HOME ERROR: ${state.message}');
              return Center(
                child: Text(
                  'Terjadi kesalahan saat memuat data.\n${state.message}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14),
                ),
              );
            }

            final loaded = state as CompanyItemListLoaded;

            return RefreshIndicator(
              onRefresh: () =>
                  context.read<CompanyItemListCubit>().refreshFromLocal(),
              // PERUBAHAN DI SINI
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Row(
                      spacing: 8,
                      children: [
                        Expanded(
                          child: SearchFieldWidget(
                            controller: _searchController,
                            onChanged: (value) {
                              context.read<CompanyItemListCubit>().updateSearch(
                                value,
                              );
                            },
                            onClear: () {
                              _searchController.clear();
                              context.read<CompanyItemListCubit>().updateSearch(
                                '',
                              );
                            },
                          ),
                        ),
                        CustomButton(
                          color: AppColors.surface,
                          padding: const EdgeInsets.all(8),
                          height: 47,
                          width: 47,
                          radius: 18,
                          borderColor: AppColors.border,
                          borderWidth: 1.2,
                          elevation: 1.2,

                          child: Icon(
                            Icons.qr_code,
                            color: AppColors.primary,
                            size: 22,
                          ),
                          onPressed: () => _showQrScanner(context),
                        ),
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            CustomButton(
                              color: AppColors.surface,
                              padding: const EdgeInsets.all(8),
                              height: 47,
                              width: 47,
                              radius: 18,
                              borderColor: AppColors.border,
                              borderWidth: 1.2,
                              elevation: 1.2,
                              child: Icon(
                                Icons.filter_alt_outlined,
                                color: AppColors.primary,
                                size: 22,
                              ),
                              onPressed: () {
                                if (state is CompanyItemListLoaded) {
                                  _showFilterModal(context, state);
                                }
                              },
                            ),
                            if (state is CompanyItemListLoaded &&
                                state.activeFilterCount > 0)
                              Positioned(
                                top: -5,
                                right: -5,
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    '${state.activeFilterCount}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  Divider(height: 0),
                  Expanded(
                    child: CustomScrollView(
                      slivers: [
                        const SliverToBoxAdapter(child: SizedBox(height: 10)),

                        // 3. Company Item Header
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: _buildSectionHeader(
                              context,
                              loaded.companyItems.length,
                            ),
                          ),
                        ),

                        const SliverToBoxAdapter(child: SizedBox(height: 10)),

                        // 4. Company Item List (Ini intinya: Gunakan SliverList)
                        if (loaded.companyItems.isEmpty)
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Text(
                                'Belum ada barang terdaftar.',
                                style: TextStyle(
                                  color: cs.onBackground.withOpacity(0.6),
                                ),
                              ),
                            ),
                          )
                        else
                          SliverPadding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            sliver: SliverList(
                              delegate: SliverChildBuilderDelegate((
                                context,
                                index,
                              ) {
                                final item = loaded.companyItems[index];
                                // Return widget card anda
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: CompanyItemCard(row: item),
                                );
                              }, childCount: loaded.companyItems.length),
                            ),
                          ),

                        // Tambahan padding bawah agar list tidak tertutup gesture nav
                        const SliverToBoxAdapter(child: SizedBox(height: 20)),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // Helper kecil untuk Header Section (dipisah agar rapi)
  Widget _buildSectionHeader(BuildContext context, int count) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'LIST BARANG',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
            color: cs.onBackground.withOpacity(0.7),
          ),
        ),
        if (count > 0)
          Text(
            '$count item',
            style: TextStyle(
              fontSize: 11,
              color: cs.onBackground.withOpacity(0.55),
            ),
          ),
      ],
    );
  }

  Future<void> _onHardResetPressed() async {
    final _db = context.read<AppDatabase>();
    DatabaseRecoveryService _recoveryService = DatabaseRecoveryService(_db);
    // Konfirmasi Terakhir
    final confirm = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('⚠️ Hapus Semua Data?'),
        content: const Text(
          'Database lokal akan dihapus total dan aplikasi akan dimulai ulang.\n\n'
          'Pastikan Anda SUDAH melakukan Share/Backup jika ada tombol backup berwarna oranye.',
        ),
        actions: [
          TextButton(
            child: const Text('Batal'),
            onPressed: () => Navigator.pop(ctx, false),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text(
              'YA, HAPUS & RESET',
              style: TextStyle(color: AppColors.surface),
            ),
            onPressed: () => Navigator.pop(ctx, true),
          ),
        ],
      ),
    );

    if (confirm == true) {
      LoadingOverlay.show(context);

      // Lakukan Reset
      await _recoveryService.nukeDatabase();

      // Beri sedikit delay visual
      await Future.delayed(
        const Duration(seconds: 1),
      ).then((value) => LoadingOverlay.hide());

      // if (mounted) {
      //   // Restart Aplikasi ke Halaman Awal (Splash / StartUp)
      //   Navigator.of(context).pushAndRemoveUntil(
      //     MaterialPageRoute(builder: (_) => const AppRoot()),
      //     (route) => false,
      //   );
      // }
    }
  }

  void _showSyncDetails(BuildContext context, SyncCounts counts) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Sinkronisasi Data",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),

            // if (!Config.isProduction())
            //   SizedBox(
            //     width: double.infinity,
            //     child: GestureDetector(
            //       onTap: () => _onHardResetPressed(),
            //       child: Text('Hapus Data Lokal dan Sync Ulang'),
            //     ),
            //   ),
            if (counts.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(child: Text("Semua data telah tersinkronisasi")),
              )
            else ...[
              if (counts.companyItems > 0)
                _buildRow("Item/Barang", counts.companyItems),
              if (counts.variants > 0) _buildRow("Varian", counts.variants),
              if (counts.variantComponents > 0)
                _buildRow("Varian - Komponen", counts.variantComponents),
              if (counts.components > 0)
                _buildRow("Komponen", counts.components),
              if (counts.units > 0) _buildRow("Unit Label", counts.units),
              if (counts.photos > 0) _buildRow("Foto Upload", counts.photos),
              const Divider(),
              _buildRow("Total Antrian", counts.displayTotal, isBold: true),

              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(ctx);
                    final result = await context.read<SyncCubit>().pushData(
                      manual: true,
                    );

                    if (!result.success && result.message != null) {
                      CustomToast.error(context, description: result.message!);
                    }
                  },
                  child: const Text("SYNC SEKARANG"),
                ),
              ),
              if (!Config.isProduction())
                SizedBox(
                  width: double.infinity,
                  child: GestureDetector(
                    onTap: () => _onHardResetPressed(),
                    child: Text('Hapus Data Lokal dan Sync Ulang'),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, int count, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            "$count",
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showQrScanner(BuildContext context) async {
    auth_user.User _user = (await UserStorage.getUser())!;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) {
        return BlocProvider.value(
          value: context.read<QrScanCubit>(),
          child: BlocConsumer<QrScanCubit, QrScanState>(
            listener: (ctx, state) {
              if (state.status == QrScanStatus.success &&
                  state.unitData != null) {
                // Close modal
                Navigator.pop(modalContext);

                // Navigate ke detail variant
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        UnitDetailScreen(unitId: state.unitData!.unit.id),
                  ),
                );
                // Navigator.pushNamed(
                //   context,
                //   '/variant-detail',
                //   arguments: {
                //     'variantId': state.unitData!.variant!.id,
                //     'variant': state.unitData!.variant,
                //     'companyItem': state.unitData!.companyItem,
                //     'product': state.unitData!.product,
                //   },
                // );

                // Reset state
                ctx.read<QrScanCubit>().reset();
              } else if (state.status == QrScanStatus.notFound) {
                // Show error
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.error ?? 'QR tidak ditemukan'),
                    backgroundColor: Colors.orange,
                  ),
                );

                // Close modal after delay
                Future.delayed(const Duration(seconds: 2), () {
                  if (modalContext.mounted) {
                    Navigator.pop(modalContext);
                    ctx.read<QrScanCubit>().reset();
                  }
                });
              } else if (state.status == QrScanStatus.error) {
                // Show error
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.error ?? 'Terjadi kesalahan'),
                    backgroundColor: Colors.red,
                  ),
                );

                // Close modal after delay
                Future.delayed(const Duration(seconds: 2), () {
                  if (modalContext.mounted) {
                    Navigator.pop(modalContext);
                    ctx.read<QrScanCubit>().reset();
                  }
                });
              }
            },
            builder: (ctx, state) {
              return QrScannerModal(
                onScanSuccess: (qrValue) {
                  ctx.read<QrScanCubit>().scanQr(qrValue);
                },
              );
            },
          ),
        );
      },
    );
  }
}

Widget _buildFilterChip(
  BuildContext context, {
  required String label,
  required VoidCallback onDeleted,
}) {
  return Chip(
    label: Text(
      label,
      style: TextStyle(
        fontSize: 12,
        color: AppColors.primary,
        fontWeight: FontWeight.w500,
      ),
    ),
    backgroundColor: AppColors.primary.withOpacity(0.1),
    deleteIcon: Icon(Icons.close, size: 16, color: AppColors.primary),
    onDeleted: onDeleted,
    side: BorderSide.none,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  );
}

void _showFilterModal(BuildContext context, CompanyItemListLoaded state) async {
  auth_user.User user = (await UserStorage.getUser())!;

  // Check if user has multiple sections
  final sections = user.sections ?? [];
  final hasMultipleSections = sections.length > 1;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => _FilterModalContent(
      state: state,
      hasMultipleSections: hasMultipleSections,
      sections: sections,
      cubit: context.read<CompanyItemListCubit>(),
    ),
  );
}

class _FilterModalContent extends StatefulWidget {
  final CompanyItemListLoaded state;
  final bool hasMultipleSections;
  final List<auth_user.Section> sections;
  final CompanyItemListCubit cubit;

  const _FilterModalContent({
    required this.state,
    required this.hasMultipleSections,
    required this.sections,
    required this.cubit,
  });

  @override
  State<_FilterModalContent> createState() => _FilterModalContentState();
}

class _FilterModalContentState extends State<_FilterModalContent> {
  Set<String> _selectedCategoryIds = {};
  Set<String> _selectedWarehouseIds = {};
  Set<String> _selectedSectionIds = {};
  Set<String> _selectedLabelingStatus = {};

  @override
  void initState() {
    super.initState();
    _selectedCategoryIds = Set.from(widget.state.selectedCategoryIds);
    _selectedWarehouseIds = Set.from(widget.state.selectedWarehouseIds);
    _selectedSectionIds = Set.from(widget.state.selectedSectionIds);
    _selectedLabelingStatus = Set.from(widget.state.selectedLabelingStatus);
  }

  void _toggle(Set<String> set, String id) {
    setState(() {
      if (set.contains(id)) {
        set.remove(id);
      } else {
        set.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.all(20),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Filter',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _selectedCategoryIds.clear();
                    _selectedWarehouseIds.clear();
                    _selectedSectionIds.clear();
                    _selectedLabelingStatus.clear();
                  });
                },
                child: const Text('Reset Filter'),
              ),
            ],
          ),
          const SizedBox(height: 20),

          Flexible(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Labeling Status Filter
                  _buildSectionTitle('Status Pelabelan'),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildTile(
                        label: 'Sudah Dilabeli',
                        isSelected: _selectedLabelingStatus.contains('labeled'),
                        onTap: () =>
                            _toggle(_selectedLabelingStatus, 'labeled'),
                      ),
                      _buildTile(
                        label: 'Belum Dilabeli',
                        isSelected: _selectedLabelingStatus.contains(
                          'unlabeled',
                        ),
                        onTap: () =>
                            _toggle(_selectedLabelingStatus, 'unlabeled'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Section Filter
                  if (widget.hasMultipleSections) ...[
                    _buildSectionTitle('Section'),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: widget.sections
                          .where((s) => s.id != null)
                          .map(
                            (s) => _buildTile(
                              label: s.name ?? '-',
                              isSelected: _selectedSectionIds.contains(s.id!),
                              onTap: () => _toggle(_selectedSectionIds, s.id!),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Category Filter
                  _buildSectionTitle('Kategori'),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: widget.state.categories
                        .map(
                          (c) => _buildTile(
                            label: c.name,
                            isSelected: _selectedCategoryIds.contains(
                              c.categoryId,
                            ),
                            onTap: () =>
                                _toggle(_selectedCategoryIds, c.categoryId),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 20),

                  // Warehouse Filter
                  _buildSectionTitle('Gudang'),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: widget.state.warehouses
                        .map(
                          (w) => _buildTile(
                            label: w.name,
                            isSelected: _selectedWarehouseIds.contains(w.id),
                            onTap: () => _toggle(_selectedWarehouseIds, w.id),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                final cubit = widget.cubit;
                cubit.setCategoryFilter(_selectedCategoryIds);
                cubit.setWarehouseFilter(_selectedWarehouseIds);
                cubit.setSectionFilter(_selectedSectionIds);
                cubit.setLabelingStatusFilter(_selectedLabelingStatus);
                Navigator.pop(context);
              },
              child: Text(
                'Terapkan Filter',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 10), // Bottom padding
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildTile({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFC2410C) : const Color(0xFFFFF1F2),
          borderRadius: BorderRadius.circular(20),
          border: isSelected ? null : Border.all(color: Colors.transparent),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
