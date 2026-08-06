import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bg_tools/core/consts/export.dart';
import 'package:bg_tools/core/widgets/export.dart';
import 'package:bg_tools/features/session_runner/categories.dart';
import 'package:bg_tools/features/session_runner/widgets/export.dart';

enum _SelectMode { single, draw, none }

class ResultScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> data;

  const ResultScreen({super.key, required this.data});

  @override
  ConsumerState<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends ConsumerState<ResultScreen> {
  _SelectMode _mode = _SelectMode.single;
  // Контроллеры
  final Map<int, dynamic> _placeControllers = {};
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
    }
    if (widget.data['resultType'] != ResultTypeEnum.condition.id &&
        _hasDraw()) {
      _mode = _SelectMode.draw;
    }

    List<Map<String, dynamic>> playersData = widget.data['gamers']
        .cast<Map<String, dynamic>>();
    for (final Map<String, dynamic> playerData in playersData) {
      _placeControllers[playerData['id']] = {
        'username': playerData['username'],
        'controller': TextEditingController(),
        'focusNode': FocusNode(),
        'extraData': (widget.data['resultType'] != ResultTypeEnum.condition.id)
            ? playerData['score']
            : null,
      };
    }
    _setInitialDrawMode();

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

    _initialFillPlace();
  }

  bool _hasDraw() {
    for (int i = 0; i < widget.data['gamers'].length - 1; i++) {
      if (widget.data['gamers'][i]['place'] ==
          widget.data['gamers'][i + 1]['place']) {
        return true; // Найдены одинаковые соседние значения
      }
    }
    return false; // Нет одинаковых соседних значений
  }

  void _setInitialDrawMode() {
    for (final playerData in widget.data['gamers']) {
      _placeControllers[playerData['id']]['controller'].text =
          playerData['place'].toString();
    }
  }

  void _toggleMode(_SelectMode selectedMode) {
    setState(() {
      _mode = selectedMode;
      if (_mode == _SelectMode.single) {
        _fillPlaceOneToOne();
      } else if (_mode == _SelectMode.draw) {
        _sortByWinCondition();
        _initialFillPlace();
      } else {
        for (final playerData in widget.data['gamers']) {
          playerData['place'] = null;
        }
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
      _fillPlaceOneToOne();
    });
  }

  void _fillPlaceOneToOne() {
    for (final entry in widget.data['gamers'].asMap().entries) {
      if (widget.data['type'] != GameTypeEnum.oneWinner.id || entry.key == 0) {
        entry.value['place'] = entry.key + 1;
      } else {
        entry.value['place'] = null;
      }
    }
  }

  void _initialFillPlace() {
    for (int i = 0; i < widget.data['gamers'].length; i++) {
      if (i == 0) {
        widget.data['gamers'][i]['place'] = 1;
      } else if (widget.data['resultType'] == ResultTypeEnum.condition.id) {
        break;
      } else {
        if (widget.data['gamers'][i]['score'] ==
            widget.data['gamers'][i - 1]['score']) {
          widget.data['gamers'][i]['place'] =
              widget.data['gamers'][i - 1]['place'];
        } else {
          widget.data['gamers'][i]['place'] =
              widget.data['gamers'][i - 1]['place'] + 1;
        }
      }
    }
  }

  void _updatePlace(int gamerId, String value) {
    int? newPlace = int.tryParse(value);
    for (final Map<String, dynamic> gamerData in widget.data['gamers']) {
      if (gamerData['id'] == gamerId) {
        if (widget.data['type'] != GameTypeEnum.oneWinner.id || newPlace == 1) {
          gamerData['place'] = newPlace;
        } else {
          gamerData['place'] = null;
        }
      }
    }
  }

  Widget _buildPlacePositionsWidget() {
    if (_mode == _SelectMode.draw) {
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
                  final int gamerId = widget.data['gamers'][index]['id'];
                  FocusNode? nextFocusNode;
                  if (index < widget.data['gamers'].length - 1) {
                    nextFocusNode =
                        _placeControllers[widget.data['gamers'][index +
                            1]['id']]['focusNode'];
                  }

                  return PlayerInputCard(
                    gamerId: gamerId,
                    controllerData: _placeControllers[gamerId],
                    nextFocusNode: nextFocusNode,
                    addCalcBtn: false,
                    digitsOnly: true,
                    updateScore: _updatePlace,
                    label: 'Занятое место',
                  );
                },
              ),
            ],
          ),
        ),
      );
    }
    return ReorderableListView(
      padding: const EdgeInsets.all(16),
      onReorder: _reorder,
      proxyDecorator: (child, index, animation) {
        return Material(elevation: 0, color: Colors.transparent, child: child);
      },
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

  Widget _buildPlayerCard(int index, Map<String, dynamic> gamerData) {
    final isTop3 = index < 3;
    late final Color color;
    switch (index) {
      case 0:
        color = goldColor;
      case 1:
        color = silverColor;
      case 2:
        color = bronzeColor;
      default:
        color = textColor;
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: color, width: isTop3 ? 2 : 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          spacing: 8,
          children: [
            if (_mode == _SelectMode.single)
            // Drag handle
            ...[
              if ((widget.data['altVictoryType'] == AltVictoryTypeEnum.yes.id ||
                  widget.data['resultType'] == ResultTypeEnum.condition.id))
                ReorderableDragStartListener(
                  index: index,
                  child: Icon(Icons.drag_handle, color: Colors.grey),
                ),

              // Позиция
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: secondColor,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),
            ],

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
                  color: textColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${gamerData['score']}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: secondColor,
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
        in _placeControllers.values) {
      controllerData['controller'].dispose();
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
                    segments: [
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
                      if (widget.data['generalDefeatType'] ==
                          GeneralDefeatTypeEnum.yes.id)
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

                  Flexible(child: _buildPlacePositionsWidget()),
                ],
              );
      },
    );
  }
}
