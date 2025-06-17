import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:med_document/dbHelper/db_helper.dart';
import 'package:med_document/model/control_model.dart';

class ControlNotifier extends StateNotifier<AsyncValue<List<ControlModel>>> {
  ControlNotifier() : super(const AsyncValue.loading());

  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  Future<void> getControl() async {
    try {
      if (!mounted) return;
      final control = await _databaseHelper.getControls();
      if (control.isEmpty) {
        state = const AsyncValue.data([]);
      } else {
        state = AsyncValue.data(control);
      }
    } catch (e) {
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
  }

  Future<void> insertControl(
    int userId,
    int doctorId,
    String? date,
    String? time,
    String? description,
    String? appointment,
    int rujuk,
  ) async {
    try {
      if (!mounted) return;
      final control = ControlModel(
        userId: userId,
        doctorId: doctorId ?? 0,
        date: date ?? '',
        time: time ?? '',
        description: description ?? '',
        appointment: appointment ?? '',
        rujuk: rujuk ?? 0,
      );
      final result = await _databaseHelper.insertControl(control);
      if (result == 1) {
        final controls = await _databaseHelper.getControls();
        state = AsyncValue.data(controls);
      } else {
        state = AsyncValue.error(
          'Failed to insert control',
          StackTrace.current,
        );
      }
    } catch (e) {
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
  }

  Future<void> updateControl(
    int userId,
    int doctorId,
    String? date,
    String? time,
    String? description,
    String? appointment,
    int rujuk,
  ) async {
    try {
      if (!mounted) return;
      final control = ControlModel(
        userId: userId,
        doctorId: doctorId,
        date: date,
        time: time,
        description: description,
        appointment: appointment,
        rujuk: rujuk,
      );
      final result = await _databaseHelper.updateControl(control);
      if (result == 1) {
        final controls = await _databaseHelper.getControls();
        state = AsyncValue.data(controls);
      } else {
        state = AsyncValue.error(
          'Failed to update control',
          StackTrace.current,
        );
      }
    } catch (e) {
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
  }

  Future<void> deleteControl(int id) async {
    try {
      if (!mounted) return;
      final result = await _databaseHelper.deleteControl(id);
      if (result == 1) {
        final controls = await _databaseHelper.getControls();
        state = AsyncValue.data(controls);
      } else {
        state = AsyncValue.error(
          'Failed to delete control',
          StackTrace.current,
        );
      }
    } catch (e) {
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
  }
}

final controlProvider =
    StateNotifierProvider<ControlNotifier, AsyncValue<List<ControlModel>>>(
      (ref) => ControlNotifier()..getControl(),
    );
