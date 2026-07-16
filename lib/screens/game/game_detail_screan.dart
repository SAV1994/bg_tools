import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:bg_tools/core/consts/export.dart';
import 'package:bg_tools/core/database/app_database.dart';
import 'package:bg_tools/core/dataclasses/game_dataclasses.dart';
import 'package:bg_tools/core/dataclasses/games_counting_templates_dataclasses.dart';
import 'package:bg_tools/core/providers/data_providers.dart';
import 'package:bg_tools/core/providers/database_providers.dart';
import 'package:bg_tools/core/providers/paginated_providers/game_provider.dart';
import 'package:bg_tools/core/utils/confirm_del_modal_builder.dart';
import 'package:bg_tools/core/utils/error_screen_builder.dart';
import 'package:bg_tools/core/utils/export.dart';
import 'package:bg_tools/core/utils/loading_screen_builder.dart';
import 'package:bg_tools/core/widgets/export.dart';
import 'package:bg_tools/features/session_runner/services/session_data_initializer.dart';
import 'package:bg_tools/screens/game/mixins/update_is_favorite.dart';

class GamesDetailScreen extends ConsumerStatefulWidget {
  final int gameId;

  const GamesDetailScreen({super.key, required this.gameId});

  @override
  ConsumerState<GamesDetailScreen> createState() => _GamesDetailScreenState();
}

class _GamesDetailScreenState extends ConsumerState<GamesDetailScreen>
    with UpdateIsFaforiteMixin {
  Future<void> _openNewScreen(String pathName) async {
    await context.pushNamed(
      pathName,
      pathParameters: {'gameId': widget.gameId.toString()},
    );

    ref.invalidate(gameFullDataProvider); // Обновляем провайдер
  }

  Future<void> _runSession() async {
    final gamesCountingTemplatesDao = ref.read(
      gamesCountingTemplatesDaoProvider,
    );
    List<GamesCountingTemplatesData> templatesData =
        await gamesCountingTemplatesDao.getAll(widget.gameId);
    await initSessionData(templatesData[0]);

    ref.invalidate(sessionDataProvider);

    if (mounted) {
      await context.pushNamed('session-runner');
      ref.invalidate(gameFullDataProvider); // Обновляем провайдер
    }
  }

  Widget _buildError(BuildContext context, Object error, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red.shade300),
          const SizedBox(height: 16),
          Text(
            'Ошибка загрузки',
            style: TextStyle(fontSize: 18, color: Colors.grey.shade700),
          ),
          const SizedBox(height: 8),
          Text(
            error.toString(),
            style: TextStyle(color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              ref.invalidate(gameFullDataProvider(widget.gameId));
            },
            child: const Text('Повторить'),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, GameFullData data) {
    final Game game = data.game;
    final List<Game> bases = data.bases;
    final List<Designer> designers = data.designers;
    final List<Artist> artists = data.artists;
    final List<Tag> tags = data.tags;
    final List<Game> expansions = data.expansions;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Заголовок с именем
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  ClipRRect(
                    child: game.imagePath != null
                        ? Image.file(
                            File(game.imagePath!),
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            width: 100,
                            height: 100,
                            color: Colors.grey.shade300,
                            child: const Icon(
                              Icons.image_not_supported,
                              size: 40,
                              color: Colors.grey,
                            ),
                          ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          game.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      game.isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: game.isFavorite ? goldColor : borderColor,
                    ),
                    onPressed: () => updateIsFavorite(game),
                  ),
                ],
              ),
            ),
          ),
          // Основная информация
          const Text(
            'Основная информация',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  InfoRow(label: 'Год', value: game.year, isFirst: true),
                  InfoRow(
                    label: 'Минимальное количество игроков',
                    value: game.minPlayers?.toString(),
                  ),
                  InfoRow(
                    label: 'Максимальное количество игроков',
                    value: game.maxPlayers?.toString(),
                  ),
                  InfoRow(
                    label: 'Наличие в коллекции',
                    value: convertBoolToStr(game.isInCollection),
                  ),
                  InfoRow(
                    label: 'Самодостаточность',
                    value: convertBoolToStr(game.isStandalone),
                  ),
                  InfoRow(
                    label: 'Рейтинг',
                    value: ([null, 0.0].contains(game.rating))
                        ? 'Неизвестно'
                        : game.rating.toString(),
                  ),
                  InfoRow(label: 'Описание', value: game.description),
                ],
              ),
            ),
          ),
          _buildMultiValCard('Базовая игра', Icons.layers, bases),
          _buildMultiValCard('Дополнения', Icons.layers, expansions),
          _buildMultiValCard('Геймдизайнеры', Icons.account_balance, designers),
          _buildMultiValCard('Художники', Icons.border_color, artists),
          _buildMultiValCard('Метки категорий', Icons.location_on, tags),
        ],
      ),
    );
  }

  Widget _buildMultiValCard(String title, IconData icon, List items) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Card(
          child: items.isEmpty
              ? const Padding(
                  padding: EdgeInsets.all(32),
                  child: Center(child: Text(emptyVal)),
                )
              : ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: items.length,
                  separatorBuilder: (_, _) => const Divider(),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return ListTile(
                      leading: Icon(icon),
                      title: Text(item.name),
                    );
                  },
                ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final gameAsync = ref.watch(gameFullDataProvider(widget.gameId));

    return gameAsync.when(
      data: (data) {
        if (data != null) {
          final Game game = data.game;
          final int templatesCount = data.templatesCount;

          return Scaffold(
            appBar: AppBar(
              title: Text('Игра'),
              actions: [
                // Кнопка редактирования
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () async {
                    _openNewScreen('games-update');
                  },
                ),
                // Кнопка настройки шаблонов
                IconButton(
                  icon: const Icon(Icons.build),
                  onPressed: () async {
                    _openNewScreen('counting-templates-list');
                  },
                ),
                // Кнопка запуска партии
                if (templatesCount > 0)
                  IconButton(
                    icon: (templatesCount == 1)
                        ? Icon(Icons.play_arrow)
                        : Icon(Icons.play_arrow_outlined),
                    onPressed: () async {
                      (templatesCount == 1)
                          ? _runSession()
                          : _openNewScreen('counting-templates-select');
                    },
                  ),
                // Заметки
                IconButton(
                  icon: const Icon(Icons.note),
                  onPressed: () {
                    context.pushNamed(
                      'notes-list',
                      pathParameters: {
                        'gameId': gameAsync.value!.game.id.toString(),
                      },
                    );
                  },
                ),
                // Кнопка удаления
                IconButton(
                  icon: const Icon(Icons.delete_outlined),
                  onPressed: () {
                    buildDelModal(
                      context,
                      ref,
                      gameDaoProvider,
                      mounted,
                      game,
                      () {
                        ref.invalidate(gamingSessionFullDataProvider);
                        ref.read(gamesPaginatedProvider.notifier).refresh();
                      },
                    );
                  },
                ),
              ],
            ),
            body: _buildContent(context, data),
          );
        } else {
          return buildErrorScreen();
        }
      },
      loading: () => buildLoadingScreen(),
      error: (error, _) => _buildError(context, error, ref),
    );
  }
}
