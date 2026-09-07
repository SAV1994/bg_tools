import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bg_tools/core/app_data.dart';
import 'package:bg_tools/core/consts/export.dart';
import 'package:bg_tools/core/widgets/loading_screen.dart';

class RoleManagementScreen extends ConsumerStatefulWidget {
  const RoleManagementScreen({super.key});

  @override
  ConsumerState<RoleManagementScreen> createState() =>
      _RoleManagementScreenState();
}

class _RoleManagementScreenState extends ConsumerState<RoleManagementScreen> {
  late final Map<String, dynamic>? _sessionData;
  final Map<String, int?> _rolesPool = {};
  // Загрузка
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    _sessionData = await AppDataManager.loadActiveSession();
    for (Map<String, dynamic> role in _sessionData!['roles']) {
      _rolesPool[role['name']] =
          role['count'] - _getRemainingCount(role['name']);
    }

    setState(() => _isLoading = false);
  }

  Future<void> _saveData() async {
    await AppDataManager.saveActiveSession(_sessionData!);
  }

  int _getAssignmentsCount(String roleName) {
    return _sessionData!['gamers']
        .where((player) => player['role']['roleName'] == roleName)
        .length;
  }

  // Получить оставшееся количество для роли
  int _getRemainingCount(String roleName) {
    final Map<String, dynamic> role = _sessionData!['roles'].firstWhere(
      (role) => role['name'] == roleName,
    );

    return role['count'] - _getAssignmentsCount(roleName);
  }

  List<dynamic> _getAvailableRoles(String? currentRole) {
    return _sessionData!['roles'].where((role) {
      if (role['name'] == currentRole) return true;

      final remaining = _getRemainingCount(role['name']);
      return remaining > 0;
    }).toList();
  }

  void _assignRole(Map<String, dynamic> playerData, String? roleName) {
    setState(() {
      playerData['role'] = {'roleName': roleName};
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return LoadingScreen();
    }

    return Scaffold(
      appBar: AppBar(
        title: Icon(rolesManagementIcon, color: blueColor),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          // Счётчик назначенных
          Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                '${_sessionData!['gamers'].where((player) => player['role']?['roleName'] != null).length}/${_sessionData['gamers'].length}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Статистика по ролям
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.deepPurple.shade50,
              border: Border(
                bottom: BorderSide(color: Colors.deepPurple.shade200),
              ),
            ),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _sessionData['roles'].map<Widget>((role) {
                final remaining = _getRemainingCount(role['name']);
                final isComplete = remaining == 0;

                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isComplete ? goldColor : secondColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isComplete ? firstColor : textColor,
                      width: isComplete ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        role['name'],
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isComplete
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: isComplete ? textColor : Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 1,
                        ),
                        decoration: BoxDecoration(
                          color: isComplete ? textColor : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '$remaining/${role['count']}',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: isComplete
                                ? textColor
                                : Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),

          // Список игроков
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: _sessionData['gamers'].length,
              itemBuilder: (context, index) {
                final player = _sessionData['gamers'][index];
                final currentRole = player['role']?['roleName'];
                final availableRoles = _getAvailableRoles(currentRole);

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  elevation: currentRole != null ? 2 : 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: currentRole != null
                          ? textColor
                          : Colors.grey.shade200,
                      width: currentRole != null ? 2 : 1,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        // Аватар игрока
                        CircleAvatar(
                          backgroundColor: currentRole != null
                              ? textColor
                              : Colors.grey.shade300,
                          radius: 24,
                          child: Text(
                            player['username'][0].toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Имя игрока
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                player['username'],
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (currentRole != null)
                                Text(
                                  currentRole,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                )
                              else
                                Text(
                                  'Роль не назначена',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade500,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                            ],
                          ),
                        ),

                        // Селект роли
                        Expanded(
                          flex: 2,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String?>(
                                value: currentRole,
                                isExpanded: true,
                                hint: const Text(
                                  'Выбрать',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey,
                                  ),
                                ),
                                icon: const Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.deepPurple,
                                ),
                                items: [
                                  // Опция "Не назначена"
                                  const DropdownMenuItem<String?>(
                                    value: null,
                                    child: Text(
                                      'Не назначена',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  // Доступные роли
                                  ...availableRoles.map((role) {
                                    final remaining = _getRemainingCount(
                                      role['name'],
                                    );
                                    final isCurrent =
                                        role['name'] == currentRole;

                                    return DropdownMenuItem<String>(
                                      value: role['name'],
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              role['name'],
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: isCurrent
                                                    ? FontWeight.bold
                                                    : FontWeight.normal,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Text(
                                            isCurrent ? '✓' : '($remaining)',
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: isCurrent
                                                  ? textColor
                                                  : Colors.grey.shade500,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                                ],
                                onChanged: (value) {
                                  _assignRole(player, value);
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Кнопка завершения
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Column(
              children: [
                // Прогресс
                Row(
                  children: [
                    Expanded(
                      child: LinearProgressIndicator(
                        value:
                            _sessionData['gamers']
                                .where(
                                  (player) =>
                                      player['role']?['roleName'] != null,
                                )
                                .length /
                            _sessionData['gamers'].length,
                        backgroundColor: Colors.grey.shade200,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.deepPurple,
                        ),
                        minHeight: 8,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '${_sessionData['gamers'].where((player) => player['role']?['roleName'] != null).length}'
                      '/${_sessionData['gamers'].length}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Кнопка
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      _saveData();
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Сохранить',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
