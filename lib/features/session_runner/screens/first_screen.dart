import 'package:bg_tools/core/utils/gamer_session_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bg_tools/core/consts.dart';
import 'package:bg_tools/core/database/app_database.dart';
import 'package:bg_tools/core/providers/database_providers.dart';
import 'package:bg_tools/core/utils/dateformats.dart';
import 'package:bg_tools/core/utils/loading_screen_builder.dart';
import 'package:bg_tools/core/widgets/select_with_search.dart';
import 'package:bg_tools/features/session_runner/categories.dart';

class FirstScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> data;

  const FirstScreen({super.key, required this.data});

  @override
  ConsumerState<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends ConsumerState<FirstScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<GamingSession> _gamingSessions = [];
  GamingSession? _selectedGamingSession;
  List<Gamer> _gamers = [];
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
      final gamerDao = ref.read(gamerDaoProvider);
      _gamers = await gamerDao.getEverybody();
      if (widget.data['master'] != null) {
        _selectedMaster = await gamerDao.get(widget.data['master']);
      }
    }

    final sessionsDao = ref.read(gamingSessionDaoProvider);
    _gamingSessions = await sessionsDao.getByGame(widget.data['gameId']);

    final int? selectedGamingSessionId = widget.data['rootSessionId'];
    if (selectedGamingSessionId != null) {
      _selectedGamingSession = await sessionsDao.getSingle(
        selectedGamingSessionId,
      );
    }

    _numberRoundsController = TextEditingController(
      text: widget.data['totalRounds']?.toString() ?? '',
    );

    setState(() => _isLoading = false);
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
          child: Form(
            key: _formKey,
            child: Column(
              spacing: 16,
              mainAxisSize: MainAxisSize.min,
              children: _isLoading
                  ? [buildLoadingScreen()]
                  : [
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: SelectWithSearch<GamingSession>(
                          label: 'Первая сессия серии',
                          items: _gamingSessions,
                          selectedItem: _selectedGamingSession,
                          onSelectionChanged: (gamingSession) {
                            widget.data['rootSessionId'] = gamingSession?.id;
                            setState(() {
                              _selectedGamingSession = gamingSession;
                            });
                          },
                          displayName: (gamingSession) =>
                              '${DateFormats.formatDate(gamingSession.startedAt)} (${gamingSession.comment ?? emptyVal})',
                          getId: (gamingSession) => gamingSession.id,
                          searchHint: 'Поиск сессии...',
                          isRequired: false,
                          placeholder: 'Не выбрана',
                        ),
                      ),

                      if (widget.data['gameHostType'] ==
                          GameHostTypeEnum.master.id)
                        Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: SelectWithSearch<Gamer>(
                            label: 'Ведущий',
                            items: _gamers,
                            selectedItem: _selectedMaster,
                            onSelectionChanged: (gamer) {
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

                              final Map<String, dynamic>? oldGamerData = widget
                                  .data['gamers']
                                  .firstWhere(
                                    (player) => player['id'] == gamer.id,
                                    orElse: () => null,
                                  );
                              if (oldGamerData == null) {
                                widget.data['gamers'].add(gamerData);
                              }

                              setState(() {
                                _selectedMaster = gamer;
                              });
                            },
                            displayName: (gamer) => gamer.username,
                            getId: (gamer) => gamer.id,
                            searchHint: 'Поиск игрока...',
                            isRequired: true,
                            placeholder: 'Не выбран',
                          ),
                        ),

                      if (widget.data['roundsType'] == RoundsTypeEnum.fix.id)
                        Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: TextFormField(
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
                        ),
                    ],
            ),
          ),
        );
      },
    );
  }
}
