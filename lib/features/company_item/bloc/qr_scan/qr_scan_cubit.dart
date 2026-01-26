// lib/features/home/presentation/bloc/qr_scan/qr_scan_cubit.dart

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/db/daos/unit_dao.dart';
import '../../../labeling/data/labeling_repository.dart';

part 'qr_scan_state.dart';

class QrScanCubit extends Cubit<QrScanState> {
  final LabelingRepository _repository;

  QrScanCubit(this._repository) : super(const QrScanState());

  Future<void> scanQr(String qrValue) async {
    emit(state.copyWith(status: QrScanStatus.loading));

    try {
      // Scan QR menggunakan repository
      final result = await _repository.scanQrUnit(qrValue);

      if (result == null) {
        emit(
          state.copyWith(
            status: QrScanStatus.notFound,
            error: 'QR Code tidak ditemukan dalam database',
          ),
        );
        return;
      }

      // Cek apakah data lengkap
      if (result.variant == null) {
        emit(
          state.copyWith(
            status: QrScanStatus.error,
            error: 'Data variant tidak ditemukan',
          ),
        );
        return;
      }

      emit(
        state.copyWith(
          status: QrScanStatus.success,
          unitData: result,
          scannedQr: qrValue,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: QrScanStatus.error,
          error: 'Error scanning QR: $e',
        ),
      );
    }
  }

  void reset() {
    emit(const QrScanState());
  }
}
