import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_sync_apps/core/db/daos/component_dao.dart';
import 'package:inventory_sync_apps/core/db/daos/variant_dao.dart';
import 'package:inventory_sync_apps/core/styles/color_scheme.dart';
import 'package:inventory_sync_apps/core/utils/custom_back_button.dart';
import 'package:inventory_sync_apps/features/inventory/presentation/screens/create_component_separate_screen.dart';
import 'package:inventory_sync_apps/shared/presentation/widgets/primary_button.dart';
import 'package:inventory_sync_apps/shared/presentation/widgets/search_field_widget.dart';
import '../../../../core/constant.dart';
import '../../../../core/db/model/variant_detail_row.dart';
import '../../../../core/db/app_database.dart';
import '../../../../core/styles/text_theme.dart';
import '../../data/inventory_repository.dart';
import '../../data/model/component_request.dart';
import '../widget/separate_component_card.dart';
import 'create_component_in_box_screen.dart';

class ComponentPickerScreen extends StatefulWidget {
  final int type;
  final VariantDetailRow variant;
  const ComponentPickerScreen({
    super.key,
    required this.type,
    required this.variant,
  });

  @override
  State<ComponentPickerScreen> createState() => _ComponentPickerScreenState();
}

class _ComponentPickerScreenState extends State<ComponentPickerScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  String _query = '';
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    // debounce 300ms
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      final text = _searchController.text;
      if (text != _query) {
        setState(() => _query = text);
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final db = context.read<AppDatabase>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColors.onSurface),
        backgroundColor: AppColors.background,
        leading: CustomBackButton(),
        title: Text(
          'Pilih Komponen',
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.mono.copyWith(
            color: AppColors.onSurface,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        foregroundColor: Colors.transparent,
      ),

      // floatingActionButton: CustomButton(
      //   radius: 1000,
      //   color: AppColors.primary,
      //   width: 150,
      //   child: Text(
      //     '+  Tambah ${widget.type == inBoxType ? 'Isi' : 'Komponen'}',
      //     style: TextStyle(
      //       color: AppColors.surface,
      //       fontWeight: FontWeight.w600,
      //     ),
      //   ),
      //   onPressed: () async {
      //     final repo = context.read<InventoryRepository>();

      //     final result = await Navigator.push<ComponentRequest>(
      //       context,
      //       MaterialPageRoute(
      //         builder: (_) {
      //           if (widget.type == inBoxType) {
      //             return CreateComponentInBoxScreen(
      //               variantDetailRow: widget.variant,
      //             );
      //           } else {
      //             return CreateComponentSeparateScreen(
      //               variantDetailRow: widget.variant,
      //             );
      //           }
      //         },
      //       ),
      //     );
      //     if (result != null) {
      //       await repo.createComponentAndAttach(
      //         type: widget.type,
      //         productId: widget.variant.productId,
      //         brandId: widget.variant.brandId,
      //         name: result.name.trim(),
      //         manufCode: result.manufCode?.trim(),
      //         specification: result.specification?.trim(),
      //         variantId: widget.variant.variantId,
      //         photos: result.pathPhotos,
      //         // type: inBoxType,
      //       );
      //       if (mounted) Navigator.pop(context);
      //     }
      //   },
      // ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.background,
          border: Border(top: BorderSide(width: 0.2, color: AppColors.border)),
        ),
        child: CustomButton(
          elevation: 0,
          radius: 40,
          height: 50,
          color: AppColors.primary,
          onPressed: () async {
            final repo = context.read<InventoryRepository>();

            final result = await Navigator.push<ComponentRequest>(
              context,
              MaterialPageRoute(
                builder: (_) {
                  if (widget.type == inBoxType) {
                    return CreateComponentInBoxScreen(
                      variantDetailRow: widget.variant,
                    );
                  } else {
                    return CreateComponentSeparateScreen(
                      variantDetailRow: widget.variant,
                    );
                  }
                },
              ),
            );
            if (result != null) {
              await repo.createComponentAndAttach(
                type: widget.type,
                productId: widget.variant.productId,
                brandId: widget.variant.brandId,
                name: result.name.trim(),
                manufCode: result.manufCode?.trim(),
                specification: result.specification?.trim(),
                variantId: widget.variant.variantId,
                photos: result.pathPhotos,
                // type: inBoxType,
              );
              if (mounted) Navigator.pop(context);
            }
          },
          child: Text(
            '+  TAMBAH KOMPONEN',
            style: TextStyle(
              letterSpacing: 1.1,
              color: AppColors.surface,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          widget.type == inBoxType
              ? _buildInBoxHeader()
              : _buildSeparateHeader(),
          Padding(
            padding: const EdgeInsets.all(12),
            child: SearchFieldWidget(
              hintText: 'Cari kata kunci...',
              controller: _searchController,
              focusNode: _searchFocusNode, // pass focus node
              onClear: () {
                _searchController.clear();
                // optionally keep focus after clear:
                _searchFocusNode.requestFocus();
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<List<ComponentWithBrandAndStock>>(
              stream: db.componentDao.watchComponentsByProductAndType(
                productId: widget.variant.productId,
                type: widget.type,
                search: _query, // use debounced _query
              ),
              builder: (context, snapshot) {
                final items = snapshot.data ?? [];
                if (items.isEmpty) {
                  return const Center(
                    child: Text(
                      'Tidak ada komponen terdaftar untuk produk ini\nBuat komponen baru',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.onSurface),
                    ),
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemCount: items.length,

                  itemBuilder: (_, i) {
                    final component = items[i];

                    return GestureDetector(
                      onTap: () =>
                          Navigator.pop(context, component.component.id),
                      child: SeparateComponentCard(item: component),
                    );

                    // return ListTile(
                    //   title: Text(component.name),
                    //   onTap: () => Navigator.pop(context, component.id),
                    // );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeparateHeader() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 1.0, color: AppColors.border),
        color: AppColors.primary.withAlpha(30),
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(18),
      child: Row(
        children: [
          Icon(Icons.layers_outlined, size: 28, color: AppColors.primary),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              spacing: 2,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Komponen Box Terpisah',
                  style: TextStyle(
                    color: AppColors.onSurface,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                Text(
                  'Komponen dengan box/kemasan terpisah',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInBoxHeader() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      padding: const EdgeInsets.all(18),
      child: Row(
        children: [
          Icon(Icons.inbox_outlined, color: AppColors.surface),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Part / Komponen',
                  style: TextStyle(
                    color: AppColors.surface,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                Text(
                  'Pilh komponen untuk varian ini',
                  style: TextStyle(
                    color: AppColors.border,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
