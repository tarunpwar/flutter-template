// ui_state.dart
import 'package:flutter/material.dart';

enum UIStateType {
  initial,
  loading,
  empty,
  success,
  error,
  custom,
}

class UIState<T> {
  const UIState._({
    required this.type,
    this.data,
    this.message,
    this.customData,
  });

  factory UIState.custom({dynamic customData, String? message}) => UIState._(
    type: UIStateType.custom,
    customData: customData,
        message: message,
      );

  factory UIState.empty({String? message}) => UIState._(
        type: UIStateType.empty,
        message: message ?? 'No data available',
      );

  factory UIState.error(String message) =>
      UIState._(type: UIStateType.error,
        message: message,
      );

  // Factory constructors for each state
  factory UIState.initial() => const UIState._(type: UIStateType.initial);

  factory UIState.loading({String? message}) =>
      UIState._(type: UIStateType.loading,
        message: message,
      );

  factory UIState.success(T data, {String? message}) =>
      UIState._(type: UIStateType.success, data: data,
        message: message,
      );

  final dynamic customData;
  final T? data;
  final String? message;
  final UIStateType type;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UIState<T> &&
        other.type == type &&
        other.data == data &&
        other.message == message &&
        other.customData == customData;
  }

  @override
  int get hashCode {
    return type.hashCode ^
        data.hashCode ^
        message.hashCode ^
        customData.hashCode;
  }

  @override
  String toString() {
    return 'UIState(type: $type, data: $data, message: $message, customData: $customData)';
  }

  // Convenience getters
  bool get isInitial => type == UIStateType.initial;

  bool get isLoading => type == UIStateType.loading;

  bool get isEmpty => type == UIStateType.empty;

  bool get isSuccess => type == UIStateType.success;

  bool get isError => type == UIStateType.error;

  bool get isCustom => type == UIStateType.custom;

  // Pattern matching method
  R when<R>({
    required R Function() initial,
    required R Function(String? message) loading,
    required R Function(String message) empty,
    required R Function(T data, String? message) success,
    required R Function(String message) error,
    required R Function(dynamic customData, String? message) custom,
  }) {
    switch (type) {
      case UIStateType.initial:
        return initial();
      case UIStateType.loading:
        return loading(message);
      case UIStateType.empty:
        return empty(message ?? 'No data available');
      case UIStateType.success:
        return success(data as T, message);
      case UIStateType.error:
        return error(message ?? 'An error occurred');
      case UIStateType.custom:
        return custom(customData, message);
    }
  }

  // Optional pattern matching (doesn't require all cases)
  R? whenOrNull<R>({
    R Function()? initial,
    R Function(String? message)? loading,
    R Function(String message)? empty,
    R Function(T data, String? message)? success,
    R Function(String message)? error,
    R Function(dynamic customData, String? message)? custom,
  }) {
    switch (type) {
      case UIStateType.initial:
        return initial?.call();
      case UIStateType.loading:
        return loading?.call(message);
      case UIStateType.empty:
        return empty?.call(message ?? 'No data available');
      case UIStateType.success:
        return success?.call(data as T, message);
      case UIStateType.error:
        return error?.call(message ?? 'An error occurred');
      case UIStateType.custom:
        return custom?.call(customData, message);
    }
  }
}


class UIStateNotifier<T> extends ChangeNotifier {
  UIState<T> _state = UIState<T>.initial();

  UIState<T> get state => _state;

  void setState(UIState<T> newState) {
    _state = newState;
    notifyListeners();
  }

  void setInitial() => setState(UIState<T>.initial());

  void setLoading({String? message}) => setState(UIState<T>.loading(message: message));

  void setEmpty({String? message}) => setState(UIState<T>.empty(message: message));

  void setSuccess(T data, {String? message}) => setState(UIState<T>.success(data, message: message));

  void setError(String message) => setState(UIState<T>.error(message));

  void setCustom({dynamic customData, String? message}) => 
      setState(UIState<T>.custom(customData: customData, message: message));
}

// Example usage in a widget
class ExampleUsage extends StatefulWidget {
  const ExampleUsage({super.key});

  @override
  State<ExampleUsage> createState() => _ExampleUsageState();
}

class _ExampleUsageState extends State<ExampleUsage> {
  final UIStateNotifier<List<String>> _notifier = UIStateNotifier<List<String>>();

  @override
  void dispose() {
    _notifier.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _simulateDataFetching();
  }

  Future<void> _simulateDataFetching() async {
    _notifier.setLoading(message: 'Fetching data...');
    
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));
    
    // Simulate different outcomes
    final random = DateTime.now().millisecond % 4;
    switch (random) {
      case 0:
        _notifier.setSuccess(['Item 1', 'Item 2', 'Item 3'], message: 'Data loaded successfully');
        break;
      case 1:
        _notifier.setEmpty(message: 'No items found');
        break;
      case 2:
        _notifier.setError('Failed to load data');
        break;
      case 3:
        _notifier.setCustom(
          customData: {'customField': 'customValue'},
          message: 'Custom state with data'
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('UI State Example')),
      body: AnimatedBuilder(
        animation: _notifier,
        builder: (context, child) {
          return _notifier.state.when<Widget>(
            initial: () => const Center(
              child: Text('Tap the refresh button to start'),
            ),
            loading: (message) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  if (message != null) ...[
                    const SizedBox(height: 16),
                    Text(message),
                  ],
                ],
              ),
            ),
            empty: (message) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.inbox_outlined, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(message, style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            success: (data, message) => Column(
              children: [
                if (message != null)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    color: Colors.green.shade50,
                    child: Text(
                      message,
                      style: TextStyle(color: Colors.green.shade800),
                      textAlign: TextAlign.center,
                    ),
                  ),
                Expanded(
                  child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) => ListTile(
                      title: Text(data[index]),
                    ),
                  ),
                ),
              ],
            ),
            error: (message) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(message, style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _simulateDataFetching,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
            custom: (customData, message) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.info_outline, size: 64, color: Colors.blue),
                  const SizedBox(height: 16),
                  Text(message ?? 'Custom state'),
                  if (customData != null) ...[
                    const SizedBox(height: 8),
                    Text('Data: $customData', style: const TextStyle(fontSize: 12)),
                  ],
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _simulateDataFetching,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}