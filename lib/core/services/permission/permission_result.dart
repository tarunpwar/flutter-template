import 'permission_types.dart';

/// Result class for permission operations
class PermissionResult {
  final AppPermissionStatus status;
  final String message;
  final bool isGranted;
  final bool canShowRationale;

  const PermissionResult({
    required this.status,
    required this.message,
    required this.isGranted,
    this.canShowRationale = false,
  });

  factory PermissionResult.granted() {
    return const PermissionResult(
      status: AppPermissionStatus.granted,
      message: 'Permission granted',
      isGranted: true,
    );
  }

  factory PermissionResult.denied([String? customMessage]) {
    return PermissionResult(
      status: AppPermissionStatus.denied,
      message: customMessage ?? 'Permission denied',
      isGranted: false,
      canShowRationale: true,
    );
  }

  factory PermissionResult.permanentlyDenied([String? customMessage]) {
    return PermissionResult(
      status: AppPermissionStatus.permanentlyDenied,
      message: customMessage ?? 'Permission permanently denied. Please enable from settings.',
      isGranted: false,
    );
  }

  factory PermissionResult.restricted([String? customMessage]) {
    return PermissionResult(
      status: AppPermissionStatus.restricted,
      message: customMessage ?? 'Permission restricted',
      isGranted: false,
    );
  }

  @override
  String toString() {
    return 'PermissionResult(status: $status, message: $message, isGranted: $isGranted)';
  }
}