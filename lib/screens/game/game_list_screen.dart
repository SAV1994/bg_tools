import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:bg_tools/core/consts/export.dart';
import 'package:bg_tools/core/database/app_database.dart';
import 'package:bg_tools/core/database/daos/export.dart';
import 'package:bg_tools/core/providers/database_providers.dart';
import 'package:bg_tools/core/providers/paginated_providers/game_provider.dart';
import 'package:bg_tools/core/utils/export.dart';
import 'package:bg_tools/core/widgets/export.dart';
import 'package:bg_tools/screens/game/mixins/export.dart';

class GamesListScreen extends ConsumerStatefulWidget {
  const GamesListScreen({super.key});

  @override
  ConsumerState<GamesListScreen> createState() => _GamesListScreenState();
}

class _GamesListScreenState extends ConsumerState<GamesListScreen>
    with UpdateIsFaforiteMixin {
  bool _isSearchOpen = false;
  // Контроллеры
  final ScrollController _scrollController = ScrollController();
  final ScrollController _modalScrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  Future<List<Game>> getItemsForForBaseGamesSelect() async {
    final GameDao gameDao = ref.read(gameDaoProvider);
    return await gameDao.getHasExpansions();
  }

  Future<List<Designer>> getItemsForForDesignersSelect() async {
    final designerDao = ref.read(designerDaoProvider);
    return await designerDao.getHasGames();
  }

  Future<List<Artist>> getItemsForForArtistsSelect() async {
    final artistDao = ref.read(artistDaoProvider);
    return await artistDao.getHasGames();
  }

  Future<List<Tag>> getItemsForForTagsSelect() async {
    final tagDao = ref.read(tagDaoProvider);
    return await tagDao.getHasGames();
  }

  Future<void> _showFilterModal(GamesNotifier notifier) async {
    int? startYear = notifier.startYear;
    int? endYear = notifier.endYear;
    RangeValues ratingRange = RangeValues(
      notifier.startRating ?? 0.0,
      notifier.endRating ?? 0.0,
    );
    int numPlayers = notifier.numPlayers ?? 0;
    bool? isPlayed = notifier.isPlayed;
    bool? isInCollection = notifier.isInCollection;
    bool? isFavorite = notifier.isFavorite;
    bool? isStandalone = notifier.isStandalone;
    Set<int> baseIds = notifier.baseIds;
    Set<int> designerIds = notifier.designerIds;
    Set<int> artistIds = notifier.artistIds;
    Set<int> tagIds = notifier.tagIds;

    bool hasRatingFilter() => ratingRange.start > 0.0 || ratingRange.end > 0.0;

    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => StatefulBuilder(
          builder: (context, setStateDialog) {
            return Dialog(
              insetPadding: const EdgeInsets.all(15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              clipBehavior: Clip.antiAlias,
              child: Container(
                width: double.maxFinite,
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.9,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: secondColor, // ← Фон заголовка
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Icon(Icons.filter, color: Colors.white),
                          const SizedBox(width: 8),
                          const Expanded(
                            child: Text(
                              'Фильтры',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.white),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    ),

                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        color: firstColor,
                        child: Scrollbar(
                          controller: _modalScrollController,
                          thumbVisibility: true,
                          child: SingleChildScrollView(
                            padding: EdgeInsetsGeometry.symmetric(
                              horizontal: 10,
                            ),
                            controller: _modalScrollController,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SectionTitle(
                                  title: 'Год',
                                  icon: Icons.date_range,
                                ),
                                YearRangeField(
                                  initialStartYear: startYear,
                                  initialEndYear: endYear,
                                  onChanged: (start, end) => setStateDialog(() {
                                    startYear = start;
                                    endYear = end;
                                  }),
                                ),

                                const SizedBox(height: 7),

                                SectionTitle(
                                  title:
                                      'Количество игроков: ${numPlayers == 0 ? emptyFilterVal : numPlayers}',
                                  icon: Icons.people,
                                ),
                                Slider(
                                  value: numPlayers.toDouble(),
                                  min: 0,
                                  max: 20,
                                  divisions: 21,
                                  onChanged: (value) {
                                    setStateDialog(
                                      () => numPlayers = value.toInt(),
                                    );
                                  },
                                ),

                                const SizedBox(height: 7),

                                SectionTitle(
                                  title: 'Рейтинг',
                                  icon: Icons.star,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        hasRatingFilter()
                                            ? '${ratingRange.start.toStringAsFixed(1)} — ${ratingRange.end.toStringAsFixed(1)}'
                                            : emptyFilterVal,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: textColor,
                                        ),
                                      ),
                                    ),
                                    if (hasRatingFilter())
                                      TextButton(
                                        onPressed: () {
                                          setStateDialog(() {
                                            ratingRange = const RangeValues(
                                              0.0,
                                              0.0,
                                            );
                                          });
                                        },
                                        child: const Text('Сбросить'),
                                      ),
                                  ],
                                ),
                                RangeSlider(
                                  values: ratingRange,
                                  min: 0.0,
                                  max: 10.0,
                                  divisions: 100,
                                  labels: RangeLabels(
                                    ratingRange.start.toStringAsFixed(1),
                                    ratingRange.end.toStringAsFixed(1),
                                  ),
                                  onChanged: (values) {
                                    setStateDialog(() {
                                      ratingRange = values;
                                    });
                                  },
                                  activeColor: secondColor,
                                ),

                                const SizedBox(height: 7),

                                SectionTitle(
                                  title: 'Наличие в коллекции',
                                  icon: Icons.inventory_2,
                                ),
                                TriStateBtn(
                                  value: isInCollection,
                                  onChanged: (value) {
                                    setStateDialog(
                                      () => isInCollection = value,
                                    );
                                  },
                                  labels: const [
                                    'Не важно',
                                    'В коллекции',
                                    'Не в коллекции',
                                  ],
                                ),

                                const SizedBox(height: 7),

                                SectionTitle(
                                  title: 'Самодостаточность',
                                  icon: Icons.extension,
                                ),
                                TriStateBtn(
                                  value: isStandalone,
                                  onChanged: (value) {
                                    setStateDialog(() => isStandalone = value);
                                  },
                                  labels: const [
                                    'Не важно',
                                    'Самодостаточна',
                                    'Требует базовую игру',
                                  ],
                                ),

                                const SizedBox(height: 7),

                                SectionTitle(
                                  title: 'В избранном',
                                  icon: Icons.favorite,
                                ),
                                TriStateBtn(
                                  value: isFavorite,
                                  onChanged: (value) {
                                    setStateDialog(() => isFavorite = value);
                                  },
                                  labels: const [
                                    'Не важно',
                                    'В избранном',
                                    'Не в избранном',
                                  ],
                                ),

                                const SizedBox(height: 7),

                                SectionTitle(
                                  title: 'Наличие игровых сессий',
                                  icon: sessionsIcon,
                                ),
                                TriStateBtn(
                                  value: isPlayed,
                                  onChanged: (value) {
                                    setStateDialog(() => isPlayed = value);
                                  },
                                  labels: const [
                                    'Не важно',
                                    'Поиграна',
                                    'Неиграна',
                                  ],
                                ),

                                const SizedBox(height: 7),

                                MultiSelectWithSearch<Game>(
                                  label: 'Базовая игра',
                                  labelIcon: gamesIcon,
                                  getItems: () =>
                                      getItemsForForBaseGamesSelect(),
                                  selectedIds: baseIds,
                                  onSelectionChanged: (newSelected) {
                                    setStateDialog(() => baseIds = newSelected);
                                  },
                                  displayName: (baseGame) => baseGame.name,
                                  getId: (baseGame) => baseGame.id,
                                  searchHint: 'Поиск игр...',
                                  customItemBuilder: (baseGame) => Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        baseGame.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 7),

                                MultiSelectWithSearch<Designer>(
                                  label: 'Геймдизайнеры',
                                  labelIcon: designersIcon,
                                  getItems: () =>
                                      getItemsForForDesignersSelect(),
                                  selectedIds: designerIds,
                                  onSelectionChanged: (newSelected) {
                                    setStateDialog(
                                      () => designerIds = newSelected,
                                    );
                                  },
                                  displayName: (designer) => designer.name,
                                  getId: (designer) => designer.id,
                                  searchHint: 'Поиск геймдизайнеров...',
                                  customItemBuilder: (designer) => Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        designer.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 7),

                                MultiSelectWithSearch<Artist>(
                                  label: 'Художники',
                                  labelIcon: artistsIcon,
                                  getItems: () => getItemsForForArtistsSelect(),
                                  selectedIds: artistIds,
                                  onSelectionChanged: (newSelected) {
                                    setStateDialog(
                                      () => artistIds = newSelected,
                                    );
                                  },
                                  displayName: (artist) => artist.name,
                                  getId: (artist) => artist.id,
                                  searchHint: 'Поиск художника...',
                                  customItemBuilder: (artist) => Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        artist.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 7),

                                MultiSelectWithSearch<Tag>(
                                  label: 'Категории',
                                  labelIcon: categoriesIcon,
                                  getItems: () => getItemsForForTagsSelect(),
                                  selectedIds: tagIds,
                                  onSelectionChanged: (newSelected) {
                                    setStateDialog(() => tagIds = newSelected);
                                  },
                                  displayName: (tag) => tag.name,
                                  getId: (tag) => tag.id,
                                  searchHint: 'Поиск тэгов...',
                                  customItemBuilder: (tag) => Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        tag.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: secondColor,
                        border: Border(
                          top: BorderSide(color: Colors.grey.shade200),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              notifier.reset();
                              Navigator.pop(context);
                            },
                            child: Text('Сбросить'),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: goldColor,
                              foregroundColor: firstColor,
                            ),
                            onPressed: () {
                              notifier.startYear = startYear;
                              notifier.endYear = endYear;
                              notifier.startRating = (ratingRange.start > 0.0)
                                  ? ratingRange.start
                                  : null;
                              notifier.endRating = (ratingRange.end > 0.0)
                                  ? ratingRange.end
                                  : null;
                              if (numPlayers > 0) {
                                notifier.numPlayers = numPlayers;
                              }
                              notifier.isPlayed = isPlayed;
                              notifier.isInCollection = isInCollection;
                              notifier.isFavorite = isFavorite;
                              notifier.isStandalone = isStandalone;
                              notifier.baseIds = baseIds;
                              notifier.designerIds = designerIds;
                              notifier.artistIds = artistIds;
                              notifier.tagIds = tagIds;

                              notifier.refresh();

                              Navigator.pop(context);
                            },
                            child: Text('Применить'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _modalScrollController.dispose();
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
                : Tooltip(
                    message: 'Список настольных игр',
                    child: const Icon(gamesIcon),
                  ),
          ),
          actions: [
            IconButton(
              icon: Icon(
                _isSearchOpen ? Icons.close : Icons.search,
                color: _isSearchOpen ? redColor : textColor,
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
                icon: getFilterIcon(
                  numActiveFilters: notifier.countActiveFilters(),
                ),
                onPressed: () => _showFilterModal(notifier),
              ),
              IconButton(
                icon: Icon(
                  notifier.reverseOrdering
                      ? Icons.arrow_upward
                      : Icons.arrow_downward,
                  color: notifier.reverseOrdering ? goldColor : textColor,
                ),
                onPressed: () => notifier.toggleOrdering(),
              ),
              IconButton(
                icon: Icon(addBtnIcon),
                onPressed: () => context.pushNamed('games-add'),
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

                        String gameInfo = game.isInCollection ? '🟢 ' : '🔴 ';

                        gameInfo += getPlayersCountStr(
                          game.minPlayers,
                          game.maxPlayers,
                        );

                        return Card(
                          child: ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: game.imagePath != null
                                  ? Image.file(
                                      File(game.imagePath!),
                                      width: 40,
                                      height: 40,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, _, _) => SizedBox(
                                        width: 40,
                                        height: 40,
                                        child: BrokenImagePlaceholder(),
                                      ),
                                    )
                                  : SizedBox(
                                      width: 40,
                                      height: 40,
                                      child: ImagePlaceholder(),
                                    ),
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
                            trailing: IconButton(
                              icon: Icon(
                                game.isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: game.isFavorite ? goldColor : textColor,
                              ),
                              onPressed: () => updateIsFavorite(game),
                            ),
                            onTap: () => context.pushNamed(
                              'games-detail',
                              pathParameters: {'gameId': game.id.toString()},
                            ),
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
