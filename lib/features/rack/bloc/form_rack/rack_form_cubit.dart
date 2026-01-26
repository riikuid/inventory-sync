import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:inventory_sync_apps/core/db/app_database.dart';
import 'package:inventory_sync_apps/features/labeling/data/labeling_repository.dart';

part 'rack_form_state.dart';

class RackFormCubit extends Cubit<RackFormState> {
  final LabelingRepository repo;
  final String? rackId; // null = create mode, not null = edit mode

  RackFormCubit({required this.repo, this.rackId})
    : super(RackFormState.initial());

  bool get isEditMode => rackId != null;

  // Load rack untuk edit mode
  Future<void> loadRack() async {
    if (rackId == null) return;

    emit(state.copyWith(status: RackFormStatus.loading));

    try {
      final rack = await repo.getRackById(rackId!);
      if (rack == null) {
        emit(
          state.copyWith(
            status: RackFormStatus.failure,
            errorMessage: 'Rack tidak ditemukan',
          ),
        );
        return;
      }

      final warehouses = await repo.getWarehouses();

      emit(
        state.copyWith(
          status: RackFormStatus.loaded,
          rackId: rack.id,
          name: rack.name,
          warehouseId: rack.warehouseId,
          warehouses: warehouses,
        ),
      );
    } catch (e) {
      log('Error loading rack: $e');
      emit(
        state.copyWith(
          status: RackFormStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  // Load warehouses untuk create mode
  Future<void> loadWarehouses() async {
    emit(state.copyWith(status: RackFormStatus.loading));

    try {
      final warehouses = await repo.getWarehouses();
      emit(
        state.copyWith(status: RackFormStatus.loaded, warehouses: warehouses),
      );
    } catch (e) {
      log('Error loading warehouses: $e');
      emit(
        state.copyWith(
          status: RackFormStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  // Setters
  void setName(String name) {
    emit(state.copyWith(name: name));
  }

  void setWarehouse(String warehouseId) {
    emit(state.copyWith(warehouseId: warehouseId));
  }

  // Validation
  bool get canSubmit =>
      state.name.trim().isNotEmpty && state.warehouseId != null;

  // Submit (create or update)
  Future<void> submit() async {
    if (!canSubmit) return;

    emit(state.copyWith(status: RackFormStatus.loading));

    try {
      if (rackId == null) {
        // CREATE MODE
        await repo.createRack(
          name: state.name.trim(),
          warehouseId: state.warehouseId!,
        );
      } else {
        // EDIT MODE
        await repo.updateRack(
          rackId: rackId!,
          name: state.name.trim(),
          warehouseId: state.warehouseId!,
        );
      }

      emit(state.copyWith(status: RackFormStatus.success));
    } catch (e) {
      log('Error submitting rack: $e');
      emit(
        state.copyWith(
          status: RackFormStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
