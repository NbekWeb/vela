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
  String? _storedRitualId;

  // Generated data storage
  Map<String, dynamic>? _generatedData;

  // My meditations storage
  List<Map<String, dynamic>>? _myMeditations;

  // File URL storage
  String? _fileUrl;

  // Archive meditation storage (for restored meditations)
  List<Map<String, dynamic>>? _archiveMeditation;

  // Library meditation storage
  List<Map<String, dynamic>>? _libraryDatas;

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
  String? get storedRitualId => _storedRitualId;

  // Generated data getter
  Map<String, dynamic>? get generatedData => _generatedData;

  // My meditations getter
  List<Map<String, dynamic>>? get myMeditations => _myMeditations;

  // File URL getter
  String? get fileUrl => _fileUrl;

  // Archive meditation getter (for restored meditations)
  List<Map<String, dynamic>>? get archiveMeditation => _archiveMeditation;

  // Library meditation getter
  List<Map<String, dynamic>>? get libraryDatas => _libraryDatas;

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

  void setFileUrl(String? fileUrl) {
    _fileUrl = fileUrl;
    notifyListeners();
  }

  void setArchiveMeditation(List<Map<String, dynamic>>? meditation) {
    _archiveMeditation = meditation;
    notifyListeners();
  }

  void setLibraryDatas(List<Map<String, dynamic>>? libraryData) {
    _libraryDatas = libraryData;
    notifyListeners();
  }

  // Ritual settings storage methods
  Future<void> saveRitualSettings({
    required String ritualType,
    required String tone,
    required String duration,
    required int planType,
    String? fileUrl,
    String? ritualId,
  }) async {
    try {
      await _secureStorage.write(key: 'ritual_type', value: ritualType);
      await _secureStorage.write(key: 'tone', value: tone);
      await _secureStorage.write(key: 'duration', value: duration);
      await _secureStorage.write(key: 'plan_type', value: planType.toString());
      if (fileUrl != null) {
        await _secureStorage.write(key: 'file', value: fileUrl);
      }
      if (ritualId != null) {
        await _secureStorage.write(key: 'ritual_id', value: ritualId);
      }

      _storedRitualType = ritualType;
      _storedTone = tone;
      _storedDuration = duration;
      _storedPlanType = planType;
      _storedRitualId = ritualId;
      if (fileUrl != null) {
        _fileUrl = fileUrl;
      }

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
      _storedRitualId = await _secureStorage.read(key: 'ritual_id');
      _fileUrl = await _secureStorage.read(key: 'file');

      notifyListeners();
    } catch (e) {
      // Error handling without logging
    }
  }

  Future<void> clearRitualSettings() async {
    try {
      // await _secureStorage.delete(key: 'ritual_type');
      await _secureStorage.delete(key: 'tone');
      await _secureStorage.delete(key: 'duration');
      await _secureStorage.delete(key: 'plan_type');
      await _secureStorage.delete(key: 'ritual_id');

      _storedRitualType = null;
      _storedTone = null;
      _storedDuration = null;
      _storedPlanType = null;
      _storedRitualId = null;

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

  // Fetch meditation library
  Future<void> fetchMeditationLibrary() async {
    setLoading(true);
    setError(null);

    try {
      final response = await ApiService.request(
        url: 'auth/meditation-library/',
        method: 'GET',
      );
      print('🔍 Meditation Library Response: ${response.data}');

      _handleMeditationLibraryResponse(response.data);
    } catch (e) {
      _handleMeditationLibraryError();
    } finally {
      setLoading(false);
    }
  }

  // Helper method to map ritual type name to ID
  String _mapRitualTypeNameToId(String ritualTypeName) {
    final firstWord = ritualTypeName.split(' ').first.toLowerCase();
    
    switch (firstWord) {
      case 'sleep':
        return '1';
      case 'morning':
        return '2';
      case 'calming':
        return '3';
      case 'dream':
        return '4';
      default:
        return '1'; // Default to Sleep Manifestation
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
    print('🔍 postCombinedProfile called');
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
        "description": description,
        "ritual_type": ritualType,
        "tone": tone,
        "voice": voice.isNotEmpty ? voice : 'male',
        "duration": duration.isNotEmpty ? duration : '2',
      };

      final response = await ApiService.request(
        url: 'auth/meditation/external/',
        method: 'POST',
        data: data,
      );

      // Handle external meditation response
      final responseData = response.data;
      
      if (responseData != null && responseData['success'] == true) {
        final fileUrl = responseData['file_url'] ?? responseData['file'];
        final ritualTypeName = responseData['ritual_type_name'];
        
        // Map ritual type name back to ID
        final mappedRitualType = ritualTypeName != null 
            ? _mapRitualTypeNameToId(ritualTypeName)
            : ritualType;
        
        if (fileUrl != null && fileUrl.isNotEmpty) {
          setFileUrl(fileUrl);
          
          // Save ritual settings including file URL with mapped ritual type
          await saveRitualSettings(
            ritualType: mappedRitualType,
            tone: tone,
            duration: duration,
            planType: planType ?? 1,
            fileUrl: fileUrl,
            ritualId: mappedRitualType, // Save ritual ID as well
          );
        }
        
        // Create a basic meditation profile from the response data
        final profileData = {
          'id': responseData['meditation_id'],
          'file': fileUrl,
          'plan_type': 1, // Use default plan type since external API returns string
          'description': responseData['message'],
          'ritual_type': [mappedRitualType],
          'tone': [tone],
          'voice': [voice.isNotEmpty ? voice : 'male'],
          'duration': [duration.isNotEmpty ? duration : '2'],
        };
        
        try {
          final profile = MeditationProfileData.fromJson(profileData);
          setMeditationProfile(profile);
        } catch (e) {
          // Continue without setting profile if parsing fails
        }
      }
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

  // Private method to handle meditation library response
  void _handleMeditationLibraryResponse(dynamic response) {
    final responseData = response;
    print('🔍 Processing library response data: $responseData');
    print('🔍 Response data type: ${responseData.runtimeType}');
    
    if (responseData != null && responseData is List) {
      print('🔍 Response is List, length: ${responseData.length}');
      final libraryData = responseData.cast<Map<String, dynamic>>();
      setLibraryDatas(libraryData);
      print('🔍 Set library data: ${libraryData.length} items');
    } else if (responseData != null && responseData['results'] != null) {
      // Handle paginated response
      final results = responseData['results'] as List;
      final libraryData = results.cast<Map<String, dynamic>>();
      setLibraryDatas(libraryData);
    } else {
      print('🔍 No valid data found, setting empty list');
      setLibraryDatas([]);
    }
  }

  // Private method to handle meditation library error
  void _handleMeditationLibraryError() {
    setLibraryDatas(null);
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
    _libraryDatas = null;
    _storedRitualType = null;
    _storedTone = null;
    _storedDuration = null;
    _storedPlanType = null;
    _storedRitualId = null;
  }
}