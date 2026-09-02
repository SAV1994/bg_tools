import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import 'package:bg_tools/features/counters/screens/export.dart';
import 'package:bg_tools/features/randomizer/screens/export.dart';
import 'package:bg_tools/features/session_runner/step_wizard.dart';
import 'package:bg_tools/features/statistics/screens/export.dart';
import 'package:bg_tools/features/top/screens/export.dart';
import 'package:bg_tools/screens/export.dart';

final GoRouter goRouter = GoRouter(
  initialLocation: '/',
  routes: <RouteBase>[
    // Главный экран
    GoRoute(
      path: '/',
      name: 'home',
      builder: (BuildContext context, GoRouterState state) =>
          const HomeScreen(),
    ),

    // Настройки
    GoRoute(
      path: '/settings',
      name: 'settings',
      builder: (BuildContext context, GoRouterState state) =>
          const SettingsScreen(),
    ),

    // Настольные игры
    GoRoute(
      path: '/games',
      name: 'games-list',
      builder: (BuildContext context, GoRouterState state) {
        final artistId = int.tryParse(
          state.uri.queryParameters['artistId'] ?? '',
        );
        final designerId = int.tryParse(
          state.uri.queryParameters['designerId'] ?? '',
        );
        final tagId = int.tryParse(state.uri.queryParameters['tagId'] ?? '');

        return GamesListScreen(
          artistId: artistId,
          designerId: designerId,
          tagId: tagId,
        );
      },
    ),
    GoRoute(
      path: '/games/add',
      name: 'games-add',
      builder: (BuildContext context, GoRouterState state) {
        final baseGameId = int.tryParse(
          state.uri.queryParameters['baseGameId'] ?? '',
        );
        return GamesFormScreen(baseGameId: baseGameId);
      },
    ),
    GoRoute(
      path: '/games/:gameId',
      name: 'games-detail',
      builder: (BuildContext context, GoRouterState state) =>
          GamesDetailScreen(gameId: int.parse(state.pathParameters['gameId']!)),
    ),
    GoRoute(
      path: '/games/:gameId/update',
      name: 'games-update',
      builder: (BuildContext context, GoRouterState state) =>
          GamesFormScreen(gameId: int.parse(state.pathParameters['gameId']!)),
    ),

    // Игроки
    GoRoute(
      path: '/gamers',
      name: 'gamers-list',
      builder: (BuildContext context, GoRouterState state) =>
          const GamersListScreen(),
    ),
    GoRoute(
      path: '/gamers/add',
      name: 'gamers-add',
      builder: (BuildContext context, GoRouterState state) =>
          GamersFormScreen(),
    ),
    GoRoute(
      path: '/gamers/:gamerId',
      name: 'gamers-update',
      builder: (BuildContext context, GoRouterState state) => GamersFormScreen(
        gamerId: int.parse(state.pathParameters['gamerId']!),
      ),
    ),

    // Заметки
    GoRoute(
      path: '/games/:gameId/notes',
      name: 'notes-list',
      builder: (BuildContext context, GoRouterState state) =>
          NotesListScreen(gameId: int.parse(state.pathParameters['gameId']!)),
    ),
    GoRoute(
      path: '/games/:gameId/notes/add',
      name: 'notes-add',
      builder: (BuildContext context, GoRouterState state) =>
          NoteForm(gameId: int.parse(state.pathParameters['gameId']!)),
    ),
    GoRoute(
      path: '/games/:gameId/notes/:noteId',
      name: 'notes-detail',
      builder: (BuildContext context, GoRouterState state) => NoteDetailScreen(
        gameId: int.parse(state.pathParameters['gameId']!),
        noteId: int.parse(state.pathParameters['noteId']!),
      ),
    ),
    GoRoute(
      path: '/games/:gameId/notes/:noteId/update',
      name: 'notes-update',
      builder: (BuildContext context, GoRouterState state) => NoteForm(
        gameId: int.parse(state.pathParameters['gameId']!),
        noteId: int.parse(state.pathParameters['noteId']!),
      ),
    ),

    // Шаблоны сессий игры
    GoRoute(
      path: '/games/:gameId/counting-templates',
      name: 'counting-templates-list',
      builder: (BuildContext context, GoRouterState state) =>
          GamesCountingTemplateslistScreen(
            gameId: int.parse(state.pathParameters['gameId']!),
          ),
    ),
    GoRoute(
      path: '/games/:gameId/counting-templates/add',
      name: 'counting-templates-add',
      builder: (BuildContext context, GoRouterState state) =>
          GamesCountingTemplatesModalForm(
            gameId: int.parse(state.pathParameters['gameId']!),
          ),
    ),
    GoRoute(
      path: '/games/:gameId/counting-templates/select',
      name: 'counting-templates-select',
      builder: (BuildContext context, GoRouterState state) =>
          GamesCountingTemplatesSelectScreen(
            gameId: int.parse(state.pathParameters['gameId']!),
          ),
    ),
    GoRoute(
      path:
          '/games/:gameId/counting-templates/:gamesCountingTemplatesId/update',
      name: 'counting-templates-update',
      builder: (BuildContext context, GoRouterState state) =>
          GamesCountingTemplatesModalForm(
            gameId: int.parse(state.pathParameters['gameId']!),
            gamesCountingTemplatesId: int.parse(
              state.pathParameters['gamesCountingTemplatesId']!,
            ),
          ),
    ),

    // Игровые сессии
    GoRoute(
      path: '/gaming-sessions',
      name: 'gaming-sessions-list',
      builder: (BuildContext context, GoRouterState state) {
        final gameId = int.tryParse(state.uri.queryParameters['gameId'] ?? '');

        return GamingSessionListScreen(gameId: gameId);
      },
    ),
    GoRoute(
      path: '/gaming-sessions/add',
      name: 'gaming-sessions-add',
      builder: (BuildContext context, GoRouterState state) =>
          GamingSessionFormScreen(),
    ),
    GoRoute(
      path: '/gaming-sessions/:gamingSessionId',
      name: 'gaming-sessions-detail',
      builder: (BuildContext context, GoRouterState state) =>
          GamingSessionDetailScreen(
            gamingSessionId: int.parse(
              state.pathParameters['gamingSessionId']!,
            ),
          ),
    ),
    GoRoute(
      path: '/gaming-sessions/:gamingSessionId/update',
      name: 'gaming-sessions-update',
      builder: (BuildContext context, GoRouterState state) =>
          GamingSessionFormScreen(
            gamingSessionId: int.parse(
              state.pathParameters['gamingSessionId']!,
            ),
          ),
    ),

    // Шаблоны
    GoRoute(
      path: '/templates',
      name: 'templates-list',
      builder: (BuildContext context, GoRouterState state) =>
          const CountingTemplateListScreen(),
    ),
    GoRoute(
      path: '/templates/add',
      name: 'templates-add',
      builder: (BuildContext context, GoRouterState state) =>
          CountingTemplateFormScreen(),
    ),
    GoRoute(
      path: '/templates/:templateId',
      name: 'templates-detail',
      builder: (BuildContext context, GoRouterState state) =>
          CountingTemplateDetailScreen(
            templateId: int.parse(state.pathParameters['templateId']!),
          ),
    ),
    GoRoute(
      path: '/templates/:templateId/update',
      name: 'templates-update',
      builder: (BuildContext context, GoRouterState state) =>
          CountingTemplateFormScreen(
            templateId: int.parse(state.pathParameters['templateId']!),
          ),
    ),

    // Геймдизайнеры
    GoRoute(
      path: '/designers',
      name: 'designers',
      builder: (BuildContext context, GoRouterState state) =>
          DesignersListScreen(),
    ),

    // Художники
    GoRoute(
      path: '/artists',
      name: 'artists',
      builder: (BuildContext context, GoRouterState state) =>
          ArtistsListScreen(),
    ),

    // Метки
    GoRoute(
      path: '/tags',
      name: 'tags',
      builder: (BuildContext context, GoRouterState state) => TagsListScreen(),
    ),

    // Игровая сессия
    GoRoute(
      path: '/session-runner',
      name: 'session-runner',
      builder: (BuildContext context, GoRouterState state) =>
          StepWizardScreen(),
    ),

    // Каунтеры
    GoRoute(
      path: '/counters',
      name: 'counters',
      builder: (BuildContext context, GoRouterState state) => CountersScreen(),
    ),

    // Рандомайзер
    GoRoute(
      path: '/randomizer',
      name: 'randomizer',
      builder: (BuildContext context, GoRouterState state) =>
          SelectionRandomizerScreen(),
    ),
    GoRoute(
      path: '/randomizer/number',
      name: 'randomizer-number',
      builder: (BuildContext context, GoRouterState state) =>
          RandomNumberScreen(),
    ),
    GoRoute(
      path: '/randomizer/players',
      name: 'randomizer-players',
      builder: (BuildContext context, GoRouterState state) =>
          RandomPlayersScreen(),
    ),
    GoRoute(
      path: '/randomizer/games',
      name: 'randomizer-games',
      builder: (BuildContext context, GoRouterState state) =>
          RandomGamesScreen(),
    ),
    GoRoute(
      path: '/randomizer/dice',
      name: 'randomizer-dice',
      builder: (BuildContext context, GoRouterState state) =>
          RandomDiceScreen(),
    ),
    GoRoute(
      path: '/randomizer/fate',
      name: 'randomizer-fate',
      builder: (BuildContext context, GoRouterState state) =>
          RandomFateScreen(),
    ),
    GoRoute(
      path: '/randomizer/coin',
      name: 'randomizer-coin',
      builder: (BuildContext context, GoRouterState state) =>
          RandomCoinScreen(),
    ),
    GoRoute(
      path: '/randomizer/touch',
      name: 'randomizer-touch',
      builder: (BuildContext context, GoRouterState state) =>
          RandomTouchScreen(),
    ),

    // Статистика
    GoRoute(
      path: '/statistics',
      name: 'statistics',
      builder: (BuildContext context, GoRouterState state) =>
          StatisticsMainScreen(),
    ),
    GoRoute(
      path: '/statistics/session',
      name: 'statistics-session',
      builder: (BuildContext context, GoRouterState state) =>
          SessionsStatisticsScreen(),
    ),
    GoRoute(
      path: '/statistics/win-rate',
      name: 'statistics-win-rate',
      builder: (BuildContext context, GoRouterState state) => WinRateScreen(),
    ),
    GoRoute(
      path: '/statistics/game',
      name: 'statistics-game',
      builder: (BuildContext context, GoRouterState state) => GameStatsScreen(),
    ),

    // ТОП
    GoRoute(
      path: '/top',
      name: 'top',
      builder: (BuildContext context, GoRouterState state) => TopMainScreen(),
    ),
    GoRoute(
      path: '/top/add',
      name: 'top-add',
      builder: (BuildContext context, GoRouterState state) => TopInitScreen(),
    ),
    GoRoute(
      path: '/top/process',
      name: 'top-process',
      builder: (BuildContext context, GoRouterState state) => RankingScreen(),
    ),
    GoRoute(
      path: '/top/common',
      name: 'top-common',
      builder: (BuildContext context, GoRouterState state) =>
          CommonTopListScreen(),
    ),
    GoRoute(
      path: '/top/artists',
      name: 'top-artists',
      builder: (BuildContext context, GoRouterState state) =>
          ByArtistsTopListScreen(),
    ),
    GoRoute(
      path: '/top/designers',
      name: 'top-designers',
      builder: (BuildContext context, GoRouterState state) =>
          ByDesignersTopListScreen(),
    ),
    GoRoute(
      path: '/top/tags',
      name: 'top-tags',
      builder: (BuildContext context, GoRouterState state) =>
          ByTagsTopListScreen(),
    ),
    GoRoute(
      path: '/top/games',
      name: 'top-games',
      builder: (BuildContext context, GoRouterState state) =>
          RatingGamesListScreen(),
    ),
  ],
);
