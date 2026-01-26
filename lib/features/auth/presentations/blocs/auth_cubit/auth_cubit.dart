// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
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

    final token = await Token.getSanctumToken();
    if (token == null) {
      return emit(UnAuthorized());
    }

    // Coba ambil user dari cache local (SharedPreferences)
    final cachedUser = await UserStorage.getUser();
    if (cachedUser != null) {
      _user = cachedUser;
    }

    // 1. Coba /auth/me ke server
    final result = await GetUser()(null);

    if (result.isSuccess) {
      final user = result.resultValue!;
      _user = user;
      await UserStorage.saveUser(user);

      emit(AuthLoading('Menyiapkan sinkronisasi...', progress: 0.0));

      final progressSub = _syncRepository.onSyncProgress.listen((progress) {
        String msg = 'Mengunduh data...';
        if (progress > 0.3) msg = 'Memproses data...';
        if (progress > 0.8) msg = 'Finalisasi...';

        emit(AuthLoading(msg, progress: progress));
      });

      try {
        await _syncRepository.pullSinceLast();
        await progressSub.cancel();
        emit(Authorized(user: user, offline: false));
      } catch (_) {
        await progressSub.cancel();
        emit(Authorized(user: user, offline: true));
      }
      return;
    }

    if (result.statusCode == ResponseCode.unAuthorized) {
      await Token.removeSanctumToken();
      await UserStorage.clearUser();
      _user = null;
      return emit(UnAuthorized());
    }

    if (cachedUser != null) {
      _user = cachedUser;
      return emit(Authorized(user: cachedUser, offline: true));
    }

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
