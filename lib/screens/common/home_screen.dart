import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_exit_app/flutter_exit_app.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:bg_tools/core/consts/export.dart';
import 'package:bg_tools/core/providers/data_providers.dart';
import 'package:bg_tools/core/providers/paginated_providers/export.dart';
import 'package:bg_tools/core/widgets/export.dart';
import 'package:bg_tools/features/export_import_service/services/export.dart';
import 'package:bg_tools/features/export_import_service/utils/export.dart';

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
                        exportIcon,
                        size: 18,
                        color: greenColor,
                      ),
                      title: const Text('Экспорт'),
                      dense: true,
                    ),
                    onTap: () =>
                        exportData(context: context, mover: AllDataMover()),
                  ),

                  PopupMenuItem(
                    child: ListTile(
                      leading: const Icon(
                        Icons.restore,
                        size: 18,
                        color: titleColor,
                      ),
                      title: const Text('Импорт'),
                      dense: true,
                    ),
                    onTap: () => importData(
                      context: context,
                      mover: AllDataMover(),
                      onSuccess: () {
                        // Обновляем провайдеры
                        ref.invalidate(countingTemplateDataProvider);
                        ref.invalidate(gameFullDataProvider);
                        ref.invalidate(ownerDataProvider);
                        ref.invalidate(gamingSessionFullDataProvider);
                        // AppDataManager
                        ref.invalidate(sessionDataProvider);
                        // AsyncNotifierProvider
                        final artistsNotifier = ref.read(
                          artistsPaginatedProvider.notifier,
                        );
                        artistsNotifier.refresh();
                        final countingTemplatesNotifier = ref.read(
                          countingTemplatesPaginatedProvider.notifier,
                        );
                        countingTemplatesNotifier.refresh();
                        final designersNotifier = ref.read(
                          designersPaginatedProvider.notifier,
                        );
                        designersNotifier.refresh();
                        final gamesNotifier = ref.read(
                          gamesPaginatedProvider.notifier,
                        );
                        gamesNotifier.refresh();
                        final gamersNotifier = ref.read(
                          gamersPaginatedProvider.notifier,
                        );
                        gamersNotifier.refresh();
                        final gamesCountingTemplatesNotifier = ref.read(
                          gamesCountingTemplatesPaginatedProvider.notifier,
                        );
                        gamesCountingTemplatesNotifier.refresh();
                        final gamingSessionsNotifier = ref.read(
                          gamingSessionsPaginatedProvider.notifier,
                        );
                        gamingSessionsNotifier.refresh();
                        final notesNotifier = ref.read(
                          notesPaginatedProvider.notifier,
                        );
                        notesNotifier.refresh();
                        final tagsNotifier = ref.read(
                          tagsPaginatedProvider.notifier,
                        );
                        tagsNotifier.refresh();
                        final ratingsNotifier = ref.read(
                          ratingsPaginatedProvider.notifier,
                        );
                        ratingsNotifier.refresh();
                        final ratingsGamesNotifier = ref.read(
                          ratingsGamesPaginatedProvider.notifier,
                        );
                        ratingsGamesNotifier.refresh();
                      },
                      warnStr:
                          'Импорт заменит все текущие данные!\n'
                          'Вы уверены, что хотите продолжить?',
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
                    onTap: () => FlutterExitApp.exitApp(),
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
                  MenuButton(
                    onPressed: () => context.pushNamed('statistics'),
                    label: 'Статистика',
                    icon: statisticsIcon,
                  ),
                  MenuButton(
                    onPressed: () => context.pushNamed('top'),
                    label: 'Мой рейтинг игр',
                    icon: topsIcon,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
