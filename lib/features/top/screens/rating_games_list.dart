import 'package:bg_tools/core/database/daos/export.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:bg_tools/core/consts/export.dart';
import 'package:bg_tools/core/database/app_database.dart';
import 'package:bg_tools/core/dataclasses/rating_dataclasses.dart';
import 'package:bg_tools/core/providers/database_providers.dart';
import 'package:bg_tools/core/providers/paginated_providers/export.dart';
import 'package:bg_tools/core/utils/export.dart';
import 'package:bg_tools/core/widgets/export.dart';
import 'package:bg_tools/screens/game/mixins/export.dart';

class RatingGamesListScreen extends ConsumerStatefulWidget {
  const RatingGamesListScreen({super.key});

  @override
  ConsumerState<RatingGamesListScreen> createState() =>
      _RatingGamesListScreenState();
}

class _RatingGamesListScreenState extends ConsumerState<RatingGamesListScreen>
    with UpdateIsFaforiteMixin {
  Rating? rating;
  bool _isSearchOpen = false;
  // Контроллеры
  final ScrollController _scrollController = ScrollController();
  final ScrollController _modalScrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  Future<List<Designer>> getItemsForDesignersSelect(
    RatingGamesNotifier notifier,
  ) async {
    if (rating == null) {
      await setRating(notifier);
    }

    final DesignerDao designerDao = ref.read(designerDaoProvider);
    return await designerDao.getHasGames(rating: rating);
  }

  Future<List<Artist>> getItemsForArtistsSelect(
    RatingGamesNotifier notifier,
  ) async {
    if (rating == null) {
      await setRating(notifier);
    }

    final ArtistDao artistDao = ref.read(artistDaoProvider);
    return await artistDao.getHasGames(rating: rating);
  }

  Future<List<Tag>> getItemsForTagsSelect(RatingGamesNotifier notifier) async {
    if (rating == null) {
      await setRating(notifier);
    }

    final TagDao tagDao = ref.read(tagDaoProvider);
    return await tagDao.getHasGames(rating: rating);
  }

  Future<void> setRating(RatingGamesNotifier notifier) async {
    final RatingDao ratingDao = ref.read(ratingDaoProvider);
    rating = await ratingDao.getSingle(notifier.ratingId!);
  }

  Future<void> _showFilterModal(RatingGamesNotifier notifier) async {
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

                                MultiSelectWithSearch<Designer>(
                                  label: 'Геймдизайнеры',
                                  labelIcon: designersIcon,
                                  getItems: () =>
                                      getItemsForDesignersSelect(notifier),
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
                                  getItems: () =>
                                      getItemsForArtistsSelect(notifier),
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
                                  getItems: () =>
                                      getItemsForTagsSelect(notifier),
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
    final ratingGamesAsync = ref.watch(ratingsGamesPaginatedProvider);
    final notifier = ref.read(ratingsGamesPaginatedProvider.notifier);

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
                : Row(
                    children: [
                      HomeBtn(context: context),
                      Tooltip(
                        message: 'Результаты топа',
                        child: Icon(topsIcon, color: goldColor),
                      ),
                    ],
                  ),
          ),
          actions: [
            IconButton(
              icon: Icon(
                _isSearchOpen ? Icons.close : Icons.search,
                color: _isSearchOpen ? redColor : textColor,
              ),
              tooltip: _isSearchOpen ? 'Закрыть поиск' : 'Поиск',
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
                tooltip: 'Фильтры',
                onPressed: () => _showFilterModal(notifier),
              ),

              IconButton(
                visualDensity: VisualDensity(horizontal: -4.0),
                icon: Icon(
                  notifier.reverseOrdering
                      ? Icons.arrow_upward
                      : Icons.arrow_downward,
                  color: notifier.reverseOrdering ? goldColor : textColor,
                ),
                tooltip:
                    'Сортировка по ${notifier.reverseOrdering ? 'убыванию' : 'возрастанию'}',
                onPressed: () => notifier.toggleOrdering(),
              ),

              IconButton(
                icon: const Icon(delIcon, color: redColor),
                tooltip: 'Удалить топ',
                onPressed: () {
                  final rating = ratingGamesAsync.value?[0].rating;
                  buildDelModal(
                    context,
                    ref,
                    ratingDaoProvider,
                    mounted,
                    rating,
                    () {
                      Navigator.pop(context, true);
                      ref.read(ratingsPaginatedProvider.notifier).refresh();
                      ref
                          .read(ratingsGamesPaginatedProvider.notifier)
                          .refresh();
                    },
                  );
                },
              ),
            ],
          ],
        ),
        body: Column(
          children: [
            // Список
            Expanded(
              child: ratingGamesAsync.when(
                data: (ratingGamesData) {
                  List<RatingGameData> ratingGames = ratingGamesData[0].games;
                  // Если данных нет
                  if (ratingGames.isEmpty) {
                    return EmptyListScreen();
                  }
                  return Scrollbar(
                    controller: _scrollController,
                    thumbVisibility: true,
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: ratingGames.length,
                      itemBuilder: (context, index) {
                        final RatingGameData ratingGame = ratingGames[index];

                        String gameInfo = ratingGame.game.isInCollection
                            ? '🟢 '
                            : '🔴 ';

                        gameInfo +=
                            '${getPlayersCountStr(ratingGame.game.minPlayers, ratingGame.game.maxPlayers)} [${ratingGame.score}]';

                        return Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: firstColor,
                              child: Text(
                                ratingGame.place.toString(),
                                style: TextStyle(color: secondColor),
                              ),
                            ),
                            title: Text(ratingGame.game.name),
                            subtitle: Text(gameInfo),
                            trailing: Icon(Icons.arrow_forward_ios),
                            onTap: () => context.pushNamed(
                              'games-detail',
                              pathParameters: {
                                'gameId': ratingGame.game.id.toString(),
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
                loading: () => LoadingScreen(),
                error: (err, _) {
                  return ErrorNotification();
                },
              ),
            ),
            // Панель пагинации (всегда внизу)
            if (ratingGamesAsync.hasValue && ratingGamesAsync.value!.isNotEmpty)
              PaginationPanel(notifier: notifier),
          ],
        ),
      ),
    );
  }
}
