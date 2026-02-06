part of 'refresh_permissions.dart';

class RefreshPermissionsParams {
  final int? currentVersion; // ambil dari state
  final String? userId;
  const RefreshPermissionsParams({this.currentVersion, this.userId});
}
