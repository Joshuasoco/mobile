/// MSME Pathways - Storage Service
///
/// Abstract wrapper for SharedPreferences to enable
/// dependency injection and easier testing.
library;

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Abstract interface for persistent storage operations.
///
/// This abstraction allows for:
/// - Easy mocking in unit tests
/// - Swapping implementations (e.g., secure storage)
/// - Centralized storage access
abstract class IStorageService {
  /// Initialize the storage service.
  Future<void> init();

  /// Save a string value.
  Future<bool> saveString(String key, String value);

  /// Get a string value.
  Future<String?> getString(String key);

  /// Save a boolean value.
  Future<bool> saveBool(String key, bool value);

  /// Get a boolean value.
  Future<bool?> getBool(String key);

  /// Save an integer value.
  Future<bool> saveInt(String key, int value);

  /// Get an integer value.
  Future<int?> getInt(String key);

  /// Remove a value by key.
  Future<bool> remove(String key);

  /// Clear all stored values.
  Future<void> clear();

  /// Check if a key exists.
  Future<bool> containsKey(String key);
}

/// SharedPreferences implementation of [IStorageService].
///
/// Provides persistent local storage using SharedPreferences.
class StorageService implements IStorageService {
  StorageService._();

  static final StorageService _instance = StorageService._();

  /// Factory constructor returns singleton instance.
  factory StorageService() => _instance;

  SharedPreferences? _prefs;

  /// Whether the service has been initialized.
  bool get isInitialized => _prefs != null;

  @override
  Future<void> init() async {
    if (_prefs != null) return;

    try {
      _prefs = await SharedPreferences.getInstance();
      debugPrint('StorageService: Initialized successfully');
    } catch (e) {
      debugPrint('StorageService: Initialization failed - $e');
      rethrow;
    }
  }

  /// Ensures preferences is initialized before access.
  Future<SharedPreferences> get _preferences async {
    if (_prefs == null) {
      await init();
    }
    return _prefs!;
  }

  @override
  Future<bool> saveString(String key, String value) async {
    try {
      final prefs = await _preferences;
      return await prefs.setString(key, value);
    } catch (e) {
      debugPrint('StorageService: Error saving string "$key" - $e');
      return false;
    }
  }

  @override
  Future<String?> getString(String key) async {
    try {
      final prefs = await _preferences;
      return prefs.getString(key);
    } catch (e) {
      debugPrint('StorageService: Error getting string "$key" - $e');
      return null;
    }
  }

  @override
  Future<bool> saveBool(String key, bool value) async {
    try {
      final prefs = await _preferences;
      return await prefs.setBool(key, value);
    } catch (e) {
      debugPrint('StorageService: Error saving bool "$key" - $e');
      return false;
    }
  }

  @override
  Future<bool?> getBool(String key) async {
    try {
      final prefs = await _preferences;
      return prefs.getBool(key);
    } catch (e) {
      debugPrint('StorageService: Error getting bool "$key" - $e');
      return null;
    }
  }

  @override
  Future<bool> saveInt(String key, int value) async {
    try {
      final prefs = await _preferences;
      return await prefs.setInt(key, value);
    } catch (e) {
      debugPrint('StorageService: Error saving int "$key" - $e');
      return false;
    }
  }

  @override
  Future<int?> getInt(String key) async {
    try {
      final prefs = await _preferences;
      return prefs.getInt(key);
    } catch (e) {
      debugPrint('StorageService: Error getting int "$key" - $e');
      return null;
    }
  }

  @override
  Future<bool> remove(String key) async {
    try {
      final prefs = await _preferences;
      return await prefs.remove(key);
    } catch (e) {
      debugPrint('StorageService: Error removing "$key" - $e');
      return false;
    }
  }

  @override
  Future<void> clear() async {
    try {
      final prefs = await _preferences;
      await prefs.clear();
      debugPrint('StorageService: Cleared all data');
    } catch (e) {
      debugPrint('StorageService: Error clearing storage - $e');
    }
  }

  @override
  Future<bool> containsKey(String key) async {
    try {
      final prefs = await _preferences;
      return prefs.containsKey(key);
    } catch (e) {
      debugPrint('StorageService: Error checking key "$key" - $e');
      return false;
    }
  }
}
