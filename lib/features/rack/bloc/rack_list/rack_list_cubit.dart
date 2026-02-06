import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:inventory_sync_apps/core/db/tables.dart';
import 'package:inventory_sync_apps/features/labeling/data/labeling_repository.dart';
import '../../../../core/db/model/rack_with_warehouse_sections.dart';
import '../../../printer/bloc/printer_cubit.dart';

part 'rack_list_state.dart';

class RackListCubit extends Cubit<RackListState> {
  final LabelingRepository rackRepository;
  final PrinterCubit printerCubit;

  StreamSubscription? _racksSubscription;
  StreamSubscription? _printerSubscription;

  RackListCubit({required this.rackRepository, required this.printerCubit})
    : super(RackListState.initial());

  // Watch racks dan printer status
  void watchRacks() {
    emit(state.copyWith(status: RackListStatus.loading));

    // Subscribe to racks stream
    _racksSubscription = rackRepository.watchRacks().listen(
      (racks) {
        // Extract unique warehouses
        final warehouses = _extractWarehouses(racks);

        emit(
          state.copyWith(
            status: RackListStatus.loaded,
            racks: racks,
            warehouses: warehouses,
            filteredRacks: _applyFilter(
              racks,
              state.searchQuery,
              state.selectedWarehouseId,
            ),
          ),
        );
      },
      onError: (error) {
        emit(
          state.copyWith(
            status: RackListStatus.error,
            errorMessage: error.toString(),
          ),
        );
      },
    );

    // Subscribe to printer status via stream
    _printerSubscription = printerCubit.stream.listen((printerState) {
      emit(
        state.copyWith(
          printerStatus: printerState.isConnected
              ? PrinterConnectionStatus.connected
              : PrinterConnectionStatus.disconnected,
        ),
      );
    });

    emit(
      state.copyWith(
        printerStatus: printerCubit.state.isConnected
            ? PrinterConnectionStatus.connected
            : PrinterConnectionStatus.disconnected,
      ),
    );
  }

  // Search/filter racks
  void searchRacks(String query) {
    final filtered = _applyFilter(
      state.racks,
      query,
      state.selectedWarehouseId,
    );
    emit(state.copyWith(searchQuery: query, filteredRacks: filtered));
  }

  // Select warehouse filter
  void selectWarehouse(String? warehouseId) {
    final filtered = _applyFilter(state.racks, state.searchQuery, warehouseId);
    emit(
      state.copyWith(
        selectedWarehouseId: warehouseId,
        clearWarehouseFilter: warehouseId == null,
        filteredRacks: filtered,
      ),
    );
  }

  // Extract unique warehouses from racks
  List<WarehouseInfo> _extractWarehouses(
    List<RackWithWarehouseAndSections> racks,
  ) {
    final warehouses = <WarehouseInfo>[];
    final seen = <String>{};

    for (var rack in racks) {
      if (!seen.contains(rack.warehouseId)) {
        seen.add(rack.warehouseId);
        warehouses.add(
          WarehouseInfo(id: rack.warehouseId, name: rack.warehouseName),
        );
      }
    }

    return warehouses;
  }

  // Helper untuk filter
  List<RackWithWarehouseAndSections> _applyFilter(
    List<RackWithWarehouseAndSections> racks,
    String? query,
    String? warehouseId,
  ) {
    var filtered = racks;

    // Filter by warehouse first
    if (warehouseId != null) {
      filtered = filtered.where((r) => r.warehouseId == warehouseId).toList();
    }

    // Then filter by search query
    if (query == null || query.trim().isEmpty) {
      return filtered;
    }

    final lowerQuery = query.toLowerCase();
    return filtered.where((rack) {
      // Search by rack name, warehouse name, or section codes
      final matchRackName = rack.rackName.toLowerCase().contains(lowerQuery);
      final matchWarehouse = rack.warehouseName.toLowerCase().contains(
        lowerQuery,
      );
      final matchSectionCode = rack.sectionCodes.any(
        (code) => code.toLowerCase().contains(lowerQuery),
      );

      return matchRackName || matchWarehouse || matchSectionCode;
    }).toList();
  }

  // Check printer connection
  void checkPrinterConnection() {
    printerCubit.checkConnection();
  }

  // Navigate to printer management (dari screen, bukan cubit)
  // Atau bisa trigger reconnect
  void reconnectPrinter() {
    if (printerCubit.state.selectedDevice != null) {
      printerCubit.reconnect();
    }
  }

  @override
  Future<void> close() {
    _racksSubscription?.cancel();
    _printerSubscription?.cancel();
    return super.close();
  }
}
