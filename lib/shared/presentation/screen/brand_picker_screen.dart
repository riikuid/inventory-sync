import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_sync_apps/core/styles/text_theme.dart';
import 'package:inventory_sync_apps/core/utils/custom_back_button.dart';
import 'package:inventory_sync_apps/shared/presentation/widgets/search_field_widget.dart';
import '../../../core/styles/app_style.dart';
import '../../../core/styles/color_scheme.dart';
import '../../models/selected_brand_result.dart';
import '../../../core/db/app_database.dart';

class BrandPickerScreen extends StatefulWidget {
  const BrandPickerScreen({super.key});

  @override
  State<BrandPickerScreen> createState() => _BrandPickerScreenState();
}

class _BrandPickerScreenState extends State<BrandPickerScreen> {
  String search = "";

  @override
  Widget build(BuildContext context) {
    final db = context.read<AppDatabase>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColors.onSurface),
        leading: CustomBackButton(),
        backgroundColor: AppColors.background,
        foregroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0.5,
        toolbarHeight: 60,
        title: Text(
          'Pilih Brand',
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: AppColors.onSurface,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            // child: TextField(
            //   decoration: const InputDecoration(
            //     hintText: "Cari Brand...",
            //     prefixIcon: Icon(Icons.search),
            //   ),
            //   onChanged: (v) => setState(() => search = v),
            // ),
            child: SearchFieldWidget(
              hintText: 'Cari nama brand...',
              onChanged: (v) => setState(() => search = v),
            ),
          ),

          GestureDetector(
            onTap: () => Navigator.pop(
              context,
              SelectedBrandResult(null, "Tanpa Brand"),
            ),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              margin: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                // border: Border.all(width: 1.0, color: AppColors.border),
                color: AppColors.surface,
                boxShadow: [AppStyle.defaultBoxShadow],
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
              ),
              child: Text(
                "Tanpa Brand",
                style: TextStyle(
                  color: AppColors.onSurface,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          SizedBox(height: 12),

          // Default Tanpa Brand
          // ListTile(
          //   title: const Text("Tanpa Brand"),
          //   onTap: () => Navigator.pop(
          //     context,
          //     SelectedBrandResult(null, "Tanpa Brand"),
          //   ),
          // ),
          Expanded(
            child: StreamBuilder<List<Brand>>(
              stream: db.brandDao.watchBrands(
                search: search,
              ), // DAO implement manual bentar
              builder: (context, snapshot) {
                final items = snapshot.data ?? [];

                return ListView.separated(
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemCount: items.length,
                  itemBuilder: (_, i) {
                    final brand = items[i];
                    return GestureDetector(
                      onTap: () => Navigator.pop(
                        context,
                        SelectedBrandResult(brand.id, brand.name),
                      ),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 20,
                        ),
                        margin: EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          // border: Border.all(width: 1.0, color: AppColors.border),
                          color: AppColors.surface,
                          boxShadow: [AppStyle.defaultBoxShadow],
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        ),
                        child: Text(
                          brand.name,
                          style: TextStyle(
                            color: AppColors.onSurface,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
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
