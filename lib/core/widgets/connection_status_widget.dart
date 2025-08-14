import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/connectivity_service.dart';

class ConnectionStatusWidget extends StatelessWidget {
  const ConnectionStatusWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectivityService>(
      builder: (context, connectivityService, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: connectivityService.hasConnection 
              ? Colors.green.withValues(alpha:0.1)
              : Colors.red.withValues(alpha:0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                connectivityService.hasConnection 
                  ? Icons.wifi 
                  : Icons.wifi_off,
                color: connectivityService.hasConnection 
                  ? Colors.green 
                  : Colors.red,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                connectivityService.hasConnection 
                  ? 'Connected (${_getConnectionType(connectivityService.connectionStatus)})'
                  : 'No Connection',
                style: TextStyle(
                  color: connectivityService.hasConnection 
                    ? Colors.green[700]
                    : Colors.red[700],
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _getConnectionType(List<ConnectivityResult> results) {
    if (results.isEmpty || results.every((result) => result == ConnectivityResult.none)) {
      return 'No Connection';
    }
    
    final types = results
        .where((result) => result != ConnectivityResult.none)
        .map((result) {
          switch (result) {
            case ConnectivityResult.wifi:
              return 'WiFi';
            case ConnectivityResult.mobile:
              return 'Mobile';
            case ConnectivityResult.ethernet:
              return 'Ethernet';
            case ConnectivityResult.bluetooth:
              return 'Bluetooth';
            case ConnectivityResult.vpn:
              return 'VPN';
            case ConnectivityResult.other:
              return 'Other';
            default:
              return 'Unknown';
          }
        }).toList();
    
    return types.join(', ');
  }
}