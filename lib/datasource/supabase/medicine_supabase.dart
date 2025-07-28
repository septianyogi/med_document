import 'package:dartz/dartz.dart';
import 'package:med_document/config/failure.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MedicineSupabase {
  final supabase = Supabase.instance.client;
  Future<Either<Failure, bool>> insertMedicine(
    String uuId,
    String name,
    String dosage,
    String frequency,
    String controlId,
    int quantity,
  ) async {
    try {
      await supabase.from('medicines').insert({
        'uuId': uuId,
        'name': name,
        'dosage': dosage,
        'frequency': frequency,
        'control_id': controlId,
        'quantity': quantity,
      });
      print('Medicine added to supabase successfully');
      return Right(true);
    } catch (e) {
      if (e is Failure) {
        print('Error adding medicine: ${e.message}');
        return left(e);
      } else {
        print('Error adding medicine: $e');
        return left(FetchFailure(e.toString()));
      }
    }
  }

  Future<Either<Failure, List>> getMedicine() async {
    try {
      final PostgrestList response = await supabase.from('medicines').select();
      print('Response: $response');
      return Right(response);
    } catch (e) {
      if (e is Failure) {
        print('Error fetching medicines: ${e.message}');
        return left(e);
      } else {
        print('Error fetching medicines: $e');
        return left(FetchFailure(e.toString()));
      }
    }
  }

  Future<Either<Failure, bool>> deleteMedicine(String uuId) async {
    try {
      await supabase.from('medicines').delete().eq('uuId', uuId);
      print('Medicine with id $uuId deleted successfully');
      return const Right(true);
    } catch (e) {
      if (e is Failure) {
        print('Error deleting medicine: ${e.message}');
        return left(e);
      } else {
        print('Error deleting medicine: $e');
        return left(FetchFailure(e.toString()));
      }
    }
  }
}
