import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;
import '../../data/auth_repository.dart';
import '../../domain/auth_state.dart';

/// Auth repository provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

/// Auth state notifier provider
final authStateProvider = StateNotifierProvider<AuthStateNotifier, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthStateNotifier(repository);
});

/// Auth state notifier
class AuthStateNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;
  StreamSubscription<sb.AuthState>? _authSubscription;

  AuthStateNotifier(this._repository) : super(const AuthInitial()) {
    _init();
  }

  void _init() {
    // Check initial auth state
    final user = _repository.currentUser;
    if (user != null) {
      state = AuthAuthenticated(user);
    } else {
      state = const AuthUnauthenticated();
    }

    // Listen to auth state changes
    _authSubscription = _repository.authStateChanges.listen((authState) {
      final user = authState.session?.user;
      if (user != null) {
        state = AuthAuthenticated(user);
      } else {
        state = const AuthUnauthenticated();
      }
    });
  }

  /// Sign in with email and password
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    state = const AuthLoading();
    try {
      await _repository.signInWithEmail(
        email: email,
        password: password,
      );
      // State will be updated by auth state listener
    } on sb.AuthException catch (e) {
      state = AuthError(e.message);
    } catch (e) {
      state = AuthError(e.toString());
    }
  }

  /// Sign up with email and password
  Future<void> signUp({
    required String email,
    required String password,
  }) async {
    state = const AuthLoading();
    try {
      await _repository.signUpWithEmail(
        email: email,
        password: password,
      );
      // State will be updated by auth state listener
    } on sb.AuthException catch (e) {
      state = AuthError(e.message);
    } catch (e) {
      state = AuthError(e.toString());
    }
  }

  /// Send password reset email
  Future<bool> resetPassword({required String email}) async {
    try {
      await _repository.resetPassword(email: email);
      return true;
    } catch (e) {
      state = AuthError(e.toString());
      return false;
    }
  }

  /// Sign out
  Future<void> signOut() async {
    await _repository.signOut();
    // State will be updated by auth state listener
  }

  /// Clear error state
  void clearError() {
    if (state is AuthError) {
      state = const AuthUnauthenticated();
    }
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}
