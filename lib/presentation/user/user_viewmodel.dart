import 'package:flutter/material.dart';

import '../../features/user/user_model.dart';
import '../../features/user/user_repository.dart';

enum ViewState { idle, loading, error, success }

class UserViewModel extends ChangeNotifier {
  final UserRepository _userRepository;

  UserViewModel(this._userRepository);

  ViewState _viewState = ViewState.idle;
  String? _errorMessage;
  UserModel? _selectedUser;
  List<UserModel> _users = [];

  // Getters
  ViewState get viewState => _viewState;
  String? get errorMessage => _errorMessage;
  UserModel? get selectedUser => _selectedUser;
  List<UserModel> get users => _users;
  bool get isLoading => _viewState == ViewState.loading;

  // Set view state
  void _setViewState(ViewState state) {
    _viewState = state;
    notifyListeners();
  }

  // Set error
  void _setError(String message) {
    _errorMessage = message;
    _setViewState(ViewState.error);
  }

  // Get user by ID
  Future<void> getUser(int userId) async {
    _setViewState(ViewState.loading);
    _errorMessage = null;

    try {
      final response = await _userRepository.getUser(userId);
      
      if (response.success && response.data != null) {
        _selectedUser = response.data;
        _setViewState(ViewState.success);
      } else {
        _setError(response.message ?? 'Failed to load user');
      }
    } catch (e) {
      _setError('An unexpected error occurred');
    }
  }

  // Get users list
  Future<void> getUsers({int page = 1, int limit = 10}) async {
    _setViewState(ViewState.loading);
    _errorMessage = null;

    try {
      final response = await _userRepository.getUsers(page: page, limit: limit);
      
      if (response.success && response.data != null) {
        _users = response.data!;
        _setViewState(ViewState.success);
      } else {
        _setError(response.message ?? 'Failed to load users');
      }
    } catch (e) {
      _setError('An unexpected error occurred');
    }
  }

  // Create user
  Future<bool> createUser(Map<String, dynamic> userData) async {
    _setViewState(ViewState.loading);
    _errorMessage = null;

    try {
      final response = await _userRepository.createUser(userData);
      
      if (response.success && response.data != null) {
        _users.add(response.data!);
        _setViewState(ViewState.success);
        return true;
      } else {
        _setError(response.message ?? 'Failed to create user');
        return false;
      }
    } catch (e) {
      _setError('An unexpected error occurred');
      return false;
    }
  }

  // Update user
  Future<bool> updateUser(int userId, Map<String, dynamic> userData) async {
    _setViewState(ViewState.loading);
    _errorMessage = null;

    try {
      final response = await _userRepository.updateUser(userId, userData);
      
      if (response.success && response.data != null) {
        final index = _users.indexWhere((user) => user.id == userId);
        if (index != -1) {
          _users[index] = response.data!;
        }
        _selectedUser = response.data;
        _setViewState(ViewState.success);
        return true;
      } else {
        _setError(response.message ?? 'Failed to update user');
        return false;
      }
    } catch (e) {
      _setError('An unexpected error occurred');
      return false;
    }
  }

  // Delete user
  Future<bool> deleteUser(int userId) async {
    _setViewState(ViewState.loading);
    _errorMessage = null;

    try {
      final response = await _userRepository.deleteUser(userId);
      
      if (response.success) {
        _users.removeWhere((user) => user.id == userId);
        if (_selectedUser?.id == userId) {
          _selectedUser = null;
        }
        _setViewState(ViewState.success);
        return true;
      } else {
        _setError(response.message ?? 'Failed to delete user');
        return false;
      }
    } catch (e) {
      _setError('An unexpected error occurred');
      return false;
    }
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    if (_viewState == ViewState.error) {
      _setViewState(ViewState.idle);
    }
  }

  // Clear selected user
  void clearSelectedUser() {
    _selectedUser = null;
    notifyListeners();
  }
}
