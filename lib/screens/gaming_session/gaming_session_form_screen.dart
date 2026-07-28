import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bg_tools/core/consts/export.dart';
import 'package:bg_tools/core/database/app_database.dart';
import 'package:bg_tools/core/database/daos/game/game_dao.dart';
import 'package:bg_tools/core/dataclasses/gaming_session_dataclasses.dart';
import 'package:bg_tools/core/providers/database_providers.dart';
import 'package:bg_tools/core/providers/paginated_providers/export.dart';
import 'package:bg_tools/core/utils/export.dart';
import 'package:bg_tools/core/widgets/export.dart';
import 'package:bg_tools/features/session_runner/categories.dart';
import 'package:bg_tools/screens/gaming_session/form_widgets/gamer_card_widget.dart';
import 'package:bg_tools/screens/gaming_session/form_widgets/gamer_form_detail_widget.dart';

class GamingSessionFormScreen extends ConsumerStatefulWidget {
  final int? gamingSessionId;

  const GamingSessionFormScreen({super.key, this.gamingSessionId});

  @override
  ConsumerState<GamingSessionFormScreen> createState() =>
      _GamingSessionFormScreenState();
}

class _GamingSessionFormScreenState
    extends ConsumerState<GamingSessionFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final GamingSessionFullData? gamingSessionData;
  // Локальное состояние формы
  List<Game> _games = [];
  Game? _selectedGame;
  List<Game> _expansions = [];
  Set<int> _selectedExpansionIds = {};
  DateTime _startedAt = DateTime.now();
  bool _isFinished = true;
  DateTime? _finishedAt;
  List<Gamer> _allGamers = [];
  List<GamingSession> _gamingSessions = [];
  GamingSession? _selectedGamingSession;
  GameTypeEnum? _selectedGameType;
  // Выбранные игроки
  final Map<int, GamingSessionGamerData> _selectedGamers = {};
  // Контроллеры
  late final TextEditingController _commentController;
  // Загрузка
  bool _isLoading = false;
  // Ошибка
  String? _generalError;

  @override
  void initState() {
    _isLoading = true;
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    // Загружаем всех игроков
    final gamerDao = ref.read(gamerDaoProvider);
    _allGamers = await gamerDao.getEverybody();
    // Загружаем все игры
    final GameDao gameDao = ref.read(gameDaoProvider);
    _games = await gameDao.getAll();

    if (widget.gamingSessionId == null) {
      gamingSessionData = null;
    } else {
      final gamingSessionDao = ref.read(gamingSessionDaoProvider);
      gamingSessionData = await gamingSessionDao.getFullInfo(
        widget.gamingSessionId!,
      );
      final List<GamingSessionGamerData?> gamersData =
          gamingSessionData!.gamers;
      final GamingSession gamingSession = gamingSessionData!.gamingSession;
      _selectedGameType = gamingSession.gameType != null
          ? GameTypeEnum.fromId(gamingSession.gameType!)
          : null;
      _selectedGame = gamingSessionData!.game;
      if (gamingSession.rootSessionId == null) {
        _selectedGamingSession = null;
      } else {
        _selectedGamingSession = await gamingSessionDao.getSingle(
          gamingSession.rootSessionId!,
        );
      }
      await _loadExpansionsForGame(_selectedGame!.id);
      await _loadGamingSessionsForGame(_selectedGame!.id);
      _selectedExpansionIds = gamingSessionData!.selectedExpansionIds;
      _startedAt = gamingSession.startedAt;
      _finishedAt = gamingSession.finishedAt;
      if (gamingSession.finishedAt != null) {
        _finishedAt = gamingSession.finishedAt;
      }
      if (gamersData.isNotEmpty) {
        for (final gamerData in gamingSessionData!.gamers) {
          _selectedGamers[gamerData!.gamer.id] = gamerData;
        }
      }
    }

    _commentController = TextEditingController(
      text: gamingSessionData?.gamingSession.comment,
    );

    setState(() => _isLoading = false);
  }

  Future<void> _loadGamingSessionsForGame(int gameId) async {
    final sessionsDao = ref.read(gamingSessionDaoProvider);
    _gamingSessions = await sessionsDao.getByGame(gameId);
  }

  Future<void> _loadExpansionsForGame(int gameId) async {
    final gameDao = ref.read(gameDaoProvider);
    final expansions = await gameDao.getExpansions(gameId);

    setState(() {
      _expansions = expansions;
    });
  }

  Future<void> _onGameSelected(Game? game) async {
    _selectedExpansionIds.clear(); // Очищаем выбранные дополнения
    _selectedGamingSession = null;
    setState(() {
      _selectedGame = game;
    });

    if (game != null) {
      await _loadExpansionsForGame(game.id);
      await _loadGamingSessionsForGame(_selectedGame!.id);
    } else {
      setState(() {
        _expansions = [];
      });
    }
  }

  void _showAddGamerDialog() {
    final notSelectedGamers = _allGamers
        .where((g) => !_selectedGamers.containsKey(g.id))
        .toList();

    if (notSelectedGamers.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Все игроки уже добавлены')));
      return;
    }

    // Показываем диалог игрока
    buildAddGamerModal(
      context,
      notSelectedGamers,
      (gamer) => _addGamerWithDetails(gamer),
    );
  }

  void _addGamerWithDetails(Gamer gamer) {
    // Показываем форму для заполнения деталей
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Детали для ${gamer.username}'),
        content: AddGamerDetailsForm(
          gamer: gamer,
          onSave: (data) {
            setState(() {
              _selectedGamers[gamer.id] = data;
            });
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  Future<void> _selectDateTime({bool isFinishedAt = false}) async {
    final DateTime? initialDate = isFinishedAt ? _finishedAt : _startedAt;

    final date = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (date == null) return;

    if (mounted) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(date),
      );
      if (time == null) return;

      final DateTime dateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
      if (isFinishedAt) {
        setState(() => _finishedAt = dateTime);
      } else {
        setState(() => _startedAt = dateTime);
      }
    }
  }

  void _setCurrentDateTime() {
    setState(() => _finishedAt = DateTime.now());
  }

  void _submitForm() async {
    if (_selectedGameType == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Укажите тип игры')));
      return;
    }

    if (_formKey.currentState!.validate()) {
      final gamingSessionDao = ref.read(gamingSessionDaoProvider);
      final List<GamingSessionGamerData> gamersData = _selectedGamers.values
          .toList();
      final Map<String, dynamic> sessionData = _getSessionData(gamersData);

      final gamingSessionComp = GamingSessionsCompanion(
        gameId: Value(_selectedGame!.id),
        startedAt: Value(_startedAt),
        finishedAt: Value(_finishedAt),
        isFinished: Value(_isFinished),
        comment: Value(_commentController.text),
        gameType: Value(_selectedGameType!.id),
        rootSessionId: Value(_selectedGamingSession?.id),
        data: Value(jsonEncode(sessionData)),
      );

      try {
        if (widget.gamingSessionId == null) {
          await gamingSessionDao.create(
            gamingSessionComp,
            gamersData,
            _selectedExpansionIds,
          );
        } else {
          await gamingSessionDao.updInstance(
            widget.gamingSessionId!,
            gamingSessionComp,
            gamersData,
            _selectedExpansionIds,
          );
        }

        _formKey.currentState!.save();

        ref.read(gamingSessionsPaginatedProvider.notifier).updatePageLimit();

        if (mounted) {
          Navigator.pop(context, true);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                widget.gamingSessionId == null
                    ? 'Запись о игровой сессии добавлена'
                    : 'Изменения сохранены',
              ),
            ),
          );
        }
      } catch (e) {
        setState(() {
          _generalError = 'Ошибка';
        });
      }
    }
  }

  Map<String, dynamic> _getSessionData(
    List<GamingSessionGamerData> playersData,
  ) {
    Map<String, dynamic> sessionData = getSessionInitialData();

    for (var playerData in playersData) {
      if (playerData.team != null) {
        if (sessionData['teamsData'][playerData.team.toString()] == null) {
          sessionData['teamsData'][playerData.team.toString()] = {
            'score': playerData.score,
            'scoreByrounds': [],
            'numWinRounds': null,
            "place": playerData.place,
            "name": null,
          };
        } else if (playerData.score != null) {
          if (sessionData['teamsData'][playerData.team.toString()]['score'] ==
              null) {
            sessionData['teamsData'][playerData.team.toString()]['score'] =
                playerData.score;
          } else {
            sessionData['teamsData'][playerData.team.toString()]['score'] +=
                playerData.score;
          }
        }
      }
    }

    return sessionData;
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.gamingSessionId == null
              ? 'Новая запись о игровой сессии'
              : 'Редактирование игровой сессии',
        ),
        actions: [
          TextButton(
            onPressed: _showAddGamerDialog,
            child: const Row(
              children: [
                Icon(Icons.add),
                SizedBox(width: 4),
                Text('Добавить игрока'),
              ],
            ),
          ),
        ],
      ),
      body: _isLoading
          ? LoadingScreen()
          : Scrollbar(
              thumbVisibility: true,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    spacing: 16,
                    children: [
                      if (_generalError != null)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(8),
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.red.shade200),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.error,
                                color: Colors.red.shade700,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _generalError!,
                                  style: TextStyle(color: Colors.red.shade700),
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (widget.gamingSessionId != null)
                        SelectWithSearch<GamingSession>(
                          label: 'Первая сессия серии',
                          items: _gamingSessions,
                          selectedItem: _selectedGamingSession,
                          onSelectionChanged: (gamingSession) {
                            setState(() {
                              _selectedGamingSession = gamingSession;
                            });
                          },
                          displayName: (gamingSession) =>
                              '${DateFormats.formatDate(gamingSession.startedAt)} (${gamingSession.comment ?? emptyVal})',
                          getId: (template) => template.id,
                          searchHint: 'Поиск сессии...',
                          isRequired: false,
                          placeholder: 'Не выбрана',
                        ),
                      SelectWithSearch<Game>(
                        label: 'Игра *',
                        items: _games,
                        selectedItem: _selectedGame,
                        onSelectionChanged: (baseGame) {
                          _onGameSelected(baseGame);
                        },
                        displayName: (baseGame) => baseGame.name,
                        getId: (baseGame) => baseGame.id,
                        searchHint: 'Поиск игры...',
                        isRequired: true,
                        placeholder: 'Не выбрана',
                        customItemBuilder: (baseGame) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                      // Выбор дополнений (MultiSelect) - появляется только если есть дополнения
                      if (_expansions.isNotEmpty)
                        MultiSelectWithSearch<Game>(
                          label: 'Дополнения',
                          items: _expansions,
                          selectedIds: _selectedExpansionIds,
                          onSelectionChanged: (newSelected) {
                            setState(() {
                              _selectedExpansionIds = newSelected;
                            });
                          },
                          displayName: (expansion) => expansion.name,
                          getId: (expansion) => expansion.id,
                          searchHint: 'Поиск дополнений...',
                        ),
                      EnumSelector(
                        label: 'Тип игры',
                        choices: GameTypeEnum.values.map((val) {
                          return DropdownMenuItem(
                            value: val,
                            child: Row(
                              children: [
                                Text(
                                  val.label,
                                  style: TextStyle(color: textColor),
                                ),
                              ],
                            ),
                          );
                        }),
                        selected: _selectedGameType,
                        onChanged: (value) {
                          setState(() {
                            _selectedGameType = (value != null)
                                ? value as GameTypeEnum
                                : null;
                          });
                        },
                      ),
                      InkWell(
                        onTap: () async {
                          _selectDateTime();
                        },
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'Начало партии *',
                            border: OutlineInputBorder(),
                          ),
                          child: Text(DateFormats.formatDateTime(_startedAt)),
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () async {
                                _selectDateTime(isFinishedAt: true);
                              },
                              child: InputDecorator(
                                decoration: const InputDecoration(
                                  labelText: 'Конец партии',
                                  border: OutlineInputBorder(),
                                ),
                                child: Text(
                                  _finishedAt != null
                                      ? DateFormats.formatDateTime(_finishedAt!)
                                      : emptyVal,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Tooltip(
                            message: 'Установить текущие дату и время',
                            child: InkWell(
                              onTap: _setCurrentDateTime,
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade50,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Colors.blue.shade200,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.today,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      CheckboxListTile(
                        title: Text('Партия закончена?'),
                        value: _isFinished,
                        onChanged: (value) {
                          setState(() {
                            _isFinished = value!;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                      ),

                      TextFormField(
                        controller: _commentController,
                        decoration: InputDecoration(
                          labelText: 'Комментарий',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      // Список выбранных дизайнеров
                      const Text(
                        'Игроки',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),

                      if (_selectedGamers.isEmpty)
                        const Card(
                          child: Padding(
                            padding: EdgeInsets.all(32),
                            child: Center(
                              child: Text('Нет добавленных игроков'),
                            ),
                          ),
                        )
                      else
                        ..._selectedGamers.values.map((gamerData) {
                          return GamingSessionGamerCard(
                            gamerData: gamerData,
                            onChanged: (data) {
                              setState(() {
                                _selectedGamers[data.gamer.id] = data;
                              });
                            },
                            onRemove: () {
                              setState(() {
                                _selectedGamers.remove(gamerData.gamer.id);
                              });
                            },
                          );
                        }),

                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _submitForm,
                              child: Text('Сохранить'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
