import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure(this.message, [this.statusCode]);

  final String message;
  final int? statusCode;

  @override
  List<Object?> get props => [message, statusCode];
}

class ServerFailure extends Failure {
  const ServerFailure(super.message, [super.statusCode]);
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure(String message) : super(message, 401);
}

class ValidationFailure extends Failure {
  const ValidationFailure(String message, [this.errors]) : super(message, 422);

  final Map<String, dynamic>? errors;
}

class TimeoutFailure extends Failure {
  const TimeoutFailure(super.message);
}