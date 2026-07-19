import 'package:antinote/antinote.dart';
import 'package:test/test.dart';

void main() {
  test('Login to PRONOTE', timeout: .none, () async {
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
        await credentials.login(options: .new(debugMode: true));

    try {
      await session.ensurePage(7);

      // final focusedDay = session.instance.demoDateTime!.add(Duration(days: 28));
      final homepage = await session.access(
        HomePageAccessor(modules: const []),
      );

      print(homepage);
    } catch (e) {
      rethrow;
    } finally {
      await session.access(DisconnectionAccessor.logged());
    }
  });
}
