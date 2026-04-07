import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:bg_tools/core/consts.dart';
import 'package:bg_tools/core/database/app_database.dart';
import 'package:bg_tools/core/providers/database_providers.dart';

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
    final result = await context.pushNamed('games-detail', pathParameters: {'gameId': gameId.toString()});;
    
    if (result == true) {
      ref.invalidate(gameDaoProvider); // Обновляем провайдер
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final gameDao = ref.watch(gameDaoProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Настольные игры'),
        actions: [
          IconButton(
            onPressed: () => {_openAddForm()},
            icon: Icon(Icons.add_box),
          )
        ],
      ),
      body: FutureBuilder<List<Game>> (
        future: gameDao.getAll(),
        builder: (context, snapshot) {
          // Показываем индикатор загрузки
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          
          // Обрабатываем ошибки
          if (snapshot.hasError) {
            return Center(child: Text('Ошибка: ${snapshot.error}'));
          }
          
          // Если данных нет
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text(emptyListMsg));
          }
          
          // Получаем данные
          final games = snapshot.data!;

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
                gameInfo += ' (${game.minPlayers} - ${game.maxPlayers} игроков)';
              }

              return Card(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: Icon(Icons.layers),
                  title: Text(game.name),
                  subtitle: Text(gameInfo),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {_openDetailPage(game.id);},
                )
              );
            }
          );
        },
      )
      
    );
  }
}
