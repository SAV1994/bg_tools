import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bg_tools/core/consts/export.dart';
import 'package:bg_tools/core/database/app_database.dart';
import 'package:bg_tools/core/providers/database_providers.dart';
import 'package:bg_tools/core/providers/paginated_providers/export.dart';
import 'package:bg_tools/core/widgets/export.dart';
import 'package:bg_tools/features/session_runner/categories.dart';

class CountingTemplateFormScreen extends ConsumerStatefulWidget {
  final int? templateId;

  const CountingTemplateFormScreen({super.key, this.templateId});

  @override
  ConsumerState<CountingTemplateFormScreen> createState() =>
      _CountingTemplateFormFormState();
}

class _CountingTemplateFormFormState
    extends ConsumerState<CountingTemplateFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late final CountingTemplate? template;
  // Контроллеры
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  // Переменные для валидации целостности связи с играми
  int _gamesTemplateCount = 0;
  GameTypeEnum? _oldSelectedGameType;
  // Поля для хранения выбранных значений
  GameTypeEnum? _selectedGameType;
  FirstPlayerStartTypeEnum? _selectedFirstPlayerStartType;
  ResultTypeEnum? _selectedResultType;
  GeneralDefeatTypeEnum? _selectedGeneralDefeatType;
  TeamPointTypeEnum? _selectedTeamPointType;
  PointTypeEnum? _selectedPointType;
  RoundsTypeEnum? _selectedRoundsType;
  AltVictoryTypeEnum? _selectedAltVictoryType;
  FirstPlayerRoundTypeEnum? _selectedFirstPlayerRoundType;
  SequencePlayersMovesTypeEnum? _selectedSequencePlayersMovesType;
  GameHostTypeEnum? _selectedGameHostType;
  SecretRolesDistributionTypeEnum? _selectedSecretRolesDistributionType;
  // Состояния для отображения селектов
  bool _showFirstPlayerStartType = false;
  bool _showResultType = false;
  bool _showPointType = false;
  bool _showGeneralDefeatType = false;
  bool _showTeamPointType = false;
  bool _showRoundsType = false;
  bool _showAltVictoryType = false;
  bool _showFirstPlayerRoundType = false;
  bool _showSequencePlayersMovesType = false;
  bool _showGameHostType = false;
  bool _showSecretRolesDistributionType = false;
  // Загрузка
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    if (widget.templateId == null) {
      template = null;
    } else {
      final templateDao = ref.read(countingTemplateDaoProvider);
      template = await templateDao.get(widget.templateId!);
      final Map<String, dynamic> templateData = jsonDecode(template!.data);
      _selectedGameType = templateData['gameType'] != null
          ? GameTypeEnum.fromId(templateData['gameType'])
          : null;

      _oldSelectedGameType = _selectedGameType;
      final gamesTemplateDao = ref.read(gamesCountingTemplatesDaoProvider);
      _gamesTemplateCount = await gamesTemplateDao.getGamesTemplateCount(
        template!.id,
      );

      _selectedFirstPlayerStartType =
          templateData['firstPlayerStartType'] != null
          ? FirstPlayerStartTypeEnum.fromId(
              templateData['firstPlayerStartType'],
            )
          : null;
      _selectedResultType = templateData['resultType'] != null
          ? ResultTypeEnum.fromId(templateData['resultType'])
          : null;
      _selectedGeneralDefeatType = templateData['generalDefeatType'] != null
          ? GeneralDefeatTypeEnum.fromId(templateData['generalDefeatType'])
          : null;
      _selectedTeamPointType = templateData['teamPointType'] != null
          ? TeamPointTypeEnum.fromId(templateData['teamPointType'])
          : null;
      _selectedPointType = templateData['pointType'] != null
          ? PointTypeEnum.fromId(templateData['pointType'])
          : null;
      _selectedRoundsType = templateData['roundsType'] != null
          ? RoundsTypeEnum.fromId(templateData['roundsType'])
          : null;
      _selectedAltVictoryType = templateData['altVictoryType'] != null
          ? AltVictoryTypeEnum.fromId(templateData['altVictoryType'])
          : null;
      _selectedFirstPlayerRoundType =
          templateData['firstPlayerRoundType'] != null
          ? FirstPlayerRoundTypeEnum.fromId(
              templateData['firstPlayerRoundType'],
            )
          : null;
      _selectedSequencePlayersMovesType =
          templateData['sequencePlayersMovesType'] != null
          ? SequencePlayersMovesTypeEnum.fromId(
              templateData['sequencePlayersMovesType'],
            )
          : null;
      _selectedGameHostType = templateData['gameHostType'] != null
          ? GameHostTypeEnum.fromId(templateData['gameHostType'])
          : null;
      _selectedSecretRolesDistributionType =
          templateData['secretRolesDistributionType'] != null
          ? SecretRolesDistributionTypeEnum.fromId(
              templateData['secretRolesDistributionType'],
            )
          : null;
    }
    _nameController = TextEditingController(text: template?.name);
    _descriptionController = TextEditingController(text: template?.description);

    _updateSelectorsVisibility();

    setState(() => _isLoading = false);
  }

  void _updateSelectorsVisibility() {
    setState(() {
      _showFirstPlayerStartType =
          _selectedGameType != null &&
          ![
            GameTypeEnum.solo,
            GameTypeEnum.secretRoles,
          ].contains(_selectedGameType);
      _showResultType =
          _selectedGameType != null &&
          _selectedGameType != GameTypeEnum.secretRoles;
      _showGeneralDefeatType =
          _selectedGameType != null &&
          ![GameTypeEnum.coop, GameTypeEnum.solo].contains(_selectedGameType);
      _showTeamPointType =
          _selectedGameType != null &&
          [
            GameTypeEnum.team,
            GameTypeEnum.coop,
            GameTypeEnum.teamOneWinner,
            GameTypeEnum.secretTeams,
          ].contains(_selectedGameType) &&
          _selectedResultType != null &&
          _selectedResultType != ResultTypeEnum.condition;
      _showPointType =
          _selectedResultType != null &&
          _selectedResultType != ResultTypeEnum.condition;
      _showRoundsType =
          _selectedResultType != null &&
          _selectedResultType == ResultTypeEnum.round;
      _showAltVictoryType =
          _selectedResultType != null &&
          _selectedResultType != ResultTypeEnum.condition &&
          _selectedGameType != GameTypeEnum.solo;
      _showFirstPlayerRoundType =
          _selectedResultType != null &&
          _selectedResultType == ResultTypeEnum.round &&
          _selectedGameType != GameTypeEnum.solo &&
          (_selectedTeamPointType == null ||
              _selectedTeamPointType == TeamPointTypeEnum.personal);
      _showSequencePlayersMovesType =
          _selectedFirstPlayerRoundType != null &&
          [
            FirstPlayerRoundTypeEnum.leader,
            FirstPlayerRoundTypeEnum.loser,
            FirstPlayerRoundTypeEnum.leaderNext,
          ].contains(_selectedFirstPlayerRoundType) &&
          (_selectedTeamPointType == null ||
              _selectedTeamPointType == TeamPointTypeEnum.personal);
      _showGameHostType =
          _selectedGameType != null &&
          _selectedGameType == GameTypeEnum.secretRoles;
      _showSecretRolesDistributionType = _showGameHostType;
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    if (_oldSelectedGameType != null &&
        _selectedGameType != _oldSelectedGameType &&
        _gamesTemplateCount > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Нельзя изменить тип игры, сначала удалите связи с играми.',
          ),
        ),
      );
      return;
    }

    if (_selectedGameType == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Выберите тип игры')));
      return;
    }
    if (_showFirstPlayerStartType && _selectedFirstPlayerStartType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Выберите тип определения первого игрока'),
        ),
      );
      return;
    }
    if (_showResultType && _selectedResultType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Выберите тип определения результативности'),
        ),
      );
      return;
    }
    if (_showGeneralDefeatType && _selectedGeneralDefeatType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Укажите есть ли возможность общего поражения'),
        ),
      );
      return;
    }
    if (_showTeamPointType && _selectedTeamPointType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Выберите тип игровых очков при командной игре'),
        ),
      );
      return;
    }
    if (_showPointType && _selectedPointType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Выберите тип игровых очков')),
      );
      return;
    }
    if (_showRoundsType && _selectedRoundsType == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Выберите тип раундов')));
      return;
    }
    if (_showAltVictoryType && _selectedAltVictoryType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Укажите есть ли возможность победы другим путём'),
        ),
      );
      return;
    }
    if (_showFirstPlayerRoundType && _selectedFirstPlayerRoundType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Выберите тип определения первого игрока в раунде'),
        ),
      );
      return;
    }
    if (_showSequencePlayersMovesType &&
        _selectedSequencePlayersMovesType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Выберите тип последовательности ходов игроков'),
        ),
      );
      return;
    }
    if (_showGameHostType && _selectedGameHostType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Выберите тип организации игры')),
      );
      return;
    }
    if (_showSecretRolesDistributionType &&
        _selectedSecretRolesDistributionType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Выберите способ распределения ролей')),
      );
      return;
    }

    final templateDao = ref.read(countingTemplateDaoProvider);
    final Map<String, dynamic> templateData = {
      'gameType': _selectedGameType!.id,
      'firstPlayerStartType': _selectedFirstPlayerStartType?.id,
      'resultType': _selectedResultType?.id,
      'generalDefeatType': _selectedGeneralDefeatType?.id,
      'teamPointType': _selectedTeamPointType?.id,
      'pointType': _selectedPointType?.id,
      'roundsType': _selectedRoundsType?.id,
      'altVictoryType': _selectedAltVictoryType?.id,
      'firstPlayerRoundType': _selectedFirstPlayerRoundType?.id,
      'sequencePlayersMovesType': _selectedSequencePlayersMovesType?.id,
      'gameHostType': _selectedGameHostType?.id,
      'secretRolesDistributionType': _selectedSecretRolesDistributionType?.id,
      'score_calc': null,
    };
    final CountingTemplatesCompanion templateCompanion =
        CountingTemplatesCompanion(
          name: Value(_nameController.text),
          description: Value(_descriptionController.text),
          data: Value(jsonEncode(templateData)),
        );

    try {
      if (widget.templateId == null) {
        await templateDao.create(templateCompanion);
      } else {
        await templateDao.updInstance(widget.templateId!, templateCompanion);
      }

      ref.read(countingTemplatesPaginatedProvider.notifier).refresh();

      if (mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.templateId == null
                  ? 'Шаблон добавлен'
                  : 'Изменения сохранены',
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _delGamesLinks() async {
    setState(() => _isLoading = true);

    final gamesTemplateDao = ref.read(gamesCountingTemplatesDaoProvider);
    await gamesTemplateDao.delByTemplate(template!.id);

    setState(() {
      _gamesTemplateCount = 0;
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.templateId == null
              ? 'Новаый шаблон'
              : 'Редактирование шаблона',
        ),
      ),
      body: _isLoading
          ? LoadingScreen()
          : Form(
              key: _formKey,
              child: Scrollbar(
                thumbVisibility: true,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    spacing: 16,
                    children: [
                      if (_gamesTemplateCount > 0)
                        ElevatedButton(
                          onPressed: _delGamesLinks,
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          child: Text(
                            'Удалить все ($_gamesTemplateCount) связи с играми',
                          ),
                        ),

                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Название *',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Пожалуйста, введите название';
                          }
                          return null;
                        },
                      ),

                      TextFormField(
                        controller: _descriptionController,
                        decoration: InputDecoration(
                          labelText: 'Описание',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
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
                            // Сбрасываем зависимые поля
                            if ([
                              GameTypeEnum.solo,
                              GameTypeEnum.secretRoles,
                            ].contains(value)) {
                              _selectedFirstPlayerStartType = null;
                              _selectedFirstPlayerRoundType = null;
                              _selectedSequencePlayersMovesType = null;
                              _selectedAltVictoryType = null;
                            }
                            if (value == GameTypeEnum.secretRoles) {
                              _selectedResultType = null;
                              _selectedPointType = null;
                              _selectedRoundsType = null;
                            }
                            if (value != GameTypeEnum.secretRoles) {
                              _selectedGameHostType = null;
                              _selectedSecretRolesDistributionType = null;
                            }
                            if (![
                              GameTypeEnum.coop,
                              GameTypeEnum.team,
                              GameTypeEnum.teamOneWinner,
                              GameTypeEnum.secretTeams,
                            ].contains(value)) {
                              _selectedTeamPointType = null;
                            }
                          });

                          _updateSelectorsVisibility();
                        },
                      ),

                      if (_showFirstPlayerStartType)
                        EnumSelector(
                          label: 'Тип определения первого игрока',
                          choices: FirstPlayerStartTypeEnum.values.map((val) {
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
                          selected: _selectedFirstPlayerStartType,
                          onChanged: (value) {
                            setState(() {
                              _selectedFirstPlayerStartType = (value != null)
                                  ? value as FirstPlayerStartTypeEnum
                                  : null;
                            });
                          },
                        ),

                      if (_showResultType)
                        EnumSelector(
                          label: 'Тип определения результативности',
                          choices: ResultTypeEnum.values.map((val) {
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
                          selected: _selectedResultType,
                          onChanged: (value) {
                            _selectedResultType = (value != null)
                                ? value as ResultTypeEnum
                                : null;
                            // Сбрасываем зависимые поля
                            if (value == ResultTypeEnum.condition) {
                              _selectedPointType = null;
                              _selectedAltVictoryType = null;
                              _selectedTeamPointType = null;
                            }
                            if (value != ResultTypeEnum.round) {
                              _selectedRoundsType = null;
                              _selectedFirstPlayerRoundType = null;
                              _selectedSequencePlayersMovesType = null;
                            }
                            // setState внутри
                            _updateSelectorsVisibility();
                          },
                        ),

                      if (_showGeneralDefeatType)
                        EnumSelector(
                          label: 'Возможность общего поражения',
                          choices: GeneralDefeatTypeEnum.values.map((val) {
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
                          selected: _selectedGeneralDefeatType,
                          onChanged: (value) {
                            _selectedGeneralDefeatType = (value != null)
                                ? value as GeneralDefeatTypeEnum
                                : null;
                          },
                        ),

                      if (_showTeamPointType)
                        EnumSelector(
                          label: 'Тип игровых очков при командной игре',
                          choices: TeamPointTypeEnum.values.map((val) {
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
                          selected: _selectedTeamPointType,
                          onChanged: (value) {
                            setState(() {
                              _selectedTeamPointType = (value != null)
                                  ? value as TeamPointTypeEnum
                                  : null;
                            });

                            // Сбрасываем зависимые поля
                            if (value == TeamPointTypeEnum.general) {
                              _selectedFirstPlayerRoundType = null;
                              _selectedSequencePlayersMovesType = null;
                            }

                            _updateSelectorsVisibility();
                          },
                        ),

                      if (_showPointType)
                        EnumSelector(
                          label: 'Тип игровых очков',
                          choices: PointTypeEnum.values.map((val) {
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
                          selected: _selectedPointType,
                          onChanged: (value) {
                            setState(() {
                              _selectedPointType = (value != null)
                                  ? value as PointTypeEnum
                                  : null;
                            });
                          },
                        ),

                      if (_showRoundsType)
                        EnumSelector(
                          label: 'Тип раундов',
                          choices: RoundsTypeEnum.values.map((val) {
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
                          selected: _selectedRoundsType,
                          onChanged: (value) {
                            setState(() {
                              _selectedRoundsType = (value != null)
                                  ? value as RoundsTypeEnum
                                  : null;
                            });
                          },
                        ),

                      if (_showAltVictoryType)
                        EnumSelector(
                          label: 'Возможность победы другим путём',
                          choices: AltVictoryTypeEnum.values.map((val) {
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
                          selected: _selectedAltVictoryType,
                          onChanged: (value) {
                            setState(() {
                              _selectedAltVictoryType = (value != null)
                                  ? value as AltVictoryTypeEnum
                                  : null;
                            });
                          },
                        ),

                      if (_showFirstPlayerRoundType)
                        EnumSelector(
                          label: 'Тип определения первого игрока в раунде',
                          choices: FirstPlayerRoundTypeEnum.values.map((val) {
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
                          selected: _selectedFirstPlayerRoundType,
                          onChanged: (value) {
                            setState(() {
                              _selectedFirstPlayerRoundType = (value != null)
                                  ? value as FirstPlayerRoundTypeEnum
                                  : null;
                            });

                            if ([
                              FirstPlayerRoundTypeEnum.queue,
                              FirstPlayerRoundTypeEnum.manually,
                            ].contains(value)) {
                              _selectedSequencePlayersMovesType = null;
                            }

                            _updateSelectorsVisibility();
                          },
                        ),

                      if (_showSequencePlayersMovesType)
                        EnumSelector(
                          label: 'Тип последовательности ходов игроков',
                          choices: SequencePlayersMovesTypeEnum.values.map((
                            val,
                          ) {
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
                          selected: _selectedSequencePlayersMovesType,
                          onChanged: (value) {
                            setState(() {
                              _selectedSequencePlayersMovesType =
                                  (value != null)
                                  ? value as SequencePlayersMovesTypeEnum
                                  : null;
                            });
                          },
                        ),

                      if (_showGameHostType)
                        EnumSelector(
                          label: 'Тип организации игры',
                          choices: GameHostTypeEnum.values.map((val) {
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
                          selected: _selectedGameHostType,
                          onChanged: (value) {
                            setState(() {
                              _selectedGameHostType = (value != null)
                                  ? value as GameHostTypeEnum
                                  : null;
                            });
                          },
                        ),

                      if (_showSecretRolesDistributionType)
                        EnumSelector(
                          label: 'Способ распределения ролей',
                          choices: SecretRolesDistributionTypeEnum.values.map((
                            val,
                          ) {
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
                          selected: _selectedSecretRolesDistributionType,
                          onChanged: (value) {
                            setState(() {
                              _selectedSecretRolesDistributionType =
                                  (value != null)
                                  ? value as SecretRolesDistributionTypeEnum
                                  : null;
                            });
                          },
                        ),

                      ElevatedButton(
                        onPressed: _save,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: const Text('Сохранить'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
