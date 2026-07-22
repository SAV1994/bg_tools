import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:bg_tools/core/consts/export.dart';
import 'package:bg_tools/core/database/app_database.dart';
import 'package:bg_tools/core/database/daos/game/game_dao.dart';
import 'package:bg_tools/core/dataclasses/gaming_session_dataclasses.dart';
import 'package:bg_tools/core/providers/database_providers.dart';
import 'package:bg_tools/core/providers/paginated_providers/export.dart';
import 'package:bg_tools/core/utils/dateformats.dart';
import 'package:bg_tools/core/utils/empty_list_screen_builder.dart';
import 'package:bg_tools/core/utils/export.dart';
import 'package:bg_tools/core/utils/loading_screen_builder.dart';
import 'package:bg_tools/core/widgets/export.dart';

class GamingSessionListScreen extends ConsumerStatefulWidget {
  const GamingSessionListScreen({super.key});

  @override
  ConsumerState<GamingSessionListScreen> createState() =>
      _GamingSessionListScreenState();
}

class _GamingSessionListScreenState
    extends ConsumerState<GamingSessionListScreen> {
  List<Game> _games = [];
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
    _games = await gameDao.getStandalones();

    setState(() => _isLoading = false);
  }

  Future<void> _openAddForm() async {
    final result = await context.pushNamed('gaming-sessions-add');

    if (result == true) {
      ref.invalidate(gamingSessionDaoProvider); // Обновляем провайдер
      setState(() {});
    }
  }

  Future<void> _openDetailPage(int gamingSessionId) async {
    final result = await context.pushNamed(
      'gaming-sessions-detail',
      pathParameters: {'gamingSessionId': gamingSessionId.toString()},
    );

    if (result == true) {
      ref.invalidate(gamingSessionDaoProvider); // Обновляем провайдер
      setState(() {});
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return buildLoadingScreen();
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
                  )
                : Icon(sessionsIcon),
          ),
          actions: [
            IconButton(
              icon: Icon(
                _isGameSelectOpen ? Icons.close : gamesIcon,
                color: _isGameSelectOpen ? redColor : borderColor,
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
                  color: notifier.onlyIsFinished ? borderColor : goldColor,
                ),
                onPressed: () => notifier.toggleonlyIsFinished(),
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
              child: gamingSessionsAsync.when(
                data: (gamingSessions) {
                  // Если данных нет
                  if (gamingSessions.isEmpty) {
                    return buildEmptyListScreen();
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

                        String gamingSessionInfo =
                            gamingSession.finishedAt == null
                            ? '🟡'
                            : gamingSession.isFinished
                            ? '🟢'
                            : '⏱️';

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
                            onTap: () {
                              _openDetailPage(gamingSession.id);
                            },
                          ),
                        );
                      },
                    ),
                  );
                },
                loading: () => buildLoadingScreen(),
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
