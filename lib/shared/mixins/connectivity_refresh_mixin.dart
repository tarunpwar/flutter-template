import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/services/connectivity_service.dart';

mixin ConnectivityRefreshMixin<T extends StatefulWidget> on State<T> {
  late ConnectivityService _connectivityService;
  bool _wasDisconnected = false;

  @override
  void dispose() {
    _connectivityService.removeListener(_onConnectivityChanged);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _connectivityService = Provider.of<ConnectivityService>(context, listen: false);
    _connectivityService.addListener(_onConnectivityChanged);
  }

  // Override this method in your page to define refresh logic
  void onReconnectRefresh();

  // Override this method in your page to define disconnect logic
  // void onDisconnect();

  void _onConnectivityChanged() {
    if (!_connectivityService.hasConnection) {
      _wasDisconnected = true;
    } else if (_wasDisconnected && _connectivityService.hasConnection) {
      _wasDisconnected = false;
      onReconnectRefresh();
    }
  }
}