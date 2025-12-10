import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_sync_apps/core/db/daos/component_dao.dart';
import 'package:inventory_sync_apps/core/db/daos/variant_dao.dart';
import 'package:inventory_sync_apps/core/styles/color_scheme.dart';
import 'package:inventory_sync_apps/features/inventory/presentation/screens/create_component_separate_screen.dart';
import 'package:inventory_sync_apps/shared/presentation/widgets/primary_button.dart';
import 'package:inventory_sync_apps/shared/presentation/widgets/search_field_widget.dart';
import '../../../../core/styles/app_style.dart';
import '../../../../shared/models/selected_brand_result.dart';
import '../../../../core/db/app_database.dart';
import '../../data/inventory_repository.dart';
import '../../data/model/component_request.dart';
import '../widget/separate_component_card.dart';

class ComponentPickerScreen extends StatefulWidget {
  final String type;
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
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            size: 18,
            weight: 260,
            color: AppColors.onSurface,
          ),
        ),
        title: Text(
          'Pilih Komponen',
          overflow: TextOverflow.ellipsis,
          style: AppStyle.monoTextStyle.copyWith(
            color: AppColors.onSurface,
            fontSize: 16,
            fontWeight: FontWeight.w900,
          ),
        ),
        foregroundColor: Colors.transparent,
      ),
      floatingActionButton: CustomButton(
        radius: 1000,
        color: AppColors.primaryDark,
        width: 150,
        child: Text(
          '+  Tambah Komponen',
          style: AppStyle.poppinsTextSStyle.copyWith(
            color: AppColors.surface,
            fontWeight: FontWeight.w600,
          ),
        ),
        onPressed: () async {
          final repo = context.read<InventoryRepository>();

          final result = await Navigator.push<ComponentRequest>(
            context,
            MaterialPageRoute(
              builder: (_) => CreateComponentSeparateScreen(
                variantDetailRow: widget.variant,
              ),
            ),
          );
          if (result != null) {
            await repo.createComponentAndAttach(
              type: 'SEPARATE',
              productId: widget.variant.productId,
              brandId: widget.variant.brandId,
              name: result.name.trim(),
              manufCode: result.manufCode?.trim(),
              specification: result.specification?.trim(),
              variantId: widget.variant.variantId,
              photos: result.pathPhotos,
              // type: 'IN_BOX',
            );
            if (mounted) Navigator.pop(context);
          }
        },
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: SearchFieldWidget(
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
}
