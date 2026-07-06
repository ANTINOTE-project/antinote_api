import 'package:antinote/antinote.dart';
import 'package:test/test.dart';

void main() {
  test('Login to PRONOTE', () async {
    final credentials = PasswordCredentials(
      username: 'demonstration',
      password: 'pronotevs',
      workspace: Workspace(
        type: WorkspaceType.mobileEleve,
        label: '',
        pathSegment: 'mobile.eleve.html',
      ),
      baseUrl: Uri.parse('https://demo.index-education.net/pronote'),
      deviceUuid: Credentials.generateDeviceUuid(),
    );

    final (session: session, refreshCredentials: refreshCredentials) =
        await credentials.login();

    try {
      await session.ensurePage(16);
      final timetable = await session.access(
        TimetableAccessor.forYear(
          resource: session.userResource,
          session: session,
        ),
      );

      print(timetable);
    } catch (_) {}

    await session.access(DisconnectionAccessor.logged());
  });
}
