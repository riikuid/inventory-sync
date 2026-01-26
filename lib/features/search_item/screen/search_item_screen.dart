import 'dart:collection';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:inventory_sync_apps/core/styles/color_scheme.dart';
import 'package:inventory_sync_apps/core/utils/custom_back_button.dart';
import 'package:inventory_sync_apps/features/inventory/data/inventory_repository.dart';
import 'package:inventory_sync_apps/core/db/daos/company_item_dao.dart';
import 'package:inventory_sync_apps/shared/presentation/widgets/text_field_widget.dart';

import '../../../shared/presentation/widgets/search_field_widget.dart';
import '../../company_item/widget/company_item_card.dart';
import '../../inventory/data/model/inventory_search_item.dart';
import '../../company_item/screen/company_item_detail_screen.dart';
import '../../variant/screen/create_variant_screen.dart';
import '../bloc/search_item_cubit.dart';

class SearchItemScreen extends StatelessWidget {
  const SearchItemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => SearchItemCubit(ctx.read<InventoryRepository>()),
      child: const _SearchItemView(),
    );
  }
}

class _SearchItemView extends StatefulWidget {
  const _SearchItemView();

  @override
  State<_SearchItemView> createState() => _SearchItemViewState();
}

class _SearchItemViewState extends State<_SearchItemView> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSubmitted(String value) {
    context.read<SearchItemCubit>().search(value);
  }

  void _onClear() {
    _controller.clear();
    context.read<SearchItemCubit>().emit(SearchItemInitial());
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: cs.background,
        foregroundColor: cs.onBackground,
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
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsetsGeometry.symmetric(horizontal: 16),
              child: Hero(
                tag: 'inventory-search-bar',
                child: Material(
                  child: SearchFieldWidget(
                    hintText: 'Cari kode / nama barang (mis. 030, Bearing...)',
                    controller: _controller,
                    focusNode: _focusNode, // pass focus node
                    onClear: () {
                      _controller.clear();
                      // optionally keep focus after clear:
                      _focusNode.requestFocus();
                    },
                    onSubmitted: _onSubmitted,
                  ),
                ),
              ),
            ),
            // SEARCH BAR
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 16),
            //   child: Hero(
            //     tag: 'inventory-search-bar',
            //     child: Material(
            //       color: Colors.transparent,
            //       child: Container(
            //         padding: const EdgeInsets.symmetric(
            //           horizontal: 16,
            //           vertical: 4,
            //         ),
            //         decoration: BoxDecoration(
            //           color: cs.surface,
            //           borderRadius: BorderRadius.circular(24),
            //           boxShadow: [
            //             BoxShadow(
            //               color: Colors.black.withOpacity(0.04),
            //               blurRadius: 18,
            //               offset: const Offset(0, 8),
            //             ),
            //           ],
            //         ),
            //         child: Row(
            //           children: [
            //             Icon(
            //               Icons.search_rounded,
            //               color: cs.onSurface.withOpacity(0.5),
            //             ),
            //             const SizedBox(width: 8),
            //             Expanded(
            //               child: TextField(
            //                 controller: _controller,
            //                 focusNode: _focusNode,
            //                 textInputAction: TextInputAction.search,
            //                 onSubmitted: _onSubmitted,
            //                 decoration: InputDecoration(
            //                   contentPadding: const EdgeInsets.symmetric(
            //                     horizontal: 6,
            //                     vertical: 12,
            //                   ),
            //                   hintText:
            //                       'Cari kode / nama barang (mis. 030, Bearing...)',
            //                   border: InputBorder.none,
            //                   isDense: true,
            //                   hintStyle: TextStyle(
            //                     color: cs.onSurface.withOpacity(0.45),
            //                     fontSize: 14,
            //                   ),
            //                 ),
            //                 style: const TextStyle(fontSize: 14),
            //               ),
            //             ),
            //             if (_controller.text.isNotEmpty)
            //               GestureDetector(
            //                 onTap: _onClear,
            //                 child: Icon(
            //                   Icons.close_rounded,
            //                   size: 18,
            //                   color: cs.onSurface.withOpacity(0.5),
            //                 ),
            //               ),
            //           ],
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            const SizedBox(height: 16),

            // BODY
            Expanded(
              child: BlocBuilder<SearchItemCubit, SearchItemState>(
                builder: (context, state) {
                  if (state is SearchItemInitial) {
                    return Center(
                      child: Text(
                        'Cari item berdasarkan company code\nmis. 043, 058, 0030\natau nama produk (Bearing, Forklift Wheel...)',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          color: cs.onBackground.withOpacity(0.65),
                        ),
                      ),
                    );
                  }

                  if (state is SearchItemLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is SearchItemEmpty) {
                    return Center(
                      child: Text(
                        'Tidak ada hasil untuk "${_controller.text}".',
                        style: TextStyle(
                          fontSize: 13,
                          color: cs.onBackground.withOpacity(0.7),
                        ),
                      ),
                    );
                  }

                  if (state is SearchItemError) {
                    return Center(
                      child: Text(
                        'Terjadi kesalahan.\n${state.message}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 13),
                      ),
                    );
                  }

                  final loaded = state as SearchItemLoaded;
                  final items = loaded.items;

                  // --- GROUP BY CATEGORY ---
                  final grouped = _groupByCategory(
                    items,
                  ); // LinkedHashMap<String, List<InventorySearchItem>>
                  final totalCount = items.length;

                  return ListView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    children: [
                      // Header "HASIL PENCARIAN"
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'HASIL PENCARIAN',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.2,
                              color: cs.onBackground.withOpacity(0.7),
                            ),
                          ),
                          Text(
                            '$totalCount item',
                            style: TextStyle(
                              fontSize: 11,
                              color: cs.onBackground.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Section per kategori
                      for (final entry in grouped.entries) ...[
                        _CategoryResultHeader(
                          categoryName: entry.key,
                          count: entry.value.length,
                        ),
                        const SizedBox(height: 8),
                        // list card per kategori
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: entry.value.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            final item = entry.value[index];

                            // convert ke CompanyItemListRow supaya bisa pakai CompanyItemCard
                            final row = CompanyItemListRow(
                              companyItemId: item.companyItemId,
                              companyCode: item.companyCode,
                              productName: item.productName,
                              categoryName: item.categoryName,
                              totalVariants: item.variantCount,
                            );

                            return CompanyItemCard(row: row);
                          },
                        ),
                        const SizedBox(height: 16),
                      ],
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Header kategori di hasil pencarian:
///  SPARE PART   (2)
class _CategoryResultHeader extends StatelessWidget {
  final String categoryName;
  final int count;

  const _CategoryResultHeader({
    required this.categoryName,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      children: [
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(child: Container(height: 1, color: cs.outlineVariant)),
            const SizedBox(width: 12),
            Text(
              categoryName.toUpperCase(),
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.4,
                color: cs.onBackground.withOpacity(0.7),
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: cs.surface,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: cs.outlineVariant),
              ),
              child: Text(
                '$count',
                style: TextStyle(
                  fontSize: 11,
                  color: cs.onSurface.withOpacity(0.75),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(child: Container(height: 1, color: cs.outlineVariant)),
          ],
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

/// Helper: group hasil search berdasarkan kategori utama
LinkedHashMap<String, List<InventorySearchItem>> _groupByCategory(
  List<InventorySearchItem> items,
) {
  final map = <String, List<InventorySearchItem>>{};

  for (final item in items) {
    final name = (item.categoryName ?? 'Others').trim();
    map.putIfAbsent(name, () => []).add(item);
  }

  // Biar urutannya stabil, pakai LinkedHashMap
  final sortedKeys = map.keys.toList()..sort();
  final result = LinkedHashMap<String, List<InventorySearchItem>>();
  for (final k in sortedKeys) {
    result[k] = map[k]!;
  }
  return result;
}
