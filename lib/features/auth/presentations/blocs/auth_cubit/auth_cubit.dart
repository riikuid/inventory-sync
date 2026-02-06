// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:drift/native.dart';
import 'package:meta/meta.dart';

import '../../../../../core/response_code.dart';
import '../../../../../core/token.dart';
import '../../../../../core/user_storage.dart';
import '../../../../sync/data/sync_repository.dart';
import '../../../models/user.dart';
import '../../../usecases/get_user.dart';

part 'auth_state.dart';

// auth_cubit.dart
class AuthCubit extends Cubit<AuthState> {
  final SyncRepository _syncRepository;

  AuthCubit(this._syncRepository) : super(AuthInitial());

  User? _user;
  User? get user => _user;

  /// Dipanggil sekali di AppRoot.initState()
  Future<void> checkAuthAndStartup() async {
    emit(AuthLoading('Memeriksa sesi login...'));

    // 1. Cek Token Sanctum
    final token = await Token.getSanctumToken();
    if (token == null) {
      return emit(UnAuthorized());
    }

    // 2. Load User Cache
    final cachedUser = await UserStorage.getUser();
    if (cachedUser != null) {
      _user = cachedUser;
    }

    // 3. Hit Server (/auth/me)
    final result = await GetUser()(null);

    if (result.isSuccess) {
      final user = result.resultValue!;
      _user = user;
      await UserStorage.saveUser(user);

      emit(AuthLoading('Menyiapkan sinkronisasi...', progress: 0.0));

      // Listen Progress
      final progressSub = _syncRepository.onSyncProgress.listen((progress) {
        String msg = 'Mengunduh data...';
        if (progress > 0.3) msg = 'Memproses data...';
        if (progress > 0.8) msg = 'Finalisasi...';

        // Cek mounted/closed biasanya dihandle UI, tapi di Cubit aman emit asal belum close
        if (!isClosed) {
          emit(AuthLoading(msg, progress: progress));
        }
      });

      try {
        // 1. TAMPUNG HASILNYA (Jangan cuma di-await)
        final syncResult = await _syncRepository.pullSinceLast();

        await progressSub.cancel();

        // 2. CEK STATUS RESULT
        if (syncResult.isSuccess) {
          emit(Authorized(user: user, offline: false));
        } else {
          // 3. JIKA GAGAL, ANALISA ERRORNYA
          final errorMsg = syncResult.errorMessage ?? "Unknown error";
          final errorLower = errorMsg.toLowerCase();

          // Daftar keyword error fatal (Data Mismatch / Coding Error / DB Corrupt)
          bool isCritical =
              errorLower.contains(
                "type 'null' is not a subtype",
              ) || // JSON Null Safety Crash
              errorLower.contains("subtype of type") || // TypeError general
              errorLower.contains("no such column") || // Schema Mismatch
              errorLower.contains("sqliteexception"); // DB Corrupt

          if (isCritical) {
            // Lempar ke Halaman Error Merah (Rescue Screen)
            emit(
              AuthDatabaseCriticalError(
                "Terjadi kesalahan struktur data (Data Mismatch).\n\nTeknis: $errorMsg",
              ),
            );
          } else {
            // Jika error koneksi biasa (timeout, 500, no internet), masuk mode offline
            emit(Authorized(user: user, offline: true));
          }
        }
      } catch (e, stack) {
        // Catch block ini jaga-jaga jika ada error di luar pullSinceLast (misal progressSub fail)
        await progressSub.cancel();
        print("Unexpected error in AuthCubit: $e $stack");
        emit(Authorized(user: user, offline: true));
      }
      return;
    }

    // --- Handling jika GetUser gagal (Token Expired atau No Internet) ---

    // Jika 401 Unauthorized -> Logout
    if (result.statusCode == ResponseCode.unAuthorized) {
      await Token.removeSanctumToken();
      await UserStorage.clearUser();
      _user = null;
      return emit(UnAuthorized());
    }

    // Jika error lain (No Internet) tapi punya cache user -> Mode Offline
    if (cachedUser != null) {
      _user = cachedUser;

      // Catatan: Di sini kita berasumsi DB aman karena tidak melakukan sync.
      // Jika DB rusak saat user membuka halaman lain nanti,
      // 'AppBlocObserver' (Global Error Watcher) yang akan menangkapnya.
      return emit(Authorized(user: cachedUser, offline: true));
    }

    // Tidak ada koneksi & Tidak ada data cache
    emit(AuthError('Tidak bisa terhubung ke server dan tidak ada data lokal.'));
  }

  /// Logout
  Future<void> logout() async {
    await Token.removeSanctumToken();
    await UserStorage.clearUser();
    _user = null;
    emit(UnAuthorized());
  }
}
