import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bg_tools/core/database/app_database.dart';
import 'package:bg_tools/core/dataclasses/games_counting_templates_dataclasses.dart';
import 'package:bg_tools/core/providers/database_providers.dart';
import 'package:bg_tools/core/utils/confirm_del_modal_builder.dart';
import 'package:bg_tools/core/utils/loading_screen_builder.dart';
import 'package:bg_tools/core/widgets/multiple_select_with_search.dart';
import 'package:bg_tools/core/widgets/select_with_search.dart';
import 'package:bg_tools/features/session_runner/categories.dart';

class GamesCountingTemplatesModalForm extends ConsumerStatefulWidget {
  final int gameId;
  final int? gamesCountingTemplatesId;

  const GamesCountingTemplatesModalForm({
    super.key,
    required this.gameId,
    this.gamesCountingTemplatesId,
  });

  @override
  ConsumerState<GamesCountingTemplatesModalForm> createState() =>
      _GamesCountingTemplatesModalFormState();
}

class _GamesCountingTemplatesModalFormState
    extends ConsumerState<GamesCountingTemplatesModalForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final GamesCountingTemplatesData? gamesCountingTemplatesData;
  // Локальное состояние формы
  List<CountingTemplate> _countingTemplates = [];
  CountingTemplate? _selectedCountingTemplate;
  List<Game> _expansions = [];
  Set<int> _selectedExpansionIds = {};
  bool _showRoundsScoreLimitInput = false;
  // Контроллеры
  late final TextEditingController _nameController;
  late TextEditingController _roundsScoreLimitController;
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
    // Загружаем все шаблоны
    final countingTemplatesDao = ref.read(countingTemplateDaoProvider);
    _countingTemplates = await countingTemplatesDao.getAll();
    // Загружаем дополнения игры
    final gameDao = ref.read(gameDaoProvider);
    _expansions = await gameDao.getExpansions(widget.gameId);

    int? roundsScoreLimit;

    if (widget.gamesCountingTemplatesId == null) {
      gamesCountingTemplatesData = null;
    } else {
      final gamesCountingTemplatesDao = ref.read(
        gamesCountingTemplatesDaoProvider,
      );
      gamesCountingTemplatesData = await gamesCountingTemplatesDao.getSingle(
        widget.gamesCountingTemplatesId!,
      );
      _selectedCountingTemplate = gamesCountingTemplatesData!.countingTemplate;
      _selectedExpansionIds = gamesCountingTemplatesData!.selectedexpansionIds;

      final Map<String, dynamic> templatesData = jsonDecode(
        _selectedCountingTemplate!.data,
      );

      if (templatesData['roundsType'] == RoundsTypeEnum.condition.id) {
        final Map<String, dynamic> gameData = jsonDecode(
          gamesCountingTemplatesData!.gamesCountingTemplate.data!,
        );
        roundsScoreLimit = gameData['roundsScoreLimit'];
        _showRoundsScoreLimitInput = true;
      }
    }

    _roundsScoreLimitController = TextEditingController(
      text: roundsScoreLimit?.toString(),
    );

    _nameController = TextEditingController(
      text: gamesCountingTemplatesData?.gamesCountingTemplate.name,
    );

    setState(() => _isLoading = false);
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final gamesCountingTemplatesDao = ref.read(
        gamesCountingTemplatesDaoProvider,
      );

      final Map<String, dynamic> data = {
        'roundsScoreLimit': int.tryParse(_roundsScoreLimitController.text),
      };

      final GamesCountingTemplatesCompanion gamesCountingTemplatesComp =
          GamesCountingTemplatesCompanion(
            gameId: Value(widget.gameId),
            name: Value(_nameController.text),
            countingTemplateId: Value(_selectedCountingTemplate!.id),
            data: Value(jsonEncode(data)),
          );
      try {
        if (widget.gamesCountingTemplatesId == null) {
          await gamesCountingTemplatesDao.create(
            gamesCountingTemplatesComp,
            _selectedExpansionIds,
          );
        } else {
          await gamesCountingTemplatesDao.updInstance(
            widget.gamesCountingTemplatesId!,
            gamesCountingTemplatesComp,
            _selectedExpansionIds,
          );
        }

        _formKey.currentState!.save();

        if (mounted) {
          Navigator.pop(context, true);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                widget.gamesCountingTemplatesId == null
                    ? 'Шаблон добавлен'
                    : 'Изменения сохранены',
              ),
            ),
          );
        }
      } catch (e) {
        print(e);
        setState(() {
          _generalError = 'Ошибка';
        });
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.gamesCountingTemplatesId == null
              ? 'Новый шаблон'
              : 'Редактирование шаблона',
        ),
        actions: [
          if (widget.gamesCountingTemplatesId != null)
            IconButton(
              icon: const Icon(Icons.delete_outlined),
              onPressed: () {
                buildDelModal(
                  context,
                  ref,
                  gamesCountingTemplatesDaoProvider,
                  mounted,
                  gamesCountingTemplatesData!.gamesCountingTemplate,
                );
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            spacing: 16,
            mainAxisSize: MainAxisSize.min,
            children: _isLoading
                ? [buildLoadingScreen()]
                : [
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
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Название *',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 6,
                      validator: (v) =>
                          v?.isEmpty == true ? 'Введите название' : null,
                    ),
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
                    SelectWithSearch<CountingTemplate>(
                      label: 'Шаблон *',
                      items: _countingTemplates,
                      selectedItem: _selectedCountingTemplate,
                      onSelectionChanged: (template) {
                        bool showRoundsScoreLimitInput = false;
                        if (template != null) {
                          final Map<String, dynamic> templateData = jsonDecode(
                            template.data,
                          );
                          if (templateData['roundsType'] ==
                              RoundsTypeEnum.condition.id) {
                            showRoundsScoreLimitInput = true;
                          } else {
                            showRoundsScoreLimitInput = false;
                            _roundsScoreLimitController.clear();
                          }
                        }

                        setState(() {
                          _selectedCountingTemplate = template;
                          _showRoundsScoreLimitInput =
                              showRoundsScoreLimitInput;
                        });
                      },
                      displayName: (template) =>
                          '${template.name} (${template.description})',
                      getId: (template) => template.id,
                      searchHint: 'Поиск шаблона...',
                      isRequired: true,
                      placeholder: 'Не выбран',
                    ),
                    if (_showRoundsScoreLimitInput)
                      TextFormField(
                        controller: _roundsScoreLimitController,
                        decoration: InputDecoration(
                          labelText: 'Граничное значение очков для раундов *',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType:
                            TextInputType.number, // Цифровая клавиатура
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'^-?\d*')),
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Пожалуйста, введите ограничитель';
                          }
                          return null;
                        },
                      ),
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
