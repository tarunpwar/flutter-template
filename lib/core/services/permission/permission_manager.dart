import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'permission_exceptions.dart';
import 'permission_result.dart';
import 'permission_types.dart';

/// Production-ready Permission Manager
class PermissionManager {
  static PermissionManager? _instance;
  static PermissionManager get instance => _instance ??= PermissionManager._();

  PermissionManager._();

  // Permission status cache to reduce system calls
  final Map<AppPermission, AppPermissionStatus> _statusCache = {};

  // Request timestamps to prevent spam requests
  final Map<AppPermission, DateTime> _lastRequestTime = {};

  // Minimum time between permission requests (in milliseconds)
  static const int _minimumRequestInterval = 1000;

  /// Maps app permissions to permission_handler permissions
  Permission _getPermissionFromAppPermission(AppPermission appPermission) {
    switch (appPermission) {
      case AppPermission.camera:
        return Permission.camera;
      case AppPermission.microphone:
        return Permission.microphone;
      case AppPermission.storage:
        return Permission.storage;
      case AppPermission.photos:
        return Permission.photos;
      case AppPermission.location:
        return Permission.location;
      case AppPermission.locationWhenInUse:
        return Permission.locationWhenInUse;
      case AppPermission.locationAlways:
        return Permission.locationAlways;
      case AppPermission.contacts:
        return Permission.contacts;
      case AppPermission.phone:
        return Permission.phone;
      case AppPermission.sms:
        return Permission.sms;
      case AppPermission.notification:
        return Permission.notification;
      case AppPermission.bluetooth:
        return Permission.bluetooth;
      case AppPermission.bluetoothScan:
        return Permission.bluetoothScan;
      case AppPermission.bluetoothAdvertise:
        return Permission.bluetoothAdvertise;
      case AppPermission.bluetoothConnect:
        return Permission.bluetoothConnect;
      case AppPermission.mediaLibrary:
        return Permission.mediaLibrary;
      case AppPermission.calendarRead:
        return Permission.calendarFullAccess;
      case AppPermission.calendarWrite:
        return Permission.calendarWriteOnly;
      case AppPermission.reminders:
        return Permission.reminders;
      case AppPermission.sensors:
        return Permission.sensors;
      case AppPermission.speech:
        return Permission.speech;
      case AppPermission.ignoreBatteryOptimizations:
        return Permission.ignoreBatteryOptimizations;
      case AppPermission.requestInstallPackages:
        return Permission.requestInstallPackages;
      case AppPermission.systemAlertWindow:
        return Permission.systemAlertWindow;
      case AppPermission.criticalAlerts:
        return Permission.criticalAlerts;
      case AppPermission.accessMediaLocation:
        return Permission.accessMediaLocation;
      case AppPermission.activityRecognition:
        return Permission.activityRecognition;
      case AppPermission.unknown:
        return Permission.unknown;
    }
  }

  /// Converts PermissionStatus to AppPermissionStatus
  AppPermissionStatus _convertPermissionStatus(PermissionStatus status) {
    switch (status) {
      case PermissionStatus.granted:
        return AppPermissionStatus.granted;
      case PermissionStatus.denied:
        return AppPermissionStatus.denied;
      case PermissionStatus.permanentlyDenied:
        return AppPermissionStatus.permanentlyDenied;
      case PermissionStatus.restricted:
        return AppPermissionStatus.restricted;
      case PermissionStatus.limited:
        return AppPermissionStatus.limited;
      case PermissionStatus.provisional:
        return AppPermissionStatus.provisional;
    }
  }

  /// Check if enough time has passed since last request
  bool _canMakeRequest(AppPermission permission) {
    final lastRequest = _lastRequestTime[permission];
    if (lastRequest == null) return true;

    return DateTime.now().millisecondsSinceEpoch -
            lastRequest.millisecondsSinceEpoch >
        _minimumRequestInterval;
  }

  /// Update request timestamp
  void _updateRequestTime(AppPermission permission) {
    _lastRequestTime[permission] = DateTime.now();
  }

  /// Get human-readable permission name
  String getPermissionName(AppPermission permission) {
    switch (permission) {
      case AppPermission.camera:
        return 'Camera';
      case AppPermission.microphone:
        return 'Microphone';
      case AppPermission.storage:
        return 'Storage';
      case AppPermission.photos:
        return 'Photos';
      case AppPermission.location:
        return 'Location';
      case AppPermission.locationWhenInUse:
        return 'Location (When in Use)';
      case AppPermission.locationAlways:
        return 'Location (Always)';
      case AppPermission.contacts:
        return 'Contacts';
      case AppPermission.phone:
        return 'Phone';
      case AppPermission.sms:
        return 'SMS';
      case AppPermission.notification:
        return 'Notifications';
      case AppPermission.bluetooth:
        return 'Bluetooth';
      case AppPermission.bluetoothScan:
        return 'Bluetooth Scan';
      case AppPermission.bluetoothAdvertise:
        return 'Bluetooth Advertise';
      case AppPermission.bluetoothConnect:
        return 'Bluetooth Connect';
      case AppPermission.mediaLibrary:
        return 'Media Library';
      case AppPermission.calendarRead:
        return 'Calendar (Read)';
      case AppPermission.calendarWrite:
        return 'Calendar (Write)';
      case AppPermission.reminders:
        return 'Reminders';
      case AppPermission.sensors:
        return 'Sensors';
      case AppPermission.speech:
        return 'Speech Recognition';
      case AppPermission.ignoreBatteryOptimizations:
        return 'Battery Optimization';
      case AppPermission.requestInstallPackages:
        return 'Install Packages';
      case AppPermission.systemAlertWindow:
        return 'System Alert Window';
      case AppPermission.criticalAlerts:
        return 'Critical Alerts';
      case AppPermission.accessMediaLocation:
        return 'Media Location Access';
      case AppPermission.activityRecognition:
        return 'Activity Recognition';
      case AppPermission.unknown:
        return 'Unknown';
    }
  }

  /// Check if permission is supported on current platform
  bool isPermissionSupported(AppPermission permission) {
    if (kIsWeb) {
      // Web-specific permissions
      switch (permission) {
        case AppPermission.camera:
        case AppPermission.microphone:
        case AppPermission.notification:
        case AppPermission.location:
          return true;
        default:
          return false;
      }
    }

    if (Platform.isIOS) {
      // iOS-specific restrictions
      switch (permission) {
        case AppPermission.storage:
        case AppPermission.requestInstallPackages:
        case AppPermission.systemAlertWindow:
        case AppPermission.ignoreBatteryOptimizations:
          return false;
        default:
          return true;
      }
    }

    if (Platform.isAndroid) {
      // Android supports most permissions
      return true;
    }

    return false;
  }

  /// Check current status of a permission
  Future<AppPermissionStatus> checkPermissionStatus(
    AppPermission permission,
  ) async {
    try {
      if (!isPermissionSupported(permission)) {
        _log('Permission $permission not supported on current platform');
        return AppPermissionStatus.denied;
      }

      final systemPermission = _getPermissionFromAppPermission(permission);
      final status = await systemPermission.status;
      final appStatus = _convertPermissionStatus(status);

      // Update cache
      _statusCache[permission] = appStatus;

      _log('Permission $permission status: $appStatus');
      return appStatus;
    } catch (e) {
      _logError('Error checking permission status for $permission', e);
      return AppPermissionStatus.unknown;
    }
  }

  /// Request a single permission
  Future<PermissionResult> requestPermission(
    AppPermission permission, {
    String? rationale,
  }) async {
    try {
      if (!isPermissionSupported(permission)) {
        return PermissionResult.denied(
          'Permission not supported on this platform',
        );
      }

      // Check if we can make a request (rate limiting)
      if (!_canMakeRequest(permission)) {
        _log('Rate limiting permission request for $permission');
        final cachedStatus =
            _statusCache[permission] ?? AppPermissionStatus.unknown;
        return _createResultFromStatus(cachedStatus, permission);
      }

      _updateRequestTime(permission);

      final systemPermission = _getPermissionFromAppPermission(permission);

      // Check current status first
      final currentStatus = await systemPermission.status;

      if (currentStatus.isGranted) {
        return PermissionResult.granted();
      }

      if (currentStatus.isPermanentlyDenied) {
        return PermissionResult.permanentlyDenied(
          'Permission permanently denied. Please enable from settings.',
        );
      }

      // Request permission
      _log('Requesting permission: $permission');
      final result = await systemPermission.request();
      final appStatus = _convertPermissionStatus(result);

      // Update cache
      _statusCache[permission] = appStatus;

      return _createResultFromStatus(appStatus, permission);
    } catch (e) {
      _logError('Error requesting permission $permission', e);
      throw PermissionException(
        message: 'Failed to request permission: $e',
        permission: permission,
        status: AppPermissionStatus.unknown,
      );
    }
  }

  /// Request multiple permissions at once
  Future<Map<AppPermission, PermissionResult>> requestMultiplePermissions(
    List<AppPermission> permissions, {
    bool stopOnFirstDenial = false,
  }) async {
    final results = <AppPermission, PermissionResult>{};

    try {
      // Filter supported permissions
      final supportedPermissions = permissions
          .where((p) => isPermissionSupported(p))
          .toList();

      if (supportedPermissions.isEmpty) {
        for (final permission in permissions) {
          results[permission] = PermissionResult.denied(
            'Permission not supported',
          );
        }
        return results;
      }

      // Convert to system permissions
      final systemPermissions = supportedPermissions
          .map((p) => _getPermissionFromAppPermission(p))
          .toList();

      _log(
        'Requesting multiple permissions: ${supportedPermissions.map((p) => getPermissionName(p)).join(', ')}',
      );

      // Request all permissions at once
      final permissionResults = await systemPermissions.request();

      // Process results
      for (int i = 0; i < supportedPermissions.length; i++) {
        final appPermission = supportedPermissions[i];
        final systemPermission = systemPermissions[i];
        final status =
            permissionResults[systemPermission] ?? PermissionStatus.denied;
        final appStatus = _convertPermissionStatus(status);

        // Update cache
        _statusCache[appPermission] = appStatus;

        final result = _createResultFromStatus(appStatus, appPermission);
        results[appPermission] = result;

        // Stop on first denial if requested
        if (stopOnFirstDenial && !result.isGranted) {
          _log('Stopping permission requests due to denial: $appPermission');
          break;
        }
      }

      return results;
    } catch (e) {
      _logError('Error requesting multiple permissions', e);

      // Return error results for all permissions
      for (final permission in permissions) {
        results[permission] = PermissionResult.denied(
          'Failed to request permission: $e',
        );
      }

      return results;
    }
  }

  /// Open app settings for permission management
  Future<bool> openAppSettings() async {
    try {
      _log('Opening app settings');
      return await openAppSettings();
    } catch (e) {
      _logError('Error opening app settings', e);
      return false;
    }
  }

  /// Check if permission should show rationale (Android only)
  Future<bool> shouldShowRequestPermissionRationale(
    AppPermission permission,
  ) async {
    try {
      if (!Platform.isAndroid) return false;

      final systemPermission = _getPermissionFromAppPermission(permission);
      return await systemPermission.shouldShowRequestPermissionRationale;
    } catch (e) {
      _logError('Error checking rationale for $permission', e);
      return false;
    }
  }

  /// Clear permission cache
  void clearCache() {
    _statusCache.clear();
    _lastRequestTime.clear();
    _log('Permission cache cleared');
  }

  /// Get cached permission status (no system call)
  AppPermissionStatus? getCachedPermissionStatus(AppPermission permission) {
    return _statusCache[permission];
  }

  /// Check if all permissions in list are granted
  Future<bool> areAllPermissionsGranted(List<AppPermission> permissions) async {
    for (final permission in permissions) {
      final status = await checkPermissionStatus(permission);
      if (status != AppPermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }

  /// Get permissions that are not granted from a list
  Future<List<AppPermission>> getMissingPermissions(
    List<AppPermission> permissions,
  ) async {
    final missing = <AppPermission>[];

    for (final permission in permissions) {
      final status = await checkPermissionStatus(permission);
      if (status != AppPermissionStatus.granted) {
        missing.add(permission);
      }
    }

    return missing;
  }

  /// Create PermissionResult from status
  PermissionResult _createResultFromStatus(
    AppPermissionStatus status,
    AppPermission permission,
  ) {
    switch (status) {
      case AppPermissionStatus.granted:
        return PermissionResult.granted();
      case AppPermissionStatus.denied:
        return PermissionResult.denied();
      case AppPermissionStatus.permanentlyDenied:
        return PermissionResult.permanentlyDenied();
      case AppPermissionStatus.restricted:
        return PermissionResult.restricted();
      case AppPermissionStatus.limited:
        return PermissionResult(
          status: status,
          message: 'Permission granted with limitations',
          isGranted: true,
        );
      case AppPermissionStatus.provisional:
        return PermissionResult(
          status: status,
          message: 'Permission granted provisionally',
          isGranted: true,
        );
      case AppPermissionStatus.unknown:
        return PermissionResult(
          status: status,
          message: 'Permission status unknown',
          isGranted: false,
        );
    }
  }

  /// Log debug messages
  void _log(String message) {
    if (kDebugMode) {
      debugPrint('[PermissionManager] $message');
    }
  }

  /// Log error messages
  void _logError(String message, dynamic error) {
    if (kDebugMode) {
      debugPrint('[PermissionManager] ERROR: $message - $error');
    }
  }
}

/// Extension methods for convenience
extension PermissionManagerExtensions on PermissionManager {
  /// Quick camera permission check and request
  Future<bool> requestCameraPermission() async {
    final result = await requestPermission(AppPermission.camera);
    return result.isGranted;
  }

  /// Quick location permission check and request
  Future<bool> requestLocationPermission() async {
    final result = await requestPermission(AppPermission.location);
    return result.isGranted;
  }

  /// Quick storage permission check and request
  Future<bool> requestStoragePermission() async {
    final result = await requestPermission(AppPermission.storage);
    return result.isGranted;
  }

  /// Request essential permissions for most apps
  Future<Map<AppPermission, PermissionResult>>
  requestEssentialPermissions() async {
    final permissions = <AppPermission>[];

    if (Platform.isAndroid) {
      permissions.addAll([
        AppPermission.storage,
        AppPermission.camera,
        AppPermission.microphone,
      ]);
    } else if (Platform.isIOS) {
      permissions.addAll([
        AppPermission.camera,
        AppPermission.microphone,
        AppPermission.photos,
      ]);
    }

    return await requestMultiplePermissions(permissions);
  }
}

/// Widget helper for handling permissions with UI
class PermissionHandler extends StatefulWidget {
  final AppPermission permission;
  final Widget Function(BuildContext context, bool hasPermission) builder;
  final Widget? loadingWidget;
  final Widget? deniedWidget;
  final String? rationale;
  final VoidCallback? onPermissionDenied;
  final VoidCallback? onPermissionGranted;

  const PermissionHandler({
    super.key,
    required this.permission,
    required this.builder,
    this.loadingWidget,
    this.deniedWidget,
    this.rationale,
    this.onPermissionDenied,
    this.onPermissionGranted,
  });

  @override
  State<PermissionHandler> createState() => _PermissionHandlerState();
}

class _PermissionHandlerState extends State<PermissionHandler> {
  bool _isLoading = true;
  bool _hasPermission = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  Future<void> _checkPermission() async {
    try {
      final status = await PermissionManager.instance.checkPermissionStatus(
        widget.permission,
      );

      setState(() {
        _hasPermission = status == AppPermissionStatus.granted;
        _isLoading = false;
      });

      if (_hasPermission) {
        widget.onPermissionGranted?.call();
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  Future<void> _requestPermission() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final result = await PermissionManager.instance.requestPermission(
        widget.permission,
        rationale: widget.rationale,
      );

      setState(() {
        _hasPermission = result.isGranted;
        _isLoading = false;
        _errorMessage = result.isGranted ? null : result.message;
      });

      if (result.isGranted) {
        widget.onPermissionGranted?.call();
      } else {
        widget.onPermissionDenied?.call();
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return widget.loadingWidget ??
          const Center(child: CircularProgressIndicator());
    }

    if (!_hasPermission) {
      if (widget.deniedWidget != null) {
        return widget.deniedWidget!;
      }

      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.security,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Permission Required',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'This feature requires ${PermissionManager.instance.getPermissionName(widget.permission).toLowerCase()} permission.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (_errorMessage != null) ...[
              const SizedBox(height: 8),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            ],
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _requestPermission,
              child: const Text('Grant Permission'),
            ),
            TextButton(
              onPressed: () => PermissionManager.instance.openAppSettings(),
              child: const Text('Open Settings'),
            ),
          ],
        ),
      );
    }

    return widget.builder(context, _hasPermission);
  }
}


// basic permission result
// Single permission
// final result = await PermissionManager.instance.requestPermission(AppPermission.camera);
// if (result.isGranted) {
//   // Use camera
// }

// // Multiple permissions
// final results = await PermissionManager.instance.requestMultiplePermissions([
//   AppPermission.camera,
//   AppPermission.microphone,
// ]);

/// UI widget implementation
// PermissionHandler(
//   permission: AppPermission.camera,
//   builder: (context, hasPermission) {
//     return hasPermission 
//       ? CameraWidget() 
//       : Text('Camera not available');
//   },
//   onPermissionGranted: () => print('Camera granted!'),
// )

/// check permission
// final status = await PermissionManager.instance.checkPermissionStatus(AppPermission.location);
// final isGranted = status == AppPermissionStatus.granted;

/// Platform Setup Required:
/// - Android: Add permissions in AndroidManifest.xml
// <uses-permission android:name="android.permission.CAMERA" />
// <uses-permission android:name="android.permission.RECORD_AUDIO" />
// <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
// <!-- Add other permissions as needed -->

// - iOS: Add permissions in Info.plist
// <key>NSCameraUsageDescription</key>
// <string>This app needs camera access to take photos</string>
// <key>NSMicrophoneUsageDescription</key>
// <string>This app needs microphone access to record audio</string>
// <!-- Add other usage descriptions as needed -->