import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import 'package:bg_tools/features/session_runner/step_wizard.dart';
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
      builder: (BuildContext context, GoRouterState state) =>
          const GamesListScreen(),
    ),
    GoRoute(
      path: '/games/add',
      name: 'games-add',
      builder: (BuildContext context, GoRouterState state) => GamesFormScreen(),
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
      builder: (BuildContext context, GoRouterState state) =>
          const GamingSessionListScreen(),
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
  ],
);
