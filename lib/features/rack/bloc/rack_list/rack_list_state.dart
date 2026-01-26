part of 'rack_list_cubit.dart';

enum RackListStatus { initial, loading, loaded, error }

enum PrinterConnectionStatus { disconnected, connecting, connected }

class WarehouseInfo {
  final String id;
  final String name;

  const WarehouseInfo({required this.id, required this.name});
}

class RackListState extends Equatable {
  final RackListStatus status;
  final List<RackWithWarehouseAndSections> racks;
  final List<RackWithWarehouseAndSections> filteredRacks;
  final List<WarehouseInfo> warehouses;
  final String? selectedWarehouseId;
  final PrinterConnectionStatus printerStatus;
  final String? searchQuery;
  final String? errorMessage;

  const RackListState({
    required this.status,
    required this.racks,
    required this.filteredRacks,
    required this.warehouses,
    this.selectedWarehouseId,
    required this.printerStatus,
    this.searchQuery,
    this.errorMessage,
  });

  factory RackListState.initial() => const RackListState(
    status: RackListStatus.initial,
    racks: [],
    filteredRacks: [],
    warehouses: [],
    selectedWarehouseId: null,
    printerStatus: PrinterConnectionStatus.disconnected,
    searchQuery: null,
    errorMessage: null,
  );

  RackListState copyWith({
    RackListStatus? status,
    List<RackWithWarehouseAndSections>? racks,
    List<RackWithWarehouseAndSections>? filteredRacks,
    List<WarehouseInfo>? warehouses,
    String? selectedWarehouseId,
    bool clearWarehouseFilter = false,
    PrinterConnectionStatus? printerStatus,
    String? searchQuery,
    String? errorMessage,
  }) {
    return RackListState(
      status: status ?? this.status,
      racks: racks ?? this.racks,
      filteredRacks: filteredRacks ?? this.filteredRacks,
      warehouses: warehouses ?? this.warehouses,
      selectedWarehouseId: clearWarehouseFilter
          ? null
          : (selectedWarehouseId ?? this.selectedWarehouseId),
      printerStatus: printerStatus ?? this.printerStatus,
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    racks,
    filteredRacks,
    warehouses,
    selectedWarehouseId,
    printerStatus,
    searchQuery,
    errorMessage,
  ];
}
