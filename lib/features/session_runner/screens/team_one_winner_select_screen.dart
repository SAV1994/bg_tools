import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bg_tools/core/consts/export.dart';
import 'package:bg_tools/core/widgets/export.dart';
import 'package:bg_tools/features/session_runner/categories.dart';

enum _SelectMode { single, multiple, none }

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

class TeamOneWinnerSelectScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> data;

  const TeamOneWinnerSelectScreen({super.key, required this.data});

  @override
  ConsumerState<TeamOneWinnerSelectScreen> createState() =>
      _TeamOneWinnerSelectScreenState();
}

class _TeamOneWinnerSelectScreenState
    extends ConsumerState<TeamOneWinnerSelectScreen> {
  _SelectMode _mode = _SelectMode.single;
  _SelectScoreMode _scoreMode = _SelectScoreMode.sum;
  final List<Map<String, dynamic>> _teams = [];
  int? _singleSelected;
  final Set<int> _multipleSelected = {};
  // Загрузка
  bool _isLoading = false;

  @override
  void initState() {
    _isLoading = true;
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    List<int> winnerIds = [];
    for (final teamData in widget.data['teamsData'].entries) {
      if (teamData.value['place'] == 1) {
        winnerIds.add(int.parse(teamData.key));
      }
    }

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
      final String teamName =
          widget.data['teamsData'][teamData.key]['name'] ?? teamEnum.label;

      _teams.add({
        'team': teamEnum,
        'name': teamName,
        'gamers': gamersMap[teamData.key],
        'controller': null,
        'score': teamData.value['score'],
      });
    }

    if (widget.data['teamPointType'] == TeamPointTypeEnum.personal.id) {
      for (final teamData in _teams) {
        _updateTeamScore(teamData);
      }
    }

    if (winnerIds.length > 1) {
      _mode = _SelectMode.multiple;
      _multipleSelected.addAll(winnerIds);
    } else if (winnerIds.length == 1) {
      _singleSelected = winnerIds[0];
    } else {
      _sortByWinCondition();
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

  void _toggleMode(_SelectMode selectedMode) {
    setState(() {
      _mode = selectedMode;
      if (_mode == _SelectMode.single && _multipleSelected.isNotEmpty) {
        _singleSelected = _multipleSelected.first;
        _updateData([_singleSelected!]);
        _multipleSelected.clear();
      } else if (_mode == _SelectMode.multiple && _singleSelected != null) {
        _multipleSelected.add(_singleSelected!);
        _updateData(_multipleSelected.toList());
        _singleSelected = null;
      } else if (_mode == _SelectMode.none) {
        _singleSelected = null;
        _multipleSelected.clear();
        _updateData([]);
      }
    });
  }

  void _toggleScoreMode(Set<_SelectScoreMode> selection) {
    _scoreMode = selection.first;
    widget.data['resulScreenMode'] = _scoreMode.id;

    for (var teamData in _teams) {
      _updateTeamScore(teamData);
    }

    _sortByWinCondition();

    setState(() {});
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

  void _updateData(List<int> selectedIds) {
    for (final teamData in widget.data['teamsData'].entries) {
      if (selectedIds.contains(int.parse(teamData.key))) {
        teamData.value['place'] = 1;
      } else {
        teamData.value['place'] = null;
      }
    }

    for (final Map<String, dynamic> gamerData in widget.data['gamers']) {
      if (selectedIds.contains(gamerData['team'])) {
        gamerData['place'] = 1;
      } else {
        gamerData['place'] = null;
      }
    }
  }

  void _toggleItem(int teamId) {
    setState(() {
      if (_mode == _SelectMode.single) {
        _singleSelected = teamId;
        _updateData([_singleSelected!]);
      } else {
        if (_multipleSelected.contains(teamId)) {
          _multipleSelected.remove(teamId);
        } else {
          _multipleSelected.add(teamId);
        }
        _updateData(_multipleSelected.toList());
      }
    });
  }

  bool _isSelected(int teamId) {
    return _mode == _SelectMode.single
        ? _singleSelected == teamId
        : _multipleSelected.contains(teamId);
  }

  Widget _buildTeamTile(Map<String, dynamic> teamData, bool isSelected) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? teamData['team'].color : Colors.transparent,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => _toggleItem(teamData['team'].id),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Индикатор выбора
                  if (_mode != _SelectMode.none) ...[
                    _buildSelectionIndicator(isSelected),
                    const SizedBox(width: 16),
                  ],

                  if (widget.data['type'] != GameTypeEnum.secretRoles.id) ...[
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: teamData['team'].color,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          widget
                                  .data['teamsData'][teamData['team'].id
                                      .toString()]['numWinRounds']
                                  ?.toString() ??
                              '0',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
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
                          (widget.data['type'] != GameTypeEnum.secretRoles.id)
                              ? 'Очки: ${widget.data['teamsData'][teamData['team'].id.toString()]['score'] ?? 0}'
                              : 'Количество игроков: ${teamData['gamers'].length}',
                          style: TextStyle(fontSize: 14, color: titleColor),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
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
                        backgroundColor: teamData['team'].color.withOpacity(
                          0.2,
                        ),
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
                          (widget.data['type'] != GameTypeEnum.secretRoles.id)
                              ? '${gamer['score'] ?? 0}'
                              : '${gamer['role']['roleName']}${gamer['role']['groupName'] != null ? ' (${gamer['role']['groupName']})' : ''}',
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

  Widget _buildSelectionIndicator(bool isSelected) {
    if (_mode == _SelectMode.single) {
      return Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? Colors.blue : Colors.transparent,
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey.shade400,
            width: 2,
          ),
        ),
        child: isSelected
            ? const Icon(Icons.check, size: 16, color: Colors.white)
            : null,
      );
    }
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue : Colors.transparent,
        border: Border.all(
          color: isSelected ? Colors.blue : Colors.grey.shade400,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: isSelected
          ? const Icon(Icons.check, size: 16, color: Colors.white)
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return _isLoading
            ? LoadingScreen()
            : Column(
                children: [
                  // Кнопка переключение режима командных очков
                  if (widget.data['teamPointType'] ==
                          TeamPointTypeEnum.personal.id &&
                      _mode != _SelectMode.none)
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

                  // Кнопка переключения режима
                  if (widget.data['type'] != GameTypeEnum.secretRoles.id)
                    SegmentedButton<_SelectMode>(
                      segments: const [
                        ButtonSegment(
                          value: _SelectMode.single,
                          label: Text('Один победитель'),
                          icon: Icon(Icons.radio_button_unchecked),
                        ),
                        ButtonSegment(
                          value: _SelectMode.multiple,
                          label: Text('Ничья'),
                          icon: Icon(Icons.check_box_outline_blank),
                        ),
                        ButtonSegment(
                          value: _SelectMode.none,
                          label: Text('Поражение'),
                          icon: Icon(Icons.sentiment_very_dissatisfied),
                        ),
                      ],
                      selected: {_mode},
                      onSelectionChanged: (Set<_SelectMode> selection) {
                        _toggleMode(selection.first);
                      },
                    ),

                  if (_mode != _SelectMode.none)
                    // Информационная панель
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Icon(
                            _mode == _SelectMode.single
                                ? Icons.radio_button_checked
                                : Icons.check_box,
                            color: Colors.blue,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _mode == _SelectMode.single
                                  ? 'Выберите одного победителя'
                                  : 'Выберите несколько победителей (${_multipleSelected.length} выбрано)',
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Список элементов
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _teams.length,
                      itemBuilder: (context, index) {
                        final teamData = _teams[index];
                        final isSelected = _isSelected(teamData['team'].id);

                        return _buildTeamTile(teamData, isSelected);
                      },
                    ),
                  ),
                ],
              );
      },
    );
  }
}
