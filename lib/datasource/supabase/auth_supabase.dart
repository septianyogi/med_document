import 'package:dartz/dartz.dart';
import 'package:med_document/model/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../config/failure.dart';

class AuthSupabase {
  final supabase = Supabase.instance.client;

  Future<Either<Failure, UserModel>> getUser(String id) async {
    try {
      final user =
          await supabase.from('users').select().eq('id', id).maybeSingle();
      if (user == null) {
        return left(FetchFailure('User Not Found'));
      }

      return right(UserModel.fromJson(user));
    } catch (e) {
      print(e.toString());
      return left(FetchFailure(e.toString()));
    }
  }

  Future<Either<Failure, AuthResponse>> signUp(
    String username,
    String rm,
    String sex,
    String email,
    String password,
  ) async {
    try {
      final AuthResponse response = await supabase.auth.signUp(
        email: email,
        password: password,
      );
      final Session? session = response.session;
      final User? user = response.user;

      if (user != null) {
        await supabase.from('users').insert({
          'id': user.id,
          'rm': rm,
          'name': username,
          'sex': sex,
        });
      }
      print('Response: $response');
      if (session != null) {
        print('Session created successfully: ${session.accessToken}');
      } else {
        print('No session created');
      }
      return right(response);
    } on AuthException catch (e) {
      print('Error signing up: ${e.message}');
      return Left(FetchFailure(e.message));
    } catch (e) {
      print('Error adding control: $e');
      if (e is Failure) {
        return left(e);
      } else {
        return left(FetchFailure(e.toString()));
      }
    }
  }

  Future<Either<Failure, bool>> signOut() async {
    try {
      await supabase.auth.signOut();
      print('User signed out successfully');
      return const Right(true);
    } on AuthException catch (e) {
      print('Error signing out: ${e.message}');
      return Left(FetchFailure(e.message));
    } catch (e) {
      print('Error adding control: $e');
      if (e is Failure) {
        return left(e);
      } else {
        return left(FetchFailure(e.toString()));
      }
    }
  }

  Future<Either<Failure, AuthResponse>> signIn(
    String email,
    String password,
  ) async {
    try {
      final AuthResponse response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      final Session? session = response.session;
      final User? user = response.user;
      print('Response: $response');
      if (session != null) {
        print('Session created successfully: ${session.accessToken}');
      } else {
        print('No session created');
      }
      return right(response);
    } on AuthException catch (e) {
      print('Error signing In: ${e.message}');
      return Left(FetchFailure(e.message));
    } catch (e) {
      print('Error adding control: $e');
      if (e is Failure) {
        return left(e);
      } else {
        return left(FetchFailure(e.toString()));
      }
    }
  }
}
