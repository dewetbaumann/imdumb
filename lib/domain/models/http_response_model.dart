class HttpResponseModel<T> {
  const HttpResponseModel({required this.statusCode, required this.data});
  final int statusCode;
  final T data;
}
