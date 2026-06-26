import 'dart:io';

import 'package:bg_tools/core/dataclasses/games_counting_templates_dataclasses.dart';
import 'package:bg_tools/features/session_runner/services/session_data_initializer.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:bg_tools/core/consts.dart';
import 'package:bg_tools/core/database/app_database.dart';
import 'package:bg_tools/core/dataclasses/game_dataclasses.dart';
import 'package:bg_tools/core/providers/data_providers.dart';
import 'package:bg_tools/core/providers/database_providers.dart';
import 'package:bg_tools/core/utils/checkbox_view_builder.dart';
import 'package:bg_tools/core/utils/confirm_del_modal_builder.dart';
import 'package:bg_tools/core/utils/error_screen_builder.dart';
import 'package:bg_tools/core/utils/loading_screen_builder.dart';

class GamesDetailScreen extends ConsumerStatefulWidget {
  final int gameId;

  const GamesDetailScreen({super.key, required this.gameId});

  @override
  ConsumerState<GamesDetailScreen> createState() => _GamesDetailScreenState();
}

class _GamesDetailScreenState extends ConsumerState<GamesDetailScreen> {
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

  Widget _buildInfoRow(String label, String? value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(label, style: TextStyle(color: titleColor)),
          ),
          Expanded(
            child: Text(
              value ?? emptyVal,
              style: TextStyle(fontWeight: FontWeight.w500, color: valueColor),
            ),
          ),
        ],
      ),
    );
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
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
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
                  _buildInfoRow('Описание', game.description),
                  const Divider(),
                  _buildInfoRow('Год', game.year),
                  const Divider(),
                  _buildInfoRow(
                    'Минимальное количество игроков',
                    game.minPlayers?.toString(),
                  ),
                  const Divider(),
                  _buildInfoRow(
                    'Максимальное количество игроков',
                    game.maxPlayers?.toString(),
                  ),
                  const Divider(),
                  ListTile(
                    title: Text('Наличие в коллекции'),
                    trailing: buildCheckboxView(game.isInCollection),
                  ),
                  const Divider(),
                  _buildInfoRow('Описание', game.description),
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
                  separatorBuilder: (_, __) => const Divider(),
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
                      () => {ref.invalidate(gamingSessionFullDataProvider)},
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
