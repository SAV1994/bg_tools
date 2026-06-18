import 'package:bg_tools/core/utils/player_round_score_card_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bg_tools/core/app_data.dart';
import 'package:bg_tools/core/consts.dart';
import 'package:bg_tools/core/utils/loading_screen_builder.dart';
import 'package:bg_tools/core/widgets/score_calc_modal.dart';
import 'package:bg_tools/features/session_runner/categories.dart';

class TeamScoreRoundScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> data;

  const TeamScoreRoundScreen({super.key, required this.data});

  @override
  ConsumerState<TeamScoreRoundScreen> createState() =>
      _TeamScoreRoundScreenState();
}

class _TeamScoreRoundScreenState extends ConsumerState<TeamScoreRoundScreen> {
  String? _lastRoundFirst;
  bool _isFinished = false;
  late final int? _roundsScoreLimit;
  // Контроллеры
  List<Map<String, dynamic>> _scoreControllers = [];
  List<Map<String, dynamic>> _teamScoreControllers = [];
  // Загрузка
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _loadData();
  }

  Future<void> _loadData() async {
    _roundsScoreLimit = widget.data['roundsScoreLimit'];

    if (widget.data['teamPointType'] == TeamPointTypeEnum.general.id) {
      for (int i = 1; i <= widget.data['numberTeams']; i++) {
        final teamEnum = TeamsEnum.fromId(i);
        final int? score = widget.data['teamsData'][i.toString()]['score'];
        _teamScoreControllers.add({
          'team': teamEnum,
          'controller': TextEditingController(),
          'gamers': [],
          'score': score,
          'show': false,
        });

        if (_isFinished == false &&
            _roundsScoreLimit != null &&
            score != null) {
          _isFinished =
              _roundsScoreLimit < 0 && score <= _roundsScoreLimit ||
              _roundsScoreLimit >= 0 && score >= _roundsScoreLimit;
        }
      }

      for (Map<String, dynamic> gamerData in widget.data['gamers']) {
        _teamScoreControllers[gamerData['team'] - 1]['gamers'].add(gamerData);
      }
    } else {
      List<Map<String, dynamic>> gamersData = widget.data['gamers']
          .cast<Map<String, dynamic>>();
      for (final Map<String, dynamic> gamerData in gamersData) {
        _scoreControllers.add({
          'controller': TextEditingController(),
          'score': gamerData['score'],
        });

        if (_isFinished == false &&
            _roundsScoreLimit != null &&
            gamerData['score'] != null) {
          _isFinished =
              _roundsScoreLimit < 0 &&
                  gamerData['score'] <= _roundsScoreLimit ||
              _roundsScoreLimit >= 0 && gamerData['score'] >= _roundsScoreLimit;
        }
      }
    }

    _sortByCondition();

    setState(() => _isLoading = false);
  }

  Future<void> _nextRound() async {
    setState(() => _isLoading = true);

    if (widget.data['teamPointType'] == TeamPointTypeEnum.general.id) {
      _nextRoundTeams();
    } else {
      _nextRoundPlayers();
    }

    await AppDataManager.saveActiveSession(widget.data);

    setState(() => _isLoading = false);
  }

  void _nextRoundPlayers() {
    _lastRoundFirst = widget.data['gamers'][0]['username'];
    List<(int, int)> roundResults = [];

    for (int i = 0; i < _scoreControllers.length; i++) {
      final Map<String, dynamic> controllerData = _scoreControllers[i];
      final Map<String, dynamic> gamerData = widget.data['gamers'][i];

      final newScore = int.tryParse(controllerData['controller'].text) ?? 0;

      controllerData['controller'].clear();

      roundResults.add((i, newScore));

      if (gamerData['score'] != null) {
        gamerData['score'] += newScore;
      } else {
        gamerData['score'] = newScore;
      }

      gamerData['scoreByrounds'].add(newScore);
      controllerData['score'] = gamerData['score'];
      if (_isFinished == false && _roundsScoreLimit != null) {
        if (_roundsScoreLimit < 0) {
          _isFinished = gamerData['score'] <= _roundsScoreLimit;
        } else {
          _isFinished = gamerData['score'] >= _roundsScoreLimit;
        }
      }
    }

    if (widget.data['pointType'] == PointTypeEnum.max.id) {
      roundResults.sort((a, b) => b.$2.compareTo(a.$2));
    } else {
      roundResults.sort((a, b) => a.$2.compareTo(b.$2));
    }
    // Засчитываем победу в раунде только если не было ничьей
    if (roundResults[0].$2 != roundResults[1].$2) {
      widget.data['gamers'][roundResults[0].$1]['numWInRounds'] += 1;
    }

    if (!_isFinished) {
      widget.data['round']++;

      _sortByCondition();
    }
  }

  void _nextRoundTeams() {
    _lastRoundFirst = _teamScoreControllers[0]['team'].label;
    List<(String, int)> roundResults = [];

    for (final controllerData in _teamScoreControllers) {
      final TeamsEnum team = controllerData['team'];

      final newScore = int.tryParse(controllerData['controller'].text) ?? 0;

      controllerData['controller'].clear();

      roundResults.add((team.id.toString(), newScore));

      if (widget.data['teamsData'][team.id.toString()]['score'] != null) {
        widget.data['teamsData'][team.id.toString()]['score'] += newScore;
      } else {
        widget.data['teamsData'][team.id.toString()]['score'] = newScore;
      }
      widget.data['teamsData'][team.id.toString()]['scoreByrounds'].add(
        newScore,
      );

      controllerData['score'] =
          widget.data['teamsData'][team.id.toString()]['score'];
      if (_isFinished == false && _roundsScoreLimit != null) {
        if (_roundsScoreLimit < 0) {
          _isFinished =
              widget.data['teamsData'][team.id.toString()]['score'] <=
              _roundsScoreLimit;
        } else {
          _isFinished =
              widget.data['teamsData'][team.id.toString()]['score'] >=
              _roundsScoreLimit;
        }
      }
    }

    if (widget.data['pointType'] == PointTypeEnum.max.id) {
      roundResults.sort((a, b) => b.$2.compareTo(a.$2));
    } else {
      roundResults.sort((a, b) => a.$2.compareTo(b.$2));
    }
    // Засчитываем победу в раунде только если не было ничьей
    if (roundResults[0].$2 != roundResults[1].$2) {
      if (widget.data['teamsData'][roundResults[0].$1]['numWInRounds'] !=
          null) {
        widget.data['teamsData'][roundResults[0].$1]['numWInRounds'] += 1;
      } else {
        widget.data['teamsData'][roundResults[0].$1]['numWInRounds'] = 1;
      }
    }

    if (!_isFinished) {
      widget.data['round']++;

      _sortByCondition();
    }
  }

  void _sortByCondition() {
    if (widget.data['firstPlayerRoundType'] ==
        FirstPlayerRoundTypeEnum.queue.id) {
      _sortByClockwise(1);
    } else if (widget.data['firstPlayerRoundType'] ==
        FirstPlayerRoundTypeEnum.leader.id) {
      _sortByLeaderCondition();
    } else if (widget.data['firstPlayerRoundType'] ==
        FirstPlayerRoundTypeEnum.loser.id) {
      late final data;
      if (widget.data['teamPointType'] == TeamPointTypeEnum.general.id) {
        data = _teamScoreControllers;
      } else {
        data = widget.data['gamers'];
      }

      if (widget.data['sequencePlayersMovesType'] ==
          SequencePlayersMovesTypeEnum.random.id) {
        data.sort((a, b) {
          final scoreA = a['score'] as int? ?? 0;
          final scoreB = b['score'] as int? ?? 0;
          if (widget.data['pointType'] == PointTypeEnum.max.id) {
            return scoreA.compareTo(scoreB);
          } else {
            return scoreB.compareTo(scoreA);
          }
        });

        if (widget.data['teamPointType'] == TeamPointTypeEnum.personal.id) {
          _scoreControllers.sort((a, b) {
            final scoreA = a['score'] as int? ?? 0;
            final scoreB = b['score'] as int? ?? 0;
            if (widget.data['pointType'] == PointTypeEnum.max.id) {
              return scoreA.compareTo(scoreB);
            } else {
              return scoreB.compareTo(scoreA);
            }
          });
        }
      } else {
        final int loserIndex = data.asMap().entries.fold(null, (
          fixed,
          current,
        ) {
          final int currentScore = current.value['score'] ?? 0;
          final int fixedScore = fixed?.value['score'] ?? 0;

          if (widget.data['pointType'] == PointTypeEnum.max.id) {
            if (fixed == null || currentScore < fixedScore) {
              return current;
            }
          } else {
            if (fixed == null || currentScore > fixedScore) {
              return current;
            }
          }

          return fixed;
        })?.key;

        _sortByClockwise(loserIndex);
      }
    } else if (widget.data['firstPlayerRoundType'] ==
        FirstPlayerRoundTypeEnum.leaderNext.id) {
      _sortByLeaderCondition();
      _sortByClockwise(1);
    }
  }

  void _sortByLeaderCondition() {
    late final data;
    if (widget.data['teamPointType'] == TeamPointTypeEnum.general.id) {
      data = _teamScoreControllers;
    } else {
      data = widget.data['gamers'];
    }

    if (widget.data['sequencePlayersMovesType'] ==
        SequencePlayersMovesTypeEnum.random.id) {
      data.sort((a, b) {
        final scoreA = a['score'] as int? ?? 0;
        final scoreB = b['score'] as int? ?? 0;
        if (widget.data['pointType'] == PointTypeEnum.max.id) {
          return scoreB.compareTo(scoreA);
        } else {
          return scoreA.compareTo(scoreB);
        }
      });

      if (widget.data['teamPointType'] == TeamPointTypeEnum.personal.id) {
        _scoreControllers.sort((a, b) {
          final scoreA = a['score'] as int? ?? 0;
          final scoreB = b['score'] as int? ?? 0;
          if (widget.data['pointType'] == PointTypeEnum.max.id) {
            return scoreB.compareTo(scoreA);
          } else {
            return scoreA.compareTo(scoreB);
          }
        });
      }
    } else {
      final int leaderIndex = data.asMap().entries.fold(null, (fixed, current) {
        final int currentScore = current.value['score'] ?? 0;
        final int fixedScore = fixed?.value['score'] ?? 0;

        if (widget.data['pointType'] == PointTypeEnum.max.id) {
          if (fixed == null || currentScore > fixedScore) {
            return current;
          }
        } else {
          if (fixed == null || currentScore < fixedScore) {
            return current;
          }
        }

        return fixed;
      })?.key;

      _sortByClockwise(leaderIndex);
    }
  }

  void _sortByClockwise(int index) {
    late final List<Map<String, dynamic>> data;
    if (widget.data['teamPointType'] == TeamPointTypeEnum.general.id) {
      data = _teamScoreControllers;
    } else {
      data = widget.data['gamers'].cast<Map<String, dynamic>>();
    }

    final List<Map<String, dynamic>> reorderGamers =
        data.sublist(index) + data.sublist(0, index);
    if (widget.data['teamPointType'] == TeamPointTypeEnum.general.id) {
      _teamScoreControllers = reorderGamers;
    } else {
      widget.data['gamers'] = reorderGamers;
      final List<dynamic> reorderControllers =
          _scoreControllers.sublist(index) +
          _scoreControllers.sublist(0, index);
      _scoreControllers = reorderControllers as List<Map<String, dynamic>>;
    }
  }

  void _reorder(int oldIndex, int newIndex) {
    setState(() {
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }

      final Map<String, dynamic> gamerData = widget.data['gamers'].removeAt(
        oldIndex,
      );
      widget.data['gamers'].insert(newIndex, gamerData);

      final Map<String, dynamic> controllerData = _scoreControllers.removeAt(
        oldIndex,
      );
      _scoreControllers.insert(newIndex, controllerData);
    });

    setState(() {});
  }

  Widget _buildScrean() {
    if (widget.data['teamPointType'] == TeamPointTypeEnum.general.id) {
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.deepPurple.shade200, Colors.white],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              children: [
                if (_lastRoundFirst != null)
                  Text(
                    'Предыдущий раунд ходила первой: $_lastRoundFirst',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                Text(
                  (widget.data['round'] < widget.data['totalRounds'] &&
                          _isFinished == false)
                      ? 'Раунд ${widget.data['round'] + 1} из '
                            '${(widget.data['totalRounds'] == infNumRounds) ? '∞' : widget.data['totalRounds']}'
                      : 'По итогу всех раундов',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                ReorderableListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(16),
                  onReorder: _reorder,
                  children: List.generate(_teamScoreControllers.length, (
                    index,
                  ) {
                    final Map<String, dynamic> teamData =
                        _teamScoreControllers[index];

                    return _buildTeamCard(teamData);
                  }),
                ),

                if (widget.data['round'] < widget.data['totalRounds'] &&
                    _isFinished == false)
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _nextRound,
                          child: Text('Следующий раунд'),
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

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.deepPurple.shade200, Colors.white],
        ),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            children: [
              if (_lastRoundFirst != null)
                Text(
                  'Предыдущий раунд ходил первым: $_lastRoundFirst',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              Text(
                (widget.data['round'] < widget.data['totalRounds'] &&
                        _isFinished == false)
                    ? 'Раунд ${widget.data['round'] + 1} из '
                          '${(widget.data['totalRounds'] == infNumRounds) ? '∞' : widget.data['totalRounds']}'
                    : 'По итогу всех раундов',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              ReorderableListView(
                shrinkWrap: true,
                padding: const EdgeInsets.all(16),
                onReorder: _reorder,
                children: List.generate(widget.data['gamers'].length, (index) {
                  final Map<String, dynamic> gamerData =
                      widget.data['gamers'][index];

                  return Container(
                    key: Key('${gamerData['id']}_$index'),
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withValues(alpha: 0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: buildPlayerRoundScoreInputCard(
                        context,
                        index,
                        _scoreControllers,
                        widget.data,
                        _isFinished,
                      ),
                    ),
                  );
                }),
              ),

              if (widget.data['round'] < widget.data['totalRounds'] &&
                  !_isFinished)
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _nextRound,
                        child: Text('Следующий раунд'),
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

  Widget _buildTeamCard(Map<String, dynamic> teamData) {
    return Card(
      key: Key('${teamData['team'].id}'),
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          // Заголовок команды
          InkWell(
            onTap: () => setState(() {
              teamData['show'] = !teamData['show'];
            }),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Цвет команды
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
                                .toString()]['numWInRounds']
                            .toString(),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Информация о команде
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          teamData['team'].label,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Счки: ${teamData['score'] ?? '...'}',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Поле ввода очков
                  SizedBox(
                    width: 100,
                    child: TextFormField(
                      enabled:
                          widget.data['round'] < widget.data['totalRounds'] &&
                          !_isFinished,
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
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Список игроков (сворачиваемый)
          if (teamData['show'])
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
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
  void dispose() {
    for (final Map<String, dynamic> controllerData in _scoreControllers) {
      controllerData['controller'].dispose();
    }
    for (final Map<String, dynamic> controllerData in _teamScoreControllers) {
      controllerData['controller'].dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return _isLoading ? buildLoadingScreen() : _buildScrean();
      },
    );
  }
}
