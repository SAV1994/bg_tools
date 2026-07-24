import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bg_tools/core/consts/export.dart';
import 'package:bg_tools/core/widgets/export.dart';

class SecretRolesViewScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> data;

  const SecretRolesViewScreen({super.key, required this.data});

  @override
  ConsumerState<SecretRolesViewScreen> createState() =>
      _SecretRolesViewerScreenState();
}

class _SecretRolesViewerScreenState
    extends ConsumerState<SecretRolesViewScreen> {
  final List<Map<String, dynamic>> _teams = [];
  bool _show = false;
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
            .putIfAbsent(gamerData['team'].toString(), () => [])
            .add(gamerData);
      }
    }

    for (final teamData in widget.data['teamsData'].entries) {
      final teamEnum = TeamsEnum.fromId(int.parse(teamData.key));

      _teams.add({
        'team': teamEnum,
        'name': teamData.value['name'],
        'gamers': gamersMap[teamData.key],
        'controller': null,
        'score': teamData.value['score'],
      });
    }

    setState(() => _isLoading = false);
  }

  Widget _buildContent() {
    return _show
        ? Column(
            spacing: 12,
            children: [
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _teams.length,
                  itemBuilder: (context, index) {
                    final teamData = _teams[index];

                    return _buildTeamTile(teamData);
                  },
                ),
              ),
            ],
          )
        : GradientCenterButton(
            onPressed: () => setState(() {
              _show = true;
            }),
            label: 'Посмотреть',
          );
  }

  Widget _buildTeamTile(Map<String, dynamic> teamData) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: teamData['team'].color, width: 2),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Информация о команде
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        teamData['name'],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: teamData['team'].color,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Количество игроков: ${teamData['gamers'].length}',
                        style: TextStyle(fontSize: 14, color: textColor),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Список игроков
          Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Column(
              children: teamData['gamers'].map<Widget>((gamer) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: teamData['team'].bgColor,
                        child: Text(
                          gamer['username'][0].toUpperCase(),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: teamData['team'].color,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          gamer['username'],
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: teamData['team'].color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${gamer['role']['roleName']}'
                          '${gamer['role']['groupName'] != null ? ' (${gamer['role']['groupName']})' : ''}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: teamData['team'].color,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
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
