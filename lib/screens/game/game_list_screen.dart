import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:bg_tools/core/consts.dart';
import 'package:bg_tools/core/providers/data_providers.dart';
import 'package:bg_tools/core/providers/database_providers.dart';
import 'package:bg_tools/core/utils/empty_list_screen_builder.dart';
import 'package:bg_tools/core/utils/loading_screen_builder.dart';

class GamesListScreen extends ConsumerStatefulWidget {
  const GamesListScreen({super.key});

  @override
  ConsumerState<GamesListScreen> createState() => _GamesListScreenState();
}

class _GamesListScreenState extends ConsumerState<GamesListScreen> {
  Future<void> _openAddForm() async {
    final result = await context.pushNamed('games-add');

    if (result == true) {
      ref.invalidate(gameDaoProvider); // Обновляем провайдер
      setState(() {});
    }
  }

  Future<void> _openDetailPage(int gameId) async {
    final result = await context.pushNamed(
      'games-detail',
      pathParameters: {'gameId': gameId.toString()},
    );
    ;

    if (result == true) {
      ref.invalidate(gameDaoProvider); // Обновляем провайдер
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final gamesAsync = ref.watch(gamesDataProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Настольные игры'),
        actions: [
          IconButton(
            onPressed: () => {_openAddForm()},
            icon: Icon(Icons.add_box),
          ),
        ],
      ),
      body: gamesAsync.when(
        data: (games) {
          // Если данных нет
          if (games.isEmpty) {
            return buildEmptyListScreen();
          }

          return ListView.builder(
            itemCount: games.length,
            itemBuilder: (context, index) {
              final game = games[index];

              String gameInfo = game.isInCollection ? '🟢' : '🔴';

              if (game.minPlayers == null && game.maxPlayers == null) {
                gameInfo += emptyVal;
              } else if (game.maxPlayers == null) {
                gameInfo += ' (от ${game.minPlayers} игроков)';
              } else if (game.minPlayers == null) {
                gameInfo += ' (до ${game.maxPlayers} игроков)';
              } else {
                gameInfo +=
                    ' (${game.minPlayers} - ${game.maxPlayers} игроков)';
              }

              return Card(
                child: ListTile(
                  leading: Icon(Icons.layers, color: borderColor),
                  title: Text(game.name),
                  subtitle: Text(gameInfo),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    _openDetailPage(game.id);
                  },
                ),
              );
            },
          );
        },
        loading: () => buildLoadingScreen(),
        error: (err, _) => Text('ОШИБКА'),
      ),
    );
  }
}
