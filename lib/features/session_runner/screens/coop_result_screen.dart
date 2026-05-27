import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bg_tools/core/utils/gamer_score_card_builder.dart';
import 'package:bg_tools/core/utils/loading_screen_builder.dart';
import 'package:bg_tools/core/utils/win_toggle_btn_builder.dart';
import 'package:bg_tools/features/session_runner/categories.dart';

class CoopResultScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> data;

  const CoopResultScreen({super.key, required this.data});

  @override
  ConsumerState<CoopResultScreen> createState() => _CoopResultScreenState();
}

class _CoopResultScreenState extends ConsumerState<CoopResultScreen> {
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
    List<Map<String, dynamic>> gamersData = widget.data['gamers']
        .cast<Map<String, dynamic>>();
    for (final Map<String, dynamic> gamerData in gamersData) {
      _scoreControllers[gamerData['id']] = {
        'username': gamerData['username'],
        'controller': TextEditingController(
          text: gamerData['score']?.toString() ?? '',
        ),
      };
      if (gamerData['score'] != null) {
        _totalScore += gamerData['score'] as int;
      }
    }
    _isVictory = gamersData[0]['place'] == 1;

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
    int totalScore = 0;
    final newScore = int.tryParse(value);
    for (final Map<String, dynamic> gamerData in widget.data['gamers']) {
      if (gamerData['id'] == gamerId) {
        gamerData['score'] = newScore;
      }
      if (gamerData['score'] != null) {
        totalScore += gamerData['score'] as int;
      }
    }
    _totalScore = totalScore;

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
                              return buildGamerScoreCard(
                                gamerId,
                                _scoreControllers[gamerId],
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
