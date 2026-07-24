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
import 'package:bg_tools/core/providers/paginated_providers/export.dart';
import 'package:bg_tools/core/utils/export.dart';
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
                  InfoRow(
                    label: 'Наличие в коллекции',
                    value: convertBoolToStr(game.isInCollection),
                    isFirst: true,
                  ),
                  if (game.year != null)
                    InfoRow(label: 'Год', value: game.year),
                  if (game.minPlayers != null)
                    InfoRow(
                      label: 'Минимальное количество игроков',
                      value: game.minPlayers.toString(),
                    ),
                  if (game.maxPlayers != null)
                    InfoRow(
                      label: 'Максимальное количество игроков',
                      value: game.maxPlayers.toString(),
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
                  if (game.description != null && game.description!.isNotEmpty)
                    InfoRow(label: 'Описание', value: game.description),
                ],
              ),
            ),
          ),

          if (bases.isNotEmpty)
            _buildMultiValCard('Базовая игра', Icons.layers, bases, (gameId) {
              context.pushNamed(
                'games-detail',
                pathParameters: {'gameId': gameId.toString()},
              );
            }),
          if (expansions.isNotEmpty)
            _buildMultiValCard('Дополнения', Icons.layers, expansions, (
              gameId,
            ) {
              context.pushNamed(
                'games-detail',
                pathParameters: {'gameId': gameId.toString()},
              );
            }),
          if (designers.isNotEmpty)
            _buildMultiValCard(
              'Геймдизайнеры',
              Icons.account_balance,
              designers,
              (designerId) {
                final notifier = ref.read(gamesPaginatedProvider.notifier);
                notifier.filterByDesigner(designerId);
                context.pushNamed(
                  'games-list',
                  queryParameters: {'designerId': designerId.toString()},
                );
              },
            ),
          if (artists.isNotEmpty)
            _buildMultiValCard('Художники', Icons.border_color, artists, (
              artistId,
            ) {
              final notifier = ref.read(gamesPaginatedProvider.notifier);
              notifier.filterByArtist(artistId);
              context.pushNamed(
                'games-list',
                queryParameters: {'artistId': artistId.toString()},
              );
            }),
          if (tags.isNotEmpty)
            _buildMultiValCard('Метки категорий', Icons.location_on, tags, (
              tagId,
            ) {
              final notifier = ref.read(gamesPaginatedProvider.notifier);
              notifier.filterByTag(tagId);
              context.pushNamed(
                'games-list',
                queryParameters: {'tagId': tagId.toString()},
              );
            }),
        ],
      ),
    );
  }

  Widget _buildMultiValCard(
    String title,
    IconData icon,
    List items,
    Function onTap,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
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
        Wrap(
          alignment: WrapAlignment.start,
          spacing: 8,
          runSpacing: 8,
          children: items.map((item) {
            return GestureDetector(
              onTap: () => onTap(item.id),
              child: Chip(
                label: Text(item.name, style: TextStyle(color: goldColor)),

                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            );
          }).toList(),
        ),
        SizedBox(height: 8),
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
                    final notifier = ref.read(
                      gamesCountingTemplatesPaginatedProvider.notifier,
                    );
                    notifier.filterByGame(game.id);

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
                      if (templatesCount == 1) {
                        _runSession();
                      } else {
                        final notifier = ref.read(
                          gamesCountingTemplatesPaginatedProvider.notifier,
                        );
                        notifier.filterByGame(game.id);

                        _openNewScreen('counting-templates-select');
                      }
                    },
                  ),
                // Заметки
                IconButton(
                  icon: const Icon(Icons.note),
                  onPressed: () {
                    final notifier = ref.read(notesPaginatedProvider.notifier);
                    notifier.filterByGame(game.id);

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
          return ErrorNotification();
        }
      },
      loading: () => LoadingScreen(),
      error: (error, _) => _buildError(context, error, ref),
    );
  }
}
