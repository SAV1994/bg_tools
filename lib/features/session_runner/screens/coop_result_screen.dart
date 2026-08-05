import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bg_tools/core/consts/export.dart';
import 'package:bg_tools/core/widgets/export.dart';
import 'package:bg_tools/features/session_runner/categories.dart';
import 'package:bg_tools/features/session_runner/widgets/export.dart';

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
  late final TextEditingController _generalScoreController;
  final Map<int, dynamic> _scoreControllers = {};
  final ScrollController _scrollController = ScrollController();

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
    if (widget.data['teamPointType'] == TeamPointTypeEnum.general.id) {
      _generalScoreController = TextEditingController(
        text: widget.data['teamsData'][TeamsEnum.red.id.toString()]['score']
            ?.toString(),
      );
    } else {
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
          'focusNode': FocusNode(),
        };
      }
      _isVictory = gamersData[0]['place'] == 1;

      _updateTotalScore();
    }

    setState(() => _isLoading = false);
  }

  void _toggleResult() {
    setState(() {
      _isVictory = !_isVictory;
      for (final Map<String, dynamic> gamerData in widget.data['gamers']) {
        gamerData['place'] = (_isVictory) ? 1 : null;
      }
    });
  }

  void _updateScore(int gamerId, String value) {
    final newScore = int.tryParse(value);
    setState(() {
      for (final Map<String, dynamic> gamerData in widget.data['gamers']) {
        if (gamerData['id'] == gamerId) {
          gamerData['score'] = newScore;
        }
        _updateTotalScore();
      }
    });
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

    widget.data['teamsData'][TeamsEnum.red.id.toString()]['score'] =
        _totalScore;
  }

  void _toggleMode(Set<_SelectMode> selection) {
    setState(() {
      _mode = selection.first;
      widget.data['resulScreenMode'] = _mode.id;
      _updateTotalScore();
    });
  }

  Widget _buildScrean() {
    if (widget.data['teamPointType'] == TeamPointTypeEnum.general.id) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          spacing: 20,
          children: [
            Text(
              'Общий счёт',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            TextFormField(
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
              onChanged: (value) {
                widget.data['teamsData'][TeamsEnum.red.id.toString()]['score'] =
                    value;
              },
            ),

            // Кнопка-переключатель Победа/Поражение
            WinToggleBtn(isVictory: _isVictory, toggleResult: _toggleResult),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        spacing: 8,
        children: [
          // Кнопка-переключатель Победа/Поражение
          WinToggleBtn(isVictory: _isVictory, toggleResult: _toggleResult),

          if (widget.data['resultType'] != ResultTypeEnum.condition.id)
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
                  label: FittedBox(fit: BoxFit.scaleDown, child: Text('MAX')),
                  icon: Icon(Icons.check_box_outline_blank),
                ),
                ButtonSegment(
                  value: _SelectMode.min,
                  label: FittedBox(fit: BoxFit.scaleDown, child: Text('MIN')),
                  icon: Icon(Icons.check_box_outline_blank),
                ),
              ],
              selected: {_mode},
              onSelectionChanged: (Set<_SelectMode> selection) {
                _toggleMode(selection);
              },
            ),

          // Карточка общей суммы
          if (widget.data['resultType'] != ResultTypeEnum.condition.id)
            _buildTotalScoreCard(),

          const Divider(),

          // Список игроков
          if (widget.data['resultType'] != ResultTypeEnum.condition.id)
            Expanded(
              child: Scrollbar(
                controller: _scrollController,
                thumbVisibility: true,
                child: ListView.builder(
                  controller: _scrollController,
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(10),
                  itemCount: widget.data['gamers'].length,
                  itemBuilder: (context, index) {
                    final int gamerId = widget.data['gamers'][index]['id'];
                    FocusNode? nextFocusNode;
                    if (index < widget.data['gamers'].length - 1) {
                      nextFocusNode =
                          _scoreControllers[widget.data['gamers'][index +
                              1]['id']]['focusNode'];
                    }

                    return PlayerInputCard(
                      gamerId: gamerId,
                      controllerData: _scoreControllers[gamerId],
                      nextFocusNode: nextFocusNode,
                      addCalcBtn: true,
                      digitsOnly: false,
                      updateScore: _updateScore,
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTotalScoreCard() {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      child: Row(
        spacing: 8,
        children: [
          const Text(
            'ОБЩАЯ СУММА ОЧКОВ:',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
              letterSpacing: 1.5,
            ),
          ),
          Text(
            '$_totalScore',
            style: const TextStyle(
              fontSize: 18,
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

    if (widget.data['teamPointType'] == TeamPointTypeEnum.general.id) {
      _generalScoreController.dispose();
    }

    _scrollController.dispose();

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
