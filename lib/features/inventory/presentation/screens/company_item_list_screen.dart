// lib/features/inventory/presentation/screens/company_item_list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:inventory_sync_apps/core/styles/color_scheme.dart';
import 'package:inventory_sync_apps/features/inventory/data/inventory_repository.dart';

import '../bloc/company_item_list/company_item_list_cubit.dart';
import 'company_item_detail_screen.dart';

class CompanyItemListScreen extends StatelessWidget {
  final String productId;
  final String productName;

  const CompanyItemListScreen({
    super.key,
    required this.productId,
    required this.productName,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final repo = context.read<InventoryRepository>();
        final cubit = CompanyItemListCubit(repo);
        cubit.watch(productId: productId);
        return cubit;
      },
      child: _CompanyItemListView(productName: productName),
    );
  }
}

class _CompanyItemListView extends StatelessWidget {
  final String productName;

  const _CompanyItemListView({required this.productName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(productName),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: BlocBuilder<CompanyItemListCubit, CompanyItemListState>(
        builder: (context, state) {
          if (state is CompanyItemListLoading ||
              state is CompanyItemListInitial) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CompanyItemListError) {
            return Center(child: Text('Error: ${state.message}'));
          } else if (state is CompanyItemListEmpty) {
            return const Center(child: Text('Belum ada company item.'));
          } else if (state is CompanyItemListLoaded) {
            final items = state.items;
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final ci = items[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    // leading: Container(
                    //   padding: const EdgeInsets.symmetric(
                    //     horizontal: 12,
                    //     vertical: 8,
                    //   ),
                    //   decoration: BoxDecoration(
                    //     color: Theme.of(
                    //       context,
                    //     ).colorScheme.secondary.withOpacity(0.15),
                    //     borderRadius: BorderRadius.circular(8),
                    //   ),
                    //   child: Text(
                    //     ci.companyCode,
                    //     style: const TextStyle(fontWeight: FontWeight.bold),
                    //   ),
                    // ),
                    title: Text(
                      ci.companyCode,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('${ci.totalUnits} unit'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => CompanyItemDetailScreen(
                            companyItemId: ci.companyItemId,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
