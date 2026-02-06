import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_sync_apps/core/db/app_database.dart';
import 'package:inventory_sync_apps/core/db/model/unit_row.dart';
import 'package:inventory_sync_apps/core/db/model/variant_detail_row.dart';
import 'package:inventory_sync_apps/core/styles/color_scheme.dart';
import 'package:inventory_sync_apps/core/styles/text_theme.dart';
import 'package:inventory_sync_apps/core/utils/custom_back_button.dart';
import 'package:inventory_sync_apps/features/labeling/data/labeling_repository.dart';
import 'package:inventory_sync_apps/features/unit/widget/unit_card.dart';
import 'package:inventory_sync_apps/shared/presentation/widgets/search_field_widget.dart';

class VariantUnitListScreen extends StatefulWidget {
  final VariantDetailRow variant;
  const VariantUnitListScreen({super.key, required this.variant});

  @override
  State<VariantUnitListScreen> createState() => _VariantUnitListScreenState();
}

class _VariantUnitListScreenState extends State<VariantUnitListScreen> {
  String search = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColors.onSurface),
        backgroundColor: AppColors.background,
        leading: CustomBackButton(),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.variant.name,
              style: TextStyle(
                color: AppColors.onSurface,
                fontSize: 15,
                fontWeight: FontWeight.w500,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(height: 3),
            Text(
              widget.variant.companyCode,
              style: AppTextStyles.mono.copyWith(
                color: AppColors.primary,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        foregroundColor: Colors.transparent,
        // bottom: const PreferredSize(
        //   preferredSize: Size.fromHeight(1),
        //   child: Divider(height: 1, thickness: 1),
        // ),
        elevation: 1,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: SearchFieldWidget(
              hintText: 'Cari id unit',
              onChanged: (v) => setState(() => search = v),
            ),
          ),

          Divider(height: 0),

          Expanded(
            child: StreamBuilder<List<UnitRow>>(
              stream: context.watch<LabelingRepository>().watchUnitsByVariantId(
                widget.variant.variantId,
                search: search,
              ),
              builder: (context, snapshot) {
                var data = snapshot.data ?? [];

                if (data.isEmpty) {
                  return Center(
                    child: Text("Belum ada unit pada ${widget.variant.name}"),
                  );
                }

                // if (selectedWarehouseId != null) {
                //   data = data
                //       .where((r) => r.rack.warehouseId == selectedWarehouseId)
                //       .toList();
                // }

                return ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  itemCount: data.length,
                  separatorBuilder: (_, __) => SizedBox(height: 10),
                  itemBuilder: (context, i) {
                    final unit = data[i];
                    return GestureDetector(
                      onTap: () {},
                      child: UnitCard(row: unit),
                    );
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
