import 'package:supabase_flutter/supabase_flutter.dart';

/// Authentication state
sealed class AuthState {
  const AuthState();
}

/// Initial state (checking auth)
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// Loading state
class AuthLoading extends AuthState {
  const AuthLoading();
}

/// Authenticated state
class AuthAuthenticated extends AuthState {
  final User user;

  const AuthAuthenticated(this.user);
}

/// Unauthenticated state
class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

/// Error state
class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);
}
