import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:bg_tools/core/consts/export.dart';
import 'package:bg_tools/core/database/app_database.dart';
import 'package:bg_tools/core/database/daos/game/game_dao.dart';
import 'package:bg_tools/core/dataclasses/gaming_session_dataclasses.dart';
import 'package:bg_tools/core/providers/database_providers.dart';
import 'package:bg_tools/core/providers/paginated_providers/export.dart';
import 'package:bg_tools/core/utils/export.dart';
import 'package:bg_tools/core/widgets/export.dart';

class GamingSessionListScreen extends ConsumerStatefulWidget {
  final int? gameId;

  const GamingSessionListScreen({super.key, this.gameId});

  @override
  ConsumerState<GamingSessionListScreen> createState() =>
      _GamingSessionListScreenState();
}

class _GamingSessionListScreenState
    extends ConsumerState<GamingSessionListScreen> {
  List<Game> _games = [];
  Game? _game;
  bool _isGameSelectOpen = false;
  // Контроллеры
  final ScrollController _scrollController = ScrollController();
  // Загрузка
  bool _isLoading = false;

  @override
  void initState() {
    _isLoading = true;
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final GameDao gameDao = ref.read(gameDaoProvider);
    _games = await gameDao.getAlreadyPlayed();
    if (widget.gameId != null) {
      _game = await gameDao.getSingle(widget.gameId!);
      _isGameSelectOpen = true;
    }

    setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return LoadingScreen();
    }

    final gamingSessionsAsync = ref.watch(gamingSessionsPaginatedProvider);
    final notifier = ref.read(gamingSessionsPaginatedProvider.notifier);

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        notifier.reset();
      },
      child: Scaffold(
        appBar: AppBar(
          title: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: _isGameSelectOpen
                ? AppBarSelect(
                    items: _games
                        .map((game) => SelectItem(game.id, game.name))
                        .toList(),
                    onSelectionChanged: (game) {
                      notifier.filterByGame(game?.id);
                    },
                    selectedItem: (_game != null)
                        ? SelectItem(_game!.id, _game!.name)
                        : null,
                  )
                : Icon(sessionsIcon),
          ),
          actions: [
            IconButton(
              icon: Icon(
                _isGameSelectOpen ? Icons.close : gamesIcon,
                color: _isGameSelectOpen ? redColor : textColor,
              ),
              onPressed: () {
                setState(() {
                  if (_isGameSelectOpen) {
                    notifier.filterByGame(null);
                  }
                  _isGameSelectOpen = !_isGameSelectOpen;
                });
              },
            ),
            if (!_isGameSelectOpen) ...[
              IconButton(
                icon: Icon(
                  notifier.onlyIsFinished
                      ? Icons.visibility_off
                      : Icons.visibility,
                  color: notifier.onlyIsFinished ? textColor : goldColor,
                ),
                onPressed: () => notifier.toggleonlyIsFinished(),
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
                onPressed: () => context.pushNamed('gaming-sessions-add'),
              ),
            ],
          ],
        ),
        body: Column(
          children: [
            // Список
            Expanded(
              child: gamingSessionsAsync.when(
                data: (gamingSessions) {
                  // Если данных нет
                  if (gamingSessions.isEmpty) {
                    return EmptyListScreen();
                  }
                  return Scrollbar(
                    controller: _scrollController,
                    thumbVisibility: true,
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: gamingSessions.length,
                      itemBuilder: (context, index) {
                        final GamingSessionData gamingSessionData =
                            gamingSessions[index];
                        final GamingSession gamingSession =
                            gamingSessionData.gamingSession;
                        final Game game = gamingSessionData.game;

                        String gamingSessionInfo = gamingSession.isFinished
                            ? '✅ '
                            : '⏱️ ';

                        gamingSessionInfo += DateFormats.formatDateTime(
                          gamingSession.startedAt,
                        );

                        return Card(
                          child: ListTile(
                            leading: Icon(Icons.assignment),
                            title: Text(
                              game.name,
                              style: TextStyle(
                                color: gamingSession.isFinished
                                    ? textColor
                                    : goldColor,
                              ),
                            ),
                            subtitle: Text(gamingSessionInfo),
                            trailing: Icon(Icons.arrow_forward_ios),
                            onTap: () => context.pushNamed(
                              'gaming-sessions-detail',
                              pathParameters: {
                                'gamingSessionId': gamingSession.id.toString(),
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
                loading: () => LoadingScreen(),
                error: (err, _) => Text(err.toString()),
              ),
            ),
            // Панель пагинации (всегда внизу)
            if (gamingSessionsAsync.hasValue &&
                gamingSessionsAsync.value!.isNotEmpty)
              PaginationPanel(notifier: notifier),
          ],
        ),
      ),
    );
  }
}
