import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            weight: 260,
            color: AppColors.onSurface,
          ),
        ),
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
            fontSize: 15,
            fontWeight: FontWeight.w900,
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

          // Default Tanpa Brand
          ListTile(
            title: const Text("Tanpa Brand"),
            onTap: () => Navigator.pop(
              context,
              SelectedBrandResult(null, "Tanpa Brand"),
            ),
          ),
          const Divider(height: 1),

          Expanded(
            child: StreamBuilder<List<Brand>>(
              stream: db.brandDao.watchBrands(
                search: search,
              ), // DAO implement manual bentar
              builder: (context, snapshot) {
                final items = snapshot.data ?? [];

                return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (_, i) {
                    final brand = items[i];
                    return ListTile(
                      title: Text(brand.name),
                      onTap: () => Navigator.pop(
                        context,
                        SelectedBrandResult(brand.id, brand.name),
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
