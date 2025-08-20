// Global getter for convenience
import 'package:flutter/material.dart';

import '../../features/user/user_repository.dart';
import '../network/api_client.dart';

ServiceLocator get sl => ServiceLocator();

class ServiceLocator {
  static final ServiceLocator _instance = ServiceLocator._internal();
  factory ServiceLocator() => _instance;
  ServiceLocator._internal();

  final Map<Type, dynamic> _services = {};

  // Register a service
  void register<T>(T service) {
    _services[T] = service;
  }

  // Register a factory (lazy initialization)
  void registerFactory<T>(T Function() factory) {
    _services[T] = factory;
  }

  // Get a service
  T get<T>() {
    final service = _services[T];
    if (service == null) {
      throw Exception('Service of type $T is not registered');
    }

    // If it's a factory, call it and register the instance
    if (service is Function) {
      final instance = service();
      _services[T] = instance;
      return instance;
    }

    return service as T;
  }

  // Check if service is registered
  bool isRegistered<T>() {
    return _services.containsKey(T);
  }

  // Clear all services
  void clear() {
    _services.clear();
  }

  // Remove specific service
  void remove<T>() {
    _services.remove(T);
  }
}

extension ServiceLocatorExtension on BuildContext {
  // Convenience method to get services from context
  T getService<T>() => sl.get<T>();
  
  // Get repository directly
  UserRepository get userRepository => sl.get<UserRepository>();
  
  // Get API client directly
  ApiClient get apiClient => sl.get<ApiClient>();
}