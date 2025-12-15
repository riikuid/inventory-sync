import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/db/app_database.dart';
import '../../../core/db/daos/rack_dao.dart'; // pastikan tersedia
import '../../models/selected_rack_result.dart';

class RackPickerScreen extends StatefulWidget {
  const RackPickerScreen({super.key});

  @override
  State<RackPickerScreen> createState() => _RackPickerScreenState();
}

class _RackPickerScreenState extends State<RackPickerScreen> {
  String search = "";

  @override
  Widget build(BuildContext context) {
    final db = context.read<AppDatabase>();

    return Scaffold(
      appBar: AppBar(title: const Text("Pilih Rak")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: const InputDecoration(
                hintText: "Cari Rak...",
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (v) => setState(() => search = v),
            ),
          ),

          Expanded(
            child: StreamBuilder<List<RackWithContext>>(
              stream: db.rackDao.watchRacks(search: search),
              builder: (context, snapshot) {
                final data = snapshot.data ?? [];

                if (data.isEmpty) {
                  return const Center(child: Text("Tidak ada rak ditemukan"));
                }

                return ListView.separated(
                  itemCount: data.length,
                  separatorBuilder: (_, __) => Divider(height: 1),
                  itemBuilder: (context, i) {
                    final rack = data[i];
                    return ListTile(
                      title: Text(rack.rack.name),
                      subtitle: Text(
                        '${rack.warehouseName} - ${rack.departmentName}',
                      ),
                      onTap: () {
                        Navigator.pop(
                          context,
                          SelectedRackResult(
                            id: rack.rack.id,
                            name: rack.rack.name,
                            warehouseName: rack.warehouseName,
                            sectionName: rack.sectionName,
                            departmentName: rack.departmentName,
                          ),
                        );
                      },
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
