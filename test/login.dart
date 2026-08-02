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
      await session.access(
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
    });

    test('Menu page', () async {
      final day = session.instance.demoDateTime!.toDay();
      await session.access(MenuPageAccessor(date: day));
    });

    group('Discussion page', () {
      List<DiscussionRootNode>? discussions;

      test('Discussion list', () async {
        final discussionList = await session.access(
          const DiscussionPageAccessor(showRead: true, withMessages: true),
        );

        discussions = discussionList.discussions;
      });

      test('Discussion content', () async {
        if (discussions == null || discussions!.isEmpty) return;

        await session.access(DiscussionAccessor(node: discussions!.first));
      });
    });

    test('News page', () async {
      final newsPage = await session.access(
        const NewsPageAccessor.defaultMode(),
      );

      for (final collection in newsPage.collections) {
        if (collection.news.isEmpty) continue;

        await session.access(
          NewsContentAccessor(
            mode: collection.mode,
            baseNews: collection.news.first,
          ),
        );
      }
    });

    test('Grades page', () async {
      await session.access(
        LatestGradesPageAccessor(
          period: session.instance.defaultPeriod(
            session.instance.demoDateTime ?? session.instance.serverDateTime,
          ),
        ),
      );
    });

    test('Homeworks page', () async {
      final day = session.instance.demoDateTime!.toDay();
      final page = await session.access(
        NotebookPageAccessor.upcoming(section: .homework, date: day),
      );

      expect(page.homeworkSet, isNotNull);
    });

    test('Notebook page', () async {
      final lastWeekNumber = session.instance.getWeekNumberForDate(
        session.instance.lastDate,
      );
      final page = await session.access(
        NotebookPageAccessor(
          section: .resources,
          weeks: {
            for (
              int i = session.instance.firstWeekNumber;
              i <= lastWeekNumber;
              i++
            )
              i,
          },
        ),
      );

      expect(page.entries, isNotEmpty);
    });

    tearDownAll(() async {
      await session.access(const DisconnectionAccessor.logged());
      await session.access(const DisconnectionAccessor.unlogged());
    });
  });
}
