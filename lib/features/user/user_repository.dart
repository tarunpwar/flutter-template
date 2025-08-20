import 'package:flutter_template/core/network/api_client.dart';

import '../../shared/models/api_response.dart';
import 'user_model.dart';

class UserRepository {
  final ApiClient _apiClient;

  UserRepository(this._apiClient);

  Future<ApiResponse<UserModel>> getUser(int userId) async {
    return await _apiClient.get<UserModel>(
      '/users/$userId',
      fromJson: (json) => UserModel.fromJson(json),
    );
  }

  Future<ApiResponse<List<UserModel>>> getUsers({
    int page = 1,
    int limit = 10,
  }) async {
    return await _apiClient.get<List<UserModel>>(
      '/users',
      queryParameters: {'page': page, 'limit': limit},
      fromJson: (json) {
        if (json is List) {
          return json.map((item) => UserModel.fromJson(item)).toList();
        }
        return <UserModel>[];
      },
    );
  }

  Future<ApiResponse<UserModel>> createUser(Map<String, dynamic> userData) async {
    return await _apiClient.post<UserModel>(
      '/users',
      data: userData,
      fromJson: (json) => UserModel.fromJson(json),
    );
  }

  Future<ApiResponse<UserModel>> updateUser(int userId, Map<String, dynamic> userData) async {
    return await _apiClient.put<UserModel>(
      '/users/$userId',
      data: userData,
      fromJson: (json) => UserModel.fromJson(json),
    );
  }

  Future<ApiResponse<void>> deleteUser(int userId) async {
    return await _apiClient.delete<void>('/users/$userId');
  }
}