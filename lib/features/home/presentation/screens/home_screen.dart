import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:inventory_sync_apps/features/inventory/data/inventory_repository.dart';
import 'package:inventory_sync_apps/core/db/daos/category_dao.dart';
import 'package:inventory_sync_apps/core/db/daos/company_item_dao.dart';

import '../../../inventory/presentation/screens/company_item_detail_screen.dart';
import '../../../search_item/presentation/screen/search_item_screen.dart';
import '../../../variant/presentation/screen/create_variant_screen.dart';
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
        title: const Text(
          'MP Inventory',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // TODO: sambungkan ke SyncRepository.pullSinceLast() kalau mau manual sync.
              // final syncRepo = context.read<SyncRepository>();
              // await syncRepo.pullSinceLast();
            },
            icon: const Icon(Icons.refresh_rounded),
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
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                children: [
                  _SearchBar(),
                  const SizedBox(height: 20),
                  _CategorySection(categories: loaded.categories),
                  const SizedBox(height: 20),
                  _CompanyItemSection(items: loaded.companyItems),
                ],
              ),
            );
          },
        ),
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
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const SearchItemScreen()));
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: cs.surface,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(
                  Icons.search_rounded,
                  color: cs.onSurface.withOpacity(0.5),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Cari kode / nama barang (mis. 030, Bearing...)',
                    style: TextStyle(
                      color: cs.onSurface.withOpacity(0.45),
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
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
              'BARANG TERBARU',
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
              return CompanyItemCard(
                row: item,
                // onTap: () {
                //   dev.log('TOTAL VARIANT: ${item.totalVariants}');
                //   if (item.totalVariants == 0) {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) => CreateVariantScreen(
                //           companyItemId: item.companyItemId,
                //           userId: 'SDWDSD',
                //           productName: item.productName,
                //           companyCode: item.companyCode,
                //         ),
                //       ),
                //     );
                //   } else {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (_) => CompanyItemDetailScreen(
                //           companyItemId: item.companyItemId,
                //         ),
                //       ),
                //     );
                //   }
                // },
              );
            },
          ),
      ],
    );
  }
}
