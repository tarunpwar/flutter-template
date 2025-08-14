import 'permission_types.dart';

/// Custom exception for permission-related errors
class PermissionException implements Exception {
  final String message;
  final AppPermission permission;
  final AppPermissionStatus status;

  const PermissionException({
    required this.message,
    required this.permission,
    required this.status,
  });

  @override
  String toString() {
    return 'PermissionException: $message (Permission: $permission, Status: $status)';
  }
}
