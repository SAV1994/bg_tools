import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bg_tools/core/database/app_database.dart';
import 'package:bg_tools/core/providers/database_providers.dart';
import 'package:bg_tools/core/utils/loading_screen_builder.dart';
import 'package:bg_tools/core/widgets/enum_select_widget.dart';
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
  // Поля для хранения выбранных значений (плоская структура)
  GameTypeEnum? _selectedGameType;
  FirstPlayerStartTypeEnum? _selectedFirstPlayerStartType;
  ResultTypeEnum? _selectedResultType;
  PointTypeEnum? _selectedPointType;
  AltVictoryTypeEnum? _selectedAltVictoryType;
  FirstPlayerRoundTypeEnum? _selectedFirstPlayerRoundType;
  // Состояния для отображения селектов
  bool _showFirstPlayerStartType = false;
  bool _showPointType = false;
  bool _showAltVictoryType = false;
  bool _showFirstPlayerRoundType = false;
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
      _selectedFirstPlayerStartType =
          templateData['firstPlayerStartType'] != null
          ? FirstPlayerStartTypeEnum.fromId(
              templateData['firstPlayerStartType'],
            )
          : null;
      _selectedResultType = templateData['resultType'] != null
          ? ResultTypeEnum.fromId(templateData['resultType'])
          : null;
      _selectedPointType = templateData['pointType'] != null
          ? PointTypeEnum.fromId(templateData['pointType'])
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
    }
    _nameController = TextEditingController(text: template?.name);
    _descriptionController = TextEditingController(text: template?.description);

    _updateSelectorsVisibility();

    setState(() => _isLoading = false);
  }

  void _updateSelectorsVisibility() {
    _showFirstPlayerStartType =
        _selectedGameType != null && _selectedGameType != GameTypeEnum.solo;
    _showPointType =
        _selectedResultType != null &&
        _selectedResultType != ResultTypeEnum.condition &&
        _selectedGameType != GameTypeEnum.solo;
    _showAltVictoryType =
        _selectedResultType != null &&
        _selectedResultType != ResultTypeEnum.condition &&
        _selectedGameType != GameTypeEnum.solo;
    _showFirstPlayerRoundType =
        _selectedResultType != null &&
        _selectedResultType == ResultTypeEnum.round &&
        _selectedGameType != GameTypeEnum.solo;

    setState(() {});
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

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
    if (_selectedResultType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Выберите тип определения результативности'),
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

    final templateDao = ref.read(countingTemplateDaoProvider);
    final Map<String, dynamic> templateData = {
      'gameType': _selectedGameType!.id,
      'firstPlayerStartType': _selectedFirstPlayerStartType?.id,
      'resultType': _selectedResultType!.id,
      'pointType': _selectedPointType?.id,
      'altVictoryType': _selectedAltVictoryType?.id,
      'firstPlayerRoundType': _selectedFirstPlayerRoundType?.id,
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка: $e'), backgroundColor: Colors.red),
      );
    }
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
          ? buildLoadingScreen()
          : Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  spacing: 16,
                  children: [
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
                      label: 'Тип игры *',
                      choices: GameTypeEnum.values.map((val) {
                        return DropdownMenuItem(
                          value: val,
                          child: Row(children: [Text(val.label)]),
                        );
                      }),
                      selected: _selectedGameType,
                      onChanged: (value) {
                        setState(() {
                          _selectedGameType = (value != null)
                              ? value as GameTypeEnum
                              : null;
                          // Сбрасываем зависимые поля
                          if (value == GameTypeEnum.solo) {
                            _selectedFirstPlayerStartType = null;
                          }
                        });

                        _updateSelectorsVisibility();
                      },
                    ),
                    if (_showFirstPlayerStartType) ...[
                      EnumSelector(
                        label: 'Тип определения первого игрока *',
                        choices: FirstPlayerStartTypeEnum.values.map((val) {
                          return DropdownMenuItem(
                            value: val,
                            child: Row(children: [Text(val.label)]),
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
                    ],
                    EnumSelector(
                      label: 'Тип определения результативности *',
                      choices: ResultTypeEnum.values.map((val) {
                        return DropdownMenuItem(
                          value: val,
                          child: Row(children: [Text(val.label)]),
                        );
                      }),
                      selected: _selectedResultType,
                      onChanged: (value) {
                        setState(() {
                          _selectedResultType = (value != null)
                              ? value as ResultTypeEnum
                              : null;
                          // Сбрасываем зависимые поля
                          if (value == ResultTypeEnum.condition) {
                            _selectedPointType = null;
                            _selectedAltVictoryType = null;
                          }
                          if (value != ResultTypeEnum.round) {
                            _selectedFirstPlayerRoundType = null;
                          }
                        });

                        _updateSelectorsVisibility();
                      },
                    ),
                    if (_showPointType) ...[
                      EnumSelector(
                        label: 'Тип игровых очков *',
                        choices: PointTypeEnum.values.map((val) {
                          return DropdownMenuItem(
                            value: val,
                            child: Row(children: [Text(val.label)]),
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
                    ],
                    if (_showAltVictoryType) ...[
                      EnumSelector(
                        label: 'Возможность победы другим путём *',
                        choices: AltVictoryTypeEnum.values.map((val) {
                          return DropdownMenuItem(
                            value: val,
                            child: Row(children: [Text(val.label)]),
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
                    ],
                    if (_showFirstPlayerRoundType) ...[
                      EnumSelector(
                        label: 'Тип определения первого игрока в раунде *',
                        choices: FirstPlayerRoundTypeEnum.values.map((val) {
                          return DropdownMenuItem(
                            value: val,
                            child: Row(children: [Text(val.label)]),
                          );
                        }),
                        selected: _selectedFirstPlayerRoundType,
                        onChanged: (value) {
                          setState(() {
                            _selectedFirstPlayerRoundType = (value != null)
                                ? value as FirstPlayerRoundTypeEnum
                                : null;
                          });
                        },
                      ),
                    ],

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
    );
  }
}
