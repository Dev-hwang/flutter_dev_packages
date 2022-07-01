class ApiException implements Exception {
  const ApiException([this._message]);

  final String? _message;

  @override
  String toString() => _message ?? 'ApiException';
}
