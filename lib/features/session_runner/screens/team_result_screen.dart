import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bg_tools/core/consts/export.dart';
import 'package:bg_tools/core/widgets/export.dart';
import 'package:bg_tools/features/session_runner/categories.dart';

enum _SelectMode { single, draw }

enum _SelectScoreMode {
  max(1),
  min(2),
  sum(3),
  multiple(4);

  final int id;

  const _SelectScoreMode(this.id);

  // Получить enum по id
  static _SelectScoreMode fromId(int id) {
    return _SelectScoreMode.values.firstWhere(
      (e) => e.id == id,
      orElse: () => _SelectScoreMode.sum,
    );
  }
}

class TeamResultScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> data;

  const TeamResultScreen({super.key, required this.data});

  @override
  ConsumerState<TeamResultScreen> createState() => _TeamResultScreenState();
}

class _TeamResultScreenState extends ConsumerState<TeamResultScreen> {
  _SelectMode _mode = _SelectMode.single;
  _SelectScoreMode _scoreMode = _SelectScoreMode.sum;
  final List<Map<String, dynamic>> _teams = [];
  // Загрузка
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _loadData();
  }

  Future<void> _loadData() async {
    for (int i = 1; i <= widget.data['numberTeams']; i++) {
      final teamEnum = TeamsEnum.fromId(i);
      _teams.add({
        'team': teamEnum,
        'gamers': [],
        'controller': null,
        'score': null,
        'showTeam': false,
      });
    }

    for (Map<String, dynamic> gamerData in widget.data['gamers']) {
      _teams[gamerData['team'] - 1]['gamers'].add(gamerData);
    }

    if (widget.data['teamPointType'] == TeamPointTypeEnum.personal.id) {
      for (final teamData in _teams) {
        _updateTeamScore(teamData);
      }
    } else {
      for (final teamData in _teams) {
        teamData['score'] =
            widget.data['teamsData'][teamData['team'].id.toString()]['score'];
      }
    }

    Set<int> places = {};
    for (final teamData in widget.data['teamsData'].values) {
      if (teamData['place'] != null) {
        places.add(teamData['place']);
      }
    }

    if (places.isEmpty) {
      _sortByWinCondition();
    } else if (places.length != _teams.length) {
      _mode = _SelectMode.draw;
      for (final entry in widget.data['teamsData'].asMap().entries) {
        _setTeamPlace(int.parse(entry.key), entry.value['place']);
      }
    }

    for (final entry in _teams.asMap().entries) {
      entry.value['controller'] = TextEditingController(
        text: (entry.key + 1).toString(),
      );
    }

    if (widget.data['teamPointType'] == TeamPointTypeEnum.personal.id) {
      if (widget.data['resulScreenMode'] == null) {
        widget.data['resulScreenMode'] = _scoreMode.id;
      } else {
        _scoreMode = _SelectScoreMode.fromId(widget.data['resulScreenMode']);
      }
    }

    setState(() => _isLoading = false);
  }

  void _setTeamPlace(int teamId, int place) {
    final TeamsEnum teamEnum = TeamsEnum.fromId(teamId);

    final teamData = _teams.firstWhere((td) => td['team'].id == teamEnum.id);
    teamData['controller'] = TextEditingController(text: place.toString());
    for (final Map<String, dynamic> gamerData in teamData['gamers']) {
      gamerData['place'] = place;
    }
  }

  void _updateTeamScore(Map<String, dynamic> teamData) {
    bool isFirst = true;
    int teamScore = (_scoreMode == _SelectScoreMode.multiple) ? 1 : 0;
    for (final Map<String, dynamic> gamerData in teamData['gamers']) {
      final int score = gamerData['score'] ?? 0;
      if (_scoreMode == _SelectScoreMode.max) {
        if (score > teamScore) {
          teamScore = score;
        }
      } else if (_scoreMode == _SelectScoreMode.min) {
        if (score < teamScore) {
          teamScore = score;
        }

        if (isFirst) {
          teamScore = score;
          isFirst = false;
        }
      } else if (_scoreMode == _SelectScoreMode.sum) {
        teamScore += score;
      } else if (_scoreMode == _SelectScoreMode.multiple) {
        teamScore *= score;
      }
    }

    widget.data['teamsData'][teamData['team'].id.toString()]['score'] =
        teamScore;
    teamData['score'] = teamScore;
  }

  void _sortByWinCondition() {
    _teams.sort((a, b) {
      final scoreA = a['score'] as int? ?? 0;
      final scoreB = b['score'] as int? ?? 0;
      if (widget.data['pointType'] == PointTypeEnum.max.id) {
        return scoreB.compareTo(scoreA);
      } else {
        return scoreA.compareTo(scoreB);
      }
    });

    _fillPlace();
  }

  void _fillPlace() {
    for (final entry in _teams.asMap().entries) {
      widget.data['teamsData'][entry.value['team'].id.toString()]['place'] =
          entry.key + 1;

      for (Map<String, dynamic> gamerData in entry.value['gamers']) {
        gamerData['place'] = entry.key + 1;
      }
    }
  }

  void _fillPlaceDraw() {
    for (final entry in _teams.asMap().entries) {
      final int? place = (entry.value['controller'].text != null)
          ? int.tryParse(entry.value['controller'].text)
          : null;

      widget.data['teamsData'][entry.value['team'].id.toString()]['place'] =
          place;

      for (Map<String, dynamic> gamerData in entry.value['gamers']) {
        gamerData['place'] = place;
      }
    }
  }

  void _toggleMode() {
    setState(() {
      _mode = _mode == _SelectMode.single
          ? _SelectMode.draw
          : _SelectMode.single;
      if (_mode == _SelectMode.single) {
        _fillPlace();
      }
    });
  }

  void _toggleScoreMode(Set<_SelectScoreMode> selection) {
    setState(() {
      _scoreMode = selection.first;
      widget.data['resulScreenMode'] = _scoreMode.id;

      for (var teamData in _teams) {
        _updateTeamScore(teamData);
      }

      _sortByWinCondition();
    });
  }

  void _reorder(int oldIndex, int newIndex) {
    setState(() {
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }
      final Map<String, dynamic> teamData = _teams.removeAt(oldIndex);
      _teams.insert(newIndex, teamData);

      _fillPlace();
    });
  }

  void _updatePlace(Map<String, dynamic> teamData, String place) {
    _teams.sort((a, b) {
      final scoreA = a['controller'].text as String? ?? '0';
      final scoreB = b['controller'].text as String? ?? '0';
      return scoreA.compareTo(scoreB);
    });

    _fillPlaceDraw();
  }

  Widget _buildDragAndDropMode() {
    return ReorderableListView.builder(
      padding: const EdgeInsets.all(16),
      onReorder: _reorder,
      proxyDecorator: (child, index, animation) {
        return Material(elevation: 0, color: Colors.transparent, child: child);
      },
      itemCount: _teams.length,
      itemBuilder: (context, index) {
        final Map<String, dynamic> teamData = _teams[index];
        return Container(
          key: Key('${teamData['team'].color}_$index'),
          margin: const EdgeInsets.only(bottom: 16),
          child: _buildTeamCard(teamData, index + 1),
        );
      },
    );
  }

  Widget _buildManualMode() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _teams.length,
      itemBuilder: (context, index) {
        final team = _teams[index];
        return _buildTeamCard(team, index + 1, showPlaceInput: true);
      },
    );
  }

  Widget _buildTeamCard(
    Map<String, dynamic> teamData,
    int currentPlace, {
    bool showPlaceInput = false,
  }) {
    final TeamsEnum team = teamData['team'];

    return Container(
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
              children: [
                // Место
                if (showPlaceInput)
                  _buildPlaceInput(teamData, currentPlace)
                else
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        '$currentPlace',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: blackColor,
                        ),
                      ),
                    ),
                  ),
                const SizedBox(width: 12),
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
                          color: blackColor,
                        ),
                      ),
                      if (widget.data['resultType'] !=
                          ResultTypeEnum.condition.id)
                        Text(
                          'Сумма очков: ${teamData['score']}',
                          style: TextStyle(fontSize: 14, color: blackColor),
                        ),
                    ],
                  ),
                ),
                // Drag handle для режима перетаскивания
                if (_mode == _SelectMode.single &&
                    (widget.data['altVictoryType'] ==
                            AltVictoryTypeEnum.yes.id ||
                        (widget.data['resultType']) ==
                            ResultTypeEnum.condition.id))
                  ReorderableDragStartListener(
                    index: _teams.indexOf(teamData),
                    child: Icon(Icons.drag_handle, color: Colors.white),
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
                      if (widget.data['teamPointType'] ==
                          TeamPointTypeEnum.personal.id)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: secondColor,
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

  Widget _buildPlaceInput(Map<String, dynamic> teamData, int place) {
    return SizedBox(
      width: 60,
      child: TextFormField(
        controller: teamData['controller'],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
        ),
        onChanged: (value) {
          _updatePlace(teamData, value);
        },
      ),
    );
  }

  @override
  void dispose() {
    for (final Map<String, dynamic> teamData in _teams) {
      teamData['controller']?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return _isLoading
            ? LoadingScreen()
            : Column(
                spacing: 12,
                children: [
                  // Кнопка переключения режима
                  SegmentedButton<_SelectMode>(
                    segments: const [
                      ButtonSegment(
                        value: _SelectMode.single,
                        label: Text('1 команда - 1 место'),
                        icon: Icon(Icons.radio_button_unchecked),
                      ),
                      ButtonSegment(
                        value: _SelectMode.draw,
                        label: Text('Ничья'),
                        icon: Icon(Icons.check_box_outline_blank),
                      ),
                    ],
                    selected: {_mode},
                    onSelectionChanged: (Set<_SelectMode> selection) {
                      _toggleMode();
                    },
                  ),

                  // Кнопка переключение режима командных очков
                  if (widget.data['teamPointType'] ==
                      TeamPointTypeEnum.personal.id)
                    SegmentedButton<_SelectScoreMode>(
                      segments: const [
                        ButtonSegment(
                          value: _SelectScoreMode.sum,
                          label: Text('+'),
                          icon: Icon(Icons.radio_button_unchecked),
                        ),
                        ButtonSegment(
                          value: _SelectScoreMode.multiple,
                          label: Text('x'),
                          icon: Icon(Icons.check_box_outline_blank),
                        ),
                        ButtonSegment(
                          value: _SelectScoreMode.max,
                          label: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text('MAX'),
                          ),
                          icon: Icon(Icons.check_box_outline_blank),
                        ),
                        ButtonSegment(
                          value: _SelectScoreMode.min,
                          label: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text('MIN'),
                          ),
                          icon: Icon(Icons.check_box_outline_blank),
                        ),
                      ],
                      selected: {_scoreMode},
                      onSelectionChanged: (Set<_SelectScoreMode> selection) {
                        _toggleScoreMode(selection);
                      },
                    ),

                  (_mode == _SelectMode.single)
                      ? Flexible(child: _buildDragAndDropMode())
                      : Flexible(child: _buildManualMode()),
                ],
              );
      },
    );
  }
}
