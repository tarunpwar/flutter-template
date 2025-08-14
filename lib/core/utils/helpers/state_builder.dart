import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Generic State Builder that rebuilds UI when ValueNotifier changes
class StateBuilder<T> extends StatefulWidget {
  final ValueListenable<T> notifier;
  final Widget Function(BuildContext context, T value) builder;

  const StateBuilder({
    super.key,
    required this.notifier,
    required this.builder,
  });

  @override
  State<StateBuilder<T>> createState() => _StateBuilderState<T>();
}

class _StateBuilderState<T> extends State<StateBuilder<T>> {
  @override
  void initState() {
    super.initState();
    widget.notifier.addListener(_onStateChanged);
  }

  @override
  void didUpdateWidget(StateBuilder<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.notifier != widget.notifier) {
      oldWidget.notifier.removeListener(_onStateChanged);
      widget.notifier.addListener(_onStateChanged);
    }
  }

  @override
  void dispose() {
    widget.notifier.removeListener(_onStateChanged);
    super.dispose();
  }

  void _onStateChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, widget.notifier.value);
  }
}

// State Listener that performs side effects when ValueNotifier changes
class StateListener<T> extends StatefulWidget {
  final ValueListenable<T> notifier;
  final void Function(BuildContext context, T value) listener;
  final Widget child;
  final bool Function(T previous, T current)? condition;

  const StateListener({
    super.key,
    required this.notifier,
    required this.listener,
    required this.child,
    this.condition,
  });

  @override
  State<StateListener<T>> createState() => _StateListenerState<T>();
}

class _StateListenerState<T> extends State<StateListener<T>> {
  T? _previousValue;

  @override
  void initState() {
    super.initState();
    _previousValue = widget.notifier.value;
    widget.notifier.addListener(_onStateChanged);
  }

  @override
  void didUpdateWidget(StateListener<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.notifier != widget.notifier) {
      oldWidget.notifier.removeListener(_onStateChanged);
      _previousValue = widget.notifier.value;
      widget.notifier.addListener(_onStateChanged);
    }
  }

  @override
  void dispose() {
    widget.notifier.removeListener(_onStateChanged);
    super.dispose();
  }

  void _onStateChanged() {
    if (mounted) {
      final currentValue = widget.notifier.value;
      final shouldNotify = widget.condition?.call(_previousValue as T, currentValue) ?? true;
      
      if (shouldNotify) {
        widget.listener(context, currentValue);
      }
      
      _previousValue = currentValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

// Combined Builder and Listener
class StateConsumer<T> extends StatefulWidget {
  final ValueListenable<T> notifier;
  final Widget Function(BuildContext context, T value) builder;
  final void Function(BuildContext context, T value)? listener;
  final bool Function(T previous, T current)? condition;

  const StateConsumer({
    super.key,
    required this.notifier,
    required this.builder,
    this.listener,
    this.condition,
  });

  @override
  State<StateConsumer<T>> createState() => _StateConsumerState<T>();
}

class _StateConsumerState<T> extends State<StateConsumer<T>> {
  T? _previousValue;

  @override
  void initState() {
    super.initState();
    _previousValue = widget.notifier.value;
    widget.notifier.addListener(_onStateChanged);
  }

  @override
  void didUpdateWidget(StateConsumer<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.notifier != widget.notifier) {
      oldWidget.notifier.removeListener(_onStateChanged);
      _previousValue = widget.notifier.value;
      widget.notifier.addListener(_onStateChanged);
    }
  }

  @override
  void dispose() {
    widget.notifier.removeListener(_onStateChanged);
    super.dispose();
  }

  void _onStateChanged() {
    if (mounted) {
      final currentValue = widget.notifier.value;
      final shouldNotify = widget.condition?.call(_previousValue as T, currentValue) ?? true;
      
      if (shouldNotify && widget.listener != null) {
        widget.listener!(context, currentValue);
      }
      
      _previousValue = currentValue;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, widget.notifier.value);
  }
}