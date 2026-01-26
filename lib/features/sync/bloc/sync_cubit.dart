import 'dart:async';
import 'dart:developer' as dev;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_sync_apps/features/sync/data/sync_repository.dart';

part 'sync_state.dart';

class SyncCubit extends Cubit<SyncState> {
  final SyncRepository _repo;
  final Connectivity _connectivity;

  StreamSubscription? _dbSubscription;
  StreamSubscription? _netSubscription;
  Timer? _debounceTimer; // Timer untuk debounce

  SyncCubit(this._repo, {Connectivity? connectivity})
    : _connectivity = connectivity ?? Connectivity(),
      super(const SyncState()) {
    _init();
  }

  void _init() {
    // 1. Pantau Database
    _dbSubscription = _repo.watchAllPending().listen((counts) {
      emit(state.copyWith(details: counts));

      // AUTO SYNC LOGIC (DIPERBAIKI)
      if (counts.totalForTrigger > 0 && state.status != SyncStatus.offline) {
        // Cancel timer sebelumnya jika ada perubahan baru dalam waktu dekat
        _debounceTimer?.cancel();

        // mencegah spam request saat user scan barang berturut-turut.
        _debounceTimer = Timer(const Duration(seconds: 3), () {
          pushData();
        });
      }
    });

    // 2. Pantau Internet (Tetap sama)
    _netSubscription = _connectivity.onConnectivityChanged.listen((results) {
      final result = results.first;
      if (result == ConnectivityResult.none) {
        emit(state.copyWith(status: SyncStatus.offline));
      } else {
        if (state.details.totalForTrigger > 0) {
          pushData();
        } else {
          emit(state.copyWith(status: SyncStatus.initial));
        }
      }
    });

    refreshPendingCount();
  }

  /// Panggil ini manual (misal saat pull-to-refresh atau app start)
  Future<void> refreshPendingCount() async {
    // Logic stream di _init sudah cukup sebenernya.
  }

  /// SKENARIO PUSH (Manual / Auto)
  Future<void> pushData() async {
    // Cegah double sync
    if (state.status == SyncStatus.syncing) return;

    final connectivity = await _connectivity.checkConnectivity();
    if (connectivity.contains(ConnectivityResult.none)) {
      emit(
        state.copyWith(
          status: SyncStatus.offline,
          errorMessage: "Tidak ada internet",
        ),
      );
      return;
    }

    emit(state.copyWith(status: SyncStatus.syncing));
    dev.log('START SYNC...', name: 'SYNC');

    final result = await _repo.pushPendingAll();

    if (result.isSuccess) {
      dev.log('SYNC SUCCESS', name: 'SYNC');
      emit(state.copyWith(status: SyncStatus.success));

      // Reset ke initial agar icon centang hilang setelah beberapa saat
      await Future.delayed(const Duration(seconds: 3));
      // Cek lagi apakah status masih success sebelum reset (takutnya ketimpa error baru)
      if (state.status == SyncStatus.success) {
        emit(state.copyWith(status: SyncStatus.initial));
      }
    } else {
      dev.log('SYNC FAILED: ${result.errorMessage}', name: 'SYNC');
      emit(
        state.copyWith(
          status: SyncStatus.failure,
          errorMessage: result.errorMessage ?? "Gagal sinkronisasi",
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel(); // [BARU] Clean up timer
    _dbSubscription?.cancel();
    _netSubscription?.cancel();
    return super.close();
  }
}
