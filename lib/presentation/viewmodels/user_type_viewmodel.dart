/// MSME Pathways - User Type ViewModel
/// 
/// State management for user type selection screen.
library;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/user_type_model.dart';

/// ViewModel for managing user type selection state.
/// 
/// Handles:
/// - User type selection
/// - Persistence of selection
/// - Navigation flow control
class UserTypeViewModel extends ChangeNotifier {
  /// Creates the user type viewmodel.
  UserTypeViewModel() {
    _loadSavedSelection();
  }

  /// Currently selected user type.
  UserType? _selectedType;
  
  /// Loading state for async operations.
  bool _isLoading = false;
  
  /// Error message if something goes wrong.
  String? _error;

  /// Available user type options.
  final List<UserTypeModel> options = [
    UserTypeModel.fromType(UserType.individual),
    UserTypeModel.fromType(UserType.business),
  ];

  /// Gets the currently selected user type.
  UserType? get selectedType => _selectedType;
  
  /// Gets the loading state.
  bool get isLoading => _isLoading;
  
  /// Gets any error message.
  String? get error => _error;
  
  /// Checks if user can proceed (has made a selection).
  bool get canContinue => _selectedType != null && !_isLoading;

  /// Selects a user type.
  void selectType(UserType type) {
    if (_selectedType == type) return;
    
    _selectedType = type;
    _error = null;
    notifyListeners();
  }

  /// Clears the current selection.
  void clearSelection() {
    _selectedType = null;
    notifyListeners();
  }

  /// Loads any previously saved selection.
  Future<void> _loadSavedSelection() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedType = prefs.getString('user_type');
      
      if (savedType != null) {
        _selectedType = UserType.values.firstWhere(
          (t) => t.name == savedType,
          orElse: () => UserType.individual,
        );
        notifyListeners();
      }
    } catch (e) {
      // Ignore load errors - user can just select again
      debugPrint('Error loading user type: $e');
    }
  }

  /// Saves the selection and returns success status.
  Future<bool> saveAndContinue() async {
    if (_selectedType == null) return false;
    
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_type', _selectedType!.name);
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _error = 'Failed to save selection. Please try again.';
      notifyListeners();
      return false;
    }
  }

  /// Static method to get the saved user type without ViewModel.
  static Future<UserType?> getSavedUserType() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedType = prefs.getString('user_type');
      
      if (savedType != null) {
        return UserType.values.firstWhere(
          (t) => t.name == savedType,
          orElse: () => UserType.individual,
        );
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
