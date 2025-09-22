import 'package:flutter/material.dart';

class ConnectivityDialog extends StatelessWidget {
  const ConnectivityDialog({super.key});

  Widget _buildTip(String tip) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4),
      child: Text(tip, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: Row(
          children: [
            Icon(
              Icons.wifi_off,
              color: Theme.of(context).colorScheme.error,
              size: 24,
            ),
            SizedBox(width: 12),
            Text(
              'No Internet Connection',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Please check your internet connection and try again.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 16),
            Text(
              'Tips:',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            SizedBox(height: 8),
            _buildTip('• Check if WiFi or mobile data is enabled'),
            _buildTip('• Try moving to a location with better signal'),
            _buildTip('• Restart your router or mobile data'),
            _buildTip('• Contact your service provider if issues persist'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              // The dialog will automatically close when connectivity is restored
            },
            child: const Text('Waiting for connection...'),
          ),
        ],
      ),
    );
  }
}