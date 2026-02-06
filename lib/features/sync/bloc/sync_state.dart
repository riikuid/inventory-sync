part of 'sync_cubit.dart';

class SyncResult {
  final bool success;
  final String? message;

  const SyncResult({required this.success, this.message});
}

enum SyncStatus { initial, syncing, success, failure, offline }

class SyncState extends Equatable {
  final SyncStatus status;
  final SyncCounts details; // Ganti int jadi Object SyncCounts
  final String? errorMessage;

  const SyncState({
    this.status = SyncStatus.initial,
    this.details = const SyncCounts(), // Default kosong
    this.errorMessage,
  });

  // Getter helper biar tidak merubah banyak kode di UI
  int get totalPending => details.displayTotal;

  SyncState copyWith({
    SyncStatus? status,
    SyncCounts? details,
    String? errorMessage,
  }) {
    return SyncState(
      status: status ?? this.status,
      details: details ?? this.details,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, details, errorMessage];
}

class SyncCounts {
  final int products;
  final int companyItems;
  final int variants;
  final int variantComponents;
  final int components;
  final int units;
  final int photos; // Gabungan variant & component photos
  final int racks;

  const SyncCounts({
    this.products = 0,
    this.companyItems = 0,
    this.variants = 0,
    this.variantComponents = 0,
    this.components = 0,
    this.units = 0,
    this.photos = 0,
    this.racks = 0,
  });

  // 1. Total untuk UI (Badge) - User Friendly
  int get displayTotal =>
      products + companyItems + variants + components + units + photos + racks;

  // 2. Total untuk Trigger Sistem (Cubit) - Technical
  // Masukkan variantComponents disini agar trigger auto-sync jalan
  int get totalForTrigger => displayTotal + variantComponents;

  bool get isEmpty => totalForTrigger == 0;
}
