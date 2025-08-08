import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:med_document/datasource/supabase/control_supabase.dart';
import 'package:med_document/datasource/supabase/medicine_supabase.dart';
import 'package:med_document/dbHelper/db_helper.dart';
import 'package:med_document/model/control_model.dart';
import 'package:uuid/uuid.dart';

import '../model/medicine_model.dart';

class ControlNotifier extends StateNotifier<AsyncValue<List<ControlModel>>> {
  ControlNotifier() : super(const AsyncValue.loading());

  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;
  final ControlSupabase _controlSupabase = ControlSupabase();
  final MedicineSupabase _medicineSupabase = MedicineSupabase();

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
    String? title,
    String? doctorName,
    String? date,
    String? time,
    String? description,
    String? appointment,
    int rujuk,
  ) async {
    try {
      if (!mounted) return;

      String uuId = Uuid().v4();
      final supabase = await _controlSupabase.insertControl(
        uuId,
        doctorName ?? '',
        title ?? '',
        date ?? '',
        time ?? '',
        description ?? '',
        rujuk == 1,
        appointment ?? '',
      );

      supabase.fold(
        (failure) async {
          print('Failed to add control to Supabase');
          final result = await _databaseHelper.insertControl(
            ControlModel(
              uuId: uuId,
              userId: userId,
              title: title ?? '',
              doctorName: doctorName ?? '',
              date: date ?? '',
              time: time ?? '',
              description: description ?? '',
              appointment: appointment ?? '',
              rujuk: rujuk,
              synced: false,
            ),
          );
          if (result == true) {
            print('Control added successfully to local database');
            final controls = await _databaseHelper.getControls();
            state = AsyncValue.data(controls);
          } else {
            print('Failed to insert control to local database');
            state = AsyncValue.error(
              'Failed to insert control',
              StackTrace.current,
            );
          }
        },
        (result) async {
          if (result == true) {
            final result = await _databaseHelper.insertControl(
              ControlModel(
                uuId: uuId,
                userId: userId,
                title: title ?? '',
                doctorName: doctorName ?? '',
                date: date ?? '',
                time: time ?? '',
                description: description ?? '',
                appointment: appointment ?? '',
                rujuk: rujuk ?? 0,
                synced: true,
              ),
            );
            if (result == true) {
              print('Control added successfully to local database');
              final controls = await _databaseHelper.getControls();
              state = AsyncValue.data(controls);
            } else {
              print('Failed to insert control to local database');
              state = AsyncValue.error(
                'Failed to insert control',
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

  Future<void> updateControl(
    String uuId,
    int userId,
    String? doctorName,
    String? date,
    String? time,
    String? description,
    String? appointment,
    int rujuk,
    bool synced,
  ) async {
    try {
      if (!mounted) return;
      final control = ControlModel(
        uuId: uuId,
        userId: userId,
        doctorName: doctorName,
        date: date,
        time: time,
        description: description,
        appointment: appointment,
        rujuk: rujuk,
        synced: synced,
      );
      final result = await _databaseHelper.updateControl(control);
      if (result == true) {
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

  Future<void> syncControlsFromSupabase() async {
    try {
      if (!mounted) return;
      final localControl = await _databaseHelper.getControls();
      if (localControl.isEmpty) {
        final supabaseControls = await _controlSupabase.getControl();
        supabaseControls.fold(
          (failure) {
            state = AsyncValue.error(
              'Failed to fetch controls from Supabase',
              StackTrace.current,
            );
          },
          (result) async {
            List<ControlModel> controls =
                result.map((e) {
                  return ControlModel(
                    uuId: e['uuId'],
                    userId: e['user_id'],
                    doctorName: e['doctor_name'],
                    title: e['title'],
                    date: e['date'],
                    time: e['time'],
                    description: e['description'],
                    appointment: e['appointment'],
                    rujuk: e['rujuk'],
                    synced: true,
                  );
                }).toList();
            final controlResult = await _databaseHelper.insertControls(
              controls,
            );
            if (controlResult) {
              final controls = await _databaseHelper.getControls();
              state = AsyncValue.data(controls);
            } else {
              state = AsyncValue.error(
                'Failed to insert controls from Supabase',
                StackTrace.current,
              );
            }
          },
        );
        final medicines = await _medicineSupabase.getMedicine();
        medicines.fold(
          (failure) {
            state = AsyncValue.error(
              'Failed to fetch medicines from Supabase',
              StackTrace.current,
            );
          },
          (result) async {
            List<MedicineModel> medicineList =
                result.map((e) {
                  return MedicineModel(
                    uuId: e['uuId'],
                    name: e['name'],
                    dosage: e['dosage'],
                    frequency: e['frequency'],
                    quantity: e['quantity'],
                    controlId: e['control_id'],
                    synced: true,
                  );
                }).toList();
            final medicineResult = await _databaseHelper.insertMedicines(
              medicineList,
            );
            if (medicineResult) {
            } else {
              state = AsyncValue.error(
                'Failed to insert medicines from Supabase',
                StackTrace.current,
              );
            }
          },
        );
      }
    } catch (e) {}
  }

  Future<void> updateControlSync(String uuId) async {
    try {
      if (!mounted) return;
      final result = await _databaseHelper.updateControlSynced(uuId);
      if (result == true) {
        final controls = await _databaseHelper.getControls();
        state = AsyncValue.data(controls);
      } else {
        state = AsyncValue.error(
          'Failed to update control sync status',
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
      if (result == true) {
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
