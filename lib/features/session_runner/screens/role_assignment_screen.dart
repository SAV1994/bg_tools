import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bg_tools/core/consts/export.dart';
import 'package:bg_tools/core/widgets/export.dart';

class RoleAssignmentScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  final List<dynamic> counterData;

  const RoleAssignmentScreen({
    super.key,
    required this.data,
    required this.counterData,
  });

  @override
  State<RoleAssignmentScreen> createState() => _RoleAssignmentScreenState();
}

class _RoleAssignmentScreenState extends State<RoleAssignmentScreen> {
  final Map<TeamsEnum, dynamic> _roles = {};
  // Загрузка
  bool _isLoading = false;

  @override
  void initState() {
    _isLoading = true;
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final Map<String, dynamic> gamersMap = {};
    for (Map<String, dynamic> gamerData in widget.data['gamers']) {
      if (gamerData['team'] != null) {
        gamersMap
            .putIfAbsent(gamerData['team'].toString(), () => {})
            .putIfAbsent(gamerData['role']['roleName'], () => [])
            .add(gamerData);
      }
    }

    for (Map<String, dynamic> roleData in widget.data['secretRoles']) {
      final TeamsEnum teamEnum = TeamsEnum.fromId(roleData['teamId']);
      Map<String, dynamic>? player;
      final List<dynamic>? playerList =
          gamersMap[roleData['teamId'].toString()]?[roleData['roleName']];
      if (playerList != null && playerList.isNotEmpty) {
        player = playerList.removeAt(0);
      }

      _roles.putIfAbsent(teamEnum, () => []).add({
        'team': teamEnum,
        'teamName': roleData['teamName'],
        'groupName': roleData['groupName'],
        'roleName': roleData['roleName'],
        'gamer': player,
        'isRequired': roleData['isRequired'],
      });
    }

    setState(() => _isLoading = false);
  }

  void _assignPlayerToRole(Map<String, dynamic> role, {int? playerId = 0}) {
    final Map<String, dynamic>? player = widget.data['gamers'].firstWhere(
      (player) => player['id'] == playerId,
      orElse: () => null,
    );

    setState(() {
      if (role['gamer'] != null) {
        role['gamer']['team'] = null;
        role['gamer']['role'] = {};
      }

      if (player != null) {
        player['team'] = role['team'].id;
        player['role'] = {
          'teamName': role['teamName'],
          'groupName': role['groupName'],
          'roleName': role['roleName'],
        };
      }

      role['gamer'] = player;
    });
  }

  void _clearAll() {
    setState(() {
      for (final List<dynamic> teamRoles in _roles.values) {
        for (final role in teamRoles) {
          if (role['gamer'] != null) {
            role['gamer']['role'] = {};
            role['gamer']['team'] = null;
            role['gamer'] = null;
          }
        }
      }
    });
  }

  Widget _buildContent() {
    return Column(
      children: [
        _buildActionButtons(),
        Expanded(child: _buildRoleList()),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: secondColor)),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: _clearAll,
              icon: const Icon(Icons.clear_all, size: 18),
              label: const Text('Снять всех'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
                padding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleList() {
    return ListView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.all(16),
      itemCount: _roles.keys.length,
      itemBuilder: (context, index) {
        final roles = _roles.values.elementAt(index);

        return _buildTeam(roles);
      },
    );
  }

  Widget _buildTeam(List<dynamic> roles) {
    final TeamsEnum teamEnum = roles[0]['team'];
    // Группируем по типам внутри команды
    final Map<String?, List<Map<String, dynamic>>> groupsMap = {};
    for (var role in roles) {
      groupsMap.putIfAbsent(role['groupName'], () => []).add(role);
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: teamEnum.color, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Заголовок команды
            Row(
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
                Text(
                  roles[0]['teamName'],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  '${roles.where((r) => r['gamer'] != null).length}/${roles.length}',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Divider(),
            ...groupsMap.entries.map((group) {
              return _buildGroup(group.value);
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildGroup(List<Map<String, dynamic>> roles) {
    final String? groupName = roles[0]['groupName'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (groupName != null) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.category, size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Text(
                groupName,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
        ],
        ...roles.map((role) => _buildRoleRow(role)),
      ],
    );
  }

  Widget _buildRoleRow(Map<String, dynamic> role) {
    final isAssigned = role['gamer'] != null;
    final int masterId = widget.data['master'] ?? 0;
    // Список доступных игроков для селекта
    final List<DropdownMenuItem<int?>> availablePlayers = [
      const DropdownMenuItem<int>(
        value: null,
        child: Text('Не назначен', style: TextStyle(color: redColor)),
      ),
      ...widget.data['gamers']
          .where(
            (player) =>
                player['team'] == null && player['id'] != masterId ||
                role['gamer'] != null && role['gamer']['id'] == player['id'],
          )
          .map((player) {
            return DropdownMenuItem<int>(
              value: player['id'],
              child: Row(
                children: [
                  Text(player['username'], style: TextStyle(color: textColor)),
                ],
              ),
            );
          }),
    ];

    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isAssigned ? secondColor : const Color.fromARGB(255, 155, 10, 0),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: role['isRequired'] && !isAssigned
              ? Colors.red.shade300
              : Colors.transparent,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Индикатор обязательности
          Icon(
            role['isRequired'] ? Icons.star : Icons.star_border,
            size: 16,
            color: role['isRequired'] ? Colors.orange : Colors.grey,
          ),
          const SizedBox(width: 8),

          // Название роли
          Expanded(
            flex: 2,
            child: Text(
              role['roleName'],
              style: TextStyle(
                fontSize: 15,
                fontWeight: isAssigned ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),

          // Селект игрока
          Expanded(
            flex: 3,
            child: DropdownButtonFormField<int?>(
              initialValue: role['gamer']?['id'],
              isExpanded: true,
              hint: const Text('Выбрать'),
              dropdownColor: secondColor,
              decoration: InputDecoration(
                filled: true,
                fillColor: secondColor,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: isAssigned ? borderColor : textColor,
                    width: 2,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: goldColor),
                ),
              ),
              items: availablePlayers,
              onChanged: (value) {
                if (value != null) {}
                _assignPlayerToRole(role, playerId: value);
              },
              icon: isAssigned
                  ? const Icon(Icons.check_circle, color: borderColor, size: 18)
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return _isLoading ? LoadingScreen() : _buildContent();
      },
    );
  }
}
