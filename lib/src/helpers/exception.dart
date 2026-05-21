import 'dart:io';

final class UnexpectedCASRedirect extends HttpException {
  const UnexpectedCASRedirect(super.message, this.redirected);

  final Uri redirected;
}
