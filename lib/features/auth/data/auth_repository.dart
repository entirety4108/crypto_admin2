import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../shared/services/supabase_service.dart';

/// Authentication repository
class AuthRepository {
  final _auth = SupabaseService.auth;

  /// Sign in with email and password
  Future<AuthResponse> signInWithEmail({
    required String email,
    required String password,
  }) async {
    return await _auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  /// Sign up with email and password
  Future<AuthResponse> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    return await _auth.signUp(
      email: email,
      password: password,
    );
  }

  /// Send password reset email
  Future<void> resetPassword({required String email}) async {
    await _auth.resetPasswordForEmail(email);
  }

  /// Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// Get current user
  User? get currentUser => _auth.currentUser;

  /// Auth state stream
  Stream<AuthState> get authStateChanges => _auth.onAuthStateChange;
}
