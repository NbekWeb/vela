import 'package:google_sign_in/google_sign_in.dart';

class GoogleUserData {
  final String id;
  final String email;
  final String displayName;
  final String? photoUrl;
  final String? accessToken;
  final String? idToken;

  GoogleUserData({
    required this.id,
    required this.email,
    required this.displayName,
    this.photoUrl,
    this.accessToken,
    this.idToken,
  });
}

class UserData {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String? photoUrl;

  UserData({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.photoUrl,
  });
}

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  // Simulated user storage (in real app, this would be a database)
  static final Map<String, UserData> _users = {};

  Future<GoogleUserData?> signInWithGoogle() async {
    try {
      print('🔍 Starting Google Sign-In...');
      
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        print('❌ User cancelled Google Sign-In');
        return null;
      }

      print('✅ Google Sign-In successful!');
      print('🆔 User ID: ${googleUser.id}');
      
      // Get authentication data
      GoogleSignInAuthentication? auth;
      try {
        auth = await googleUser.authentication;
        print('🔑 Access Token: ${auth.accessToken}');
        print('🆔 ID Token: ${auth.idToken}');
      } catch (authError) {
        print('❌ Error getting tokens: $authError');
      }
      
      return GoogleUserData(
        id: googleUser.id,
        email: googleUser.email,
        displayName: googleUser.displayName ?? 'Unknown',
        photoUrl: googleUser.photoUrl,
        accessToken: auth?.accessToken,
        idToken: auth?.idToken,
      );
    } catch (e) {
      print('❌ Google Sign-In error: $e');
      return null;
    }
  }

  Future<UserData?> registerWithEmail({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    try {
      // Check if user already exists
      if (_users.containsKey(email)) {
        throw Exception('This email is already registered');
      }

      // Simulate API delay
      await Future.delayed(const Duration(seconds: 1));

      // Create new user
      final userData = UserData(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        email: email,
        firstName: firstName,
        lastName: lastName,
      );

      // Store user (in real app, this would be saved to database)
      _users[email] = userData;

      print('✅ User registered successfully: $email');
      return userData;
    } catch (e) {
      print('❌ Registration error: $e');
      rethrow;
    }
  }

  Future<UserData?> loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      // Simulate API delay for testing
      await Future.delayed(const Duration(seconds: 1));

      // Simple email check: must contain @ and be gmail
      if (!email.contains('@') || !email.contains('gmail.com')) {
        throw Exception('Please enter a valid Gmail address');
      }

      // Extract name from email (before @ symbol)
      String name = email.split('@')[0];
      String firstName = name.isNotEmpty ? name[0].toUpperCase() + name.substring(1) : 'User';
      String lastName = 'User';
      
      // Create or get user data
      UserData userData = UserData(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        email: email,
        firstName: firstName,
        lastName: lastName,
      );
      
      // Store the user for future logins
      _users[email] = userData;
      
      print('✅ Test login successful: $email');
      return userData;
    } catch (e) {
      print('❌ Login error: $e');
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await _googleSignIn.signOut();
      print('👋 Google Sign-Out successful!');
    } catch (e) {
      print('❌ Google Sign-Out error: $e');
    }
  }
} 