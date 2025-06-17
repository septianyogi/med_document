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
    name TEXT NOT NULL,
    specialty TEXT NOT NULL,
    synced INTEGER DEFAULT 0
  )
  ''';

    const medicineTable = '''
  CREATE TABLE medicines (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT,
    dosage TEXT,
    frequency TEXT,
    controlId INTEGER,
    synced INTEGER DEFAULT 0,
    FOREIGN KEY (controlId) REFERENCES controls (id)
  )
  ''';

    const controlTable = '''
  CREATE TABLE controls (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    userId INTEGER NOT NULL,
    doctorId INTEGER NOT NULL,
    medicineId INTEGER NOT NULL,
    date TEXT,
    time TEXT,
    description TEXT,
    appointment TEXT,
    rujuk INTEGER DEFAULT 0,
    synced INTEGER DEFAULT 0,
    FOREIGN KEY (medicineId) REFERENCES medicines (id),
    FOREIGN KEY (userId) REFERENCES users (id),
    FOREIGN KEY (doctorId) REFERENCES doctors (id)
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

  Future<int> insertDoctor(DoctorModel doctor) async {
    try {
      final db = await database;
      await db.insert('doctors', doctor.toJson());
      print('Inserting doctor: ${doctor.toJson()}');
      return 1;
    } catch (e) {
      print('Error inserting doctor: $e');
      return 0;
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
      return doctors.map((e) => DoctorModel.fromMap(e)).toList();
    } catch (e) {
      print('Error fetching doctors: $e');
      return [];
    }
  }

  Future<int> updateDoctor(DoctorModel doctor) async {
    try {
      final db = await database;
      final result = await db.update(
        'doctors',
        doctor.toJson(),
        where: 'id = ?',
        whereArgs: [doctor.id],
      );
      print('Updating doctor: ${doctor.toJson()}');
      return result;
    } catch (e) {
      print('Error updating doctor: $e');
      return 0;
    }
  }

  Future<int> deleteDoctor(int id) async {
    try {
      final db = await database;
      final result = await db.delete(
        'doctors',
        where: 'id = ?',
        whereArgs: [id],
      );
      print('Deleting doctor with id: $id');
      return 1;
    } catch (e) {
      print('Error deleting doctor: $e');
      return 0;
    }
  }

  Future<int> insertMedicine(MedicineModel medicine) async {
    try {
      final db = await database;
      await db.insert('medicines', medicine.toJson());
      print('Inserting medicine: ${medicine.toJson()}');
      return 1;
    } catch (e) {
      print('Error inserting medicine: $e');
      return 0;
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

  Future<int> updateMedicine(MedicineModel medicine) async {
    try {
      final db = await database;
      final result = await db.update(
        'medicines',
        medicine.toJson(),
        where: 'id = ?',
        whereArgs: [medicine.id],
      );
      print('Updating medicine: ${medicine.toJson()}');
      return result;
    } catch (e) {
      print('Error updating medicine: $e');
      return 0;
    }
  }

  Future<int> deleteMedicine(int id) async {
    try {
      final db = await database;
      final result = await db.delete(
        'medicines',
        where: 'id = ?',
        whereArgs: [id],
      );
      print('Deleting medicine with id: $id');
      return result;
    } catch (e) {
      print('Error deleting medicine: $e');
      return 0;
    }
  }
}
