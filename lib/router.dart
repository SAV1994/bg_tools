import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import 'package:bg_tools/screens/screens_exports.dart';


final GoRouter goRouter = GoRouter(
  initialLocation: '/',
  routes: <RouteBase>[
    // Главный экран
    GoRoute(
      path: '/',
      name: 'home',
      builder: (BuildContext context, GoRouterState state) => const HomeScreen(),
    ),
    
    // Игроки
    GoRoute(
      path: '/gamers', 
      name: 'gamers-list',
      builder: (BuildContext context, GoRouterState state) => const GamersListScreen(),
    ),
    GoRoute(
      path: '/gamers/add',
      name: 'gamers-add',
      builder: (BuildContext context, GoRouterState state) => GamersFormScreen(),
    ),
     GoRoute(
      path: '/gamers/:gamerId',
      name: 'gamers-update',
      builder: (BuildContext context, GoRouterState state) => GamersFormScreen(gamerId: int.parse(state.pathParameters['gamerId']!)),
    ),

    // Настольные игры
    GoRoute(
      path: '/games', 
      name: 'games-list',
      builder: (BuildContext context, GoRouterState state) => const GamesListScreen(),
    ),
    GoRoute(
      path: '/games/add',
      name: 'games-add',
      builder: (BuildContext context, GoRouterState state) => GamesFormScreen(),
    ),
    GoRoute(
      path: '/games/:gameId', 
      name: 'games-detail',
      builder: (BuildContext context, GoRouterState state) => GamesDetailScreen(gameId: int.parse(state.pathParameters['gameId']!)),
    ),
    GoRoute(
      path: '/games/:gameId/update', 
      name: 'games-update',
      builder: (BuildContext context, GoRouterState state) => GamesFormScreen(gameId: int.parse(state.pathParameters['gameId']!)),
    ),

    // Игровые сессии
    // GoRoute(
    //   path: '/gaming-session', 
    //   name: 'gaming-session-list',
    //   builder: (BuildContext context, GoRouterState state) => const GamingSessionListScreen(),
    // ),
    // GoRoute(
    //   path: '/gaming-session/add',
    //   name: 'gaming-session-add',
    //   builder: (BuildContext context, GoRouterState state) => GamingSessionFormScreen(),
    // ),
    // GoRoute(
    //   path: '/gaming-session/:gamingSessionId', 
    //   name: 'gaming-session-detail',
    //   builder: (BuildContext context, GoRouterState state) => GamingSessionDetailScreen(gamingSessionId: int.parse(state.pathParameters['gamingSessionId']!)),
    // ),
    // GoRoute(
    //   path: '/gaming-session/:gamingSessionId/update', 
    //   name: 'gaming-session-update',
    //   builder: (BuildContext context, GoRouterState state) => GamingSessionFormScreen(gamingSessionId: int.parse(state.pathParameters['gamingSessionId']!)),
    // ),

    // Геймдизайнеры
    GoRoute(
      path: '/designers',
      name: 'designers',
      builder: (BuildContext context, GoRouterState state) => DesignersListScreen(),
    ),

    // Художники
    GoRoute(
      path: '/artists',
      name: 'artists',
      builder: (BuildContext context, GoRouterState state) => ArtistsListScreen(),
    ),

    // Метки
    GoRoute(
      path: '/tags',
      name: 'tags',
      builder: (BuildContext context, GoRouterState state) => TagsListScreen(),
    ),
  ],
);
