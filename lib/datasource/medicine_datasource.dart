import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:med_document/config/app%20request.dart';
import 'package:med_document/config/app_constant.dart';
import 'package:med_document/config/app_response.dart';
import 'package:med_document/config/app_session.dart';
import 'package:med_document/config/failure.dart';

class MedicineDatasource {
  static Future<Either<Failure, Map>> createMedicine(
    String name,
    String dosage,
    int quantity,
    String frequency,
    int controlId,
  ) async {
    try {
      Uri url = Uri.parse('${AppConstant.baseURL}/medicine');
      final accessToken = await AppSession.getAccessToken();
      final response = await http.post(
        url,
        headers: AppRequest.header(accessToken),
        body: {
          'name': name,
          'dosage': dosage,
          'quantity': quantity.toString(),
          'frequency': frequency,
          'control_id': controlId.toString(),
        },
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

  static Future<Either<Failure, Map>> getMedicine() async {
    try {
      Uri url = Uri.parse('${AppConstant.baseURL}/medicine');
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

  static Future<Either<Failure, Map>> updateMedicine(
    int id,
    String name,
    String dosage,
    int quantity,
    String frequency,
    int controlId,
  ) async {
    try {
      Uri url = Uri.parse('${AppConstant.baseURL}/medicine/$id');
      final accessToken = await AppSession.getAccessToken();
      final response = await http.patch(
        url,
        headers: AppRequest.header(accessToken),
        body: {
          'name': name,
          'dosage': dosage,
          'quantity': quantity.toString(),
          'frequency': frequency,
          'control_id': controlId.toString(),
        },
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

  static Future<Either<Failure, Map>> deleteMedicine(int id) async {
    try {
      Uri url = Uri.parse('${AppConstant.baseURL}/medicine/$id');
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
