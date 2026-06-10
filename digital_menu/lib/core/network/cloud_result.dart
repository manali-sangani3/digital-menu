class CloudResult<T> {
  final int statusCode;
  final T? data;
  final String message;

  const CloudResult({
    required this.statusCode,
    this.data,
    required this.message,
  });

  bool get isSuccess => statusCode >= 200 && statusCode < 300;
}
