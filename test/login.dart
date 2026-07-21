import 'package:antinote/antinote.dart';
import 'package:test/test.dart';

void main() {
  test('Login to PRONOTE', timeout: .none, () async {
    final credentials = PasswordCredentials(
      username: 'demonstration',
      password: 'pronotevs',
      workspace: Workspace(
        type: .mobileEleve,
        label: '',
        pathSegment: 'mobile.eleve.html',
      ),
      baseUrl: .parse('https://demo.index-education.net/pronote'),
      deviceUuid: Credentials.generateDeviceUuid(),
    );

    final (session: session, refreshCredentials: refreshCredentials) =
        await credentials.login(options: .new(debugMode: true));

    try {
      await session.ensurePage(7);

      final day = session.instance.demoDateTime!.toDay();
      final homepage = await session.access(
        HomePageAccessor(
          modules: [
            EDT.module(day),
            MenuDeLaCantine.module(day),
            TravailAFaire.module(),
          ],
        ),
      );

      print(homepage);
    } catch (e) {
      rethrow;
    } finally {
      await session.access(DisconnectionAccessor.logged());
    }
  });
}
