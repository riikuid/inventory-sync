part of 'rack_form_cubit.dart';

enum RackFormStatus { initial, loading, loaded, success, failure }

class RackFormState extends Equatable {
  final RackFormStatus status;
  final String? rackId;
  final String name;
  final String? warehouseId;
  final List<Warehouse> warehouses;
  final String? errorMessage;

  const RackFormState({
    required this.status,
    this.rackId,
    required this.name,
    this.warehouseId,
    required this.warehouses,
    this.errorMessage,
  });

  factory RackFormState.initial() => const RackFormState(
    status: RackFormStatus.initial,
    rackId: null,
    name: '',
    warehouseId: null,
    warehouses: [],
    errorMessage: null,
  );

  RackFormState copyWith({
    RackFormStatus? status,
    String? rackId,
    String? name,
    String? warehouseId,
    List<Warehouse>? warehouses,
    String? errorMessage,
  }) {
    return RackFormState(
      status: status ?? this.status,
      rackId: rackId ?? this.rackId,
      name: name ?? this.name,
      warehouseId: warehouseId ?? this.warehouseId,
      warehouses: warehouses ?? this.warehouses,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    rackId,
    name,
    warehouseId,
    warehouses,
    errorMessage,
  ];
}
