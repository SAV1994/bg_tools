import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bg_tools/core/consts/export.dart';
import 'package:bg_tools/core/dataclasses/rating_dataclasses.dart';
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
  bool _isSearchOpen = false;

  // Контроллеры
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ratingGamesAsync = ref.watch(ratingGamesPaginatedProvider);
    final notifier = ref.read(ratingGamesPaginatedProvider.notifier);

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
                : Icon(topsIcon, color: goldColor),
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
                visualDensity: VisualDensity(horizontal: -4.0),
                icon: Icon(
                  notifier.reverseOrdering
                      ? Icons.arrow_upward
                      : Icons.arrow_downward,
                  color: notifier.reverseOrdering ? goldColor : textColor,
                ),
                onPressed: () => notifier.toggleOrdering(),
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
                            onTap: () {},
                          ),
                        );
                      },
                    ),
                  );
                },
                loading: () => LoadingScreen(),
                error: (err, _) {
                  print(err);
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
