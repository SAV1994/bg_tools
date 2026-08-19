import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:bg_tools/core/consts/export.dart';
import 'package:bg_tools/core/providers/data_providers.dart';
import 'package:bg_tools/core/widgets/export.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final sessionDataAsync = ref.watch(sessionDataProvider);
    final ownerAsync = ref.watch(ownerDataProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(appName),
        actions: [
          IconButton(
            visualDensity: VisualDensity(horizontal: -4.0),
            icon: Icon(randomIcon),
            onPressed: () => context.pushNamed('randomizer'),
            tooltip: 'Рандомайзер',
          ),

          IconButton(
            visualDensity: VisualDensity(horizontal: -4.0),
            icon: Icon(countersIcon),
            onPressed: () => context.pushNamed('counters'),
            tooltip: 'Каунтеры',
          ),

          if (sessionDataAsync.value != null)
            IconButton(
              visualDensity: VisualDensity(horizontal: -4.0),
              icon: Icon(Icons.play_arrow),
              onPressed: () => {context.pushNamed('session-runner')},
              tooltip: 'Продолжить сессию',
            ),

          // Меню
          ownerAsync.when(
            data: (owner) {
              return PopupMenuButton(
                icon: Icon(Icons.more_vert),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: ListTile(
                      leading: const Icon(Icons.person, size: 18),
                      title: const Text('Профиль'),
                      dense: true,
                    ),
                    onTap: () => context.pushNamed(
                      'gamers-update',
                      pathParameters: {'gamerId': owner!.id.toString()},
                    ),
                  ),

                  PopupMenuItem(
                    child: ListTile(
                      leading: const Icon(
                        Icons.settings,
                        size: 18,
                        color: goldColor,
                      ),
                      title: const Text('Настройки'),
                      dense: true,
                    ),
                    onTap: () => context.pushNamed('settings'),
                  ),

                  PopupMenuItem(
                    child: ListTile(
                      leading: const Icon(
                        Icons.power_settings_new,
                        size: 18,
                        color: redColor,
                      ),
                      title: const Text('Выйти'),
                      dense: true,
                    ),
                    onTap: () => SystemNavigator.pop(),
                  ),
                ],
              );
            },
            loading: () => Icon(loadingIcon, color: borderColor),
            error: (error, _) => ErrorNotification(),
          ),
        ],
      ),
      body: Center(
        child: Scrollbar(
          thumbVisibility: true,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsetsGeometry.only(top: 10),
              child: Column(
                spacing: 16,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MenuButton(
                    onPressed: () => context.pushNamed('games-list'),
                    label: 'Настольные игры',
                    icon: gamesIcon,
                  ),
                  MenuButton(
                    onPressed: () => context.pushNamed('gamers-list'),
                    label: 'Список игроков',
                    icon: gamersIcon,
                  ),
                  MenuButton(
                    onPressed: () => context.pushNamed('gaming-sessions-list'),
                    label: 'История партий',
                    icon: sessionsIcon,
                  ),
                  MenuButton(
                    onPressed: () => context.pushNamed('templates-list'),
                    label: 'Шаблоны партий',
                    icon: templatesIcon,
                  ),
                  MenuButton(
                    onPressed: () => context.pushNamed('tags'),
                    label: 'Тэги категорий',
                    icon: tagsIcon,
                  ),
                  MenuButton(
                    onPressed: () => context.pushNamed('designers'),
                    label: 'Геймдизайнеры',
                    icon: designersIcon,
                  ),
                  MenuButton(
                    onPressed: () => context.pushNamed('artists'),
                    label: 'Художники',
                    icon: artistsIcon,
                  ),
                  // MenuButton(
                  //   onPressed: () => {},
                  //   label: 'Статистика',
                  //   icon: Icons.trending_up,
                  // ),
                  MenuButton(
                    onPressed: () => context.pushNamed('top'),
                    label: 'Мой рейтинг игр',
                    icon: topsIcon,
                  ),
                  BackupButtons(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
