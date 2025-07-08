abstract class Failure implements Exception {
  final String? message;

  Failure(this.message);
  @override
  String toString() => message ?? 'Terjadi kesalahan';
}

class FetchFailure extends Failure {
  FetchFailure(super.message);
}

class UnauthorisedFailure extends Failure {
  UnauthorisedFailure(super.message);
}

class BadRequestFailure extends Failure {
  BadRequestFailure(super.message);
}

class ForbiddenFailure extends Failure {
  ForbiddenFailure(super.message);
}

class InvalidInputFailure extends Failure {
  InvalidInputFailure(super.message);
}

class NotFoundFailure extends Failure {
  NotFoundFailure(super.message);
}

class ServerFailure extends Failure {
  ServerFailure(super.message);
}