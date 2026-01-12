class HttpExceptionModel implements Exception {
  final String message;
  final int? statusCode;

  HttpExceptionModel({required this.message, this.statusCode});

  @override
  String toString() => 'HttpExceptionModel(message: $message, statusCode: $statusCode)';
}
