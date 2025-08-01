import 'package:flutter/material.dart';
import 'dart:developer' as developer;
import '../services/api_service.dart';
import '../../shared/models/meditation_profile_data.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Meditation store for handling meditation profile data and related functionality
class MeditationStore extends ChangeNotifier {
  MeditationProfileData? _meditationProfile;
  bool _isLoading = false;
  String? _error;

  // Ritual settings storage
  String? _storedRitualType;
  String? _storedTone;
  String? _storedDuration;
  int? _storedPlanType;

  // Generated data storage
  Map<String, dynamic>? _generatedData;

  // My meditations storage
  List<Map<String, dynamic>>? _myMeditations;

  // Archive meditation storage (for restored meditations)
  List<Map<String, dynamic>>? _archiveMeditation;

  // Services
  static final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  // Getters
  MeditationProfileData? get meditationProfile => _meditationProfile;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Ritual settings getters
  String? get storedRitualType => _storedRitualType;
  String? get storedTone => _storedTone;
  String? get storedDuration => _storedDuration;
  int? get storedPlanType => _storedPlanType;

  // Generated data getter
  Map<String, dynamic>? get generatedData => _generatedData;

  // My meditations getter
  List<Map<String, dynamic>>? get myMeditations => _myMeditations;

  // Archive meditation getter (for restored meditations)
  List<Map<String, dynamic>>? get archiveMeditation => _archiveMeditation;

  // Actions
  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setError(String? error) {
    _error = error;
    notifyListeners();
  }

  void setMeditationProfile(MeditationProfileData? profile) {
    _meditationProfile = profile;
    notifyListeners();

    resetToDefault();
  }

  void setGeneratedData(Map<String, dynamic>? data) {
    _generatedData = data;
    notifyListeners();
  }

  void setMyMeditations(List<Map<String, dynamic>>? meditations) {
    _myMeditations = meditations;
    notifyListeners();
  }

  void setArchiveMeditation(List<Map<String, dynamic>>? meditation) {
    _archiveMeditation = meditation;
    notifyListeners();
  }

  // Ritual settings storage methods
  Future<void> saveRitualSettings({
    required String ritualType,
    required String tone,
    required String duration,
    required int planType,
  }) async {
    try {
      await _secureStorage.write(key: 'ritual_type', value: ritualType);
      await _secureStorage.write(key: 'tone', value: tone);
      await _secureStorage.write(key: 'duration', value: duration);
      await _secureStorage.write(key: 'plan_type', value: planType.toString());

      _storedRitualType = ritualType;
      _storedTone = tone;
      _storedDuration = duration;
      _storedPlanType = planType;

      notifyListeners();
    } catch (e) {
      // Error handling without logging
    }
  }

  Future<void> loadRitualSettings() async {
    try {
      _storedRitualType = await _secureStorage.read(key: 'ritual_type');
      _storedTone = await _secureStorage.read(key: 'tone');
      _storedDuration = await _secureStorage.read(key: 'duration');
      final planTypeStr = await _secureStorage.read(key: 'plan_type');
      _storedPlanType = planTypeStr != null ? int.tryParse(planTypeStr) : null;

      notifyListeners();
    } catch (e) {
      // Error handling without logging
    }
  }

  Future<void> clearRitualSettings() async {
    try {
      await _secureStorage.delete(key: 'ritual_type');
      await _secureStorage.delete(key: 'tone');
      await _secureStorage.delete(key: 'duration');
      await _secureStorage.delete(key: 'plan_type');

      _storedRitualType = null;
      _storedTone = null;
      _storedDuration = null;
      _storedPlanType = null;

      notifyListeners();
    } catch (e) {}
  }

  // Initialize store
  Future<void> initialize() async {
    try {
      // Load ritual settings from storage
      await loadRitualSettings();
    } catch (e) {}
  }

  // Fetch my meditations from API
  Future<void> fetchMyMeditations() async {
    setLoading(true);
    setError(null);

    try {
      final response = await ApiService.request(
        url: 'auth/my-meditations/',
        method: 'GET',
      );

      _handleMyMeditationsResponse(response);
    } catch (e) {
      _handleMyMeditationsError();
    } finally {
      setLoading(false);
    }
  }

  // Restore meditation from archive
  Future<void> restoreMeditation() async {
    setLoading(true);
    setError(null);

    try {
      final response = await ApiService.request(
        url: 'auth/restore-meditation/',
        method: 'GET',
      );

      _handleRestoreMeditationResponse(response);
    } catch (e) {
      _handleRestoreMeditationError();
    } finally {
      setLoading(false);
    }
  }

  // Post combined profile and save to store
  Future<void> postCombinedProfile({
    required String gender,
    required String dream,
    required String goals,
    required String ageRange,
    required String happiness,
    String? name,
    String? description,
    required String ritualType,
    required String tone,
    required String voice,
    required String duration,
    int? planType,
  }) async {
    setLoading(true);
    setError(null);

    try {
      final data = {
        "plan_type": planType ?? 1,
        "gender": gender.toLowerCase(),
        "dream": dream,
        "goals": goals,
        "age_range": ageRange.split('-').last.trim(),
        "happiness": happiness,
        "name": name,
        "description": description,
        "ritual_type": ritualType,
        "tone": tone,
        "voice": voice.isNotEmpty ? voice : 'male',
        "duration": duration.isNotEmpty ? duration : '2',
      };

      final response = await ApiService.request(
        url: 'auth/meditation/combined/',
        method: 'POST',
        data: data,
      );

      // Save meditation profile to store
      final profileData = response.data;
      if (profileData != null) {
        final profile = MeditationProfileData.fromJson(profileData);
        setMeditationProfile(profile);
      }
      print('🔍 Response is null: $profileData');
    } catch (e) {
    } finally {
      setLoading(false);
    }
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Private method to handle my meditations response
  void _handleMyMeditationsResponse(dynamic response) {
    final responseData = response.data;
    if (responseData != null && responseData is List) {
      final meditations = responseData.cast<Map<String, dynamic>>();
      setMyMeditations(meditations);
    } else if (responseData != null && responseData['results'] != null) {
      // Handle paginated response
      final results = responseData['results'] as List;
      final meditations = results.cast<Map<String, dynamic>>();
      setMyMeditations(meditations);
    } else {
      setMyMeditations([]);
    }
  }

  // Private method to handle my meditations error
  void _handleMyMeditationsError() {
    setMyMeditations(null);
  }

  // Private method to handle restore meditation response
  void _handleRestoreMeditationResponse(dynamic response) {
    final responseData = response.data;
    print('🔍 RestoreMeditation Response: $responseData');
    print('🔍 Response Type: ${responseData.runtimeType}');

    if (responseData != null) {
      if (responseData is List) {
        print('🔍 Response is List, length: ${responseData.length}');
        final meditations = responseData.cast<Map<String, dynamic>>();
        setArchiveMeditation(meditations);
      } else {
        print('🔍 Response is not List, setting as single item');
        setArchiveMeditation([responseData as Map<String, dynamic>]);
      }
    } else {
      print('🔍 Response is null');
      setArchiveMeditation(null);
    }
  }

  // Private method to handle restore meditation error
  void _handleRestoreMeditationError() {
    setArchiveMeditation(null);
  }

  // Reset store to default state (keeps profile)
  void resetToDefault() {
    _resetStateVariables();
    notifyListeners();
  }

  // Complete reset - clears everything including profile
  void completeReset() {
    _meditationProfile = null;
    _resetStateVariables();
    notifyListeners();
  }

  // Private method to reset state variables (reduces code duplication)
  void _resetStateVariables() {
    _isLoading = false;
    _error = null;
    _generatedData = null;
    _myMeditations = null;
    _archiveMeditation = null;
    _storedRitualType = null;
    _storedTone = null;
    _storedDuration = null;
    _storedPlanType = null;
  }
}
