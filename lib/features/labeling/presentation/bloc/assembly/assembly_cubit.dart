// lib/features/labeling/presentation/bloc/assembly/assembly_cubit.dart

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:inventory_sync_apps/core/db/app_database.dart'; // Akses ke Unit Row
import 'package:inventory_sync_apps/core/db/daos/variant_dao.dart';
import 'package:inventory_sync_apps/features/labeling/data/labeling_repository.dart';

import '../create_labels/create_labels_cubit.dart';

part 'assembly_state.dart';

class AssemblyCubit extends Cubit<AssemblyState> {
  final LabelingRepository repo;

  AssemblyCubit(this.repo, String variantId, String variantName)
    : super(AssemblyState(variantId: variantId, variantName: variantName));

  /// 1. Load daftar komponen yang harus ada dalam box
  Future<void> loadRequirements(
    List<VariantComponentRow> inBoxComponents,
  ) async {
    emit(state.copyWith(status: AssemblyStatus.loading));
    try {
      // Mapping dari data DB (Component Row) ke State UI
      final items = inBoxComponents
          .map(
            (c) => AssemblyItemState(
              componentId: c.componentId,
              name: c.name,
              manufCode: c.manufCode ?? '-',
              qtyNeeded:
                  1, // Default 1, idealnya ambil dari VariantComponent.quantity
            ),
          )
          .toList();

      emit(state.copyWith(status: AssemblyStatus.loaded, components: items));
    } catch (e) {
      emit(state.copyWith(status: AssemblyStatus.failure, error: e.toString()));
    }
  }

  /// 2. Generate Unit untuk Komponen (Dipanggil saat user klik "Cetak" di baris komponen)
  /// Return: Object Unit (agar UI bisa kirim ke PrinterCubit)
  Future<Unit?> generateComponentUnit({
    required int index,
    required String userId,
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

  Future<Unit?> createDraftSet(String userId, String companyCode) async {
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
        location: 'ASSEMBLY_STAGING',
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
  Future<Unit?> createFinalSet(String userId, String companyCode) async {
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
        location: 'DEFAULT',
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
      print("Gagal membersihkan sampah assembly: $e");
    }
  }

  // Tambahkan di CreateLabelsCubit
}
