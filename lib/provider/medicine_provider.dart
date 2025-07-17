import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:med_document/dbHelper/db_helper.dart';
import 'package:med_document/model/medicine_model.dart';

class MedicineNotifier extends StateNotifier<AsyncValue<List<MedicineModel>>> {
  MedicineNotifier() : super(const AsyncValue.loading());

  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  Future<void> getMedicineByControlId(String controlId) async {
    try {
      if (!mounted) return;
      final medicines = await _databaseHelper.getMedicineByControlId(controlId);
      if (medicines.isEmpty) {
        state = const AsyncValue.data([]);
      } else {
        state = AsyncValue.data(medicines);
      }
    } catch (e) {
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
  }

  Future<void> insertMedicine(
    String name,
    String dosage,
    String frequency,
    int quantity,
    String controlId,
  ) async {
    try {
      if (!mounted) return;
      final medicine = MedicineModel(
        name: name,
        dosage: dosage,
        frequency: frequency,
        quantity: quantity,
        controlId: controlId,
      );
      final result = await _databaseHelper.insertMedicine(medicine);
      if (result == 1) {
        final medicines = await _databaseHelper.getMedicineByControlId(
          controlId,
        );
        state = AsyncValue.data(medicines);
      } else {
        state = AsyncValue.error(
          'Failed to insert medicine',
          StackTrace.current,
        );
      }
    } catch (e) {
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
  }

  Future<void> updateMedicine(
    int id,
    String name,
    String dosage,
    int quantity,
    String frequency,
  ) async {
    try {
      if (!mounted) return;
      final medicine = MedicineModel(
        id: id,
        name: name,
        dosage: dosage,
        quantity: quantity,
        frequency: frequency,
      );
      final result = await _databaseHelper.updateMedicine(medicine);
      if (result > 0) {
        final medicines = await _databaseHelper.getMedicines();
        state = AsyncValue.data(medicines);
      } else {
        state = AsyncValue.error(
          'Failed to update medicine',
          StackTrace.current,
        );
      }
    } catch (e) {
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
  }

  Future<void> deleteMedicine(String uuId) async {
    try {
      if (!mounted) return;
      final result = await _databaseHelper.deleteMedicine(uuId);
      if (result == 1) {
        final medicines = await _databaseHelper.getMedicines();
        state = AsyncValue.data(medicines);
      } else {
        state = AsyncValue.error(
          'Failed to delete medicine',
          StackTrace.current,
        );
      }
    } catch (e) {
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
  }
}

final medicineProvider =
    StateNotifierProvider<MedicineNotifier, AsyncValue<List<MedicineModel>>>(
      (ref) => MedicineNotifier(),
    );
