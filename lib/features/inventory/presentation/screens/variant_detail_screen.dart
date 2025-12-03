// lib/features/inventory/presentation/screens/variant_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:inventory_sync_apps/core/styles/color_scheme.dart';
import '../../../../core/db/app_database.dart';
import '../../../../core/db/daos/variant_dao.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../labeling/data/labeling_repository.dart';
import '../../../labeling/presentation/bloc/label_set/label_state_cubit.dart';
import '../../../labeling/presentation/screens/label_set_screen.dart';
import '../../../labeling/presentation/screens/label_component_screen.dart';
import '../../../labeling/presentation/screens/assembly_screen.dart';
import '../../data/inventory_repository.dart';
import '../bloc/variant_detail/variant_detail_cubit.dart';
import '../bloc/variant_detail/variant_detail_state.dart';

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
    return BlocProvider(
      create: (ctx) {
        final repo = ctx.read<InventoryRepository>();
        final cubit = VariantDetailCubit(repo);
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
      listenWhen: (prev, curr) =>
          curr is VariantDetailLoaded && curr.errorMessage != null,
      listener: (context, state) {
        if (state is VariantDetailLoaded && state.errorMessage != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
        }
      },
      builder: (context, state) {
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
          final detail = state.detail;
          final isSet = detail.isSet;

          return Scaffold(
            appBar: AppBar(
              title: Text(
                '${detail.companyCode} • ${detail.name}',
                overflow: TextOverflow.ellipsis,
              ),
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            bottomNavigationBar: _buildLabelingActions(context, detail),
            body: Stack(
              children: [
                ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _buildHeader(detail),
                    const SizedBox(height: 16),
                    if (isSet) ...[
                      _buildComponentsSection(context, detail),
                      const SizedBox(height: 16),
                      // _buildLabelingActionsForSet(context, detail),
                    ] else ...[
                      // _buildLabelingActionsForSingle(context, detail),
                    ],
                    const SizedBox(height: 16),
                    _buildUnitSummary(context, detail),
                  ],
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

  Widget _buildHeader(VariantDetailRow d) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              d.name,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
            ),
            const SizedBox(height: 4),
            Text(
              '${d.companyCode} • ${d.brandName ?? '-'}',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
            ),
            const SizedBox(height: 4),
            if (d.defaultLocation != null)
              Text(
                'Lokasi: ${d.defaultLocation}',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
              ),
            if (d.specSummary != null && d.specSummary!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  d.specSummary!,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildComponentsSection(BuildContext context, VariantDetailRow d) {
    final cubit = context.read<VariantDetailCubit>();

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Komponen dalam Set ini',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                  ),
                ),
                TextButton.icon(
                  onPressed: () async {
                    // buka picker komponen (existing/new)
                    await _openAddComponentSheet(context, d);
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Tambah'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (d.components.isEmpty)
              Text(
                'Belum ada komponen yang terdaftar.\nContoh: Cone, Cup.',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              )
            else
              Column(
                children: d.components.map((c) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      title: Text(c.name),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (c.manufCode != null)
                            Text(
                              'Kode manuf: ${c.manufCode}',
                              style: const TextStyle(fontSize: 12),
                            ),
                          if (c.brandName != null)
                            Text(
                              'Brand: ${c.brandName}',
                              style: const TextStyle(fontSize: 12),
                            ),
                          Text(
                            '${c.totalUnits} unit komponen telah dilabeli',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      trailing: PopupMenuButton<String>(
                        onSelected: (val) async {
                          if (val == 'detach') {
                            await cubit.detachComponent(
                              variantId: d.variantId,
                              componentId: c.componentId,
                            );
                          } else if (val == 'delete') {
                            // optional: konfirmasi
                            await cubit.deleteComponent(
                              componentId: c.componentId,
                            );
                          }
                        },
                        itemBuilder: (ctx) => [
                          const PopupMenuItem(
                            value: 'detach',
                            child: Text('Copot dari set'),
                          ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: Text('Hapus komponen'),
                          ),
                        ],
                      ),
                      onTap: () {
                        // TODO: buka detail komponen (nanti)
                      },
                    ),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabelingActionsForSet(BuildContext context, VariantDetailRow d) {
    final labelingRepo = context.read<LabelingRepository>();

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Aksi Labeling',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilledButton.tonal(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => BlocProvider(
                          create: (ctx) => LabelSetCubit(
                            labelingRepository: labelingRepo,
                            variantId: d.variantId,
                            variantName: d.name,
                            brandName: d.brandName,
                            defaultLocation: d.defaultLocation,
                            userId: userId,
                          ),
                          child: const LabelSetScreen(),
                        ),
                      ),
                    );
                  },
                  child: const Text('Label as Set'),
                ),
                FilledButton.tonal(
                  onPressed: d.components.isEmpty
                      ? null
                      : () async {
                          // pilih komponen dulu baru masuk LabelComponentScreen
                          final comp = await _pickComponentForLabel(context, d);
                          if (comp == null) return;

                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => LabelComponentScreen(
                                variantId: d.variantId,
                                variantName: d.name,
                                componentId: comp.componentId,
                                componentName: comp.name,
                                defaultLocation: d.defaultLocation,
                                userId: userId,
                              ),
                            ),
                          );
                        },
                  child: const Text('Label per Component'),
                ),
                FilledButton.tonal(
                  onPressed: d.components.length < 2
                      ? null
                      : () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => AssemblyScreen(
                                variantId: d.variantId,
                                variantName: d.name,
                                componentIds: d.components
                                    .map((c) => c.componentId)
                                    .toList(),
                                userId: userId,
                              ),
                            ),
                          );
                        },
                  child: const Text('Assembly'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabelingActions(BuildContext context, VariantDetailRow d) {
    final labelingRepo = context.read<LabelingRepository>();

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.onPrimary,
        boxShadow: [
          BoxShadow(
            color: const Color(0x10000000),
            blurRadius: 10,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomButton(
              height: 40,
              elevation: 0,
              color: AppColors.secondary,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => BlocProvider(
                      create: (ctx) => LabelSetCubit(
                        labelingRepository: labelingRepo,
                        variantId: d.variantId,
                        variantName: d.name,
                        brandName: d.brandName,
                        defaultLocation: d.defaultLocation,
                        userId: userId,
                      ),
                      child: const LabelSetScreen(),
                    ),
                  ),
                );
              },
              child: Text(
                'Label as Set',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.onSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    height: 40,
                    elevation: 0,
                    color: AppColors.surface,
                    borderColor: AppColors.primary,
                    onPressed: d.components.isEmpty
                        ? null
                        : () async {
                            // pilih komponen dulu baru masuk LabelComponentScreen
                            final comp = await _pickComponentForLabel(
                              context,
                              d,
                            );
                            if (comp == null) return;

                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => LabelComponentScreen(
                                  variantId: d.variantId,
                                  variantName: d.name,
                                  componentId: comp.componentId,
                                  componentName: comp.name,
                                  defaultLocation: d.defaultLocation,
                                  userId: userId,
                                ),
                              ),
                            );
                          },
                    child: Text(
                      'Label Component',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 10),
                Expanded(
                  child: CustomButton(
                    height: 40,
                    elevation: 0,
                    color: AppColors.surface,
                    borderColor: AppColors.primary,
                    onPressed: d.components.length < 2
                        ? null
                        : () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => AssemblyScreen(
                                  variantId: d.variantId,
                                  variantName: d.name,
                                  componentIds: d.components
                                      .map((c) => c.componentId)
                                      .toList(),
                                  userId: userId,
                                ),
                              ),
                            );
                          },
                    child: Text(
                      'Gabungkan',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabelingActionsForSingle(
    BuildContext context,
    VariantDetailRow d,
  ) {
    final labelingRepo = context.read<LabelingRepository>();

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Labeling',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  foregroundColor: Colors.black,
                ),
                onPressed: () {
                  // Single bisa reuse LabelSetScreen tapi konsep "set" = 1 komponen
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => BlocProvider(
                        create: (ctx) => LabelSetCubit(
                          labelingRepository: labelingRepo,
                          variantId: d.variantId,
                          variantName: d.name,
                          brandName: d.brandName,
                          defaultLocation: d.defaultLocation,
                          userId: userId,
                        ),
                        child: const LabelSetScreen(),
                      ),
                    ),
                  );
                },
                child: const Text('Label Item'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUnitSummary(BuildContext context, VariantDetailRow d) {
    return InkWell(
      onTap: () {
        // TODO: buka UnitListScreen untuk variant ini (reprint QR)
      },
      child: Card(
        color: Colors.blueGrey.shade50,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Icon(Icons.qr_code_2, color: AppColors.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${d.totalUnits} unit untuk variant ini telah dilabeli',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Lihat detail untuk re-print QR atau cek status unit.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }

  // ===== Helper bottom sheet: tambah komponen =====

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

        void applyFilter(String q) {
          filtered = components
              .where(
                (c) =>
                    c.name.toLowerCase().contains(q.toLowerCase()) ||
                    (c.manufCode ?? '').toLowerCase().contains(q.toLowerCase()),
              )
              .toList();
        }

        applyFilter('');

        return StatefulBuilder(
          builder: (ctx, setState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(ctx).viewInsets.bottom,
                left: 16,
                right: 16,
                top: 12,
              ),
              child: Column(
                children: [
                  const Text(
                    'Tambah Komponen ke Set',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: searchCtrl,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Cari komponen / kode manuf...',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (v) {
                      setState(() {
                        applyFilter(v);
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filtered.length + 1,
                      itemBuilder: (ctx, index) {
                        if (index == filtered.length) {
                          return ListTile(
                            leading: const Icon(Icons.add),
                            title: const Text('Buat komponen baru'),
                            onTap: () {
                              Navigator.of(ctx).pop();
                              _openCreateComponentDialog(context, d);
                            },
                          );
                        }
                        final c = filtered[index];
                        return ListTile(
                          title: Text(c.name),
                          subtitle: c.manufCode != null
                              ? Text(
                                  'Kode manuf: ${c.manufCode}',
                                  style: const TextStyle(fontSize: 12),
                                )
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
      builder: (ctx) {
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
                    labelText: 'Spek singkat (opsional)',
                  ),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );

    if (result != true) return;

    final comp = await repo.createComponentForVariantProduct(
      productId: d.productId,
      brandId: d.brandId, // default brand = brand variant
      name: nameCtrl.text.trim(),
      manufCode: codeCtrl.text.trim().isEmpty ? null : codeCtrl.text.trim(),
      specJson: specCtrl.text.trim().isEmpty ? null : specCtrl.text.trim(),
    );

    await cubit.addComponentFromExisting(
      variantId: d.variantId,
      componentId: comp.id,
    );
  }

  Future<VariantComponentRow?> _pickComponentForLabel(
    BuildContext context,
    VariantDetailRow d,
  ) async {
    if (d.components.isEmpty) return null;

    return showModalBottomSheet<VariantComponentRow>(
      context: context,
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(12),
                child: Text(
                  'Pilih komponen untuk labeling',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                ),
              ),
              ...d.components.map(
                (c) => ListTile(
                  title: Text(c.name),
                  subtitle: c.manufCode != null
                      ? Text(
                          'Kode manuf: ${c.manufCode}',
                          style: const TextStyle(fontSize: 12),
                        )
                      : null,
                  onTap: () => Navigator.of(ctx).pop(c),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
