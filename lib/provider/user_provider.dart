import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:med_document/config/app_session.dart';
import 'package:med_document/dbHelper/db_helper.dart';

import '../model/user_model.dart';

class UserNotifier extends StateNotifier<AsyncValue<UserModel>> {
  UserNotifier() : super(const AsyncValue.loading());

  DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  Future<void> getUser() async {
    try {
      final users = await _databaseHelper.getUsers();
      final UserModel user = users.first;
      if (user != null) {
        state = AsyncValue.data(user);
      } else {
        state = AsyncValue.error('User not found', StackTrace.current);
      }
    } catch (e) {
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
  }

  Future<void> setUser(
    int rm,
    String name,
    String sex,
    String dob,
    String address,
  ) async {
    try {
      UserModel user = UserModel(
        id: '1',
        rm: rm,
        name: name,
        sex: sex,
        dob: dob,
        address: address,
      );
      AppSession.setUser(user.toJson());
      state = AsyncValue.data(user);
    } catch (e) {
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
  }

  Future<void> updateUser(
    int rm,
    String name,
    String sex,
    String dob,
    String address,
  ) async {
    try {
      UserModel updatedUser = UserModel(
        rm: rm,
        name: name,
        sex: sex,
        dob: dob,
        address: address,
      );
      AppSession.setUser(updatedUser.toJson());
      state = AsyncValue.data(updatedUser);
    } catch (e) {
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
  }
}

final userProvider = StateNotifierProvider<UserNotifier, AsyncValue<UserModel>>(
  (ref) => UserNotifier()..getUser(),
);
