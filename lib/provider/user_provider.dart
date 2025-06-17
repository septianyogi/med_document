import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:med_document/config/app_session.dart';

import '../model/user_model.dart';

class UserNotifier extends StateNotifier<AsyncValue<UserModel>> {
  UserNotifier() : super(const AsyncValue.loading());

  Future<void> getUser() async {
    try {
      final user = await AppSession.getUser();
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
    String rm,
    String name,
    String sex,
    String dob,
    String address,
  ) async {
    try {
      UserModel user = UserModel(
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
    String rm,
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
