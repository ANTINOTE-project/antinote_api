class SessionException implements Exception {
  final String title;
  final String message;
  final int type;

  const SessionException({
    required this.title,
    required this.message,
    required this.type,
  });

  @override
  String toString() => '$title, message: $message, type: $type';
}

class AuthException implements Exception {
  const AuthException();

  @override
  String toString() => 'Invalid login credentials';
}

class InvalidInstanceException implements Exception {
  const InvalidInstanceException();

  @override
  String toString() =>
      'Base URL pointed to a page that does\'t seem to PRONOTE';
}
