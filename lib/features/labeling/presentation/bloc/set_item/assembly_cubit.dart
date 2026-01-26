// lib/features/labeling/presentation/bloc/assembly/assembly_cubit.dart

import 'dart:developer' as dev;

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:inventory_sync_apps/core/db/app_database.dart';
import 'package:inventory_sync_apps/features/labeling/data/labeling_repository.dart';
import '../../../../../core/db/model/variant_component_row.dart';

part 'assembly_state.dart';

class AssemblyCubit extends Cubit<AssemblyState> {
  final LabelingRepository repo;

  AssemblyCubit(this.repo, String variantId, String variantName)
    : super(AssemblyState(variantId: variantId, variantName: variantName));

  /// 1. Load requirements dan AUTO-GENERATE semua units secara Batch
  Future<void> loadRequirements({
    required List<VariantComponentRow> inBoxComponents,
    required String variantRackId,
    required String variantUomId,
    required String variantUomName,
    required String variantRackName,
    required String variantManufCode,
    required int userId,
    required String companyCode,
    required String? poNumber,
    required int? variantPrice,
    int qty = 1,
  }) async {
    emit(state.copyWith(status: AssemblyStatus.loading));

    try {
      List<AssemblyUnitItem> allUnits = [];

      for (int i = 0; i < qty; i++) {
        // A. Generate Parent Unit dulu (Pending)
        final parentUnit = await repo.createParentUnitEntry(
          companyCode: companyCode,
          variantId: state.variantId,
          rackId: variantRackId,
          userId: userId,
          poNumber: poNumber,
          uomId: variantUomId,
          price: variantPrice,
        );

        dev.log('JUMLAH IN BOX: ${inBoxComponents.length}');
        dev.log(
          'PARENT UNIT ID: ${parentUnit.id}, PARENT VARIAN UOM: ${variantUomId}',
        );

        // B. Generate Components (Linked ke Parent)
        for (var component in inBoxComponents) {
          final generatedUnits = await repo.generateBatchLabels(
            variantId: state.variantId,
            companyCode: companyCode,
            rackId: variantRackId,
            batchQty: component.quantity,
            userId: userId,
            componentId: component.componentId,
            manufCode: component.manufCode ?? '-',
            parentUnitId: parentUnit.id, // 👈 Link ke Parent
            poNumber: poNumber,
            contentUomId: variantUomId,
            price: ((variantPrice ?? 0) / inBoxComponents.length).toInt(),
            contentResultQty: 1,
          );

          dev.log('JUMLAH UNIT: ${generatedUnits.length}');

          // Convert Component Units
          for (var unit in generatedUnits) {
            dev.log('UNIT ID: ${unit.id}', name: 'unit komponen');
            allUnits.add(
              AssemblyUnitItem(
                componentId: component.componentId,
                componentName: component.name,
                manufCode: component.manufCode ?? '-',
                rackName: variantRackName,
                rackId: variantRackId,
                unitId: unit.id,
                qrValue: unit.qrValue,
                createdAt: unit.createdAt,
                isPrinted: false,
                isScanned: false,
                parentUnitId: parentUnit.id,
                isParent: false,
                setIndex: i,
                quantity: 1,
              ),
            );
          }
        }

        // C. Tambahkan Parent Unit ke List (di akhir set atau awal set?)
        // Request: QR 1 (Comp A) -> QR 2 (Comp B) -> QR 3 (Parent)
        allUnits.add(
          AssemblyUnitItem(
            componentId: null, // Dummy ID
            componentName: state.variantName, // Link Name to Variant
            manufCode:
                variantManufCode, // Variant Manuf Code? bisa diambil jika ada
            rackName: variantRackName,
            rackId: variantRackId,
            unitId: parentUnit.id,
            qrValue: parentUnit.qrValue,
            createdAt: parentUnit.createdAt,
            isPrinted: false,
            isScanned: false,
            parentUnitId: null, // Parent doesn't have parent
            isParent: true, // 👈 VALID Parent
            setIndex: i,
            quantity: 1,
          ),
        );
      }

      emit(state.copyWith(status: AssemblyStatus.loaded, units: allUnits));
    } catch (e) {
      emit(state.copyWith(status: AssemblyStatus.failure, error: e.toString()));
    }
  }

  /// 2. Mark unit sebagai printed
  void markAsPrinted(int index) {
    if (index < 0 || index >= state.units.length) return;

    final updatedUnits = List<AssemblyUnitItem>.from(state.units);
    updatedUnits[index] = updatedUnits[index].copyWith(isPrinted: true);

    emit(state.copyWith(units: updatedUnits));
  }

  /// 3. Validasi Scan QR
  Future<void> onScanQr(String rawQr) async {
    // Cari unit yang punya QR ini
    final index = state.units.indexWhere(
      (u) => u.qrValue == rawQr && !u.isScanned,
    );

    if (index == -1) {
      emit(
        state.copyWith(
          lastScanMessage: 'QR tidak dikenali atau sudah di-scan.',
        ),
      );
      return;
    }

    final unit = state.units[index];

    // Tandai sebagai scanned
    final updatedUnits = List<AssemblyUnitItem>.from(state.units);
    updatedUnits[index] = unit.copyWith(isScanned: true);

    emit(
      state.copyWith(
        units: updatedUnits,
        lastScanMessage: '${unit.componentName} ✓',
      ),
    );
  }

  /// 4. Create Draft Set (Status PENDING)
  // Future<Unit?> createDraftSet({
  //   required int userId,
  //   required String companyCode,
  //   required String rackId,
  //   required String rackName,
  // }) async {
  //   if (!state.isAllUnitsScanned) return null;

  //   emit(state.copyWith(status: AssemblyStatus.assembling));

  //   try {
  //     // Kumpulkan semua unit IDs
  //     final componentUnitIds = state.units.map((u) => u.unitId).toList();

  //     final result = await repo.generateParentUnit(
  //       variantId: state.variantId,
  //       componentUnitIds: componentUnitIds,
  //       userId: userId,
  //       rackName: rackName,
  //       rackId: rackId,
  //     );

  //     final parentUnitWithRel = await repo.findUnitByQr(result.parentQrValue);

  //     emit(state.copyWith(status: AssemblyStatus.success));

  //     return parentUnitWithRel?.unit;
  //   } catch (e) {
  //     emit(state.copyWith(status: AssemblyStatus.failure, error: e.toString()));
  //     return null;
  //   }
  // }

  /// 5. Finalisasi Set (Status ACTIVE)
  // Future<Unit?> createFinalSet({
  //   required int userId,
  //   required String companyCode,
  //   required String rackId,
  //   required String rackName,
  // }) async {
  //   if (!state.isAllUnitsScanned) return null;

  //   emit(state.copyWith(status: AssemblyStatus.assembling));

  //   try {
  //     // Kumpulkan semua unit IDs
  //     final componentUnitIds = state.units.map((u) => u.unitId).toList();

  //     final result = await repo.generateParentUnit(
  //       variantId: state.variantId,
  //       componentUnitIds: componentUnitIds,
  //       userId: userId,
  //       rackId: rackId,
  //       rackName: rackName,
  //     );

  //     final parentUnit = await repo.findUnitByQr(result.parentQrValue);

  //     emit(
  //       state.copyWith(
  //         status: AssemblyStatus.success,
  //         parentSetQr: result.parentQrValue,
  //         parentSetUnitId: result.parentUnitId,
  //       ),
  //     );

  //     return parentUnit?.unit;
  //   } catch (e) {
  //     emit(state.copyWith(status: AssemblyStatus.failure, error: e.toString()));
  //     return null;
  //   }
  // }

  Future<void> activateAllUnitComponents({required int userId}) async {
    try {
      final componentUnitIds = state.units.map((u) => u.unitId).toList();
      dev.log(componentUnitIds.toString());
      await repo.activateAllUnitComponents(
        componentUnitIds: componentUnitIds,
        userId: userId,
      );
    } catch (e) {
      dev.log('ERROR ACTIVATE UNIT $e');
    }
  }

  /// 6. Cancel Assembly (Hapus sampah units)
  Future<void> cancelAssembly() async {
    final generatedIds = state.units.map((u) => u.unitId).toList();

    if (generatedIds.isEmpty) return;

    try {
      await repo.cancelGeneratedUnits(unitIds: generatedIds);
    } catch (e) {
      // Silent fail
    }
  }
}
