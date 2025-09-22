import 'package:flutter/material.dart';

class ContentSizedBottomSheet extends StatelessWidget {
  const ContentSizedBottomSheet({
    super.key,
    required this.child,
    this.maxHeight,
    this.padding,
    this.borderRadius,
    this.backgroundColor,
    this.isDismissible = true,
    this.enableDrag = true,
  });

  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final Widget child;
  final bool enableDrag;
  final bool isDismissible;
  final double? maxHeight;
  final EdgeInsetsGeometry? padding;

  /// Static method to show the bottom sheet
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    double? maxHeight,
    EdgeInsetsGeometry? padding,
    BorderRadius? borderRadius,
    Color? backgroundColor,
    bool isDismissible = true,
    bool enableDrag = true,
    bool useRootNavigator = false,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      useRootNavigator: useRootNavigator,
      backgroundColor: Colors.transparent,
      builder: (context) => ContentSizedBottomSheet(
        maxHeight: maxHeight,
        padding: padding,
        borderRadius: borderRadius,
        backgroundColor: backgroundColor,
        isDismissible: isDismissible,
        enableDrag: enableDrag,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final defaultMaxHeight = screenHeight * 0.9;

    return Container(
      constraints: BoxConstraints(
        maxHeight: maxHeight ?? defaultMaxHeight,
      ),
      decoration: BoxDecoration(
        color: backgroundColor ?? Theme.of(context).colorScheme.surface,
        borderRadius: borderRadius ??
            const BorderRadius.vertical(
              top: Radius.circular(16),
            ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle (optional)
          if (enableDrag)
            Container(
              margin: const EdgeInsets.only(top: 8),
              height: 4,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          // Content
          Flexible(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Padding(
                padding: padding ?? const EdgeInsets.all(16),
                child: child,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Example usage widget
class BottomSheetExample extends StatelessWidget {
  const BottomSheetExample({super.key});

  void _showSmallBottomSheet(BuildContext context) {
    ContentSizedBottomSheet.show(
      context: context,
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Small Bottom Sheet',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text('This is a small bottom sheet with minimal content.'),
        ],
      ),
    );
  }

  void _showMediumBottomSheet(BuildContext context) {
    ContentSizedBottomSheet.show(
      context: context,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Medium Bottom Sheet',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const Text(
            'This bottom sheet has more content and will automatically adjust its height.',
          ),
          const SizedBox(height: 16),
          ...List.generate(
            5,
            (index) => ListTile(
              leading: Icon(Icons.star, color: Colors.amber),
              title: Text('Item ${index + 1}'),
              subtitle: Text('Description for item ${index + 1}'),
            ),
          ),
        ],
      ),
    );
  }

  void _showLargeBottomSheet(BuildContext context) {
    ContentSizedBottomSheet.show(
      context: context,
      maxHeight: MediaQuery.of(context).size.height * 0.8,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Large Bottom Sheet',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const Text(
            'This is a large bottom sheet with scrollable content.',
          ),
          const SizedBox(height: 16),
          ...List.generate(
            20,
            (index) => Card(
              child: ListTile(
                leading: CircleAvatar(
                  child: Text('${index + 1}'),
                ),
                title: Text('Long Item Title ${index + 1}'),
                subtitle: Text(
                  'This is a longer description for item ${index + 1} that might wrap to multiple lines.',
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCustomStyledBottomSheet(BuildContext context) {
    ContentSizedBottomSheet.show(
      context: context,
      backgroundColor: Colors.blueGrey[50],
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(24),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Icon(Icons.info, color: Colors.blue),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Custom Styled Bottom Sheet',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'This bottom sheet has custom styling with different colors, padding, and border radius.',
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Confirm'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Content-Sized Bottom Sheet')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _showSmallBottomSheet(context),
              child: const Text('Show Small Bottom Sheet'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _showMediumBottomSheet(context),
              child: const Text('Show Medium Bottom Sheet'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _showLargeBottomSheet(context),
              child: const Text('Show Large Bottom Sheet'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _showCustomStyledBottomSheet(context),
              child: const Text('Show Custom Styled Bottom Sheet'),
            ),
          ],
        ),
      ),
    );
  }
}