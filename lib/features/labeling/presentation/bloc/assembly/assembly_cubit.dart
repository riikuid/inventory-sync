// lib/features/labeling/presentation/bloc/assembly/assembly_cubit.dart

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:inventory_sync_apps/core/db/app_database.dart'; // Akses ke Unit Row
import 'package:inventory_sync_apps/core/db/daos/variant_dao.dart';
import 'package:inventory_sync_apps/features/labeling/data/labeling_repository.dart';

import '../../../../../core/db/model/variant_component_row.dart';
import '../create_labels/create_labels_cubit.dart';

part 'assembly_state.dart';

class AssemblyCubit extends Cubit<AssemblyState> {
  final LabelingRepository repo;

  AssemblyCubit(this.repo, String variantId, String variantName)
    : super(AssemblyState(variantId: variantId, variantName: variantName));

  /// 1. Load daftar komponen yang harus ada dalam box
  Future<void> loadRequirements({
    required List<VariantComponentRow> inBoxComponents,
    required String variantRackId,
    required String variantRackName,
    required int userId, // Butuh userId untuk create unit
    required String companyCode, // Butuh companyCode untuk create unit
  }) async {
    emit(state.copyWith(status: AssemblyStatus.loading));

    try {
      // 1. Mapping awal (belum ada QR)
      List<AssemblyItemState> initialItems = inBoxComponents.map((c) {
        return AssemblyItemState(
          componentId: c.componentId,
          name: c.name,
          manufCode: c.manufCode ?? '-',
          rackId: variantRackId,
          rackName: variantRackName,
          qtyNeeded: 1,
          isPrinted: false,
          isScanned: false,
          generatedUnitId: null, // Masih null
          qrValue: null, // Masih null
        );
      }).toList();

      // 2. AUTO-GENERATE UNITS KE DB (Looping)
      List<AssemblyItemState> populatedItems = [];

      for (var item in initialItems) {
        // Panggil Repo untuk generate 1 unit PENDING
        // Kita gunakan generateBatchLabels dg qty=1
        final units = await repo.generateBatchLabels(
          variantId: state.variantId, // ID Variant Parent
          companyCode: companyCode,
          rackId: variantRackId,
          qty: 1,
          userId: userId,
          componentId: item.componentId, // Penting! ini unit komponen
          manufCode: item.manufCode,
        );

        if (units.isNotEmpty) {
          final createdUnit = units.first;
          // Update item state dengan data dari DB
          populatedItems.add(
            item.copyWith(
              generatedUnitId: createdUnit.id,
              qrValue: createdUnit.qrValue,
            ),
          );
        } else {
          populatedItems.add(item); // Fallback jika gagal (jarang terjadi)
        }
      }

      emit(
        state.copyWith(
          status: AssemblyStatus.loaded,
          components: populatedItems, // State sekarang sudah punya QR semua
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: AssemblyStatus.failure, error: e.toString()));
    }
  }

  // Tambahkan method ini di dalam class AssemblyCubit
  void markAsPrinted(int index) {
    // 1. Validasi index
    if (index < 0 || index >= state.components.length) return;

    // 2. Copy list lama agar immutability terjaga
    final updatedList = List<AssemblyItemState>.from(state.components);

    // 3. Update item spesifik menjadi isPrinted = true
    final currentItem = updatedList[index];
    updatedList[index] = currentItem.copyWith(isPrinted: true);

    // 4. Emit state baru agar UI sadar ada perubahan
    emit(state.copyWith(components: updatedList));
  }

  /// 2. Generate Unit untuk Komponen (Dipanggil saat user klik "Cetak" di baris komponen)
  /// Return: Object Unit (agar UI bisa kirim ke PrinterCubit)
  Future<Unit?> generateComponentUnit({
    required int index,
    required int userId,
    required String companyCode,
  }) async {
    final item = state.components[index];
    // Jika sudah ada unit ID (sudah pernah generate), return null atau return unit yg lama
    // Disini kita asumsikan generate baru jika belum diprint

    emit(state.copyWith(status: AssemblyStatus.generating_component));
    try {
      // Generate 1 unit komponen
      final units = await repo.generateBatchLabels(
        variantId: state.variantId,
        companyCode: companyCode,
        rackId: 'ASSEMBLY', // Rak sementara
        qty: 1,
        userId: userId,
        componentId: item.componentId,
        manufCode: item.manufCode,
      );

      final unit = units.first;

      // Update State: Simpan QR dan Unit ID di baris komponen ini
      final updatedComponents = List<AssemblyItemState>.from(state.components);
      updatedComponents[index] = item.copyWith(
        generatedUnitId: unit.id,
        qrValue: unit.qrValue,
        isPrinted: true, // Asumsi akan langsung diprint setelah ini
      );

      emit(
        state.copyWith(
          status: AssemblyStatus.loaded, // Kembali ke idle
          components: updatedComponents,
        ),
      );

      return unit;
    } catch (e) {
      emit(
        state.copyWith(
          status: AssemblyStatus.failure,
          error: "Gagal generate unit: $e",
        ),
      );
      return null;
    }
  }

  /// 3. Validasi Scan (Cek apakah QR yang discan adalah salah satu komponen yang ditunggu)
  Future<void> onScanQr(String rawQr) async {
    // Cari apakah QR ini ada di daftar komponen yang SUDAH digenerate/diprint?
    // Atau cari apakah QR ini match format komponen?

    // Logic: Cari di list components, mana yang punya qrValue == rawQr
    final index = state.components.indexWhere((item) => item.qrValue == rawQr);

    if (index == -1) {
      // Jika tidak ketemu di list generated, mungkin user scan barang stok lama?
      // Untuk simplicity Assembly flow: Kita validasi strict terhadap apa yang baru dicetak.
      emit(state.copyWith(lastScanMessage: '❌ QR tidak dikenali di set ini.'));
      return;
    }

    final item = state.components[index];
    if (item.isScanned) {
      emit(state.copyWith(lastScanMessage: '⚠️ Komponen ini sudah discan.'));
      return;
    }

    // Tandai Scanned
    final updatedComponents = List<AssemblyItemState>.from(state.components);
    updatedComponents[index] = item.copyWith(isScanned: true);

    emit(
      state.copyWith(
        components: updatedComponents,
        lastScanMessage: '✅ ${item.name} OK!',
      ),
    );

    // Cek apakah semua selesai?
    if (updatedComponents.every((c) => c.isScanned)) {
      // Trigger UI effect jika perlu
    }
  }

  Future<Unit?> createDraftSet({
    required int userId,
    required String companyCode,
    required String rackId,
    required String rackName,
  }) async {
    if (!state.isAllComponentsScanned) return null;

    emit(state.copyWith(status: AssemblyStatus.assembling));
    try {
      final componentUnitIds = state.components
          .map((c) => c.generatedUnitId!)
          .toList();

      // Panggil repo untuk assemble (Pastikan repo membuat status PENDING)
      final result = await repo.assembleComponents(
        variantId: state.variantId,
        componentUnitIds: componentUnitIds,
        userId: userId,
        rackName: rackName,
        rackId: rackId,
        // Logic di Repo harus memastikan Parent dibuat dengan status 'PENDING'
      );

      final parentUnitWithRel = await repo.findUnitByQr(result.parentQrValue);

      emit(state.copyWith(status: AssemblyStatus.success));

      return parentUnitWithRel?.unit;
    } catch (e) {
      emit(state.copyWith(status: AssemblyStatus.failure, error: e.toString()));
      return null;
    }
  }

  /// 4. Finalisasi: Buat Unit Parent (Set) & Link Children
  Future<Unit?> createFinalSet({
    required int userId,
    required String companyCode,
    required String rackId,
    required String rackName,
  }) async {
    if (!state.isAllComponentsScanned) return null;

    emit(state.copyWith(status: AssemblyStatus.assembling));
    try {
      final componentUnitIds = state.components
          .map((c) => c.generatedUnitId!)
          .toList();

      // Panggil repo untuk assemble
      final result = await repo.assembleComponents(
        variantId: state.variantId,
        componentUnitIds: componentUnitIds,
        userId: userId,
        rackId: rackId,
        rackName: rackName,
      );

      // Kita butuh data lengkap parent unit untuk diprint
      final parentUnit = await repo.findUnitByQr(
        result.parentQrValue,
      ); // Helper di repo

      emit(
        state.copyWith(
          status: AssemblyStatus.success,
          parentSetQr: result.parentQrValue,
          parentSetUnitId: result.parentUnitId,
        ),
      );

      return parentUnit
          ?.unit; // Return unit parent agar UI bisa print label parent
    } catch (e) {
      emit(state.copyWith(status: AssemblyStatus.failure, error: e.toString()));
      return null;
    }
  }

  Future<void> cancelAssembly() async {
    // 1. Kumpulkan semua unit ID yang sudah digenerate di sesi ini
    final generatedIds = state.components
        .where((c) => c.generatedUnitId != null)
        .map((c) => c.generatedUnitId!)
        .toList();

    if (generatedIds.isEmpty) return;

    try {
      // 2. Panggil repo untuk hapus (hard delete atau soft delete tergantung kebijakan)
      // Kita pakai method yang sama dengan fitur Batch Labeling
      await repo.cancelGeneratedUnits(unitIds: generatedIds);

      // Reset state (opsional, karena cubit akan didispose juga)
      // emit(state.copyWith(status: AssemblyStatus.));
    } catch (e) {
      // Log error jika gagal hapus (silent fail is okay here, or log to crashlytics)
      // print("Gagal membersihkan sampah assembly: $e");
    }
  }

  // Tambahkan di CreateLabelsCubit
}
