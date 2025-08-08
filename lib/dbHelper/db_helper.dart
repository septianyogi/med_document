import 'package:med_document/model/control_model.dart';

import '../model/doctor_model.dart';
import '../model/user_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/medicine_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;
  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('doc_document.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 2, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const userTable = '''
  CREATE TABLE users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    rm TEXT NOT NULL,
    name TEXT NOT NULL,
    sex TEXT NOT NULL,
    dob TEXT NOT NULL,
    address TEXT NOT NULL,
    synced INTEGER DEFAULT 0
  )
  ''';

    const doctorTable = '''
  CREATE TABLE doctors (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    uuId TEXT NOT NULL,
    name TEXT NOT NULL,
    specialty TEXT NOT NULL,
    synced INTEGER DEFAULT 0
  )
  ''';

    const medicineTable = '''
  CREATE TABLE medicines (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    uuId TEXT NOT NULL,
    name TEXT,
    dosage TEXT,
    quantity INTEGER,
    frequency TEXT,
    controlId INTEGER,
    synced INTEGER DEFAULT 0,
    FOREIGN KEY (controlId) REFERENCES controls (id)
  )
  ''';

    const controlTable = '''
  CREATE TABLE controls (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    uuId TEXT NOT NULL,
    title TEXT,
    userId INTEGER ,
    doctorName TEXT,
    date TEXT,
    time TEXT,
    description TEXT,
    appointment TEXT,
    rujuk INTEGER DEFAULT 0,
    synced INTEGER DEFAULT 0,
    FOREIGN KEY (userId) REFERENCES users (id)
  )
  ''';

    await db.execute(userTable);
    await db.execute(doctorTable);
    await db.execute(medicineTable);
    await db.execute(controlTable);
  }

  Future close() async {
    final db = await instance.database;
    db.close();
    _database = null;
  }

  Future<int> insertUser(UserModel user) async {
    try {
      final db = await database;
      await db.insert('users', user.toJson());
      print('Inserting user: ${user.toJson()}');
      return 1;
    } catch (e) {
      print('Error inserting user: $e');
      return 0;
    }
  }

  Future<List<UserModel>> getUsers() async {
    try {
      final db = await database;
      final users = await db.query('users');
      if (users.isEmpty) {
        print('No users found');
        return [];
      }
      return users.map((e) => UserModel.fromJson(e)).toList();
    } catch (e) {
      print('Error fetching users: $e');
      return [];
    }
  }

  Future<int> updateUser(UserModel user) async {
    try {
      final db = await database;
      final result = await db.update(
        'users',
        user.toJson(),
        where: 'id = ?',
        whereArgs: [user.id],
      );
      print('Updating user: ${user.toJson()}');
      return result;
    } catch (e) {
      print('Error updating user: $e');
      return 0;
    }
  }

  Future<int> deleteUser(int id) async {
    try {
      final db = await database;
      final result = await db.delete('users', where: 'id = ?', whereArgs: [id]);
      print('Deleting user with id: $id');
      return result;
    } catch (e) {
      print('Error deleting user: $e');
      return 0;
    }
  }

  Future<bool> insertDoctor(DoctorModel doctor) async {
    try {
      final db = await database;
      await db.insert('doctors', doctor.toJson());
      print('Inserting doctor: ${doctor.toJson()}');
      return true;
    } catch (e) {
      print('Error inserting doctor: $e');
      return false;
    }
  }

  Future<bool> insertDoctors(List<DoctorModel> doctors) async {
    try {
      final db = await database;
      for (var doctor in doctors) {
        final data = doctor.toJson();
        data['synced'] = 1;
        await db.insert(
          'doctors',
          data,
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
        print('Inserting doctor: ${doctor.toJson()}');
      }
      print('All doctors inserted successfully');
      return true;
    } catch (e) {
      print('Error inserting doctors: $e');
      return false;
    }
  }

  Future<List<DoctorModel>> getDoctors() async {
    try {
      final db = await database;
      final doctors = await db.query('doctors');
      if (doctors.isEmpty) {
        print('No doctors found');
        return [];
      }
      return doctors.map((e) => DoctorModel.fromJson(e)).toList();
    } catch (e) {
      print('Error fetching doctors: $e');
      return [];
    }
  }

  Future<DoctorModel> getDoctorById(int id) async {
    try {
      final db = await database;
      final doctor = await db.query(
        'doctors',
        where: 'id = ?',
        whereArgs: [id],
      );
      if (doctor.isEmpty) {
        print('No doctor found with id: $id');
        return DoctorModel(id: 0, name: '', specialty: '', synced: false);
      }
      return DoctorModel.fromJson(doctor.first);
    } catch (e) {
      print('Error fetching doctor by id: $e');
      return DoctorModel(id: 0, name: '', specialty: '', synced: false);
    }
  }

  Future<int> updateDoctor(DoctorModel doctor) async {
    try {
      final db = await database;
      final result = await db.update(
        'doctors',
        doctor.toJson(),
        where: 'uuId = ?',
        whereArgs: [doctor.uuId],
      );
      print('Updating doctor: ${doctor.toJson()}');
      return result;
    } catch (e) {
      print('Error updating doctor: $e');
      return 0;
    }
  }

  Future<int> updateDoctorSync(String uuId) async {
    try {
      final db = await database;
      final result = await db.update(
        'doctors',
        {'synced': 1},
        where: 'uuId = ?',
        whereArgs: [uuId],
      );
      print('Updating doctor sync status for id: $uuId');
      print('Result: $result');
      return 1;
    } catch (e) {
      print('Error updating doctor sync status: $e');
      return 0;
    }
  }

  Future<int> deleteDoctor(String uuId) async {
    try {
      final db = await database;
      final result = await db.delete(
        'doctors',
        where: 'uuId = ?',
        whereArgs: [uuId],
      );
      print('Deleting doctor with uuId: $uuId');
      return 1;
    } catch (e) {
      print('Error deleting doctor: $e');
      return 0;
    }
  }

  Future<bool> insertMedicine(MedicineModel medicine) async {
    try {
      final db = await database;
      await db.insert('medicines', medicine.toJson());
      print('Inserting medicine: ${medicine.toJson()}');
      return true;
    } catch (e) {
      print('Error inserting medicine: $e');
      return false;
    }
  }

  Future<bool> insertMedicines(List<MedicineModel> medicines) async {
    try {
      final db = await database;
      for (var medicine in medicines) {
        final data = medicine.toJson();
        data['synced'] = 1;
        await db.insert(
          'medicines',
          data,
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
        print('Inserting medicine: ${medicine.toJson()}');
      }
      return true;
    } catch (e) {
      print('Error inserting medicines: $e');
      return false;
    }
  }

  Future<List<MedicineModel>> getMedicines() async {
    try {
      final db = await database;
      final medicines = await db.query('medicines');
      if (medicines.isEmpty) {
        print('No medicines found');
        return [];
      }
      return medicines.map((e) => MedicineModel.fromJson(e)).toList();
    } catch (e) {
      print('Error fetching medicines: $e');
      return [];
    }
  }

  Future<List<MedicineModel>> getMedicineByControlId(String controlId) async {
    try {
      final db = await database;
      final medicines = await db.query(
        'medicines',
        where: 'controlId = ?',
        whereArgs: [controlId],
      );
      if (medicines.isEmpty) {
        print('No medicines found for controlId: $controlId');
        return [];
      }
      return medicines.map((e) => MedicineModel.fromJson(e)).toList();
    } catch (e) {
      print('Error fetching medicines by controlId: $e');
      return [];
    }
  }

  Future<bool> updateMedicine(MedicineModel medicine) async {
    try {
      final db = await database;
      final result = await db.update(
        'medicines',
        medicine.toJson(),
        where: 'uuId = ?',
        whereArgs: [medicine.uuId],
      );
      print('Updating medicine: ${medicine.toJson()}');
      return true;
    } catch (e) {
      print('Error updating medicine: $e');
      return false;
    }
  }

  Future<bool> deleteMedicine(String uuId) async {
    try {
      final db = await database;
      final result = await db.delete(
        'medicines',
        where: 'uuId = ?',
        whereArgs: [uuId],
      );
      print('Deleting medicine with id: $uuId');
      return true;
    } catch (e) {
      print('Error deleting medicine: $e');
      return false;
    }
  }

  Future<bool> insertControl(ControlModel control) async {
    try {
      final db = await database;
      await db.insert('controls', control.toJson());
      print('Inserting control: ${control.toJson()}');
      return true;
    } catch (e) {
      print('Error inserting control: $e');
      return false;
    }
  }

  Future<bool> insertControls(List<ControlModel> controls) async {
    try {
      final db = await database;
      for (var control in controls) {
        final data = control.toJson();
        data['synced'] = 1;
        await db.insert(
          'controls',
          data,
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
        print('Inserting control: ${control.toJson()}');
      }
      return true;
    } catch (e) {
      print('Error inserting controls: $e');
      return false;
    }
  }

  Future<List<ControlModel>> getControls() async {
    try {
      final db = await database;
      final controls = await db.query('controls');
      if (controls.isEmpty) {
        print('No controls found');
        return [];
      }
      return controls.map((e) => ControlModel.fromJson(e)).toList();
    } catch (e) {
      print('Error fetching controls: $e');
      return [];
    }
  }

  Future<bool> updateControl(ControlModel control) async {
    try {
      final db = await database;
      final result = await db.update(
        'controls',
        control.toJson(),
        where: 'id = ?',
        whereArgs: [control.id],
      );
      print('Updating control: ${control.toJson()}');
      return true;
    } catch (e) {
      print('Error updating control: $e');
      return false;
    }
  }

  Future<bool> updateControlSynced(String uuId) async {
    try {
      final db = await database;
      final result = await db.update(
        'controls',
        {'synced': 1},
        where: 'uuId = ?',
        whereArgs: [uuId],
      );
      print('Updating control sync status for uuId: $uuId');
      return true;
    } catch (e) {
      print('Error updating control sync status: $e');
      return false;
    }
  }

  Future<bool> deleteControl(int id) async {
    try {
      final db = await database;
      final result = await db.delete(
        'controls',
        where: 'id = ?',
        whereArgs: [id],
      );
      print('Deleting control with id: $id');
      return true;
    } catch (e) {
      print('Error deleting control: $e');
      return false;
    }
  }
}
