import 'package:bg_tools/core/utils/gamer_score_card_builder.dart';
import 'package:bg_tools/features/session_runner/categories.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bg_tools/core/utils/loading_screen_builder.dart';

enum _SelectMode { single, draw }

class ResultScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> data;

  const ResultScreen({super.key, required this.data});

  @override
  ConsumerState<ResultScreen> createState() => _NoScoreResultScreenState();
}

class _NoScoreResultScreenState extends ConsumerState<ResultScreen> {
  _SelectMode _mode = _SelectMode.single;
  // Контроллеры
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
    if (widget.data['gamers'][0]['place'] == null) {
      _sortByWinCondition();
      _fillPlace();
    } else if (hasDraw()) {
      _mode = _SelectMode.draw;
    }

    List<Map<String, dynamic>> gamersData = widget.data['gamers']
        .cast<Map<String, dynamic>>();
    for (final Map<String, dynamic> gamerData in gamersData) {
      _scoreControllers[gamerData['id']] = {
        'username': gamerData['username'],
        'controller': TextEditingController(
          text: gamerData['place']?.toString() ?? '',
        ),
        'extraData': (widget.data['resultType'] != ResultTypeEnum.condition.id)
            ? gamerData['score']
            : null,
      };
    }

    setState(() => _isLoading = false);
  }

  void _sortByWinCondition() {
    widget.data['gamers'].sort((a, b) {
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

  bool hasDraw() {
    for (int i = 0; i < widget.data['gamers'].length - 1; i++) {
      if (widget.data['gamers'][i]['place'] ==
          widget.data['gamers'][i + 1]['place']) {
        return true; // Найдены одинаковые соседние значения
      }
    }
    return false; // Нет одинаковых соседних значений
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

  void _reorder(int oldIndex, int newIndex) {
    setState(() {
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }
      final Map<String, dynamic> gamerData = widget.data['gamers'].removeAt(
        oldIndex,
      );
      widget.data['gamers'].insert(newIndex, gamerData);
    });

    _fillPlace();

    setState(() {});
  }

  void _fillPlace() {
    for (final entry in widget.data['gamers'].asMap().entries) {
      if (widget.data['type'] != GameTypeEnum.oneWinner.id || entry == 0) {
        entry.value['place'] = entry.key + 1;
      } else {
        entry.value['place'] = null;
      }
    }
  }

  Widget _buildPlacePositionsWidget() {
    if (_mode == _SelectMode.draw) {
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
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(16),
                  itemCount: widget.data['gamers'].length,
                  itemBuilder: (context, index) {
                    final int gamerId = widget.data['gamers'][index]['id'];
                    return buildGamerInputCard(
                      context,
                      gamerId,
                      _scoreControllers[gamerId],
                      false,
                      _updatPlace,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      );
    }
    return ReorderableListView(
      padding: const EdgeInsets.all(16),
      onReorder: _reorder,
      children: List.generate(widget.data['gamers'].length, (index) {
        final Map<String, dynamic> gamerData = widget.data['gamers'][index];

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
            child: _buildPlayerCard(index, gamerData),
          ),
        );
      }),
    );
  }

  void _updatPlace(int gamerId, String value) {
    int? newScore = int.tryParse(value);
    for (final Map<String, dynamic> gamerData in widget.data['gamers']) {
      if (gamerData['id'] == gamerId) {
        if (widget.data['type'] != GameTypeEnum.oneWinner.id || newScore == 1) {
          gamerData['place'] = newScore;
        } else {
          gamerData['place'] = null;
        }
      }
    }
  }

  Widget _buildPlayerCard(int index, Map<String, dynamic> gamerData) {
    final isTop3 = index < 3;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isTop3 ? Colors.amber.shade300 : Colors.grey.shade200,
          width: isTop3 ? 2 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          spacing: 8,
          children: [
            // Drag handle
            if (widget.data['altVictoryType'] == AltVictoryTypeEnum.yes.id)
              ReorderableDragStartListener(
                index: index,
                child: Icon(Icons.drag_handle, color: Colors.grey),
              ),

            // Позиция
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isTop3
                    ? Colors.amber.withValues(alpha: 0.2)
                    : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isTop3
                        ? Colors.amber.shade700
                        : Colors.grey.shade600,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 12),

            // Имя игрока
            Expanded(
              child: Text(
                gamerData['username'],
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            // Очки
            if (widget.data['resultType'] != ResultTypeEnum.condition.id)
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
                  '${gamerData['score']}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
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
            : Column(
                spacing: 12,
                children: [
                  // Кнопка переключения режима
                  SegmentedButton<_SelectMode>(
                    segments: const [
                      ButtonSegment(
                        value: _SelectMode.single,
                        label: Text('1 игрок - 1 место'),
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

                  Flexible(child: _buildPlacePositionsWidget()),
                ],
              );
      },
    );
  }
}
