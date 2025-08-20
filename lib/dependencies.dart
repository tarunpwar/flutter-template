import 'package:flutter_template/core/network/api_client.dart';
import 'package:flutter_template/features/user/user_repository.dart';

class AppDependencies {
  // Services
  late final ApiClient _apiClient;

  // Repositories
  late final UserRepository userRepository;

  AppDependencies() {
    _apiClient = ApiClient(onClearUserDetails: () {}, onUnauthorized: () {});
    // Repositories
    userRepository = UserRepository(_apiClient);
  }

  // Getters for Services
  ApiClient get apiClient => _apiClient;

  // Cleanup of resources used by repositories or services will happen here
  Future<void> dispose() async {}
}
