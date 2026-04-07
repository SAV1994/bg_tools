import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:bg_tools/core/consts.dart';
import 'package:bg_tools/core/database/app_database.dart';
import 'package:bg_tools/core/providers/database_providers.dart';

class GamesListScreen extends ConsumerWidget {
  const GamesListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameDao = ref.watch(gameDaoProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Настольные игры'),
        actions: [
          IconButton(
            onPressed: () => {context.pushNamed('games-add')},
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
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: Icon(Icons.article),
                  title: Text(game.title),
                  subtitle: Text('Нажмите для перехода'),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {},
                )
              );
            }
          );
        },
      )
      
    );
  }
}
