// lib/features/labeling/presentation/bloc/assembly/assembly_cubit.dart

import 'dart:developer' as dev;

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
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
                printCount: unit.printCount,
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
            printCount: parentUnit.printCount,
          ),
        );
      }

      emit(state.copyWith(status: AssemblyStatus.loaded, units: allUnits));
    } catch (e) {
      emit(state.copyWith(status: AssemblyStatus.failure, error: e.toString()));
    }
  }

  /// 2. Mark unit sebagai printed
  Future<void> markAsPrinted(int index, int userId) async {
    if (index < 0 || index >= state.units.length) return;

    final unit = state.units[index];

    // Simpan ke DB agar print_count bertambah
    await repo.recordPrintedUnits(unitIds: [unit.unitId], userId: userId);

    final updatedUnits = List<AssemblyUnitItem>.from(state.units);
    updatedUnits[index] = updatedUnits[index].copyWith(
      isPrinted: true,
      printCount: unit.printCount + 1,
    );

    emit(state.copyWith(units: updatedUnits));
  }

  /// 3. Validasi Scan QR
  Future<void> onScanQr(String rawQr) async {
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

  /// 7. Void/Delete SATU SET
  Future<void> voidSet({
    required String parentUnitId,
    required String scannedQr,
  }) async {
    // 1. Cari Parent Unit di local state
    final parent = state.units.firstWhere(
      (u) => u.unitId == parentUnitId && u.isParent,
      orElse: () => AssemblyUnitItem(
        componentId: '',
        componentName: '',
        manufCode: '',
        rackName: '',
        rackId: '',
        unitId: '',
        qrValue: '',
        createdAt: DateTime.now(),
        isPrinted: false,
        isScanned: false,
        parentUnitId: null,
        isParent: false,
        setIndex: -1,
        quantity: 0,
        printCount: 0,
      ),
    );

    if (parent.unitId.isEmpty) {
      emit(
        state.copyWith(
          lastScanMessage: 'Unit Set tidak ditemukan (error state).',
        ),
      );
      return;
    }

    // 2. Validasi QR
    if (parent.qrValue != scannedQr) {
      emit(
        state.copyWith(
          lastScanMessage: 'QR tidak cocok dengan Set Parent yang dipilih!',
        ),
      );
      return;
    }

    emit(state.copyWith(status: AssemblyStatus.loading));

    try {
      // 3. Collect IDs (Parent + Children)
      // Children adalah unit yang memiliki parentUnitId == parent.unitId (atau setIndex sama)
      // Karena di state kita punya flattened list, kita filter aja by setIndex atau parentUnitId
      final targetUnits = state.units
          .where(
            (u) =>
                (u.unitId == parentUnitId) || (u.parentUnitId == parentUnitId),
          )
          .toList();

      final idsToDelete = targetUnits.map((u) => u.unitId).toList();

      // 4. Call Repo
      await repo.deleteUnits(idsToDelete);

      // 5. Update State
      // Remove deleted units from list
      final remainingUnits = state.units
          .where((u) => !idsToDelete.contains(u.unitId))
          .toList();

      emit(
        state.copyWith(
          status: AssemblyStatus.loaded,
          units: remainingUnits,
          lastScanMessage: 'Set berhasil dihapus.',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AssemblyStatus.failure,
          // Asumsi error string, tapi better handling proper error state
          lastScanMessage: 'Gagal menghapus set: $e',
        ),
      );
    }
  }
}
