import 'package:dartz/dartz.dart';
import 'package:med_document/config/failure.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ControlSupabase {
  final supabase = Supabase.instance.client;

  Future<Either<Failure, bool>> insertControl(
    String uuId,
    String doctor_name,
    String date,
    String time,
    String description,
    bool rujuk,
    String appointment,
  ) async {
    try {
      await supabase.from('controls').insert({
        'uuId' : uuId,
        'doctor_name': doctor_name,
        'date': date,
        'time': time,
        'description': description,
        'rujuk': rujuk,
        'appointment': appointment,
      });

      print('Control added to supabase successfully');
      return Right(true);
    } catch (e) {
      print('Error adding control: $e');
      if (e is Failure) {
        return left(e);
      } else {
        return left(FetchFailure(e.toString()));
      }
    }
  }

  Future<Either<Failure, List>> getControl() async {
    try {
      final PostgrestList response = await supabase.from('controls').select();

      print('Response: $response');
      return Right(response);
    } catch (e) {
      if (e is Failure) {
        print('Error fetching control: ${e.message}');
        return left(e);
      } else {
        return left(FetchFailure(e.toString()));
      }
    }
  }

  Future<Either<Failure, bool>> deleteControl(String uuId) async {
    try {
      await supabase.from('controls').delete().eq('uuId', uuId);
      print('Control with id $uuId deleted successfully');
      return const Right(true);
    } catch (e) {
      print('Error deleting control: $e');
      if (e is Failure) {
        return left(e);
      } else {
        return left(FetchFailure(e.toString()));
      }
    }
  }
}
