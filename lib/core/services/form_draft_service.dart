// MSME Pathways - Form Draft Service
//
// Service used to persist form progress locally for offline capability.
// Handles auto-saving and restoring of partial form data.

import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../../data/models/eligibility_model.dart';
import 'storage_service.dart';

class FormDraftService {
  final IStorageService _storageService;
  static const String _eligibilityKey = 'draft_eligibility_form';

  FormDraftService(this._storageService);

  /// Saves the current state of eligibility answers.
  Future<void> saveEligibilityDraft(EligibilityAnswers answers) async {
    try {
      final jsonString = jsonEncode(answers.toJson());
      await _storageService.saveString(_eligibilityKey, jsonString);
      debugPrint('FormDraftService: Saved eligibility draft');
    } catch (e) {
      debugPrint('FormDraftService: Error saving eligibility draft - $e');
    }
  }

  /// Retrieves the saved eligibility draft if available.
  Future<EligibilityAnswers?> getEligibilityDraft() async {
    try {
      final jsonString = await _storageService.getString(_eligibilityKey);
      if (jsonString == null) return null;
      
      final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
      debugPrint('FormDraftService: Loaded eligibility draft');
      return EligibilityAnswers.fromJson(jsonMap);
    } catch (e) {
      debugPrint('FormDraftService: Error loading eligibility draft - $e');
      return null;
    }
  }

  /// Clears the saved eligibility draft.
  Future<void> clearEligibilityDraft() async {
    await _storageService.remove(_eligibilityKey);
    debugPrint('FormDraftService: Cleared eligibility draft');
  }
}
