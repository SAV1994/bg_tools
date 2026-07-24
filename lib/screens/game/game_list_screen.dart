import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:bg_tools/core/consts/export.dart';
import 'package:bg_tools/core/database/app_database.dart';
import 'package:bg_tools/core/database/daos/export.dart';
import 'package:bg_tools/core/providers/database_providers.dart';
import 'package:bg_tools/core/providers/paginated_providers/game_provider.dart';
import 'package:bg_tools/core/widgets/export.dart';
import 'package:bg_tools/screens/game/mixins/export.dart';

class GamesListScreen extends ConsumerStatefulWidget {
  final int? artistId;
  final int? designerId;
  final int? tagId;

  const GamesListScreen({
    super.key,
    this.artistId,
    this.designerId,
    this.tagId,
  });

  @override
  ConsumerState<GamesListScreen> createState() => _GamesListScreenState();
}

class _GamesListScreenState extends ConsumerState<GamesListScreen>
    with UpdateIsFaforiteMixin {
  bool _isSearchOpen = false;

  String? filterObjTitle;

  // Контроллеры
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  // Загрузка
  bool _isLoading = false;

  @override
  void initState() {
    _isLoading = true;
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    if (widget.artistId != null) {
      final ArtistDao artistDao = ref.read(artistDaoProvider);
      final Artist? artist = await artistDao.get(widget.artistId!);
      filterObjTitle = 'Художник: ${artist!.name}';
    } else if (widget.designerId != null) {
      final DesignerDao designerDao = ref.read(designerDaoProvider);
      final Designer? designer = await designerDao.get(widget.designerId!);
      filterObjTitle = 'Геймдизайнер: ${designer!.name}';
    } else if (widget.tagId != null) {
      final TagDao tagDao = ref.read(tagDaoProvider);
      final Tag? tag = await tagDao.get(widget.tagId!);
      filterObjTitle = 'Тэг: ${tag!.name}';
    }

    setState(() => _isLoading = false);
  }

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

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return LoadingScreen();
    }

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
                : filterObjTitle != null
                ? Tooltip(
                    message: filterObjTitle,
                    child: const Icon(gamesIcon, size: 25, color: goldColor),
                  )
                : Icon(gamesIcon),
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
                icon: Icon(addBtnIcon),
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
                    return EmptyListScreen();
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
                loading: () => LoadingScreen(),
                error: (err, _) => ErrorNotification(),
              ),
            ),
            // Панель пагинации (всегда внизу)
            if (gamesAsync.hasValue && gamesAsync.value!.isNotEmpty)
              PaginationPanel(notifier: notifier),
          ],
        ),
      ),
    );
  }
}
