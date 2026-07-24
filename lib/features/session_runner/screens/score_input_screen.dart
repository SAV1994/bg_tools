import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bg_tools/core/consts/export.dart';
import 'package:bg_tools/core/widgets/export.dart';
import 'package:bg_tools/features/session_runner/categories.dart';
import 'package:bg_tools/features/session_runner/widgets/export.dart';

class ScoreInputScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> data;

  const ScoreInputScreen({super.key, required this.data});

  @override
  ConsumerState<ScoreInputScreen> createState() => _ScoreInputScreenState();
}

class _ScoreInputScreenState extends ConsumerState<ScoreInputScreen> {
  // Контроллеры
  final Map<TeamsEnum, dynamic> _generalScoreController = {};
  final Map<int, dynamic> _scoreControllers = {};
  // Загрузка
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _loadData();
  }

  Future<void> _loadData() async {
    if (widget.data['teamPointType'] == TeamPointTypeEnum.general.id) {
      if (widget.data['type'] == GameTypeEnum.secretTeams.id &&
          widget.data['teamsData'].values.every(
            (element) => element['score'] == null,
          )) {
        List<Map<String, dynamic>> gamersData = widget.data['gamers']
            .cast<Map<String, dynamic>>();
        for (final Map<String, dynamic> gamerData in gamersData) {
          Map<String, dynamic> teamData =
              widget.data['teamsData'][gamerData['team'].toString()];
          if (gamerData['score'] != null) {
            if (teamData['score'] == null) {
              teamData['score'] = gamerData['score'];
            } else {
              teamData['score'] += gamerData['score'];
            }
          }
        }
      }

      for (int i = 1; i <= widget.data['numberTeams']; i++) {
        final teamEnum = TeamsEnum.fromId(i);
        _generalScoreController[teamEnum] = ({
          'team': teamEnum,
          'gamers': [],
          'controller': TextEditingController(
            text: widget.data['teamsData'][teamEnum.id.toString()]['score']
                ?.toString(),
          ),
        });
      }

      for (Map<String, dynamic> gamerData in widget.data['gamers']) {
        final TeamsEnum teamEnum = TeamsEnum.fromId(gamerData['team']);
        _generalScoreController[teamEnum]['gamers'].add(gamerData);
      }
    } else {
      List<Map<String, dynamic>> gamersData = widget.data['gamers']
          .cast<Map<String, dynamic>>();
      for (final Map<String, dynamic> gamerData in gamersData) {
        _scoreControllers[gamerData['id']] = {
          'username': gamerData['username'],
          'controller': TextEditingController(
            text: gamerData['score']?.toString() ?? '',
          ),
        };
      }
    }

    setState(() => _isLoading = false);
  }

  void _updateScore(int gamerId, String value) {
    final newScore = int.tryParse(value);
    for (final Map<String, dynamic> gamerData in widget.data['gamers']) {
      if (gamerData['id'] == gamerId) {
        gamerData['score'] = newScore;
      }
    }
  }

  Widget _buildTeamCard(Map<String, dynamic> teamData) {
    final TeamsEnum team = teamData['team'];

    return Container(
      margin: EdgeInsetsGeometry.only(bottom: 5),
      decoration: BoxDecoration(
        color: team.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: team.color, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Заголовок команды
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: team.color,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(14),
                topRight: Radius.circular(14),
              ),
            ),
            child: Row(
              spacing: 12,
              children: [
                _buildPlaceInput(teamData),
                Expanded(
                  child: Column(
                    spacing: 4,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        team.label,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Список игроков
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: teamData['gamers'].map<Widget>((gamer) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: team.color,
                        child: Text(
                          gamer['username'][0].toUpperCase(),
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          gamer['username'],
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      if (widget.data['TeamPointTypeEnum'] ==
                          TeamPointTypeEnum.personal.id)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${gamer['score']}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
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

  Widget _buildPlaceInput(Map<String, dynamic> teamData) {
    return SizedBox(
      width: 120,
      child: TextFormField(
        controller: teamData['controller'],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: teamData['team'].color,
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
        ),
        onChanged: (value) {
          final newScore = int.tryParse(value);
          widget.data['teamsData'][teamData['team'].id.toString()]['score'] =
              newScore;
        },
      ),
    );
  }

  @override
  void dispose() {
    for (final Map<String, dynamic> controllerData
        in _scoreControllers.values) {
      controllerData['controller'].dispose();
    }

    for (final Map<String, dynamic> controllerData
        in _generalScoreController.values) {
      controllerData['controller'].dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        if (_isLoading) {
          return LoadingScreen();
        }

        if (widget.data['teamPointType'] == TeamPointTypeEnum.general.id) {
          final List<dynamic> teamsData = _generalScoreController.values
              .toList();

          return Column(
            children: [
              Flexible(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _generalScoreController.length,
                  itemBuilder: (context, index) {
                    final teamData = teamsData[index];
                    return _buildTeamCard(teamData);
                  },
                ),
              ),
            ],
          );
        }

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(16),
                  itemCount: widget.data['gamers'].length,
                  itemBuilder: (context, index) {
                    final Map<String, dynamic> gamerData =
                        widget.data['gamers'][index];
                    return PlayerInputCard(
                      gamerId: gamerData['id'],
                      controllerData: _scoreControllers[gamerData['id']],
                      addCalcBtn: true,
                      digitsOnly: false,
                      updateScore: _updateScore,
                      color: (gamerData['team'] != null)
                          ? TeamsEnum.fromId(gamerData['team']).color
                          : null,
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
