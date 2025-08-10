import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:med_document/config/app_session.dart';
import '../model/user_model.dart';

class UserNotifier extends StateNotifier<AsyncValue<UserModel?>> {
  UserNotifier() : super(const AsyncValue.loading());

  Future<void> getUser() async {
    try {
      final user = await AppSession.getUser();
      state = AsyncValue.data(user);
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
      await AppSession.setUser(user);
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
        id: '1',
        rm: rm,
        name: name,
        sex: sex,
        dob: dob,
        address: address,
      );
      await AppSession.setUser(updatedUser);
      state = AsyncValue.data(updatedUser);
    } catch (e) {
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
  }
}

final userProvider =
    StateNotifierProvider<UserNotifier, AsyncValue<UserModel?>>(
      (ref) => UserNotifier()..getUser(),
    );
