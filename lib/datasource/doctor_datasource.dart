import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:med_document/config/app%20request.dart';
import 'package:med_document/config/app_constant.dart';
import 'package:med_document/config/app_response.dart';
import 'package:med_document/config/app_session.dart';
import 'package:med_document/config/failure.dart';

class DoctorDatasource {
  static Future<Either<Failure, Map>> createDoctor(
    String name,
    String specialty,
  ) async {
    try {
      Uri url = Uri.parse('${AppConstant.baseURL}/doctor');
      final accessToken = await AppSession.getAccessToken();
      final response = await http.post(
        url,
        headers: AppRequest.header(accessToken),
        body: {'name': name, 'specialty': specialty},
      );
      final data = AppResponse.data(response);
      return right(data);
    } catch (e) {
      if (e is Failure) {
        return left(e);
      } else {
        return left(FetchFailure(e.toString()));
      }
    }
  }

  static Future<Either<Failure, Map>> getDoctor() async {
    try {
      Uri url = Uri.parse('${AppConstant.baseURL}/doctor');
      final accessToken = await AppSession.getAccessToken();
      final response = await http.get(
        url,
        headers: AppRequest.header(accessToken),
      );
      final data = AppResponse.data(response);
      return right(data);
    } catch (e) {
      if (e is Failure) {
        return left(e);
      } else {
        return left(FetchFailure(e.toString()));
      }
    }
  }

  static Future<Either<Failure, Map>> updateDoctor(
    String id,
    String name,
    String specialty,
  ) async {
    try {
      Uri url = Uri.parse('${AppConstant.baseURL}/doctor/$id');
      final accessToken = await AppSession.getAccessToken();
      final response = await http.patch(
        url,
        headers: AppRequest.header(accessToken),
        body: {'name': name, 'specialty': specialty},
      );
      final data = AppResponse.data(response);
      return right(data);
    } catch (e) {
      if (e is Failure) {
        return left(e);
      } else {
        return left(FetchFailure(e.toString()));
      }
    }
  }

  static Future<Either<Failure, Map>> deleteDoctor(String id) async {
    try {
      Uri url = Uri.parse('${AppConstant.baseURL}/doctor/$id');
      final accessToken = await AppSession.getAccessToken();
      final response = await http.delete(
        url,
        headers: AppRequest.header(accessToken),
      );
      final data = AppResponse.data(response);
      return right(data);
    } catch (e) {
      if (e is Failure) {
        return left(e);
      } else {
        return left(FetchFailure(e.toString()));
      }
    }
  }
}
