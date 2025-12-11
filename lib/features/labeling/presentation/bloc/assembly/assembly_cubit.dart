import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:inventory_sync_apps/features/labeling/data/labeling_repository.dart';

part 'assembly_state.dart';

class AssemblyCubit extends Cubit<AssemblyState> {
  final LabelingRepository repo;

  AssemblyCubit(this.repo, String variantId, String variantName)
    : super(AssemblyState(variantId: variantId, variantName: variantName));

  /// 1. Load requirement komponen dari DB
  Future<void> loadRequirements() async {
    emit(state.copyWith(status: AssemblyStatus.loading));
    try {
      // TODO: Anda perlu method di Repo untuk getComponentsByVariantId
      // Saya asumsikan method itu me-return List<ComponentRow>
      // Untuk demo saya hardcode logic mapping-nya:

      final varComponentRows = await repo.getVariantComponentsByType(
        variantId: state.variantId,
        type: 'IN_BOX',
      );
      final items = varComponentRows
          .map(
            (c) => AssemblyItemState(
              componentId: c.componentId,
              componentName: c.name,
              manufCode: c.manufCode ?? '',
            ),
          )
          .toList();

      emit(state.copyWith(status: AssemblyStatus.idle, components: items));
    } catch (e) {
      emit(state.copyWith(status: AssemblyStatus.failure, error: e.toString()));
    }
  }

  /// 2. Generate QR untuk SATU komponen (Saat tombol 'Cetak' di card diklik)
  Future<void> generateComponentLabel(
    int index,
    String userId,
    String companyCode,
  ) async {
    final item = state.components[index];
    if (item.isPrinted || item.generatedUnitId != null) return; // Sudah ada

    emit(state.copyWith(status: AssemblyStatus.printing_component));
    try {
      // Panggil repo yang sudah kita refactor tadi
      // Kita generate 1 unit component
      final units = await repo.generateBatchLabels(
        variantId: state.variantId,
        companyCode: companyCode,
        rackId: 'ASSEMBLY-TEMP', // Rak sementara
        qty: 1,
        userId: userId,
        componentId: item.componentId,
        manufCode: item.manufCode,
      );

      final unit = units.first;

      // Update state item ini menjadi "Printed/Generated"
      final updatedItems = List<AssemblyItemState>.from(state.components);
      updatedItems[index] = item.copyWith(
        generatedUnitId: unit.id,
        qrValue: unit.qrValue,
        isPrinted: true, // Asumsi user langsung print setelah ini
      );

      emit(
        state.copyWith(
          status: AssemblyStatus.scanning_components, // Mode siap scan
          components: updatedItems,
        ),
      );

      // TODO: Trigger perintah ke printer bluetooth di sini jika terhubung
    } catch (e) {
      emit(state.copyWith(status: AssemblyStatus.failure, error: e.toString()));
    }
  }

  /// 3. Validasi Scan (Cek apakah QR ini milik salah satu komponen yang ditunggu)
  Future<void> onScanQr(String rawQr) async {
    // Cari item mana yang punya QR ini
    final index = state.components.indexWhere((item) => item.qrValue == rawQr);

    if (index == -1) {
      // QR tidak dikenal dalam sesi assembly ini
      emit(
        state.copyWith(
          lastScanMessage:
              '❌ QR tidak cocok dengan komponen manapun di set ini.',
        ),
      );
      return;
    }

    final item = state.components[index];
    if (item.isScanned) {
      emit(
        state.copyWith(
          lastScanMessage: '⚠️ Komponen ini sudah discan sebelumnya.',
        ),
      );
      return;
    }

    // Tandai Scanned
    final updatedItems = List<AssemblyItemState>.from(state.components);
    updatedItems[index] = item.copyWith(isScanned: true);

    emit(
      state.copyWith(
        components: updatedItems,
        lastScanMessage: '✅ ${item.componentName} OK!',
      ),
    );

    // Cek apakah semua selesai?
    if (state.isAllComponentsScanned) {
      emit(
        state.copyWith(lastScanMessage: '🎉 Semua lengkap! Siap generate Set.'),
      );
    }
  }

  /// 4. Finalisasi: Buat Unit Set Gabungan
  Future<void> createFinalSet(String userId) async {
    if (!state.isAllComponentsScanned) return;

    emit(state.copyWith(status: AssemblyStatus.generating_set));
    try {
      final componentUnitIds = state.components
          .map((c) => c.generatedUnitId!)
          .toList();

      final result = await repo.assembleComponents(
        variantId: state.variantId,
        componentUnitIds: componentUnitIds,
        userId: userId,
        location: 'DEFAULT-RACK', // Nanti bisa dipilih user
      );

      emit(
        state.copyWith(
          status: AssemblyStatus.success,
          parentSetQr: result.parentQrValue,
          parentSetUnitId: result.parentUnitId,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: AssemblyStatus.failure, error: e.toString()));
    }
  }
}
