import 'package:equatable/equatable.dart';

import '../../../models/permission_set.dart';

class PermissionState extends Equatable {
  final PermissionSet set;
  final bool loading;
  final String? error;

  const PermissionState({required this.set, this.loading = false, this.error});

  PermissionState copyWith({
    PermissionSet? set,
    bool? loading,
    String? error, // pass null explicitly to clear error
  }) {
    return PermissionState(
      set: set ?? this.set,
      loading: loading ?? this.loading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [set.version, loading, error];
}
