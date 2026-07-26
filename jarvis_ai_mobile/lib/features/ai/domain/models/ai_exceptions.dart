// AI related exceptions

class InvalidApiKeyException implements Exception {
  final String message;
  InvalidApiKeyException([this.message = 'Invalid API key']);
  @override
  String toString() => 'InvalidApiKeyException: $message';
}

class NoInternetException implements Exception {
  final String message;
  NoInternetException([this.message = 'No internet connection']);
  @override
  String toString() => 'NoInternetException: $message';
}

class RequestTimeoutException implements Exception {
  final String message;
  RequestTimeoutException([this.message = 'Request timed out']);
  @override
  String toString() => 'RequestTimeoutException: $message';
}

class UnknownAiException implements Exception {
  final String message;
  UnknownAiException([this.message = 'Unknown AI error']);
  @override
  String toString() => 'UnknownAiException: $message';
}
