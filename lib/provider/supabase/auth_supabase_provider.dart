import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../datasource/supabase/auth_supabase.dart';

class AuthSupabaseNotifier extends StateNotifier<AsyncValue<void>> {
  AuthSupabaseNotifier() : super(const AsyncLoading());

  final AuthSupabase _authSupabase = AuthSupabase();

  Future<bool> signUp(
    String username,
    String rm,
    String sex,
    String email,
    String password,
  ) async {
    try {
      if (!mounted) return false;
      final response = await _authSupabase.signUp(
        username,
        rm,
        sex,
        email,
        password,
      );
      bool success = false;
      response.fold(
        (failure) {
          state = AsyncError(
            failure.message ?? 'Unknown error',
            StackTrace.current,
          );
        },
        (result) {
          if (result.session != null) {
            print(
              'Session created successfully Access Token: ${result.session?.accessToken}',
            );
            success = true;
          } else {
            print('No session created');
          }
        },
      );
      return success;
    } catch (e) {
      print('Error signing up: $e');
      state = AsyncValue.error(e.toString(), StackTrace.current);
      return false;
    }
  }

  Future<bool> signOut() async {
    try {
      if (!mounted) return false;
      final response = await _authSupabase.signOut();
      bool success = false;
      response.fold(
        (failure) {
          state = AsyncError(
            failure.message ?? 'Unknown error',
            StackTrace.current,
          );
          success = false;
        },
        (result) {
          print('User signed out successfully');
          state = const AsyncData(true);
          success = true;
        },
      );
      return success;
    } catch (e) {
      print('Error signing out: $e');
      state = AsyncValue.error(e.toString(), StackTrace.current);
      return false;
    }
  }

  Future<bool> signIn(String email, String password) async {
    try {
      if (!mounted) return false;
      final response = await _authSupabase.signIn(email, password);
      bool success = false;
      response.fold(
        (failure) {
          state = AsyncError(
            failure.message ?? 'Unknown error',
            StackTrace.current,
          );
          success = false;
        },
        (result) {
          if (result.session != null) {
            print(
              'Session created successfully Access Token: ${result.session?.accessToken}',
            );
            success = true;
          } else {
            print('No session created');
          }
        },
      );
      return success;
    } catch (e) {
      print('Error signing in: $e');
      state = AsyncValue.error(e.toString(), StackTrace.current);
      return false;
    }
  }
}

final authSupabaseProvider =
    StateNotifierProvider<AuthSupabaseNotifier, AsyncValue<void>>(
      (ref) => AuthSupabaseNotifier(),
    );
