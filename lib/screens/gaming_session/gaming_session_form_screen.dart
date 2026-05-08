import 'package:flutter/material.dart';

import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bg_tools/core/consts.dart';
import 'package:bg_tools/core/database/app_database.dart';
import 'package:bg_tools/core/database/daos/game/game_dao.dart';
import 'package:bg_tools/core/dataclasses/gaming_session_dataclasses.dart';
import 'package:bg_tools/core/providers/database_providers.dart';
import 'package:bg_tools/core/utils/dateformats.dart';
import 'package:bg_tools/core/utils/loading_screen_builder.dart';
import 'package:bg_tools/core/widgets/multiple_select_with_search.dart';
import 'package:bg_tools/core/widgets/select_with_search.dart';
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
  DateTime? _finishedAt;
  // Контроллеры
  late final TextEditingController _commentController;
  // Поиск Игроков
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List<Gamer> _allGamers = [];
  List<Gamer> _filteredGamers = [];
  // Выбранные игроки
  final Map<int, GamingSessionGamerData> _selectedGamers = {};
  // Загрузка
  bool _isLoading = false;
  // Ошибка
  String? _generalError;

  @override
  void initState() {
    _isLoading = true;
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _loadData();
  }

  Future<void> _loadData() async {
    // Загружаем всех игроков
    final gamerDao = ref.read(gamerDaoProvider);
    _allGamers = await gamerDao.getEverybody();
    _filteredGamers = _allGamers;
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
      _selectedGame = gamingSessionData!.game;
      await _loadExpansionsForGame(_selectedGame!.id);
      _selectedExpansionIds = gamingSessionData!.selectedExpansionIds;
      _startedAt = gamingSession.startedAt;
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

  Future<void> _loadExpansionsForGame(int gameId) async {
    final gameDao = ref.read(gameDaoProvider);
    final expansions = await gameDao.getExpansions(gameId);

    setState(() {
      _expansions = expansions;
    });
  }

  Future<void> _onGameSelected(Game? game) async {
    setState(() {
      _selectedGame = game;
      _selectedExpansionIds.clear(); // Очищаем выбранные дополнения
    });

    if (game != null) {
      await _loadExpansionsForGame(game.id);
    } else {
      setState(() {
        _expansions = [];
      });
    }
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
      _filterGamers();
    });
  }

  void _filterGamers() {
    if (_searchQuery.isEmpty) {
      _filteredGamers = _allGamers;
    } else {
      _filteredGamers = _allGamers.where((gamer) {
        final username = gamer.username.toLowerCase();
        final firstName = gamer.firstName.toLowerCase();
        final lastName = gamer.lastName?.toLowerCase() ?? '';
        final query = _searchQuery.toLowerCase();
        return username.contains(query) ||
            firstName.contains(query) ||
            lastName.contains(query);
      }).toList();
    }
  }

  void _showAddGamerDialog() {
    final notSelectedGamers = _filteredGamers
        .where((g) => !_selectedGamers.containsKey(g.id))
        .toList();

    if (notSelectedGamers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _searchQuery == ''
                ? 'Все игроки уже добавлены'
                : 'Не найдено игроков',
          ),
        ),
      );
      return;
    }

    // Показываем диалог игрока
    showDialog(
      context: context,
      builder: (context) {
        String localSearchQuery = '';
        List<Gamer> localFiltered = List.from(notSelectedGamers);
        return StatefulBuilder(
          builder: (context, setDialogState) {
            // Функция обновления поиска
            void updateSearch(String query) {
              setDialogState(() {
                localSearchQuery = query;
                if (query.isEmpty) {
                  localFiltered = List.from(notSelectedGamers);
                } else {
                  localFiltered = notSelectedGamers.where((gamer) {
                    final username = gamer.username.toLowerCase();
                    final firstName = gamer.firstName.toLowerCase();
                    final lastName = gamer.lastName?.toLowerCase() ?? '';
                    final searchLower = query.toLowerCase();
                    return username.contains(searchLower) ||
                        firstName.contains(searchLower) ||
                        lastName.contains(searchLower);
                  }).toList();
                }
              });
            }

            return AlertDialog(
              title: const Text('Выберите игрока'),
              content: SizedBox(
                width: 400,
                height: 500,
                child: Column(
                  children: [
                    // Поле поиска в диалоге
                    TextField(
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: 'Поиск...',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: localSearchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () => updateSearch(''),
                              )
                            : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onChanged: updateSearch,
                    ),
                    const SizedBox(height: 12),

                    // Результаты поиска
                    Expanded(
                      child: localFiltered.isEmpty
                          ? const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.search_off,
                                    size: 48,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(height: 8),
                                  Text('Ничего не найдено'),
                                ],
                              ),
                            )
                          : ListView.builder(
                              itemCount: localFiltered.length,
                              itemBuilder: (context, index) {
                                final gamer = localFiltered[index];

                                String fio = '';
                                if (gamer.lastName != null) {
                                  fio += '${gamer.lastName} ';
                                }
                                fio += '${gamer.firstName} ';
                                if (gamer.middleName != null) {
                                  fio += '${gamer.middleName}';
                                }

                                return ListTile(
                                  leading: CircleAvatar(
                                    child: Text(
                                      gamer.username[0].toUpperCase(),
                                    ),
                                  ),
                                  title: Text(gamer.username),
                                  subtitle: Text(fio),
                                  onTap: () {
                                    Navigator.pop(context);
                                    _addGamerWithDetails(gamer);
                                  },
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Отмена'),
                ),
              ],
            );
          },
        );
      },
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
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
        ],
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

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final gamingSessionDao = ref.read(gamingSessionDaoProvider);
      final gamingSessionComp = GamingSessionsCompanion(
        gameId: Value(_selectedGame!.id),
        startedAt: Value(_startedAt),
        finishedAt: Value(_finishedAt),
        comment: Value(_commentController.text),
      );
      final List<GamingSessionGamerData?> gamersData = _selectedGamers.values
          .toList();
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
        print(e);
        setState(() {
          _generalError = 'Запись уже существует';
        });
      }
    }
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
          ? buildLoadingScreen()
          : SingleChildScrollView(
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
                    SelectWithSearch<Game>(
                      label: 'Игра *',
                      items: _games,
                      selectedItem: _selectedGame,
                      onSelectionChanged: (baseGame) {
                        setState(() {
                          _selectedGame = baseGame;
                        });
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
                            style: const TextStyle(fontWeight: FontWeight.w500),
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
                    InkWell(
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
                          child: Center(child: Text('Нет добавленных игроков')),
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
    );
  }
}
