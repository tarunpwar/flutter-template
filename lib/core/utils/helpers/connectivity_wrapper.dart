import 'package:flutter/material.dart';
import 'package:flutter_template/core/widgets/no_connection_dialog.dart';
import 'package:provider/provider.dart';

import '../../services/connectivity_service.dart';

class ConnectivityWrapper extends StatefulWidget {
  final Widget child;
  final VoidCallback? onReconnectRefresh;
  final bool enableAutoRefresh;

  const ConnectivityWrapper({
    super.key, 
    required this.child,
    this.onReconnectRefresh,
    this.enableAutoRefresh = true,
  });

  @override
  State<ConnectivityWrapper> createState() => _ConnectivityWrapperState();
}

class _ConnectivityWrapperState extends State<ConnectivityWrapper> {
  bool _dialogShown = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectivityService>(
      builder: (context, connectivityService, child) {
        // Handle connection changes
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _handleConnectivityChange(context, connectivityService);
        });

        return widget.child;
      },
    );
  }

  void _handleConnectivityChange(
    BuildContext context,
    ConnectivityService service,
  ) {
    if (!service.isFirstCheck) {
      if (!service.hasConnection && !_dialogShown) {
        // Show dialog on disconnection
        _dialogShown = true;
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const NoConnectionDialog(),
        ).then((_) {
          _dialogShown = false;
        });
      } else if (service.hasConnection && _dialogShown) {
        // Close dialog and show snackbar on reconnection
        Navigator.of(context, rootNavigator: true).pop();
        _dialogShown = false;
        
        _showReconnectionSnackbar(context);
        _handleRefreshOnReconnect(service);
        
      } else if (service.hasConnection && !_dialogShown && service.shouldRefreshOnReconnect) {
        // Just show snackbar for reconnection without dialog
        _showReconnectionSnackbar(context);
        _handleRefreshOnReconnect(service);
      }
    }
  }

  void _showReconnectionSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.wifi, color: Colors.white),
            SizedBox(width: 8),
            Text('Internet connection restored'),
          ],
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleRefreshOnReconnect(ConnectivityService service) {
    if (widget.enableAutoRefresh && service.shouldRefreshOnReconnect) {
      // Trigger custom refresh callback if provided
      if (widget.onReconnectRefresh != null) {
        widget.onReconnectRefresh!();
      }
      
      // Reset the refresh flag
      service.resetRefreshFlag();
    }
  }
}