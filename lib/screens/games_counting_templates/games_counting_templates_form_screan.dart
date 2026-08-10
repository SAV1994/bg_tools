import 'dart:convert';

import 'package:bg_tools/core/custom_exceptions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bg_tools/core/consts/export.dart';
import 'package:bg_tools/core/database/app_database.dart';
import 'package:bg_tools/core/dataclasses/games_counting_templates_dataclasses.dart';
import 'package:bg_tools/core/providers/database_providers.dart';
import 'package:bg_tools/core/providers/paginated_providers/export.dart';
import 'package:bg_tools/core/utils/export.dart';
import 'package:bg_tools/core/widgets/export.dart';
import 'package:bg_tools/features/session_runner/categories.dart';

enum _SelectMode { classic, secretTeams, secretRoles }

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

  _SelectMode _mode = _SelectMode.classic;

  late final GamesCountingTemplatesData? gamesCountingTemplatesData;
  // Локальное состояние формы
  CountingTemplate? _selectedCountingTemplate;
  Set<int> _selectedExpansionIds = {};

  bool _showRoundsScoreLimitInput = false;

  List<dynamic> _secretRolesConfig = [];

  // Контроллеры
  final TextEditingController _controllerForModal = TextEditingController();
  final TextEditingController _controllerForModal2 = TextEditingController();
  late final TextEditingController _nameController;
  final ScrollController _scrollController = ScrollController();
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
      if ([
        GameTypeEnum.secretRoles.id,
        GameTypeEnum.secretTeams.id,
      ].contains(templatesData['gameType'])) {
        if (templatesData['gameType'] == GameTypeEnum.secretRoles.id) {
          _mode = _SelectMode.secretRoles;
        } else {
          _mode = _SelectMode.secretTeams;
        }
        GamesCountingTemplate gamesCountingTemplate =
            gamesCountingTemplatesData!.gamesCountingTemplate;
        _secretRolesConfig = json.decode(
          gamesCountingTemplate.data!,
        )['secretRolesConfig'];
      }

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

  Future<List<CountingTemplate>> getItemsForCountingTemplateSelect() async {
    final countingTemplatesDao = ref.read(countingTemplateDaoProvider);
    return await countingTemplatesDao.getAll();
  }

  Future<List<Game>> getItemsForExpansionsSelect() async {
    final gameDao = ref.read(gameDaoProvider);
    return await gameDao.getExpansions(widget.gameId);
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        if (_mode == _SelectMode.secretRoles) {
          _validateSecretRoles();
        } else if (_mode == _SelectMode.secretTeams) {
          _validateSecretTeams();
        }
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
        return;
      }

      final gamesCountingTemplatesDao = ref.read(
        gamesCountingTemplatesDaoProvider,
      );

      final Map<String, dynamic> data = {
        'roundsScoreLimit': int.tryParse(_roundsScoreLimitController.text),
        'secretRolesConfig': _secretRolesConfig,
      };

      if (_selectedCountingTemplate == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Выберите шаблон')));
        return;
      }

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

        final notifier = ref.read(
          gamesCountingTemplatesPaginatedProvider.notifier,
        );
        notifier.refresh();

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
        setState(() => _generalError = 'Ошибка');
      }
    }
  }

  void _validateSecretTeams() {
    if (_secretRolesConfig.isEmpty) {
      throw ValidationException('Должны быть указаны команды');
    }
  }

  void _validateSecretRoles() {
    if (_secretRolesConfig.isEmpty) {
      throw ValidationException('Должны быть указаны роли');
    }

    for (final Map<String, dynamic> teamData in _secretRolesConfig) {
      if (teamData['groups'].isNotEmpty) {
        for (final Map<String, dynamic> groupData in teamData['groups']) {
          if (groupData['roles'].isEmpty) {
            throw ValidationException('Не должно быть групп без ролей');
          }
        }
      } else {
        if (teamData['roles'].isEmpty) {
          throw ValidationException('Не должно быть команд без ролей');
        }
      }
    }
  }

  Widget _buildTeamCard(Map<String, dynamic> teamData, int index) {
    final List<dynamic> groups = teamData['groups'];
    final List<dynamic> roles = teamData['roles'];
    final team = TeamsEnum.fromId(teamData['team']);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: team.color, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Заголовок команды
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: team.color,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      teamData['name'][0].toUpperCase(),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _showTeamModalForm(index),
                    child: Text(
                      teamData['name'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                // Кнопки действий
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.delete, color: redColor),
                      onPressed: () =>
                          setState(() => _secretRolesConfig.removeAt(index)),
                      tooltip: 'Удалить команду',
                    ),
                  ],
                ),
              ],
            ),
            if (_mode == _SelectMode.secretRoles) const SizedBox(height: 12),

            // Кнопки добавления групп и ролей
            if (_mode == _SelectMode.secretRoles)
              Row(
                spacing: 8,
                children: [
                  if (roles.isEmpty)
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _showGroupModalForm(groups),
                        icon: const Icon(
                          Icons.supervised_user_circle,
                          size: 18,
                        ),
                        label: const Text('Добавить группу'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: goldColor,
                          foregroundColor: firstColor,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
                    ),
                  if (groups.isEmpty)
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _showRoleModalForm(roles),
                        icon: const Icon(Icons.person, size: 18),
                        label: const Text('Добавить роль'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: borderColor,
                          foregroundColor: textColor,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
                    ),
                ],
              ),

            // Список групп
            if (groups.isNotEmpty) ...[
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 8),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: groups.length,
                itemBuilder: (context, index) {
                  return _buildGroupCard(groups, index);
                },
              ),
            ],

            // Список ролей
            if (roles.isNotEmpty) ...[
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 8),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: roles.length,
                itemBuilder: (context, index) {
                  return _buildRoleTile(roles, index);
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildGroupCard(List<dynamic> groups, int index) {
    final Map<String, dynamic> group = groups[index];
    final List<dynamic> roles = group['roles'];

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: firstColor,
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Заголовок группы
            Row(
              children: [
                const Icon(
                  Icons.supervised_user_circle,
                  size: 18,
                  color: goldColor,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _showGroupModalForm(groups, index),
                    child: Text(
                      group['name'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: goldColor,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 16, color: redColor),
                  onPressed: () {
                    setState(() => groups.removeAt(index));
                  },
                  tooltip: 'Удалить группу',
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Кнопка добавления роли в группу
            OutlinedButton.icon(
              onPressed: () => _showRoleModalForm(roles),
              icon: const Icon(Icons.add, size: 16),
              label: const Text('Добавить роль'),
              style: OutlinedButton.styleFrom(
                foregroundColor: borderColor,
                side: const BorderSide(color: borderColor),
                padding: const EdgeInsets.all(4),
              ),
            ),

            // Список ролей в типе
            if (roles.isNotEmpty) ...[
              const SizedBox(height: 8),
              ListView.builder(
                shrinkWrap: true,
                itemCount: roles.length,
                itemBuilder: (context, index) {
                  return _buildRoleTile(roles, index);
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildRoleTile(List<dynamic> roles, int index) {
    final Map<String, dynamic> role = roles[index];

    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: secondColor,
        border: BoxBorder.all(color: borderColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          if (role['description'].isNotEmpty)
            Tooltip(
              message: role['description'],
              child: const Icon(Icons.comment, size: 16, color: textColor),
            ),
          const SizedBox(width: 8),
          Expanded(
            child: GestureDetector(
              onTap: () => _showRoleModalForm(roles, index),
              child: Text(
                role['name'],
                style: const TextStyle(fontSize: 14, color: textColor),
              ),
            ),
          ),

          IconButton(
            icon: const Icon(Icons.close, size: 14, color: redColor),
            onPressed: () {
              setState(() => roles.removeAt(index));
            },
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  void _showTeamModalForm([int? index]) {
    TeamsEnum? selectedTeam;
    final Set<TeamsEnum> availableTeams = {};

    if (index != null) {
      final team = _secretRolesConfig[index];
      _controllerForModal.text = team['name'];
      selectedTeam = TeamsEnum.fromId(team['team']);
      availableTeams.add(selectedTeam);
    }

    List<int> selectedTeamIds = _secretRolesConfig
        .map((team) => team['team'] as int)
        .toList();
    for (final TeamsEnum team in TeamsEnum.values) {
      if (!selectedTeamIds.contains(team.id)) {
        selectedTeam ??= team;
        availableTeams.add(team);
      }
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(
          (index == null) ? 'Новая команда' : 'Редактирование команды',
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<TeamsEnum>(
              decoration: const InputDecoration(
                labelText: 'Цвет команды *',
                border: OutlineInputBorder(),
              ),
              initialValue: selectedTeam,
              items: availableTeams.map((team) {
                return DropdownMenuItem(
                  value: team,
                  child: Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: team.color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(team.label),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) selectedTeam = value;
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _controllerForModal,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'Название команды *',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _controllerForModal.clear();
              FocusScope.of(context).unfocus();
            },
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_controllerForModal.text.isNotEmpty) {
                Navigator.pop(context);

                setState(() {
                  if (index == null) {
                    _secretRolesConfig.add({
                      'name': _controllerForModal.text,
                      'team': selectedTeam!.id,
                      'groups': [],
                      'roles': [],
                    });
                  } else {
                    _secretRolesConfig[index]['name'] =
                        _controllerForModal.text;
                    _secretRolesConfig[index]['team'] = selectedTeam!.id;
                  }
                });

                _controllerForModal.clear();
                FocusScope.of(context).unfocus();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Заполните обязательные поля'),
                    backgroundColor: redColor,
                  ),
                );
              }
            },
            child: const Text('Сохранить'),
          ),
        ],
      ),
    );
  }

  void _showGroupModalForm(List<dynamic> groups, [int? index]) {
    if (index != null) {
      final group = groups[index];
      _controllerForModal.text = group['name'];
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text((index == null) ? 'Новая группа' : 'Редактирование группы'),
        content: TextField(
          controller: _controllerForModal,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Название группы *',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _controllerForModal.clear();
              FocusScope.of(context).unfocus();
            },
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              if (_controllerForModal.text.isNotEmpty) {
                Navigator.pop(context);

                setState(() {
                  if (index == null) {
                    groups.add({'name': _controllerForModal.text, 'roles': []});
                  } else {
                    groups[index]['name'] = _controllerForModal.text;
                  }
                });

                _controllerForModal.clear();
                FocusScope.of(context).unfocus();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Заполните обязательные поля'),
                    backgroundColor: redColor,
                  ),
                );
              }
            },
            child: const Text('Сохранить'),
          ),
        ],
      ),
    );
  }

  void _showRoleModalForm(List<dynamic> roles, [int? index]) {
    if (index != null) {
      final role = roles[index];
      _controllerForModal.text = role['name'];
      _controllerForModal2.text = role['description'] ?? '';
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text((index == null) ? 'Новая роль' : 'Редактирование роли'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 25,
          children: [
            TextField(
              controller: _controllerForModal,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'Название роли *',
                border: OutlineInputBorder(),
              ),
            ),
            TextField(
              controller: _controllerForModal2,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Описание',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),

        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _controllerForModal.clear();
              _controllerForModal2.clear();
              FocusScope.of(context).unfocus();
            },
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              if (_controllerForModal.text.isNotEmpty) {
                Navigator.pop(context);

                setState(() {
                  if (index == null) {
                    roles.add({
                      'name': _controllerForModal.text,
                      'description': _controllerForModal2.text,
                    });
                  } else {
                    roles[index]['name'] = _controllerForModal.text;
                    roles[index]['description'] = _controllerForModal2.text;
                  }
                });
                _controllerForModal.clear();
                _controllerForModal2.clear();
                FocusScope.of(context).unfocus();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Введите название роли')),
                );
              }
            },
            child: const Text('Сохранить'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _scrollController.dispose();
    _controllerForModal.dispose();
    _controllerForModal2.dispose();
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
          if ([
                _SelectMode.secretTeams,
                _SelectMode.secretRoles,
              ].contains(_mode) &&
              _secretRolesConfig.length < 4)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => _showTeamModalForm(),
            ),

          if (widget.gamesCountingTemplatesId != null)
            IconButton(
              icon: const Icon(Icons.delete_outlined, color: redColor),
              onPressed: () {
                buildDelModal(
                  context,
                  ref,
                  gamesCountingTemplatesDaoProvider,
                  mounted,
                  gamesCountingTemplatesData!.gamesCountingTemplate,
                  () {
                    final notifier = ref.read(
                      gamesCountingTemplatesPaginatedProvider.notifier,
                    );
                    notifier.refresh();
                  },
                );
              },
            ),
        ],
      ),
      body: Scrollbar(
        thumbVisibility: true,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              spacing: 16,
              mainAxisSize: MainAxisSize.min,
              children: _isLoading
                  ? [LoadingScreen()]
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
                      Scrollbar(
                        controller: _scrollController,
                        thumbVisibility: false,
                        interactive: false,
                        child: TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: 'Название *',
                            border: OutlineInputBorder(),
                          ),
                          maxLines: 5,
                          validator: (v) =>
                              v?.isEmpty == true ? 'Введите название' : null,
                        ),
                      ),
                      MultiSelectWithSearch<Game>(
                        label: 'Дополнения',
                        getItems: () => getItemsForExpansionsSelect(),
                        selectedIds: _selectedExpansionIds,
                        onSelectionChanged: (newSelected) {
                          setState(() => _selectedExpansionIds = newSelected);
                        },
                        displayName: (expansion) => expansion.name,
                        getId: (expansion) => expansion.id,
                        searchHint: 'Поиск дополнений...',
                      ),
                      SelectWithSearch<CountingTemplate>(
                        label: 'Шаблон',
                        getItems: () => getItemsForCountingTemplateSelect(),
                        selectedItem: _selectedCountingTemplate,
                        onSelectionChanged: (template) {
                          bool showRoundsScoreLimitInput = false;
                          _SelectMode mode = _SelectMode.classic;

                          if (template != null) {
                            final Map<String, dynamic> templateData =
                                jsonDecode(template.data);

                            if (templateData['roundsType'] ==
                                RoundsTypeEnum.condition.id) {
                              showRoundsScoreLimitInput = true;
                            } else {
                              showRoundsScoreLimitInput = false;
                              _roundsScoreLimitController.clear();
                            }
                            if (templateData['gameType'] ==
                                GameTypeEnum.secretRoles.id) {
                              mode = _SelectMode.secretRoles;
                            } else if (templateData['gameType'] ==
                                GameTypeEnum.secretTeams.id) {
                              mode = _SelectMode.secretTeams;
                            } else {
                              _secretRolesConfig.clear();
                            }
                          }

                          setState(() {
                            _selectedCountingTemplate = template;
                            _showRoundsScoreLimitInput =
                                showRoundsScoreLimitInput;
                            _mode = mode;
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
                            FilteringTextInputFormatter.allow(
                              RegExp(r'^-?\d*'),
                            ),
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Пожалуйста, введите ограничитель';
                            }
                            return null;
                          },
                        ),

                      if ([
                        _SelectMode.secretTeams,
                        _SelectMode.secretRoles,
                      ].contains(_mode))
                        _secretRolesConfig.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.people_outline,
                                      size: 64,
                                      color: Colors.grey.shade400,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'Нет команд',
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    TextButton.icon(
                                      onPressed: () => _showTeamModalForm(),
                                      icon: const Icon(Icons.add),
                                      label: const Text('Добавить команду'),
                                    ),
                                  ],
                                ),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: _secretRolesConfig.length,
                                itemBuilder: (context, index) {
                                  final team = _secretRolesConfig[index];
                                  return _buildTeamCard(team, index);
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
      ),
    );
  }
}
