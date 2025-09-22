import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/services/connectivity_service.dart';
import '../../core/widgets/connection_status_widget.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  String _getConnectionTypes(List<ConnectivityResult> results) {
    if (results.isEmpty ||
        results.every((result) => result == ConnectivityResult.none)) {
      return 'No Connection';
    }

    final types = results
        .where((result) => result != ConnectivityResult.none)
        .map((result) => result.name)
        .toList();

    return types.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connectivity Service Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: ConnectionStatusWidget(),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.network_check,
              size: 80,
              color: Colors.blue,
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RefreshableContentPage(),
                  ),
                );
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Test Auto-Refresh Page'),
            ),
            const SizedBox(height: 20),
            const Text(
              'Connectivity Service Demo',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Consumer<ConnectivityService>(
              builder: (context, connectivityService, child) {
                return Card(
                  margin: const EdgeInsets.all(20),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Text(
                          'Status: ${connectivityService.hasConnection ? "Connected" : "Disconnected"}',
                          style: TextStyle(
                            fontSize: 18,
                            color: connectivityService.hasConnection 
                              ? Colors.green 
                              : Colors.red,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Connection Type: ${_getConnectionTypes(connectivityService.connectionStatus)}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            const Text(
              'Turn off your internet connection to see the dialog.\nTurn it back on to see the reconnection snackbar.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}