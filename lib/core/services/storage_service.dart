import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/storage_keys.dart';

class StorageService {
  StorageService._internal();

  late SharedPreferences sp;

  static final StorageService _instance = StorageService._internal();
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  static StorageService get instance => _instance;

  Future<void> init() async {
    sp = await SharedPreferences.getInstance();
  }

  // Secure Storage Methods
  Future<void> setAccessToken(String token) async {
    await _secureStorage.write(key: StorageKeys.accessToken, value: token);
  }

  Future<String?> getAccessToken() async {
    return await _secureStorage.read(key: StorageKeys.accessToken);
  }

  Future<void> setRefreshToken(String token) async {
    await _secureStorage.write(key: StorageKeys.refreshToken, value: token);
  }

  Future<String?> getRefreshToken() async {
    return await _secureStorage.read(key: StorageKeys.refreshToken);
  }

  Future<void> clearTokens() async {
    await _secureStorage.delete(key: StorageKeys.accessToken);
    await _secureStorage.delete(key: StorageKeys.refreshToken);
  }

  Future<void> setSecureData(String key, String value) async {
    await _secureStorage.write(key: key, value: value);
  }

  Future<String?> getSecureData(String key) async {
    return await _secureStorage.read(key: key);
  }

  Future<void> deleteSecureData(String key) async {
    await _secureStorage.delete(key: key);
  }

  Future<void> clearAllSecureData() async {
    await _secureStorage.deleteAll();
  }

  // Regular Storage Methods
  Future<void> setString(String key, String value) async {
    await sp.setString(key, value);
  }

  String? getString(String key) {
    return sp.getString(key);
  }

  Future<void> setInt(String key, int value) async {
    await sp.setInt(key, value);
  }

  int? getInt(String key) {
    return sp.getInt(key);
  }

  Future<void> setBool(String key, bool value) async {
    await sp.setBool(key, value);
  }

  bool? getBool(String key) {
    return sp.getBool(key);
  }

  Future<void> setDouble(String key, double value) async {
    await sp.setDouble(key, value);
  }

  double? getDouble(String key) {
    return sp.getDouble(key);
  }

  Future<void> setStringList(String key, List<String> value) async {
    await sp.setStringList(key, value);
  }

  List<String>? getStringList(String key) {
    return sp.getStringList(key);
  }

  Future<void> setObject(String key, Map<String, dynamic> value) async {
    await sp.setString(key, jsonEncode(value));
  }

  Map<String, dynamic>? getObject(String key) {
    final jsonString = sp.getString(key);
    if (jsonString != null) {
      return jsonDecode(jsonString) as Map<String, dynamic>;
    }
    return null;
  }

  Future<void> remove(String key) async {
    await sp.remove(key);
  }

  Future<void> clear() async {
    await sp.clear();
  }

  bool containsKey(String key) {
    return sp.containsKey(key);
  }

  Set<String> getKeys() {
    return sp.getKeys();
  }
}