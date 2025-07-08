import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:med_document/config/app%20request.dart';
import 'package:med_document/config/app_constant.dart';
import 'package:med_document/config/app_response.dart';
import 'package:med_document/config/app_session.dart';
import 'package:med_document/config/failure.dart';

class UserDatasource {
  static Future<Either<Failure, Map>> login(
    String email,
    String password,
  ) async {
    try {
      Uri url = Uri.parse('${AppConstant.baseURL}/login');
      final response = await http.post(
        url,
        headers: AppRequest.header(),
        body: {'email': email, 'password': password},
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

  static Future<Either<Failure, Map>> register(
    String rm,
    String name,
    String sex,
    String dob,
    String address,
    String email,
    String password,
  ) async {
    try {
      Uri url = Uri.parse('${AppConstant.baseURL}/register');
      final response = await http.post(
        url,
        headers: AppRequest.header(),
        body: {
          'rm': rm,
          'name': name,
          'sex': sex,
          'dob': dob,
          'address': address,
          'email': email,
          'password': password,
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

  static Future<Either<Failure, Map>> logout() async {
    try {
      Uri url = Uri.parse('${AppConstant.baseURL}.logout');
      final accessToken = await AppSession.getAccessToken();
      final refreshToken = await AppSession.getRefreshToken();
      final response = await http.post(
        url,
        headers: AppRequest.header(accessToken),
        body: {'refresh_token': refreshToken},
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
