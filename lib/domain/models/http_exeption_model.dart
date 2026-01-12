class HttpExeptionModel {
  const HttpExeptionModel({required this.statusCode, required this.error});
  final int statusCode;
  final dynamic error;

  @override
  String toString() => error.toString();
}
