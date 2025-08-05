import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../datasource/supabase/control_supabase.dart';
import '../../model/control_model.dart';

class ControlSupabaseNotifier
    extends StateNotifier<AsyncValue<List<ControlModel>>> {
  ControlSupabaseNotifier() : super(const AsyncLoading());

  final ControlSupabase _controlSupabase = ControlSupabase();

  Future<void> insertControl(
    String uuId,
    String? doctorName,
    String? title,
    String? date,
    String? time,
    String? description,
    bool rujuk,
    String? appointment,
  ) async {
    try {
      if (!mounted) return;
      final control = await _controlSupabase.insertControl(
        uuId,
        doctorName ?? '',
        title ?? '',
        date ?? '',
        time ?? '',
        description ?? '',
        rujuk,
        appointment ?? '',
      );
      control.fold(
        (failure) {
          return state = AsyncError(
            failure.message ?? 'Unknown error',
            StackTrace.current,
          );
        },
        (result) {
          print('Control added successfully');
          return state = const AsyncData([]);
        },
      );
    } catch (e) {
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
  }

  Future<void> deleteControl(String uuId) async {
    try {
      if (!mounted) return;
      final control = await _controlSupabase.deleteControl(uuId);
      control.fold(
        (failure) {
          return state = AsyncError(
            failure.message ?? 'Unknown error',
            StackTrace.current,
          );
        },
        (result) {
          print('Control deleted successfully');
          return state = const AsyncData([]);
        },
      );
    } catch (e) {
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
  }
}

final controlSupabaseProvider = StateNotifierProvider<
  ControlSupabaseNotifier,
  AsyncValue<List<ControlModel>>
>((ref) => ControlSupabaseNotifier());
