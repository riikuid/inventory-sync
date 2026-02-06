import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:inventory_sync_apps/core/styles/color_scheme.dart';
import 'package:inventory_sync_apps/core/utils/custom_back_button.dart';
import 'package:inventory_sync_apps/core/utils/simple_loader.dart';

import 'package:inventory_sync_apps/features/purchase_order/models/purchase_order.dart';
import 'package:inventory_sync_apps/features/purchase_order/usecases/get_purchase_orders/get_purchase_orders.dart';
import 'package:inventory_sync_apps/features/purchase_order/widget/purchase_order_card.dart';
import 'package:inventory_sync_apps/features/sync/bloc/sync_cubit.dart';
import 'package:inventory_sync_apps/shared/presentation/widgets/search_field_widget.dart';

class PurchaseOrderListScreen extends StatefulWidget {
  final List<String> userSectionIds;
  const PurchaseOrderListScreen({super.key, required this.userSectionIds});

  @override
  State<PurchaseOrderListScreen> createState() =>
      _PurchaseOrderListScreenState();
}

class _PurchaseOrderListScreenState extends State<PurchaseOrderListScreen> {
  final _statuses = const [
    {'value': null, 'label': 'Semua'},
    {'value': 'belum', 'label': 'Menunggu Diterima'},
    {'value': 'proses', 'label': 'Dalam Proses'},
    {'value': 'selesai', 'label': 'Selesai'},
  ];

  final TextEditingController _searchController = TextEditingController();

  /// null = semua, 0 = ditolak, 1 = disetujui, 2 = menunggu persetujuan
  String? _selectedStatus;
  List<String> _sectionIds = [];

  late final PagingController<int, PurchaseOrder> _paging = PagingController(
    getNextPageKey: (s) => s.lastPageIsEmpty ? null : s.nextIntPageKey,
    fetchPage: (page) async {
      try {
        return await _fetchPurchaseOrdersPaged(page, 10);
      } catch (e) {
        _paging.value = PagingState<int, PurchaseOrder>(error: e);
        return [];
      }
    },
  );

  @override
  void initState() {
    _sectionIds = widget.userSectionIds;
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _paging.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 1,
        leading: CustomBackButton(),
        // bottom: const PreferredSize(
        //   preferredSize: Size.fromHeight(1),
        //   child: Divider(height: 1, thickness: 1),
        // ),
        title: Text(
          'Penerimaan Barang',
          style: TextStyle(
            color: AppColors.onSurface,
            fontSize: 18,
            fontWeight: FontWeight.w600,
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
      body: Column(
        children: [
          Column(
            spacing: 10,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: SearchFieldWidget(
                  controller: _searchController,
                  onChanged: (value) {
                    _paging.refresh();
                  },
                  hintText: 'Cari nomor PO',
                ),
              ),
              SizedBox(
                height: 40,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemCount: _statuses.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final status = _statuses[index];
                    final isSelected = _selectedStatus == status['value'];
                    return InkWell(
                      onTap: () {
                        setState(() {
                          _selectedStatus = status['value'];
                        });
                        _paging.refresh();
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Theme.of(context).primaryColor
                              : Colors.grey[200],
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? Theme.of(context).primaryColor
                                : AppColors.border,
                          ),
                        ),
                        child: Text(
                          status['label'] as String,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Divider(height: 0),
            ],
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                _paging.refresh();
              },
              child: CustomScrollView(
                slivers: [
                  // SliverPadding(
                  //   padding: const EdgeInsets.symmetric(
                  //     horizontal: 16,
                  //     vertical: 8,
                  //   ),
                  //   sliver: SliverToBoxAdapter(
                  //     child: Column(
                  //       crossAxisAlignment: CrossAxisAlignment.start,
                  //       children: [
                  //         Text(
                  //           'DAFTAR PO',
                  //           style: TextStyle(
                  //             letterSpacing: 1.2,
                  //             height: 1,
                  //             fontSize: 12,
                  //             fontWeight: FontWeight.w500,
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    sliver: PagingListener(
                      controller: _paging,
                      builder: (context, state, fetchNextPage) =>
                          PagedSliverList<int, PurchaseOrder>(
                            state: state,
                            fetchNextPage: fetchNextPage,
                            builderDelegate: PagedChildBuilderDelegate(
                              firstPageProgressIndicatorBuilder: (context) =>
                                  const SimpleLoader(
                                    height: 80,
                                    width: double.infinity,
                                    totalItem: 3,
                                  ),
                              newPageProgressIndicatorBuilder: (context) =>
                                  const SimpleLoader(
                                    height: 80,
                                    width: double.infinity,
                                    totalItem: 1,
                                  ),
                              noItemsFoundIndicatorBuilder: (context) =>
                                  const Center(
                                    child: Text('Purchase orders is empty'),
                                  ),
                              firstPageErrorIndicatorBuilder: (context) =>
                                  const Center(
                                    child: Text(
                                      'Failed to get purchase orders',
                                    ),
                                  ),
                              itemBuilder: (context, item, index) {
                                return PurchaseOrderCard(item: item);
                              },
                            ),
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<List<PurchaseOrder>> _fetchPurchaseOrdersPaged(
    int page,
    int limit,
  ) async {
    try {
      final params = GetPurchaseOrdersParams(
        page: page,
        limit: limit,
        status: _selectedStatus,
        sectionIds: _sectionIds,
        // startDate: CustomDateFormat.toYmd(_start),
        // endDate: CustomDateFormat.toYmd(_end),
        search: _searchController.text.isEmpty ? null : _searchController.text,
      );

      dev.log(
        'API CALL submissions → page=$page, status=$_selectedStatus, '
        'q=${params.search}, sectionIds=$_sectionIds',
        // 'start=${params.startDate}, end=${params.endDate}, ',
        name: 'SUB',
      );

      final res = await GetPurchaseOrders().call(params);
      if (!res.isSuccess) throw res.errorMessage ?? 'Failed';
      return res.resultValue ?? <PurchaseOrder>[];
    } catch (e) {
      dev.log('Fetch error PO: $e', name: 'PurchaseOrderListScreen');
      rethrow;
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

  // String _submittedAgo(PurchaseOrder item) {
  //   // sesuaikan dengan field datetime milik submission kamu
  //   final created = item.poDate;
  //   if (created == null) return '';
  //   return CustomDateFormat.timeAgo(created);
  // }
}
