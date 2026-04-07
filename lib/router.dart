import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import 'package:bg_tools/screens/artist_list_screen.dart';
import 'package:bg_tools/screens/designer_list_screen.dart';
import 'package:bg_tools/screens/game_add_screen.dart';
import 'package:bg_tools/screens/game_list_screen.dart';
import 'package:bg_tools/screens/home_screen.dart';
import 'package:bg_tools/screens/tag_list_screen.dart';


final GoRouter goRouter = GoRouter(
  initialLocation: '/',
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      name: 'home',
      builder: (BuildContext context, GoRouterState state) => HomeScreen(),
    ),
    GoRoute(
      path: '/games', 
      name: 'games-list',
      builder: (BuildContext context, GoRouterState state) => GamesListScreen(),
    ),
    GoRoute(
      path: '/games/add',
      name: 'games-add',
      builder: (BuildContext context, GoRouterState state) => GamesAddScreen(),
    ),
    GoRoute(
      path: '/designers',
      name: 'designers',
      builder: (BuildContext context, GoRouterState state) => DesignersListScreen(),
    ),
    GoRoute(
      path: '/artists',
      name: 'artists',
      builder: (BuildContext context, GoRouterState state) => ArtistsListScreen(),
    ),
    GoRoute(
      path: '/tags',
      name: 'tags',
      builder: (BuildContext context, GoRouterState state) => TagsListScreen(),
    ),
  ],
);
