import 'dart:io';

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
import 'package:bg_tools/features/session_runner/categories.dart';

class GamingSessionListScreen extends ConsumerStatefulWidget {
  const GamingSessionListScreen({super.key});

  @override
  ConsumerState<GamingSessionListScreen> createState() =>
      _GamingSessionListScreenState();
}

class _GamingSessionListScreenState
    extends ConsumerState<GamingSessionListScreen> {
  List<Game> _games = [];
  // Контроллеры
  final ScrollController _scrollController = ScrollController();
  final ScrollController _modalScrollController = ScrollController();
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

    setState(() => _isLoading = false);
  }

  Future<void> _showFilterModal(GamingSessionsNotifier notifier) async {
    bool? isFinished = notifier.isFinished;
    Game? selectedGame = notifier.gameId != null
        ? _games.firstWhere((game) => game.id == notifier.gameId)
        : null;
    DateTime? periodStart = notifier.periodStart;
    DateTime? periodEnd = notifier.periodEnd;
    GameTypeEnum? gameType = notifier.gameTypeId != null
        ? GameTypeEnum.fromId(notifier.gameTypeId!)
        : null;

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
                                EnumSelector(
                                  label: GameTypeEnum.title,
                                  choices: GameTypeEnum.getDropdownMenuItems(),
                                  selected: gameType,
                                  onChanged: (value) => setStateDialog(
                                    () => gameType = value as GameTypeEnum,
                                  ),
                                ),

                                const SizedBox(height: 15),

                                Row(
                                  spacing: 5,
                                  children: [
                                    Expanded(
                                      child: InkWell(
                                        onTap: () async {
                                          selectDateTime(
                                            context: context,
                                            initialDate: periodStart,
                                            onSelect: (dateTime) =>
                                                setStateDialog(
                                                  () => periodStart = dateTime,
                                                ),
                                          );
                                        },
                                        child: InputDecorator(
                                          decoration: const InputDecoration(
                                            labelText: 'Начало периода *',
                                            border: OutlineInputBorder(),
                                          ),
                                          child: Text(
                                            periodStart != null
                                                ? DateFormats.formatDateTime(
                                                    periodStart!,
                                                  )
                                                : emptyFilterVal,
                                          ),
                                        ),
                                      ),
                                    ),

                                    Expanded(
                                      child: InkWell(
                                        onTap: () async {
                                          selectDateTime(
                                            context: context,
                                            initialDate: periodEnd,
                                            onSelect: (dateTime) =>
                                                setStateDialog(
                                                  () => periodEnd = dateTime,
                                                ),
                                          );
                                        },
                                        child: InputDecorator(
                                          decoration: const InputDecoration(
                                            labelText: 'Конец периода *',
                                            border: OutlineInputBorder(),
                                          ),
                                          child: Text(
                                            periodEnd != null
                                                ? DateFormats.formatDateTime(
                                                    periodEnd!,
                                                  )
                                                : emptyFilterVal,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 7),

                                SelectWithSearch<Game>(
                                  label: 'Игра',
                                  isRequired: true,
                                  getItems: () async => _games,
                                  selectedItem: selectedGame,
                                  onSelectionChanged: (game) {
                                    setStateDialog(() => selectedGame = game);
                                  },
                                  displayName: (game) => game.name,
                                  getId: (game) => game.id,
                                  searchHint: 'Поиск игры...',
                                  placeholder: 'Не выбрана',
                                  customItemBuilder: (game) => Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        game.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 7),

                                SectionTitle(
                                  title: 'Завершённость',
                                  icon: Icons.done_outline,
                                ),
                                TriStateBtn(
                                  value: isFinished,
                                  onChanged: (value) {
                                    setStateDialog(() => isFinished = value);
                                  },
                                  labels: const [
                                    'Не важно',
                                    'Завершена',
                                    'В процессе',
                                  ],
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
                              notifier.isFinished = isFinished;
                              notifier.gameId = selectedGame?.id;
                              notifier.periodStart = periodStart;
                              notifier.periodEnd = periodEnd;
                              notifier.gameTypeId = gameType?.id;

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
          title: Tooltip(
            message: 'Список записей\nигровых сессиях',
            child: const Icon(sessionsIcon),
          ),

          actions: [
            IconButton(
              icon: getFilterIcon(
                numActiveFilters: notifier.countActiveFilters(),
              ),
              tooltip: 'Фильтры',
              onPressed: () => _showFilterModal(notifier),
            ),

            IconButton(
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
              icon: Icon(addBtnIcon),
              tooltip: 'Добавить игровую сессию',
              onPressed: () => context.pushNamed('gaming-sessions-add'),
            ),
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
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: game.imagePath != null
                                  ? Image.file(
                                      File(game.imagePath!),
                                      width: 40,
                                      height: 40,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, _, _) =>
                                          ImagePlaceholder(),
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
