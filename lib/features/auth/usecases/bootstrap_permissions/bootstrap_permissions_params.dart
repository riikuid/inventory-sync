part of 'bootstrap_permissions.dart';

class BootstrapPermissionsParams {
  final PermissionSet? seed; // permission dari payload login (opsional)
  final String? userId; // untuk cache per user (opsional tapi direkomendasikan)
  final bool refreshFromServer; // default true

  const BootstrapPermissionsParams({
    this.seed,
    this.userId,
    this.refreshFromServer = true,
  });
}
