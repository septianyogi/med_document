import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../datasource/supabase/doctor_supabase.dart';
import '../../model/doctor_model.dart';

class DocotorSupabaseNotifier
    extends StateNotifier<AsyncValue<List<DoctorModel>>> {
  DocotorSupabaseNotifier() : super(const AsyncLoading());

  final DoctorSupabase _doctorSupabase = DoctorSupabase();

  Future<void> insertDoctor(String uuId, String name, String specialty) async {
    try {
      if (!mounted) return;
      final doctors = await _doctorSupabase.addDoctors(uuId, name, specialty);
      doctors.fold(
        (failure) {
          return state = AsyncError(
            failure.message ?? 'Unknown error',
            StackTrace.current,
          );
        },
        (result) {
          print('Doctor added successfully');
          return state = const AsyncData([]);
        },
      );
    } catch (e) {
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
  }

  Future<void> getDoctor() async {
    try {
      if (!mounted) return;
      final doctors = await _doctorSupabase.getDoctors();
      doctors.fold(
        (failure) {
          return state = AsyncError(
            failure.message ?? 'Unknown error',
            StackTrace.current,
          );
        },
        (result) {
          if (result.isEmpty) {
            return state = const AsyncData([]);
          } else {
            List<DoctorModel> doctor =
                result.map((e) => DoctorModel.fromJson(e)).toList();
            return state = AsyncData(doctor);
          }
        },
      );
    } catch (e) {
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
  }

  Future<void> deleteDoctor(String uuId) async {
    try {
      if (!mounted) return;
      final result = await _doctorSupabase.deleteDoctor(uuId);
      result.fold(
        (failure) {
          return state = AsyncError(
            failure.message ?? 'Unknown error',
            StackTrace.current,
          );
        },
        (result) {
          print('Doctor with id $uuId deleted successfully');
          state = AsyncData([]);
        },
      );
    } catch (e) {
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
  }
}

final doctorSupabaseProvider = StateNotifierProvider<
  DocotorSupabaseNotifier,
  AsyncValue<List<DoctorModel>>
>((ref) => DocotorSupabaseNotifier()..getDoctor());
