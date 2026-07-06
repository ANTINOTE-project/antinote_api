import 'dart:io';

final class SessionException implements Exception {
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

final class AuthException implements Exception {
  const AuthException();

  @override
  String toString() => 'Invalid login credentials';
}

final class InvalidInstanceException implements Exception {
  const InvalidInstanceException();

  @override
  String toString() =>
      'Base URL pointed to a page that does\'t seem to be a valid instance';
}

final class ExclusiveModeException implements Exception {
  const ExclusiveModeException();

  @override
  String toString() =>
      'Tried to send a function call that edits data while exclusive mode is on';
}

final class UnexpectedCASRedirect extends HttpException {
  const UnexpectedCASRedirect(super.message, this.redirected);

  final Uri redirected;
}
