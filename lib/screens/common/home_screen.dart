import 'package:bg_tools/core/database/app_database.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:bg_tools/core/consts.dart';
import 'package:bg_tools/core/providers/database_providers.dart';


class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late final Gamer? owner;
  // Загрузка
  bool _isLoading = false;

  @override
  void initState() {
    _isLoading = true;
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final gamerDao = ref.read(gamerDaoProvider);
    owner = await gamerDao.getOwner();
    
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text(appName),
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Кидаем кубы...'),
            ],
          ),
        ),
      );
    }

    final ButtonStyle btnStyle = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 30),
      foregroundColor: Colors.black,
      backgroundColor: Colors.grey,
      fixedSize: Size(350, 50),
      iconSize: 30,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(appName),
        actions: [
          IconButton(
            icon: Icon(Icons.face),
            onPressed: () => {context.pushNamed(
              'gamers-update', pathParameters: {'gamerId': owner!.id.toString()}
            )},
            tooltip: 'Профиль',
          ),
          // Меню
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text('Настройки'),
                onTap: () => (),
              ),
            ],
          )
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
              onPressed: () => {},
              style: btnStyle,
              label: Text('История партий'),
              icon: const Icon(Icons.assignment),
            ),
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
              icon: const Icon(Icons.border_color),
            ),
          ],
        ),
      ),
    );
  }
}
