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

  SyncCubit(this._repo, {Connectivity? connectivity})
    : _connectivity = connectivity ?? Connectivity(),
      super(const SyncState()) {
    _init();
  }

  void _init() {
    // 1. Pantau Database: Update pendingCount secara real-time
    // Setiap kali user nge-save unit baru, badge akan otomatis bertambah
    _dbSubscription = _repo.watchAllPending().listen((counts) {
      emit(state.copyWith(details: counts));

      // OPTIONAL: Jika ada data baru & Online -> Langsung Auto Sync
      if (counts.totalForTrigger > 0 && state.status != SyncStatus.offline) {
        // Debounce sedikit agar tidak spam request jika user save cepat
        Future.delayed(Duration(milliseconds: 5000));
        pushData();
      }
    });

    // 2. Pantau Internet: Auto Sync saat kembali Online
    _netSubscription = _connectivity.onConnectivityChanged.listen((results) {
      // ConnectivityResult bisa list di versi baru, ambil yg pertama
      final result = results.first;

      if (result == ConnectivityResult.none) {
        emit(state.copyWith(status: SyncStatus.offline));
      } else {
        // Jika sebelumnya offline/initial, dan sekarang online -> GAS SYNC
        if (state.details.totalForTrigger > 0) {
          pushData();
        } else {
          // Reset status ke initial jika tidak ada data yg perlu disync
          emit(state.copyWith(status: SyncStatus.initial));
        }
      }
    });

    // Cek status awal
    refreshPendingCount();
  }

  /// Panggil ini manual (misal saat pull-to-refresh atau app start)
  Future<void> refreshPendingCount() async {
    // watchPendingCounts sudah menghandle stream, tapi ini untuk fetch awal
    // Logic stream di _init sudah cukup sebenernya.
  }

  /// SKENARIO PUSH (Manual / Auto)
  Future<void> pushData() async {
    dev.log('${state.status}', name: 'MASUK');
    // Jangan sync jika sedang loading
    if (state.status == SyncStatus.syncing) return;

    // Cek koneksi manual sebelum push
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
    dev.log('${state.status}', name: 'START');

    // Panggil Repository "Smart ACK" yang sudah kita buat
    final result = await _repo.pushPendingAll();

    if (result.isSuccess) {
      dev.log('SUKSES');
      emit(state.copyWith(status: SyncStatus.success));
      // pendingCount akan otomatis jadi 0 karena kita listen ke DB Stream di _init

      // Kembalikan ke idle setelah beberapa detik (biar user lihat centang hijau)
      await Future.delayed(const Duration(seconds: 3));
      emit(state.copyWith(status: SyncStatus.initial));
    } else {
      dev.log('GAGAL');
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
    _dbSubscription?.cancel();
    _netSubscription?.cancel();
    return super.close();
  }
}
