import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../inventory/data/inventory_repository.dart';
import '../../../../core/db/app_database.dart';

part 'edit_company_item_state.dart';

class EditCompanyItemCubit extends Cubit<EditCompanyItemState> {
  final InventoryRepository inventoryRepository;
  final String companyItemId;

  EditCompanyItemCubit({
    required this.inventoryRepository,
    required this.companyItemId,
  }) : super(EditCompanyItemState.initial());

  // Load company item data
  Future<void> loadCompanyItem() async {
    emit(state.copyWith(status: EditCompanyItemStatus.loading));

    try {
      final companyItem = await inventoryRepository.getCompanyItemById(
        companyItemId,
      );

      if (companyItem == null) {
        emit(
          state.copyWith(
            status: EditCompanyItemStatus.failure,
            errorMessage: 'Company Item tidak ditemukan',
          ),
        );
        return;
      }

      // Ambil informasi rack lengkap jika ada defaultRackId
      String? rackName;
      if (companyItem.defaultRackId != null) {
        final rackDetails = await inventoryRepository.getRackById(
          companyItem.defaultRackId!,
        );
        if (rackDetails != null) {
          if (rackDetails is Map<String, dynamic>) {
            rackName = rackDetails['displayName'] as String?;
          } else {
            rackName = rackDetails.name;
          }
        }
      }

      emit(
        state.copyWith(
          status: EditCompanyItemStatus.loaded,
          rackId: companyItem.defaultRackId,
          rackName: rackName,
        ),
      );
    } catch (e) {
      log('Error loading company item: $e');
      emit(
        state.copyWith(
          status: EditCompanyItemStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  // Set rack
  void setRack(String rackId, String rackName) {
    emit(state.copyWith(rackId: rackId, rackName: rackName));
  }

  // Validasi: rack harus diisi
  bool get canSubmit => state.rackId != null && state.rackId!.isNotEmpty;

  // Submit update
  Future<void> submit() async {
    if (!canSubmit) return;

    emit(state.copyWith(status: EditCompanyItemStatus.loading));

    try {
      await inventoryRepository.updateCompanyItemDefaultRack(
        companyItemId: companyItemId,
        rackId: state.rackId!,
      );

      emit(state.copyWith(status: EditCompanyItemStatus.success));
    } catch (e) {
      log('Error updating company item: $e');
      emit(
        state.copyWith(
          status: EditCompanyItemStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
