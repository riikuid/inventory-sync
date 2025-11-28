// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../../../core/response_code.dart';
import '../../../../../core/token.dart';
import '../../../models/user.dart';
import '../../../usecases/get_user.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  // final String _headRole = 'head_manager';
  // final String _outsourceSupervisorRole = 'outsource_supervisor';

  User? _user;

  User? get user => _user;

  Future<void> authCheck() async {
    String? token = await Token.getSanctumToken();
    if (token == null) return emit(UnAuthorized());

    GetUser getUser = GetUser();
    await getUser(null).then((result) async {
      if (result.isSuccess) {
        _user = result.resultValue;
        emit(Authorized(user: result.resultValue!));
      } else {
        if (result.statusCode == ResponseCode.unAuthorized) {
          await Token.removeSanctumToken();
          _user = null;
          return emit(UnAuthorized());
        }
        emit(AuthError());
      }
    });
  }

  // bool isHead() =>
  //     user?.role == _headRole || user?.role == _outsourceSupervisorRole;

  // void setUnAuthorized() async {
  //   await Token.removeSanctumToken();
  //   _user = null;
  //   emit(UnAuthorized());
  // }
}
