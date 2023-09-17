class AppException implements Exception {
  const AppException(this.message);

  final String message;

  @override
  String toString() => message;
}

Never error(String message) => throw AppException(message);
