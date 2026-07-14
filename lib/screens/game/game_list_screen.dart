import 'package:bg_tools/screens/game/mixins/export.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:bg_tools/core/consts.dart';
import 'package:bg_tools/core/database/app_database.dart';
import 'package:bg_tools/core/providers/database_providers.dart';
import 'package:bg_tools/core/providers/paginated_providers/game_provider.dart';
import 'package:bg_tools/core/utils/empty_list_screen_builder.dart';
import 'package:bg_tools/core/utils/loading_screen_builder.dart';

class GamesListScreen extends ConsumerStatefulWidget {
  const GamesListScreen({super.key});

  @override
  ConsumerState<GamesListScreen> createState() => _GamesListScreenState();
}

class _GamesListScreenState extends ConsumerState<GamesListScreen>
    with UpdateIsFaforiteMixin {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  bool _isSearchOpen = false;

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

    if (result == true) {
      ref.invalidate(gameDaoProvider); // Обновляем провайдер
      setState(() {});
    }
  }

  Widget _buildPaginationPanel(GamesNotifier notifier) {
    final int lastItemNum =
        (notifier.currentPage + 1) * notifier.pageSize > notifier.totalItems
        ? notifier.totalItems
        : (notifier.currentPage + 1) * notifier.pageSize;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: secondColor,
        boxShadow: [BoxShadow(blurRadius: 4, offset: const Offset(0, -2))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Информация
          Text(
            '${notifier.currentPage * notifier.pageSize + 1}-$lastItemNum из ${notifier.totalItems}',
            style: const TextStyle(fontSize: 12, color: goldColor),
          ),

          // Навигация
          Row(
            children: [
              // Первая страница
              IconButton(
                icon: Icon(
                  Icons.first_page,
                  size: 20,
                  color: notifier.hasPrevious ? goldColor : redColor,
                ),
                onPressed: notifier.hasPrevious
                    ? () => notifier.goToPage(0)
                    : null,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              // Назад
              IconButton(
                icon: Icon(
                  Icons.chevron_left,
                  size: 24,
                  color: notifier.hasPrevious ? goldColor : redColor,
                ),
                onPressed: notifier.hasPrevious
                    ? () => notifier.goToPage(notifier.currentPage - 1)
                    : null,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),

              // Индикатор страницы
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(color: goldColor),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    Text(
                      '${notifier.currentPage + 1}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: goldColor,
                      ),
                    ),
                    const Text(
                      ' / ',
                      style: TextStyle(fontSize: 14, color: goldColor),
                    ),
                    Text(
                      '${notifier.totalPages}',
                      style: const TextStyle(fontSize: 14, color: goldColor),
                    ),
                  ],
                ),
              ),

              // Вперед
              IconButton(
                icon: Icon(
                  Icons.chevron_right,
                  size: 24,
                  color: notifier.hasNext ? goldColor : redColor,
                ),
                onPressed: notifier.hasNext
                    ? () => notifier.goToPage(notifier.currentPage + 1)
                    : null,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              // Последняя страница
              IconButton(
                icon: Icon(
                  Icons.last_page,
                  size: 20,
                  color: notifier.hasNext ? goldColor : redColor,
                ),
                onPressed: notifier.hasNext
                    ? () => notifier.goToPage(notifier.totalPages - 1)
                    : null,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gamesAsync = ref.watch(gamesPaginatedProvider);
    final notifier = ref.read(gamesPaginatedProvider.notifier);

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        notifier.reset();
      },
      child: Scaffold(
        appBar: AppBar(
          title: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: _isSearchOpen
                ? TextField(
                    controller: _searchController,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: 'Поиск игр...',
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: textColor),
                      contentPadding: const EdgeInsets.symmetric(),
                    ),
                    style: const TextStyle(color: textColor),
                    onChanged: (value) => notifier.search(value),
                  )
                : const Text('Игры'),
          ),
          actions: [
            IconButton(
              icon: Icon(
                _isSearchOpen ? Icons.close : Icons.search,
                color: _isSearchOpen ? redColor : borderColor,
              ),
              onPressed: () {
                setState(() {
                  if (_isSearchOpen) {
                    _searchController.clear();
                    notifier.search('');
                  }
                  _isSearchOpen = !_isSearchOpen;
                });
              },
            ),
            if (!_isSearchOpen) ...[
              IconButton(
                icon: Icon(
                  notifier.onlyStandalone ? Icons.photo : Icons.photo_library,
                  color: notifier.onlyStandalone ? borderColor : goldColor,
                ),
                onPressed: () => notifier.toggleOnlyStandalone(),
              ),
              IconButton(
                icon: Icon(
                  notifier.onlyFavorite
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: notifier.onlyFavorite ? goldColor : borderColor,
                ),
                onPressed: () => notifier.toggleOnlyFavorite(),
              ),
              IconButton(
                icon: Icon(
                  notifier.reverseOrdering
                      ? Icons.arrow_upward
                      : Icons.arrow_downward,
                  color: notifier.reverseOrdering ? goldColor : borderColor,
                ),
                onPressed: () => notifier.toggleOrdering(),
              ),
              IconButton(
                icon: Icon(Icons.add_box),
                onPressed: () => {_openAddForm()},
              ),
            ],
          ],
        ),
        body: Column(
          children: [
            // Список
            Expanded(
              child: gamesAsync.when(
                data: (games) {
                  // Если данных нет
                  if (games.isEmpty) {
                    return buildEmptyListScreen();
                  }
                  return Scrollbar(
                    controller: _scrollController,
                    thumbVisibility: true,
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: games.length,
                      itemBuilder: (context, index) {
                        final Game game = games[index];

                        String gameInfo = game.isInCollection ? '🟢' : '🔴';

                        if (game.minPlayers == null &&
                            game.maxPlayers == null) {
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
                            leading: IconButton(
                              icon: Icon(
                                game.isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: game.isFavorite
                                    ? goldColor
                                    : borderColor,
                              ),
                              onPressed: () => updateIsFavorite(game),
                            ),
                            title: Text(
                              game.name,
                              style: TextStyle(
                                color: game.isStandalone
                                    ? textColor
                                    : goldColor,
                              ),
                            ),
                            subtitle: Text(gameInfo),
                            trailing: Icon(Icons.arrow_forward_ios),
                            onTap: () {
                              _openDetailPage(game.id);
                            },
                          ),
                        );
                      },
                    ),
                  );
                },
                loading: () => buildLoadingScreen(),
                error: (err, _) => Text('ОШИБКА'),
              ),
            ),
            // Панель пагинации (всегда внизу)
            if (gamesAsync.hasValue && gamesAsync.value!.isNotEmpty)
              _buildPaginationPanel(notifier),
          ],
        ),
      ),
    );
  }
}
