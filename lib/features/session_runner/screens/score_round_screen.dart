import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bg_tools/core/app_data.dart';
import 'package:bg_tools/core/consts/export.dart';
import 'package:bg_tools/core/utils/export.dart';
import 'package:bg_tools/core/widgets/export.dart';
import 'package:bg_tools/features/session_runner/categories.dart';
import 'package:bg_tools/features/session_runner/widgets/export.dart';

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
  TextEditingController? _generalScoreController;
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

    if (widget.data['type'] != GameTypeEnum.secretTeams.id &&
        widget.data['teamPointType'] == TeamPointTypeEnum.general.id) {
      final int? generalScore =
          widget.data['teamsData'][TeamsEnum.red.id.toString()]['score'];
      _generalScoreController = TextEditingController(
        text: generalScore?.toString(),
      );
      _isFinished =
          generalScore != null &&
          _roundsScoreLimit != null &&
          (_roundsScoreLimit < 0 && generalScore <= _roundsScoreLimit ||
              _roundsScoreLimit >= 0 && generalScore >= _roundsScoreLimit);
    } else {
      List<Map<String, dynamic>> gamersData = widget.data['gamers']
          .cast<Map<String, dynamic>>();
      for (final Map<String, dynamic> gamerData in gamersData) {
        _scoreControllers.add({
          'controller': TextEditingController(),
          'focusNode': FocusNode(),
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

    setState(() => _isLoading = false);
  }

  Future<void> _nextRound() async {
    setState(() => _isLoading = true);

    _lastRoundFirstPlayer = widget.data['gamers'][0]['username'];
    List<(int, int)> roundResults = [];

    for (int i = 0; i < _scoreControllers.length; i++) {
      final Map<String, dynamic> controllerData = _scoreControllers[i];
      final Map<String, dynamic> gamerData = widget.data['gamers'][i];

      final newScore = int.tryParse(controllerData['controller'].text) ?? 0;

      controllerData['controller'].clear();

      roundResults.add((i, newScore));

      increaseEnsureCounter(gamerData, 'score', newScore);

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
    if (roundResults.length > 1 && roundResults[0].$2 != roundResults[1].$2) {
      widget.data['gamers'][roundResults[0].$1]['numWinRounds'] += 1;
    }

    if (!_isFinished) {
      widget.data['round']++;

      _sortByCondition();
    }

    await AppDataManager.saveActiveSession(widget.data);

    setState(() => _isLoading = false);
  }

  Future<void> _nextRoundGeneralScore() async {
    final newScore = int.tryParse(_generalScoreController!.text) ?? 0;
    _generalScoreController!.clear();

    setState(() {
      if (widget.data['type'] == GameTypeEnum.coop.id) {
        if (widget.data['teamsData'][TeamsEnum.red.id.toString()]['score'] !=
            null) {
          widget.data['teamsData'][TeamsEnum.red.id.toString()]['score'] +=
              newScore;
        } else {
          widget.data['teamsData'][TeamsEnum.red.id.toString()]['score'] =
              newScore;
        }
      }

      if (_isFinished == false && _roundsScoreLimit != null) {
        if (_roundsScoreLimit < 0) {
          _isFinished =
              widget.data['teamsData'][TeamsEnum.red.id.toString()]['score'] <=
              _roundsScoreLimit;
        } else {
          _isFinished =
              widget.data['teamsData'][TeamsEnum.red.id.toString()]['score'] >=
              _roundsScoreLimit;
        }
      }

      if (!_isFinished) {
        widget.data['round']++;
      }
      _lastRoundGeneralScore = newScore;
    });
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
  }

  Widget _buildScrean() {
    if (widget.data['type'] != GameTypeEnum.secretTeams.id &&
        widget.data['teamPointType'] == TeamPointTypeEnum.general.id) {
      return Padding(
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
                'Всего: ${widget.data['teamsData'][TeamsEnum.red.id.toString()]['score'] ?? 0}',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),

            TextFormField(
              enabled:
                  widget.data['round'] < widget.data['totalRounds'] &&
                  _isFinished == false,
              controller: _generalScoreController,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
      );
    }

    return SingleChildScrollView(
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
              padding: const EdgeInsets.all(2),
              onReorder: _reorder,
              proxyDecorator: (child, index, animation) {
                return Material(
                  elevation: 0,
                  color: Colors.transparent,
                  child: child,
                );
              },
              children: List.generate(widget.data['gamers'].length, (index) {
                final Map<String, dynamic> gamerData =
                    widget.data['gamers'][index];

                return Container(
                  key: Key('${gamerData['id']}_$index'),
                  margin: const EdgeInsets.only(bottom: 5),
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
                    child: PlayerRoundInputCard(
                      index: index,
                      controllersData: _scoreControllers,
                      sessionData: widget.data,
                      isFinished: _isFinished,
                    ),
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
    );
  }

  @override
  void dispose() {
    for (final Map<String, dynamic> controllerData in _scoreControllers) {
      controllerData['controller'].dispose();
      controllerData['focusNode'].dispose();
    }
    _generalScoreController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return _isLoading ? LoadingScreen() : _buildScrean();
      },
    );
  }
}
