import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bg_tools/core/consts/export.dart';
import 'package:bg_tools/core/database/app_database.dart';
import 'package:bg_tools/core/dataclasses/gaming_session_dataclasses.dart';
import 'package:bg_tools/core/providers/database_providers.dart';
import 'package:bg_tools/core/utils/export.dart';
import 'package:bg_tools/core/widgets/export.dart';
import 'package:bg_tools/features/session_runner/categories.dart';
import 'package:bg_tools/features/session_runner/utils/export.dart';

class FirstScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> data;
  final List<dynamic> counterData;

  const FirstScreen({super.key, required this.data, required this.counterData});

  @override
  ConsumerState<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends ConsumerState<FirstScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GamingSession? _selectedGamingSession;
  Gamer? _selectedMaster;
  late TextEditingController _numberRoundsController;
  // Загрузка
  bool _isLoading = false;

  @override
  void initState() {
    _isLoading = true;
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    if (widget.data['gameHostType'] == GameHostTypeEnum.master.id) {
      // Загружаем всех игроков

      if (widget.data['master'] != null) {
        final gamerDao = ref.read(gamerDaoProvider);
        _selectedMaster = await gamerDao.get(widget.data['master']);
      }
    }

    final int? selectedGamingSessionId = widget.data['rootSessionId'];
    if (selectedGamingSessionId != null) {
      final sessionsDao = ref.read(gamingSessionDaoProvider);
      _selectedGamingSession = await sessionsDao.getSingle(
        selectedGamingSessionId,
      );
    }

    _numberRoundsController = TextEditingController(
      text: widget.data['totalRounds']?.toString() ?? '',
    );

    setState(() => _isLoading = false);
  }

  Future<void> _setGamingSession(GamingSession? gamingSession) async {
    setState(() => _isLoading = true);

    if (gamingSession != null && widget.data['gamers'].isEmpty) {
      final sessionsDao = ref.read(gamingSessionDaoProvider);

      final List<GamingSessionGamerData> gamersData = await sessionsDao
          .getPlayers(gamingSession.id);
      for (final GamingSessionGamerData gamerInfo in gamersData) {
        final Map<String, dynamic> gamerData = getGamerData(gamerInfo.gamer);
        gamerData['team'] = gamerInfo.team;
        widget.data['gamers'].add(gamerData);
      }
    }

    setState(() {
      widget.data['rootSessionId'] = gamingSession?.id;
      _selectedGamingSession = gamingSession;
      _isLoading = false;
    });
  }

  Future<List<GamingSession>> getItemsForGamingSessionsSelect() async {
    final sessionsDao = ref.read(gamingSessionDaoProvider);
    return await sessionsDao.getByGame(
      widget.data['gameId'],
      widget.data['type'],
    );
  }

  Future<List<Gamer>> getItemsForGamersSelect() async {
    final gamerDao = ref.read(gamerDaoProvider);
    return await gamerDao.getEverybody();
  }

  @override
  void dispose() {
    _numberRoundsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(left: 24, right: 24),
            child: Form(
              key: _formKey,
              child: Column(
                spacing: 28,
                mainAxisSize: MainAxisSize.min,
                children: _isLoading
                    ? [LoadingScreen()]
                    : [
                        SelectWithSearch<GamingSession>(
                          label: 'Первая сессия серии',
                          getItems: () => getItemsForGamingSessionsSelect(),
                          selectedItem: _selectedGamingSession,
                          onSelectionChanged: (gamingSession) =>
                              _setGamingSession(gamingSession),
                          displayName: (gamingSession) =>
                              '${gamingSession.isFinished ? '✅' : '⏱️'} '
                              '${DateFormats.formatDateTime(gamingSession.startedAt)}'
                              ' (${gamingSession.comment ?? emptyVal})',
                          getId: (gamingSession) => gamingSession.id,
                          searchHint: 'Поиск сессии...',
                          isRequired: false,
                          placeholder: 'Не выбрана',
                        ),

                        if (widget.data['gameHostType'] ==
                            GameHostTypeEnum.master.id)
                          SelectWithSearch<Gamer>(
                            label: 'Ведущий',
                            getItems: () => getItemsForGamersSelect(),
                            selectedItem: _selectedMaster,
                            onSelectionChanged: (gamer) {
                              setState(() {
                                if (widget.data['master'] != null &&
                                    gamer!.id != widget.data['master']) {
                                  widget.data['gamers'].removeWhere(
                                    (player) =>
                                        player['id'] == widget.data['master'],
                                  );
                                }
                                widget.data['master'] = gamer!.id;

                                final Map<String, dynamic> gamerData =
                                    getGamerData(gamer);

                                final Map<String, dynamic>? oldGamerData =
                                    widget.data['gamers'].firstWhere(
                                      (player) => player['id'] == gamer.id,
                                      orElse: () => null,
                                    );
                                if (oldGamerData == null) {
                                  widget.data['gamers'].add(gamerData);
                                }
                                _selectedMaster = gamer;
                              });
                            },
                            displayName: (gamer) => gamer.username,
                            getId: (gamer) => gamer.id,
                            searchHint: 'Поиск игрока...',
                            isRequired: true,
                            placeholder: 'Не выбран',
                          ),

                        if (widget.data['roundsType'] == RoundsTypeEnum.fix.id)
                          TextFormField(
                            controller: _numberRoundsController,
                            decoration: InputDecoration(
                              labelText: 'Количество раундов',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType:
                                TextInputType.number, // Цифровая клавиатура
                            inputFormatters: [
                              FilteringTextInputFormatter
                                  .digitsOnly, // Только цифры
                            ],
                            onChanged: (value) {
                              widget.data['totalRounds'] = int.tryParse(value);
                            },
                          ),
                      ],
              ),
            ),
          ),
        );
      },
    );
  }
}
