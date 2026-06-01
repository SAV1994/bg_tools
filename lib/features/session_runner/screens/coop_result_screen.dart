import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bg_tools/core/utils/gamer_score_card_builder.dart';
import 'package:bg_tools/core/utils/loading_screen_builder.dart';
import 'package:bg_tools/core/utils/win_toggle_btn_builder.dart';
import 'package:bg_tools/features/session_runner/categories.dart';

enum _SelectMode {
  max(1),
  min(2),
  sum(3),
  multiple(4);

  final int id;

  const _SelectMode(this.id);

  // Получить enum по id
  static _SelectMode fromId(int id) {
    return _SelectMode.values.firstWhere(
      (e) => e.id == id,
      orElse: () => _SelectMode.sum,
    );
  }
}

class CoopResultScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> data;

  const CoopResultScreen({super.key, required this.data});

  @override
  ConsumerState<CoopResultScreen> createState() => _CoopResultScreenState();
}

class _CoopResultScreenState extends ConsumerState<CoopResultScreen> {
  _SelectMode _mode = _SelectMode.sum;
  bool _isVictory = false;
  // Контроллеры
  final Map<int, dynamic> _scoreControllers = {};
  int _totalScore = 0;
  // Загрузка
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _loadData();
  }

  Future<void> _loadData() async {
    if (widget.data['resulScreenMode'] == null) {
      widget.data['resulScreenMode'] = _mode.id;
    } else {
      _mode = _SelectMode.fromId(widget.data['resulScreenMode']);
    }

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
    _isVictory = gamersData[0]['place'] == 1;

    _updateTotalScore();

    setState(() => _isLoading = false);
  }

  void _toggleResult() {
    _isVictory = !_isVictory;
    for (final Map<String, dynamic> gamerData in widget.data['gamers']) {
      gamerData['place'] = (_isVictory) ? 1 : null;
    }

    setState(() {});
  }

  void _updateScore(int gamerId, String value) {
    final newScore = int.tryParse(value);
    for (final Map<String, dynamic> gamerData in widget.data['gamers']) {
      if (gamerData['id'] == gamerId) {
        gamerData['score'] = newScore;
      }

      _updateTotalScore();

      setState(() {});
    }
  }

  void _updateTotalScore() {
    bool isFirst = true;
    _totalScore = (_mode == _SelectMode.multiple) ? 1 : 0;
    for (final Map<String, dynamic> gamerData in widget.data['gamers']) {
      final int score = gamerData['score'] ?? 0;
      if (_mode == _SelectMode.max) {
        if (score > _totalScore) {
          _totalScore = score;
        }
      } else if (_mode == _SelectMode.min) {
        if (score < _totalScore) {
          _totalScore = score;
        }

        if (isFirst) {
          _totalScore = score;
          isFirst = false;
        }
      } else if (_mode == _SelectMode.sum) {
        _totalScore += score;
      } else if (_mode == _SelectMode.multiple) {
        _totalScore *= score;
      }
    }

    widget.data['generalScore'] = _totalScore;
  }

  void _toggleMode(Set<_SelectMode> selection) {
    _mode = selection.first;
    widget.data['resulScreenMode'] = _mode.id;

    _updateTotalScore();

    setState(() {});
  }

  Widget _buildTotalScoreCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade600, Colors.purple.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        spacing: 8,
        children: [
          const Text(
            'ОБЩАЯ СУММА ОЧКОВ',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
              letterSpacing: 1.5,
            ),
          ),
          Text(
            '$_totalScore',
            style: const TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    for (final Map<String, dynamic> controllerData
        in _scoreControllers.values) {
      controllerData['controller'].dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return _isLoading
            ? buildLoadingScreen()
            : Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      _isVictory ? Colors.green.shade200 : Colors.red.shade200,
                      Colors.white,
                    ],
                  ),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        if (widget.data['resultType'] !=
                            ResultTypeEnum.condition.id)
                          // Кнопка переключения режима
                          SegmentedButton<_SelectMode>(
                            segments: const [
                              ButtonSegment(
                                value: _SelectMode.sum,
                                label: Text('+'),
                                icon: Icon(Icons.radio_button_unchecked),
                              ),
                              ButtonSegment(
                                value: _SelectMode.multiple,
                                label: Text('x'),
                                icon: Icon(Icons.check_box_outline_blank),
                              ),
                              ButtonSegment(
                                value: _SelectMode.max,
                                label: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text('MAX'),
                                ),
                                icon: Icon(Icons.check_box_outline_blank),
                              ),
                              ButtonSegment(
                                value: _SelectMode.min,
                                label: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text('MIN'),
                                ),
                                icon: Icon(Icons.check_box_outline_blank),
                              ),
                            ],
                            selected: {_mode},
                            onSelectionChanged: (Set<_SelectMode> selection) {
                              _toggleMode(selection);
                            },
                          ),
                        // Список игроков
                        if (widget.data['resultType'] !=
                            ResultTypeEnum.condition.id)
                          ListView.builder(
                            shrinkWrap: true,
                            padding: const EdgeInsets.all(16),
                            itemCount: widget.data['gamers'].length,
                            itemBuilder: (context, index) {
                              final int gamerId =
                                  widget.data['gamers'][index]['id'];
                              return buildGamerInputCard(
                                context,
                                gamerId,
                                _scoreControllers[gamerId],
                                true,
                                false,
                                _updateScore,
                              );
                            },
                          ),

                        // Карточка общей суммы
                        if (widget.data['resultType'] !=
                            ResultTypeEnum.condition.id)
                          _buildTotalScoreCard(),

                        // Кнопка-переключатель Победа/Поражение
                        buildWinToggleBtn(_isVictory, _toggleResult),
                      ],
                    ),
                  ),
                ),
              );
      },
    );
  }
}
