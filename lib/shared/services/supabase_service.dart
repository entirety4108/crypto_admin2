import 'package:supabase_flutter/supabase_flutter.dart';

/// Supabase service singleton
class SupabaseService {
  static SupabaseClient get client => Supabase.instance.client;

  static GoTrueClient get auth => client.auth;

  static User? get currentUser => auth.currentUser;

  static bool get isAuthenticated => currentUser != null;

  static Stream<AuthState> get authStateChanges => auth.onAuthStateChange;

  SupabaseService._();
}
