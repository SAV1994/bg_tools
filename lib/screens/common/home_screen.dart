import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:bg_tools/core/consts.dart';
import 'package:bg_tools/core/database/app_database.dart';
import 'package:bg_tools/core/providers/data_providers.dart';
import 'package:bg_tools/core/utils/loading_screen_builder.dart';
import 'package:bg_tools/core/widgets/import.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late final Gamer? owner;

  @override
  Widget build(BuildContext context) {
    final sessionDataAsync = ref.watch(sessionDataProvider);
    final ownerAsync = ref.watch(ownerDataProvider);

    final ButtonStyle btnStyle = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 30),
      foregroundColor: textColor,
      backgroundColor: secondColor,
      side: const BorderSide(color: borderColor, width: 1.5),
      fixedSize: Size(350, 50),
      iconSize: 30,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(appName),
        actions: [
          ownerAsync.when(
            data: (owner) {
              return IconButton(
                icon: Icon(Icons.face),
                onPressed: () => {
                  context.pushNamed(
                    'gamers-update',
                    pathParameters: {'gamerId': owner!.id.toString()},
                  ),
                },
                tooltip: 'Профиль',
              );
            },
            loading: () => buildLoadingScreen(),
            error: (error, _) => Text('Ошибка'),
          ),

          if (sessionDataAsync.value != null)
            IconButton(
              icon: Icon(Icons.play_arrow),
              onPressed: () => {context.pushNamed('session-runner')},
              tooltip: 'Продолжить сессию',
            ),

          // Меню
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text('Выйти'),
                onTap: () => SystemNavigator.pop(),
              ),
            ],
          ),
        ],
      ),
      body: Center(
        child: Column(
          spacing: 16,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () => {context.pushNamed('games-list')},
              style: btnStyle,
              label: Text('Настольные игры'),
              icon: const Icon(Icons.layers),
            ),
            ElevatedButton.icon(
              onPressed: () => {context.pushNamed('gamers-list')},
              style: btnStyle,
              label: Text('Список игроков'),
              icon: const Icon(Icons.wc),
            ),
            ElevatedButton.icon(
              onPressed: () => {context.pushNamed('gaming-sessions-list')},
              style: btnStyle,
              label: Text('История партий'),
              icon: const Icon(Icons.assignment),
            ),
            ElevatedButton.icon(
              onPressed: () => {context.pushNamed('templates-list')},
              style: btnStyle,
              label: Text('Шаблоны партий'),
              icon: const Icon(Icons.build),
            ),
            // ElevatedButton.icon(
            //   onPressed: () => {},
            //   style: btnStyle,
            //   label: Text('Статистика'),
            //   icon: const Icon(Icons.trending_up),
            // ),
            // ElevatedButton.icon(
            //   onPressed: () => {},
            //   style: btnStyle,
            //   label: Text('Мой рейтинг игр'),
            //   icon: const Icon(Icons.favorite),
            // ),
            ElevatedButton.icon(
              onPressed: () => {context.pushNamed('tags')},
              style: btnStyle,
              label: Text('Метки категорий'),
              icon: const Icon(Icons.location_on),
            ),
            ElevatedButton.icon(
              onPressed: () => {context.pushNamed('designers')},
              style: btnStyle,
              label: Text('Геймдизайнеры'),
              icon: const Icon(Icons.account_balance),
            ),
            ElevatedButton.icon(
              onPressed: () => {context.pushNamed('artists')},
              style: btnStyle,
              label: Text('Художники'),
              icon: const Icon(Icons.color_lens),
            ),
            BackupButtons(),
          ],
        ),
      ),
    );
  }
}
