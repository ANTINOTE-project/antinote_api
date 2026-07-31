import 'package:antinote/antinote.dart';
import 'package:logging/logging.dart';
import 'package:test/test.dart';

void main() {
  group('Page tests', timeout: Timeout.none, () {
    late RemoteSession session;

    setUpAll(() async {
      final credentials = PasswordCredentials(
        username: 'demonstration',
        password: 'pronotevs',
        workspace: const Workspace(
          type: .eleve,
          label: '',
          pathSegment: 'mobile.eleve.html',
        ),
        cookies: [],
        baseUrl: .parse('https://demo.index-education.net/pronote'),
        deviceUuid: Credentials.generateDeviceUuid(),
      );

      hierarchicalLoggingEnabled = true;
      final LoginResult(session: newSession, credentials: refreshCredentials) =
          await credentials.login(options: .new(debugMode: true));
      session = newSession;
      session.stack.log.level = .ALL;
    });

    test('Home page', () async {
      final day = session.instance.demoDateTime!.toDay();
      final homepage = await session.access(
        HomePageAccessor(
          modules: [
            Actualites.module(),
            DS.module(),
            EDT.module(day),
            MenuDeLaCantine.module(day),
            Notes.module(),
            TravailAFaire.module(),
            VieScolaire.module(),
          ],
        ),
      );

      print(homepage);
    });

    test('News page', () async {
      final newsPage = await session.access(
        const NewsPageAccessor.defaultMode(),
      );

      print(newsPage);

      for (final collection in newsPage.collections) {
        if (collection.news.isEmpty) continue;

        final details = await session.access(
          NewsContentAccessor(
            mode: collection.mode,
            baseNews: collection.news.first,
          ),
        );

        print(details);
      }
    });

    test('Grades page', () async {
      final page = await session.access(
        LatestGradesPageAccessor(
          period: session.instance.defaultPeriod(
            session.instance.demoDateTime ?? session.instance.serverDateTime,
          ),
        ),
      );

      print(page);
    });

    tearDownAll(() async {
      await session.access(const DisconnectionAccessor.logged());
      await session.access(const DisconnectionAccessor.unlogged());
    });
  });
}
