// lib/features/home/presentation/bloc/qr_scan/qr_scan_state.dart

part of 'qr_scan_cubit.dart';

enum QrScanStatus { initial, loading, success, notFound, error }

class QrScanState extends Equatable {
  final QrScanStatus status;
  final UnitWithRelations? unitData;
  final String? scannedQr;
  final String? error;

  const QrScanState({
    this.status = QrScanStatus.initial,
    this.unitData,
    this.scannedQr,
    this.error,
  });

  QrScanState copyWith({
    QrScanStatus? status,
    UnitWithRelations? unitData,
    String? scannedQr,
    String? error,
  }) {
    return QrScanState(
      status: status ?? this.status,
      unitData: unitData ?? this.unitData,
      scannedQr: scannedQr ?? this.scannedQr,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, unitData, scannedQr, error];
}
