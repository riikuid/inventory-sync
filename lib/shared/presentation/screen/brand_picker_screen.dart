import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      appBar: AppBar(title: const Text("Pilih Brand")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: const InputDecoration(
                hintText: "Cari Brand...",
                prefixIcon: Icon(Icons.search),
              ),
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
