// lib/features/labeling/presentation/bloc/create_labels/create_labels_cubit.dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:inventory_sync_apps/features/labeling/data/labeling_repository.dart';
import '../../../../inventory/data/inventory_repository.dart';

part 'create_labels_state.dart';

class LabelItem {
  final String id;
  final String qrValue;
  final String? rackId;
  String status; // 'PENDING' | 'PRINTED' | 'VALIDATED'
  int printCount;

  LabelItem({
    required this.id,
    required this.qrValue,
    this.rackId,
    this.status = 'PENDING',
    this.printCount = 0,
  });

  LabelItem copyWith({String? status, int? printCount}) {
    return LabelItem(
      id: id,
      qrValue: qrValue,
      rackId: rackId,
      status: status ?? this.status,
      printCount: printCount ?? this.printCount,
    );
  }
}

class CreateLabelsCubit extends Cubit<CreateLabelsState> {
  final LabelingRepository repo;

  CreateLabelsCubit(this.repo) : super(CreateLabelsState.initial());

  /// generate -> create pending units and seed LabelItem list
  Future<void> generate({
    required String variantId,
    required String companyCode,
    required String rackId,
    required int qty,
    required String userId,
  }) async {
    emit(state.copyWith(status: CreateLabelsStatus.generating));
    try {
      final units = await repo.generateLabelsForVariant(
        variantId: variantId,
        companyCode: companyCode,
        rackId: rackId,
        qty: qty,
        userId: userId,
      );

      // create LabelItem list from Units
      final items = units
          .map(
            (u) => LabelItem(
              id: u.id,
              qrValue: u.qrValue,
              rackId: u.rackId,
              status: u.status,
              // status: u.status ?? 'PENDING',
              printCount: u.printCount ?? 0,
            ),
          )
          .toList();

      emit(state.copyWith(status: CreateLabelsStatus.generated, items: items));
    } catch (e) {
      emit(
        state.copyWith(status: CreateLabelsStatus.failure, error: e.toString()),
      );
    }
  }

  /// mark as printed (call after physical printing success)
  Future<void> markPrinted(List<String> unitIds, String userId) async {
    emit(state.copyWith(status: CreateLabelsStatus.printing));
    try {
      await repo.recordPrintedUnits(unitIds: unitIds, userId: userId);

      final updated = state.items.map((it) {
        if (unitIds.contains(it.id)) {
          return it.copyWith(status: 'PRINTED', printCount: it.printCount + 1);
        }
        return it;
      }).toList();

      emit(state.copyWith(status: CreateLabelsStatus.printed, items: updated));
    } catch (e) {
      emit(
        state.copyWith(status: CreateLabelsStatus.failure, error: e.toString()),
      );
    }
  }

  /// validate a scanned QR (called from camera scanner)
  Future<void> validateByQr(String qrValue) async {
    // find generated item in current batch by qrValue
    LabelItem match = state.items.firstWhere(
      (it) => it.qrValue == qrValue,
      // orElse: () => null,
    );

    if (match == null) {
      // maybe try to lookup in db for friendly message (but we treat as wrong)
      emit(
        state.copyWith(
          lastScanResult: ScanResult.invalid('QR tidak terdaftar di batch ini'),
        ),
      );
      return;
    }

    if (match.status == 'VALIDATED') {
      emit(
        state.copyWith(
          lastScanResult: ScanResult.duplicate('QR sudah tervalidasi'),
        ),
      );
      return;
    }

    // mark validated locally (UI)
    final updated = state.items.map((it) {
      if (it.id == match.id) return it.copyWith(status: 'VALIDATED');
      return it;
    }).toList();

    emit(
      state.copyWith(
        items: updated,
        lastScanResult: ScanResult.valid(match.qrValue),
      ),
    );

    // optional: if you want to immediately persist validated -> call repo.finalizeValidatedUnits for single id
    // but we will finalize all at the end when user press Selesai
  }

  /// finalize (save) all validated items -> set ACTIVE in DB
  Future<void> finalize(String userId) async {
    final validatedIds = state.items
        .where((i) => i.status == 'VALIDATED')
        .map((i) => i.id)
        .toList();
    if (validatedIds.isEmpty) {
      emit(
        state.copyWith(
          status: CreateLabelsStatus.failure,
          error: 'Tidak ada yang tervalidasi',
        ),
      );
      return;
    }

    emit(state.copyWith(status: CreateLabelsStatus.validating));
    try {
      await repo.finalizeValidatedUnits(unitIds: validatedIds, userId: userId);
      emit(state.copyWith(status: CreateLabelsStatus.success));
    } catch (e) {
      emit(
        state.copyWith(status: CreateLabelsStatus.failure, error: e.toString()),
      );
    }
  }

  /// cancel -> delete pending units
  Future<void> cancelAll() async {
    final ids = state.items.map((i) => i.id).toList();
    if (ids.isEmpty) {
      emit(CreateLabelsState.initial());
      return;
    }
    try {
      await repo.cancelGeneratedUnits(unitIds: ids);
      emit(CreateLabelsState.initial());
    } catch (e) {
      emit(
        state.copyWith(status: CreateLabelsStatus.failure, error: e.toString()),
      );
    }
  }

  /// set selected printer info in state
  void setPrinter(PrinterDevice? device) {
    emit(state.copyWith(selectedPrinter: device));
  }
}
