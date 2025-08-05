import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:med_document/datasource/supabase/doctor_supabase.dart';
import 'package:med_document/dbHelper/db_helper.dart';
import 'package:med_document/model/doctor_model.dart';
import 'package:uuid/uuid.dart';

class DoctorNotifier extends StateNotifier<AsyncValue<List<DoctorModel>>> {
  DoctorNotifier() : super(const AsyncValue.loading());

  final DoctorSupabase _doctorSupabase = DoctorSupabase();
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;
  Future<void> getDoctor() async {
    try {
      if (!mounted) return;
      final doctors = await _databaseHelper.getDoctors();
      if (doctors.isEmpty) {
        state = const AsyncValue.data([]);
      } else {
        state = AsyncValue.data(doctors);
      }
    } catch (e) {
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
  }

  Future<void> syncDoctorFromSupabase() async {
    try {
      if (!mounted) return;
      final localDoctors = await _databaseHelper.getDoctors();
      if (localDoctors.isEmpty) {
        final doctors = await _doctorSupabase.getDoctors();
        doctors.fold(
          (failure) {
            state = AsyncValue.error(
              failure.message ?? 'Unknown error',
              StackTrace.current,
            );
          },
          (result) async {
            List<DoctorModel> doctor =
                result.map((e) => DoctorModel.fromJson(e)).toList();
            final syncResult = await _databaseHelper.insertDoctors(doctor);
            if (syncResult) {
              final updatedDoctors = await _databaseHelper.getDoctors();
              state = AsyncValue.data(updatedDoctors);
            } else {
              state = AsyncValue.error(
                'Failed to sync doctors',
                StackTrace.current,
              );
            }
          },
        );
      }
    } catch (e) {
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
  }

  Future<void> insertDoctor(String name, String specialty) async {
    try {
      if (!mounted) return;
      String uuId = Uuid().v4();
      final supabase = await _doctorSupabase.addDoctors(uuId, name, specialty);

      supabase.fold(
        (failure) async {
          print('Failed to add doctor to Supabase');
          final result = await _databaseHelper.insertDoctor(
            DoctorModel(
              uuId: uuId,
              name: name,
              specialty: specialty,
              synced: false,
            ),
          );
          if (result == true) {
            print('Doctor added successfully to local database');
            final doctors = await _databaseHelper.getDoctors();
            state = AsyncValue.data(doctors);
          } else {
            print('Failed to insert doctor to local database');
            state = AsyncValue.error(
              'Failed to insert doctor',
              StackTrace.current,
            );
          }
        },
        (result) async {
          if (result == true) {
            print('Doctor added successfully to Supabase');
            // Insert to local database
            final result = await _databaseHelper.insertDoctor(
              DoctorModel(
                uuId: uuId,
                name: name,
                specialty: specialty,
                synced: true,
              ),
            );
            if (result == true) {
              print('Doctor added successfully to local database');
              // Refresh the state with updated doctors
              final doctors = await _databaseHelper.getDoctors();
              state = AsyncValue.data(doctors);
            } else {
              print('Failed to insert doctor to local database');
              state = AsyncValue.error(
                'Failed to insert doctor',
                StackTrace.current,
              );
            }
          }
        },
      );
    } catch (e) {
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
  }

  Future<void> updateDoctor(
    int id,
    String name,
    String specialty,
    int synced,
  ) async {
    try {
      if (!mounted) return;

      final doctor = DoctorModel(
        id: id,
        name: name,
        specialty: specialty,
        synced: synced == 1,
      );
      final result = await _databaseHelper.updateDoctor(doctor);
      if (result > 0) {
        final doctors = await _databaseHelper.getDoctors();
        state = AsyncValue.data(doctors);
      } else {
        state = AsyncValue.error('Failed to update doctor', StackTrace.current);
      }
    } catch (e) {
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
  }

  Future<void> updateDoctorSync(String uuId) async {
    try {
      if (!mounted) return;
      final result = await _databaseHelper.updateDoctorSync(uuId);
      if (result == 1) {
        final doctors = await _databaseHelper.getDoctors();
        state = AsyncValue.data(doctors);
      } else {
        state = AsyncValue.error('Failed to update doctor', StackTrace.current);
      }
    } catch (e) {
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
  }

  Future<void> deleteDoctor(String uuId) async {
    try {
      if (!mounted) return;
      final result = await _databaseHelper.deleteDoctor(uuId);
      if (result == 1) {
        final doctors = await _databaseHelper.getDoctors();
        state = AsyncValue.data(doctors);
      } else {
        state = AsyncValue.error('Failed to delete doctor', StackTrace.current);
      }
    } catch (e) {
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
  }
}

final doctorProvider =
    StateNotifierProvider<DoctorNotifier, AsyncValue<List<DoctorModel>>>(
      (ref) => DoctorNotifier()..getDoctor(),
    );
