import 'enums.dart';

class ServerException implements Exception {
  final ErrorStatus status;
  final String message;

  ServerException({required this.status, required this.message});
}

class LocalException implements Exception {
  final ErrorStatus status;
  final String message;

  LocalException({required this.status, required this.message});
}
