import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:med_document/dbHelper/db_helper.dart';

import '../../config/failure.dart';
import '../../datasource/supabase/auth_supabase.dart';

class AuthSupabaseNotifier extends StateNotifier<AsyncValue<void>> {
  AuthSupabaseNotifier() : super(const AsyncLoading());

  final AuthSupabase _authSupabase = AuthSupabase();
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

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

      final loginResult = await _authSupabase.signIn(email, password);

      // Kalau login gagal
      if (loginResult.isLeft()) {
        final failure = loginResult.swap().getOrElse(
          () => FetchFailure('Unknown error'),
        );
        state = AsyncError(
          failure.message ?? 'Unknown error',
          StackTrace.current,
        );
        return false;
      }

      final session = loginResult.getOrElse(
        () => throw Exception('No session'),
      );
      if (session.session == null) {
        print('⚠️ No session created');
        return false;
      }

      print('✅ Session created. Access Token: ${session.session?.accessToken}');

      // Ambil user dari Supabase
      final userResult = await _authSupabase.getUser(session.user!.id);

      if (userResult.isRight()) {
        final user = userResult.getOrElse(
          () => throw Exception('User not found'),
        );
        try {
          await _databaseHelper.insertUser(user);
          print('✅ User inserted/updated: ${user.id}');
          print('✅ User stored locally: ${user.id}');
        } catch (e) {
          print('⚠️ Insert to SQLite failed: $e');
        }
      } else {
        print(
          '⚠️ Failed to get user data: ${userResult.swap().getOrElse(() => FetchFailure("Unknown")).message}',
        );
      }

      // Kalau sampai sini, login dianggap sukses
      state = AsyncValue.data(true);
      return true;
    } catch (e) {
      print('❌ Error signing in: $e');
      state = AsyncValue.error(e.toString(), StackTrace.current);
      return false;
    }
  }
}

final authSupabaseProvider =
    StateNotifierProvider<AuthSupabaseNotifier, AsyncValue<void>>(
      (ref) => AuthSupabaseNotifier(),
    );
