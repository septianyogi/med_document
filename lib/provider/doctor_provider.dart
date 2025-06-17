import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:med_document/dbHelper/db_helper.dart';
import 'package:med_document/model/doctor_model.dart';

class DoctorNotifier extends StateNotifier<AsyncValue<List<DoctorModel>>> {
  DoctorNotifier() : super(const AsyncValue.loading());

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

  Future<void> insertDoctor(String name, String specialty) async {
    try {
      if (!mounted) return;

      final doctor = DoctorModel(name: name, specialty: specialty);
      final result = await _databaseHelper.insertDoctor(doctor);
      if (result == 1) {
        final doctors = await _databaseHelper.getDoctors();
        state = AsyncValue.data(doctors);
      } else {
        state = AsyncValue.error('Failed to insert doctor', StackTrace.current);
      }
    } catch (e) {}
  }

  Future<void> updateDoctor(int id, String name, String specialty) async {
    try {
      if (!mounted) return;

      final doctor = DoctorModel(id: id, name: name, specialty: specialty);
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

  Future<void> deleteDoctor(int id) async {
    try {
      if (!mounted) return;
      final result = await _databaseHelper.deleteDoctor(id);
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
