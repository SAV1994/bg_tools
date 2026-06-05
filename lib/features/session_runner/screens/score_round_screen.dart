import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bg_tools/core/app_data.dart';
import 'package:bg_tools/core/consts.dart';
import 'package:bg_tools/core/utils/loading_screen_builder.dart';
import 'package:bg_tools/core/widgets/score_calc_modal.dart';
import 'package:bg_tools/features/session_runner/categories.dart';

class ScoreRoundScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> data;

  const ScoreRoundScreen({super.key, required this.data});

  @override
  ConsumerState<ScoreRoundScreen> createState() => _ScoreRoundScreenState();
}

class _ScoreRoundScreenState extends ConsumerState<ScoreRoundScreen> {
  String? _lastRoundFirstPlayer;
  int? _lastRoundGeneralScore;
  bool _isFinished = false;
  late final int? _roundsScoreLimit;
  // Контроллеры
  List<Map<String, dynamic>> _scoreControllers = [];
  late final TextEditingController _generalScoreController;
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
      if (widget.data['type'] == GameTypeEnum.coop.id) {
        final int? generalScore = widget.data['teamScores'][TeamsEnum.red.id];
        _generalScoreController = TextEditingController(
          text: generalScore?.toString(),
        );
        _isFinished =
            generalScore != null &&
            _roundsScoreLimit != null &&
            (_roundsScoreLimit < 0 && generalScore <= _roundsScoreLimit ||
                _roundsScoreLimit >= 0 && generalScore >= _roundsScoreLimit);
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

      _sortByCondition();
    }

    setState(() => _isLoading = false);
  }

  Future<void> _nextRound() async {
    setState(() => _isLoading = true);

    _lastRoundFirstPlayer = widget.data['gamers'][0]['username'];

    for (int i = 0; i < _scoreControllers.length; i++) {
      final Map<String, dynamic> controllerData = _scoreControllers[i];
      final Map<String, dynamic> gamerData = widget.data['gamers'][i];

      final newScore = int.tryParse(controllerData['controller'].text) ?? 0;

      controllerData['controller'].clear();

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

    if (!_isFinished) {
      widget.data['round']++;

      _sortByCondition();
    }

    await AppDataManager.saveActiveSession(widget.data);

    setState(() => _isLoading = false);
  }

  Future<void> _nextRoundGeneralScore() async {
    final newScore = int.tryParse(_generalScoreController.text) ?? 0;
    _generalScoreController.clear();

    if (widget.data['type'] == GameTypeEnum.coop.id) {
      if (widget.data['teamScores'][TeamsEnum.red.id] != null) {
        widget.data['teamScores'][TeamsEnum.red.id] += newScore;
      } else {
        widget.data['teamScores'][TeamsEnum.red.id] = newScore;
      }
    }

    if (_isFinished == false && _roundsScoreLimit != null) {
      if (_roundsScoreLimit < 0) {
        _isFinished =
            widget.data['teamScores'][TeamsEnum.red.id] <= _roundsScoreLimit;
      } else {
        _isFinished =
            widget.data['teamScores'][TeamsEnum.red.id] >= _roundsScoreLimit;
      }
    }

    if (!_isFinished) {
      widget.data['round']++;
    }

    _lastRoundGeneralScore = newScore;

    setState(() {});
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
      if (widget.data['sequencePlayersMovesType'] ==
          SequencePlayersMovesTypeEnum.random.id) {
        widget.data['gamers'].sort((a, b) {
          final scoreA = a['score'] as int? ?? 0;
          final scoreB = b['score'] as int? ?? 0;
          if (widget.data['pointType'] == PointTypeEnum.max.id) {
            return scoreA.compareTo(scoreB);
          } else {
            return scoreB.compareTo(scoreA);
          }
        });

        _scoreControllers.sort((a, b) {
          final scoreA = a['score'] as int? ?? 0;
          final scoreB = b['score'] as int? ?? 0;
          if (widget.data['pointType'] == PointTypeEnum.max.id) {
            return scoreA.compareTo(scoreB);
          } else {
            return scoreB.compareTo(scoreA);
          }
        });
      } else {
        final int loserIndex = widget.data['gamers'].asMap().entries.fold(
          null,
          (fixed, current) {
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
          },
        )?.key;

        _sortByClockwise(loserIndex);
      }
    } else if (widget.data['firstPlayerRoundType'] ==
        FirstPlayerRoundTypeEnum.leaderNext.id) {
      _sortByLeaderCondition();
      _sortByClockwise(1);
    }
  }

  void _sortByLeaderCondition() {
    if (widget.data['sequencePlayersMovesType'] ==
        SequencePlayersMovesTypeEnum.random.id) {
      widget.data['gamers'].sort((a, b) {
        final scoreA = a['score'] as int? ?? 0;
        final scoreB = b['score'] as int? ?? 0;
        if (widget.data['pointType'] == PointTypeEnum.max.id) {
          return scoreB.compareTo(scoreA);
        } else {
          return scoreA.compareTo(scoreB);
        }
      });

      _scoreControllers.sort((a, b) {
        final scoreA = a['score'] as int? ?? 0;
        final scoreB = b['score'] as int? ?? 0;
        if (widget.data['pointType'] == PointTypeEnum.max.id) {
          return scoreB.compareTo(scoreA);
        } else {
          return scoreA.compareTo(scoreB);
        }
      });
    } else {
      final int leaderIndex = widget.data['gamers'].asMap().entries.fold(null, (
        fixed,
        current,
      ) {
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
    final List<dynamic> reorderGamers =
        widget.data['gamers'].sublist(index) +
        widget.data['gamers'].sublist(0, index);
    widget.data['gamers'] = reorderGamers;

    final List<dynamic> reorderControllers =
        _scoreControllers.sublist(index) + _scoreControllers.sublist(0, index);
    _scoreControllers = reorderControllers as List<Map<String, dynamic>>;
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
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            spacing: 20,
            children: [
              if (_lastRoundFirstPlayer != null)
                Text(
                  'Предыдущий раунд: $_lastRoundGeneralScore',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),

              if (widget.data['type'] == GameTypeEnum.coop.id)
                Text(
                  'Всего: ${widget.data['teamScores'][TeamsEnum.red.id] ?? 0}',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),

              TextFormField(
                enabled:
                    widget.data['round'] < widget.data['totalRounds'] &&
                    _isFinished == false,
                controller: _generalScoreController,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^-?\d*')),
                ],
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(vertical: 8),
                ),
              ),

              if (widget.data['round'] < widget.data['totalRounds'] &&
                  _isFinished == false)
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _nextRoundGeneralScore,
                        child: Text('Следующий раунд'),
                      ),
                    ),
                  ],
                ),
            ],
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
              if (_lastRoundFirstPlayer != null)
                Text(
                  'Предыдущий раунд ходил первым: $_lastRoundFirstPlayer',
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
                      child: _buildGamerInputCard(index),
                    ),
                  );
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

  Widget _buildGamerInputCard(int index) {
    final Map<String, dynamic> controllerData = _scoreControllers[index];
    final Map<String, dynamic> gamerData = widget.data['gamers'][index];

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: Row(
                spacing: 12,
                children: [
                  // Drag handle
                  ReorderableDragStartListener(
                    index: index,
                    child: Icon(Icons.drag_handle, color: Colors.grey),
                  ),
                  // Имя игрока
                  Text(
                    gamerData['username'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  // Уже набранные очки
                  if (gamerData['score'] != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.greenAccent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        gamerData['score'].toString(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  if (widget.data['round'] < widget.data['totalRounds'] &&
                      _isFinished == false)
                    // Кнопка вызова калькулятора
                    IconButton(
                      onPressed: () {
                        final TextEditingController controller =
                            controllerData['controller'];
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ScoreCalcModal(
                              title: gamerData['username'],
                              value: int.tryParse(controller.text) ?? 0,
                              onScoreChanged: (value) {
                                final String score = value.toString();
                                controller.text = score;
                              },
                            ),
                          ),
                        );
                      },
                      icon: Icon(Icons.iso),
                    ),
                ],
              ),
            ),
            // Поле ввода
            Row(
              children: [
                SizedBox(
                  width: 80,
                  child: TextFormField(
                    enabled:
                        widget.data['round'] < widget.data['totalRounds'] &&
                        _isFinished == false,
                    controller: controllerData['controller'],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^-?\d*')),
                    ],
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    for (final Map<String, dynamic> controllerData in _scoreControllers) {
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
