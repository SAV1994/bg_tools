import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

// screens/role_management_screen.dart
import 'package:bg_tools/core/consts/export.dart';

class SecretRolesManagementScreen extends StatefulWidget {
  final Map<String, dynamic> data;

  const SecretRolesManagementScreen({super.key, required this.data});

  @override
  State<SecretRolesManagementScreen> createState() =>
      _SecretRolesManagementScreenState();
}

class _SecretRolesManagementScreenState
    extends State<SecretRolesManagementScreen> {
  bool _isRequired = false;

  void _addRole(
    Map<String, dynamic> teamData,
    String roleName, [
    String? groupName,
  ]) {
    setState(() {
      final List<Map<String, dynamic>> secretRoles =
          List<Map<String, dynamic>>.from(widget.data['secretRoles']);

      secretRoles.add({
        'teamId': teamData['team'],
        'teamName': teamData['name'],
        'groupName': groupName,
        'roleName': roleName,
        'isRequired': _isRequired,
      });

      secretRoles.sort((dynamic a, dynamic b) {
        final mapA = a as Map<String, dynamic>;
        final mapB = b as Map<String, dynamic>;
        // 1. Сравниваем первый ключ
        int compareResult = mapA['teamId'].compareTo(mapB['teamId']);
        // 2. Если одинаковые, сортируем по второму ключу
        if (compareResult == 0) {
          return mapA['roleName'].compareTo(
            mapB['roleName'],
          ); // обратите внимание на порядок b и a
        }

        return compareResult;
      });

      widget.data['secretRoles'] = secretRoles;
    });
  }

  Widget _buildRoleCard(Map<String, dynamic> role, int index) {
    TeamsEnum teamEnum = TeamsEnum.fromId(role['teamId']);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: teamEnum.color, width: 3),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Цветовая полоска слева
            Container(
              width: 6,
              height: 60,
              decoration: BoxDecoration(
                color: teamEnum.color,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 16),

            // Основная информация
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    role['roleName'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Команда и группа (мелко)
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: teamEnum.color.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          role['teamName'],
                          style: TextStyle(
                            fontSize: 12,
                            color: teamEnum.color,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      if (role['groupName'] != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            role['groupName'],
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),

            // Статус обязательности + действия
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Кнопки действий
                IconButton(
                  icon: Icon(
                    role['isRequired'] ? Icons.star : Icons.star_border,
                    size: 20,
                    color: role['isRequired'] ? Colors.orange : Colors.grey,
                  ),
                  onPressed: () => setState(() {
                    role['isRequired'] = !role['isRequired'];
                  }),
                  tooltip: 'Переключить обязательность',
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.red, size: 20),
                  onPressed: () => setState(() {
                    widget.data['secretRoles'].removeAt(index);
                  }),
                  tooltip: 'Удалить роль',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ========== МАСТЕР ДОБАВЛЕНИЯ РОЛИ ==========

  // ========== ШАГ 1: ВЫБОР КОМАНДЫ ==========
  void _showSelectTeamDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Выберите команду'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...widget.data['secretRolesConfig'].map((team) {
              TeamsEnum teamEnum = TeamsEnum.fromId(team['team']);

              return ListTile(
                leading: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: teamEnum.color,
                    shape: BoxShape.circle,
                  ),
                ),
                title: Text(team['name'], style: const TextStyle(fontSize: 16)),
                trailing: const Icon(Icons.chevron_right, color: Colors.grey),

                onTap: () {
                  Navigator.pop(context);
                  if (team['groups'].isNotEmpty) {
                    _showSelectGroupDialog(team);
                  } else {
                    _showAddRoleDialog(team, team['roles']);
                  }
                },
              );
            }),
          ],
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

  // ========== ШАГ 2: ВЫБОР ГРУППЫ ==========
  void _showSelectGroupDialog(Map<String, dynamic> teamData) {
    final List<dynamic> groups = teamData['groups'];
    TeamsEnum teamEnum = TeamsEnum.fromId(teamData['team']);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Выберите группу'),
        backgroundColor: teamEnum.color,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...groups.map((group) {
              return ListTile(
                leading: const Icon(Icons.category, color: textColor),
                title: Text(
                  group['name'],
                  style: const TextStyle(fontSize: 16),
                ),
                trailing: const Icon(Icons.chevron_right, color: textColor),
                onTap: () {
                  Navigator.pop(context);
                  _showAddRoleDialog(
                    teamData,
                    group['roles'],
                    groupName: group['name'],
                  );
                },
              );
            }),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена', style: TextStyle(color: textColor)),
          ),
        ],
      ),
    );
  }

  // ========== ШАГ 3: ВЫБОР РОЛИ (ИЛИ СОЗДАНИЕ) ==========
  void _showAddRoleDialog(
    Map<String, dynamic> teamData,
    List<dynamic> roles, {
    String? groupName,
  }) {
    TeamsEnum teamEnum = TeamsEnum.fromId(teamData['team']);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Добавить роль'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Информация о месте добавления
                Container(
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: teamEnum.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: teamEnum.color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              teamData['name'],
                              style: TextStyle(
                                fontSize: 12,
                                color: teamEnum.color,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            if (groupName != null)
                              Text(
                                groupName,
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Переключатель обязательности
                Row(
                  children: [
                    const Text('Обязательная', style: TextStyle(fontSize: 14)),
                    Switch(
                      value: _isRequired,
                      onChanged: (value) {
                        setState(() {
                          _isRequired = value;
                        });
                      },
                      activeThumbColor: Colors.orange,
                    ),
                  ],
                ),

                // Список существующих ролей (если есть)
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 8),
                const Text(
                  'Существующие роли',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                ...roles.map((role) {
                  return ListTile(
                    dense: true,
                    leading: Icon(
                      _isRequired ? Icons.star : Icons.star_border,
                      size: 16,
                      color: _isRequired ? Colors.orange : Colors.grey,
                    ),
                    title: Text(
                      role['name'],
                      style: const TextStyle(fontSize: 14),
                    ),
                    trailing: const Icon(Icons.check, color: Colors.green),
                    onTap: () {
                      Navigator.pop(context);
                      _addRole(teamData, role['name'], groupName);
                    },
                  );
                }),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Отмена'),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: OutlinedButton.icon(
                onPressed: _showSelectTeamDialog,
                icon: const Icon(Icons.add),
                label: const Text('Добавить роль'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 40),
                ),
              ),
            ),

            if (widget.data['secretRoles'].isEmpty)
              Center(
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
                      'Нет ролей',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.all(16),
                itemCount: widget.data['secretRoles'].length,
                itemBuilder: (context, index) {
                  final role = widget.data['secretRoles'][index];
                  return _buildRoleCard(role, index);
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
