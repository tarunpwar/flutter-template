import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';

import '../../shared/mixins/connectivity_refresh_mixin.dart';

class ConnectivityService extends ChangeNotifier {
  ConnectivityService() {
    _initConnectivity();
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen(
      _updateConnectionStatus,
    );
  }

  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  bool _hasConnection = false;
  bool _isFirstCheck = true;
  bool _shouldRefreshOnReconnect = false;

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  List<ConnectivityResult> get connectionStatus => _connectionStatus;

  bool get hasConnection => _hasConnection;

  bool get isFirstCheck => _isFirstCheck;

  bool get shouldRefreshOnReconnect => _shouldRefreshOnReconnect;

  // Reset refresh flag after it's been handled
  void resetRefreshFlag() {
    _shouldRefreshOnReconnect = false;
  }

  // Force refresh trigger for manual refresh
  void triggerRefresh() {
    _shouldRefreshOnReconnect = true;
    notifyListeners();
  }

  // Initialize connectivity check
  Future<void> _initConnectivity() async {
    try {
      final result = await Connectivity().checkConnectivity();
      _updateConnectionStatus(result);
    } catch (e) {
      debugPrint('Could not check connectivity status: $e');
    }
  }

  // Update connection status and notify listeners
  void _updateConnectionStatus(List<ConnectivityResult> results) {
    final previousConnection = _hasConnection;
    _connectionStatus = results;
    _hasConnection = results.any((result) => result != ConnectivityResult.none);
    
    // Set refresh flag when reconnecting after disconnection
    if (!previousConnection && _hasConnection && !_isFirstCheck) {
      _shouldRefreshOnReconnect = true;
    }
    
    // Only notify if this isn't the first check and connection status changed
    if (!_isFirstCheck && previousConnection != _hasConnection) {
      notifyListeners();
    }
    
    if (_isFirstCheck) {
      _isFirstCheck = false;
      notifyListeners();
    }
  }
}

// Refreshable Content Widget Example
class RefreshableContentPage extends StatefulWidget {
  const RefreshableContentPage({super.key});

  @override
  State<RefreshableContentPage> createState() => _RefreshableContentPageState();
}

class _RefreshableContentPageState extends State<RefreshableContentPage> with ConnectivityRefreshMixin {
  List<String> _data = [];
  bool _isLoading = false;
  int _refreshCount = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void onReconnectRefresh() {
    // This will be called automatically when connection is restored
    _refreshData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));
    
    setState(() {
      _data = List.generate(10, (index) => 'Item ${index + 1} - Load #${_refreshCount + 1}');
      _isLoading = false;
    });
  }

  Future<void> _refreshData() async {
    _refreshCount++;
    await _loadData();
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Data refreshed automatically (Refresh #$_refreshCount)'),
          backgroundColor: Colors.blue,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Refreshable Content'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshData,
            tooltip: 'Manual Refresh',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _refreshData,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _data.length + 2, // +2 for header and footer
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Card(
                      color: Colors.blue.shade50,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Auto-Refresh Demo',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text('Refresh Count: $_refreshCount'),
                            const SizedBox(height: 4),
                            const Text(
                              'This page will automatically refresh when internet connection is restored.',
                              style: TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  
                  if (index == _data.length + 1) {
                    return const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        'Pull down to refresh manually or turn off/on internet to test auto-refresh',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  }
                  
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue,
                        child: Text('$index'),
                      ),
                      title: Text(_data[index - 1]),
                      subtitle: Text('Loaded at ${DateTime.now().toString().substring(11, 19)}'),
                    ),
                  );
                },
              ),
            ),
    );
  }
}

