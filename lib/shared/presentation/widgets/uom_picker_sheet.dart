import 'package:flutter/material.dart';
import 'package:inventory_sync_apps/core/db/app_database.dart';
import 'package:inventory_sync_apps/shared/presentation/widgets/text_field_widget.dart';

class UomPickerSheet extends StatefulWidget {
  final List<Uom> uoms;

  const UomPickerSheet({super.key, required this.uoms});

  @override
  State<UomPickerSheet> createState() => _UomPickerSheetState();
}

class _UomPickerSheetState extends State<UomPickerSheet> {
  final TextEditingController _searchController = TextEditingController();
  late List<Uom> _filteredUoms;

  @override
  void initState() {
    super.initState();
    _filteredUoms = widget.uoms;
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredUoms = widget.uoms
          .where((u) => u.name.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        builder: (context, scrollController) {
          return Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: TextFieldWidget(
                  controller: _searchController,
                  hintText: 'Cari Satuan UOM...',
                  label: '',
                  required: false,
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              Expanded(
                child: _filteredUoms.isEmpty
                    ? Center(
                        child: Text(
                          'Tidak ada data ditemukan',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      )
                    : ListView.separated(
                        controller: scrollController,
                        itemCount: _filteredUoms.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (_, i) => ListTile(
                          title: Text(
                            _filteredUoms[i].name,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          onTap: () =>
                              Navigator.of(context).pop(_filteredUoms[i]),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 4,
                          ),
                          trailing: const Icon(
                            Icons.chevron_right,
                            size: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
