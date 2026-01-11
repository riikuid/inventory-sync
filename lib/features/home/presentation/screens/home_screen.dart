import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:inventory_sync_apps/features/inventory/data/inventory_repository.dart';
import 'package:inventory_sync_apps/core/db/daos/category_dao.dart';
import 'package:inventory_sync_apps/core/db/daos/company_item_dao.dart';
import 'package:inventory_sync_apps/shared/presentation/widgets/search_field_widget.dart';

import '../../../search_item/presentation/screen/search_item_screen.dart';
import '../../../sync/bloc/sync_cubit.dart';
import '../bloc/home_cubit.dart';
import '../widget/category_card.dart';
import '../widget/company_item_card.dart';
// import 'company_item_detail_screen.dart'; // TODO: ganti dengan screen detail-mu

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => HomeCubit(ctx.read<InventoryRepository>()),
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
  // @override
  // Widget build(BuildContext context) {
  //   final cs = Theme.of(context).colorScheme;

  //   return Scaffold(
  //     backgroundColor: cs.background,
  //     appBar: AppBar(
  //       elevation: 0,
  //       backgroundColor: cs.background,
  //       foregroundColor: cs.onBackground,
  //       centerTitle: false,
  //       title: Hero(
  //         tag: 'mp-title',
  //         child: Material(
  //           child: const Text(
  //             'MP Inventory',
  //             style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
  //           ),
  //         ),
  //       ),
  //       actions: [
  //         BlocBuilder<SyncCubit, SyncState>(
  //           builder: (context, state) {
  //             return IconButton(
  //               icon: const Icon(Icons.refresh_rounded),
  //               onPressed: () => _showSyncDetails(context, state.details),
  //             );
  //           },
  //         ),
  //       ],
  //     ),
  //     body: SafeArea(
  //       child: BlocBuilder<HomeCubit, HomeState>(
  //         builder: (context, state) {
  //           if (state is HomeLoading) {
  //             return const Center(child: CircularProgressIndicator());
  //           }

  //           if (state is HomeError) {
  //             dev.log('HOME ERROR: ${state.message}');
  //             return Center(
  //               child: Text(
  //                 'Terjadi kesalahan saat memuat data.\n${state.message}',
  //                 textAlign: TextAlign.center,
  //                 style: const TextStyle(fontSize: 14),
  //               ),
  //             );
  //           }

  //           final loaded = state as HomeLoaded;

  //           return RefreshIndicator(
  //             onRefresh: () => context.read<HomeCubit>().refreshFromLocal(),
  //             child: ListView(
  //               padding: const EdgeInsets.symmetric(
  //                 horizontal: 16,
  //                 vertical: 8,
  //               ),
  //               children: [
  //                 _SearchBar(),
  //                 // const SizedBox(height: 20),
  //                 // _CategorySection(categories: loaded.categories),
  //                 const SizedBox(height: 20),
  //                 _CompanyItemSection(items: loaded.companyItems),
  //               ],
  //             ),
  //           );
  //         },
  //       ),
  //     ),
  //   );
  // }

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
        title: Hero(
          tag: 'mp-title',
          child: Material(
            child: const Text(
              'MP Inventory',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        actions: [
          BlocBuilder<SyncCubit, SyncState>(
            builder: (context, state) {
              return IconButton(
                icon: const Icon(Icons.refresh_rounded),
                onPressed: () => _showSyncDetails(context, state.details),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is HomeError) {
              dev.log('HOME ERROR: ${state.message}');
              return Center(
                child: Text(
                  'Terjadi kesalahan saat memuat data.\n${state.message}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14),
                ),
              );
            }

            final loaded = state as HomeLoaded;

            return RefreshIndicator(
              onRefresh: () => context.read<HomeCubit>().refreshFromLocal(),
              // PERUBAHAN UTAMA DI SINI
              child: CustomScrollView(
                slivers: [
                  // 1. Search Bar (Bukan List, jadi pakai Adapter)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: _SearchBar(),
                    ),
                  ),

                  // 2. Category Section (List Horizontal, tetap dibungkus Adapter karena tingginya fix)
                  // SliverToBoxAdapter(
                  //   child: Padding(
                  //     padding: const EdgeInsets.symmetric(
                  //       horizontal: 16,
                  //       vertical: 8,
                  //     ),
                  //     // Pastikan _CategorySection tidak punya padding internal yang dobel
                  //     child: _CategorySection(categories: loaded.categories),
                  //   ),
                  // ),
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
                        padding: const EdgeInsets.symmetric(horizontal: 16),
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
                        delegate: SliverChildBuilderDelegate((context, index) {
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
                  onPressed: () {
                    Navigator.pop(ctx);
                    context.read<SyncCubit>().pushData(); // Trigger Sync Manual
                  },
                  child: const Text("SYNC SEKARANG"),
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
}

class _SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Hero(
      tag: 'inventory-search-bar',
      child: Material(
        color: Colors.transparent,
        child: GestureDetector(
          // borderRadius: BorderRadius.circular(24),
          onTap: () {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const SearchItemScreen()));
          },
          child: Material(child: SearchFieldWidget(enabled: false)),
        ),
      ),
    );
  }
}

class _CategorySection extends StatelessWidget {
  final List<CategorySummary> categories;

  const _CategorySection({required this.categories});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    if (categories.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'KATEGORI',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
              color: cs.onBackground.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Belum ada kategori terdaftar.',
            style: TextStyle(
              fontSize: 13,
              color: cs.onBackground.withOpacity(0.6),
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'KATEGORI',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
            color: cs.onBackground.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 108,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final cat = categories[index];
              return CategoryCard(category: cat);
            },
          ),
        ),
      ],
    );
  }
}

class _CompanyItemSection extends StatelessWidget {
  final List<CompanyItemListRow> items;

  const _CompanyItemSection({required this.items});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
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
            if (items.isNotEmpty)
              Text(
                '${items.length} item',
                style: TextStyle(
                  fontSize: 11,
                  color: cs.onBackground.withOpacity(0.55),
                ),
              ),
          ],
        ),
        const SizedBox(height: 10),
        if (items.isEmpty)
          Text(
            'Belum ada barang terdaftar.',
            style: TextStyle(
              fontSize: 13,
              color: cs.onBackground.withOpacity(0.6),
            ),
          )
        else
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final item = items[index];
              return CompanyItemCard(row: item);
            },
          ),
      ],
    );
  }
}
