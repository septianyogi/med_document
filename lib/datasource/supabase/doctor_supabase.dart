import 'package:dartz/dartz.dart';
import 'package:http/http.dart';
import 'package:med_document/config/app_response.dart';
import 'package:med_document/config/failure.dart';
import 'package:med_document/model/doctor_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DoctorSupabase {
  final supabase = Supabase.instance.client;

  Future<Either<Failure, bool>> addDoctors(
    String uuId,
    String name,
    String specialty,
  ) async {
    try {
      await supabase.from('doctors').insert({
        'uuId' : uuId,
        'name': name,
        'specialty': specialty,
      });

      print('Doctor added to supabase successfully');
      return Right(true);
    } catch (e) {
      print('Error adding doctor: $e');
      if (e is Failure) {
        return left(e);
      } else {
        return left(FetchFailure(e.toString()));
      }
    }
  }

  Future<Either<Failure, List>> getDoctors() async {
    try {
      final PostgrestList response = await supabase.from('doctors').select();

      print('Response: $response');
      return Right(response);
    } catch (e) {
      if (e is Failure) {
        print('Error fetching doctors: ${e.message}');
        return left(e);
      } else {
        return left(FetchFailure(e.toString()));
      }
    }
  }

  Future<Either<Failure, bool>> deleteDoctor(String uuId) async {
    try {
      await supabase.from('doctors').delete().eq('uuId', uuId);
      print('Doctor with id $uuId deleted successfully');
      return const Right(true);
    } catch (e) {
      print('Error deleting doctor: $e');
      if (e is Failure) {
        return left(e);
      } else {
        return left(FetchFailure(e.toString()));
      }
    }
  }
}
