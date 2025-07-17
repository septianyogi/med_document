import 'dart:convert';

import 'package:d_method/d_method.dart';
import 'package:http/http.dart';
import 'package:med_document/config/failure.dart';

class AppResponse {
  static Map data(Response response) {
    DMethod.printResponse(response);

    switch (response.statusCode) {
      case 200:
      case 201:
        return jsonDecode(response.body);
      case 204:
        return {'success': true};
      case 400:
        throw BadRequestFailure(_parseMessage(response.body));
      case 401:
        throw UnauthorisedFailure(_parseMessage(response.body));
      case 403:
        throw ForbiddenFailure(_parseMessage(response.body));
      case 404:
        throw NotFoundFailure(_parseMessage(response.body));
      case 422:
        throw InvalidInputFailure(_parseMessage(response.body));
      case 500:
      default:
        throw ServerFailure(_parseMessage(response.body));
    }
  }

  static String _parseMessage(String body) {
    try {
      final decoded = jsonDecode(body);
      return decoded['message'] ?? 'Terjadi kesalahan';
    } catch (e) {
      return 'Terjadi kesalahan';
    }
  }
}
