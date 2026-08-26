import 'package:flutter/material.dart';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bg_tools/core/consts/export.dart';
import 'package:bg_tools/core/dataclasses/export.dart';
import 'package:bg_tools/core/providers/database_providers.dart';
import 'package:bg_tools/core/utils/export.dart';
import 'package:bg_tools/core/widgets/loading_screen.dart';

class SessionsStatisticsScreen extends ConsumerStatefulWidget {
  const SessionsStatisticsScreen({super.key});

  @override
  ConsumerState<SessionsStatisticsScreen> createState() =>
      _SessionsStatisticsScreenState();
}

class _SessionsStatisticsScreenState
    extends ConsumerState<SessionsStatisticsScreen> {
  final List<Map<String, dynamic>> _gamesStat = [];
  int _totalSesions = 0;
  int _totalTimes = 0;
  final List<Color> _colors = [];
  int? _touchedIndex;
  late DateTime _periodStart;
  late DateTime _periodEnd;
  // Загрузка
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _load();
  }

  Future<void> _load() async {
    final DateTime now = DateTime.now();
    _periodStart = DateTime(now.year, now.month - 1, now.day);
    _periodEnd = DateTime(now.year, now.month, now.day);

    await _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    final gamingSessionDao = ref.read(gamingSessionDaoProvider);
    _gamesStat.clear();
    _totalSesions = 0;
    _totalTimes = 0;

    final List<GamingSessionData> gamingSessions = await gamingSessionDao
        .getAllFinished(periodStart: _periodStart, periodEnd: _periodEnd);

    Map<int, dynamic> gamesStat = {};
    for (final GamingSessionData sessionData in gamingSessions) {
      int time = sessionData.gamingSession.finishedAt
          .difference(sessionData.gamingSession.startedAt)
          .inMinutes;

      _totalSesions += 1;
      _totalTimes += time;

      if (gamesStat[sessionData.game.id] == null) {
        gamesStat[sessionData.game.id] = {
          'id': sessionData.game.id,
          'name': sessionData.game.name,
          'sessionsCount': 1,
          'sessionsTimes': time,
        };
      } else {
        gamesStat[sessionData.game.id]['sessionsCount'] += 1;
        gamesStat[sessionData.game.id]['sessionsTimes'] += time;
      }
    }

    for (final gameStatItem in gamesStat.entries) {
      _gamesStat.add(gameStatItem.value);
    }

    _gamesStat.sort((a, b) => a['sessionsCount'].compareTo(b['sessionsCount']));

    _colors.addAll(_generateColors(_gamesStat.length));

    setState(() => _isLoading = false);
  }

  List<Color> _generateColors(int count) {
    final List<Color> colorPalette = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.teal,
      Colors.pink,
      Colors.amber,
      Colors.indigo,
      Colors.cyan,
      Colors.pink,
      Colors.grey,
      Colors.brown,
    ];

    // Если игр больше, чем цветов, повторяем с разной прозрачностью
    if (count <= colorPalette.length) {
      return colorPalette.sublist(0, count);
    } else {
      final colors = <Color>[];
      for (int i = 0; i < count; i++) {
        final color = colorPalette[i % colorPalette.length];
        final opacity = 1.0 - (i ~/ colorPalette.length) * 0.15;
        colors.add(color.withValues(alpha: opacity));
      }
      return colors;
    }
  }

  Future<void> _selectDate({bool isPeriodEnd = false}) async {
    final DateTime initialDate = isPeriodEnd ? _periodEnd : _periodStart;

    final date = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (date == null) return;

    if (mounted) {
      setState(() {
        if (isPeriodEnd) {
          _periodEnd = date;
        } else {
          _periodStart = date;
        }
        _loadData();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(statisticsIcon, color: silverColor),
            Icon(sessionsStatIcon),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Выйти', style: TextStyle(color: redColor)),
          ),
        ],
      ),

      body: _isLoading
          ? LoadingScreen()
          : Scrollbar(
              thumbVisibility: true,
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsetsGeometry.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: Column(
                    spacing: 5,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        spacing: 5,
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () async {
                                _selectDate();
                              },
                              child: InputDecorator(
                                decoration: const InputDecoration(
                                  labelText: 'Начало периода *',
                                  border: OutlineInputBorder(),
                                ),
                                child: Text(
                                  DateFormats.formatDate(_periodStart),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () async {
                                _selectDate(isPeriodEnd: true);
                              },
                              child: InputDecorator(
                                decoration: const InputDecoration(
                                  labelText: 'Конец периода *',
                                  border: OutlineInputBorder(),
                                ),
                                child: Text(DateFormats.formatDate(_periodEnd)),
                              ),
                            ),
                          ),
                        ],
                      ),

                      if (_gamesStat.isNotEmpty) ...[
                        // Информация о выбранном секторе
                        if (_touchedIndex != null &&
                            _touchedIndex! < _gamesStat.length)
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: _colors[_touchedIndex!].withValues(
                                alpha: 0.1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: _colors[_touchedIndex!],
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: _colors[_touchedIndex!],
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    '${_gamesStat[_touchedIndex!]['name']} $diceEmoji '
                                    '${_gamesStat[_touchedIndex!]['sessionsCount']} '
                                    '$timerEmoji ${formatMinutes(_gamesStat[_touchedIndex!]['sessionsTimes'])}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        Container(
                          height: 660,
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            children: [
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Количество партий',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade50,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      'Всего: $_totalSesions',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.blue.shade700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              Expanded(
                                child: PieChart(
                                  PieChartData(
                                    sections: _gamesStat.asMap().entries.map((
                                      entry,
                                    ) {
                                      final index = entry.key;
                                      final data = entry.value;
                                      final isTouched = _touchedIndex == index;

                                      return PieChartSectionData(
                                        value: data['sessionsCount'].toDouble(),
                                        title: isTouched
                                            ? ' ${data['sessionsCount']}\u00A0'
                                            : '',
                                        color: _colors[index % _colors.length],
                                        radius: isTouched ? 120 : 100,
                                        titleStyle: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          backgroundColor: firstColor,
                                          color: textColor,
                                        ),
                                        titlePositionPercentageOffset: 0.6,
                                        borderSide: BorderSide(
                                          color: Colors.white,
                                          width: isTouched ? 3 : 2,
                                        ),
                                      );
                                    }).toList(),
                                    borderData: FlBorderData(show: false),
                                    sectionsSpace: 2,
                                    centerSpaceRadius: 25,
                                    startDegreeOffset: -90,
                                    pieTouchData: PieTouchData(
                                      touchCallback:
                                          (
                                            FlTouchEvent event,
                                            pieTouchResponse,
                                          ) {
                                            setState(() {
                                              if ((event is FlTapDownEvent ||
                                                  event is FlLongPressStart)) {
                                                _touchedIndex = pieTouchResponse
                                                    ?.touchedSection
                                                    ?.touchedSectionIndex;
                                              }

                                              if (_touchedIndex == -1) {
                                                _touchedIndex = null;
                                              }
                                            });
                                          },
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(height: 12),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Общее время',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade50,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      'Всего: ${formatMinutes(_totalTimes)}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.blue.shade700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              Expanded(
                                child: PieChart(
                                  PieChartData(
                                    sections: _gamesStat.asMap().entries.map((
                                      entry,
                                    ) {
                                      final index = entry.key;
                                      final data = entry.value;
                                      final isTouched = _touchedIndex == index;

                                      return PieChartSectionData(
                                        value: data['sessionsTimes'].toDouble(),
                                        title: isTouched
                                            ? ' ${formatMinutes(data['sessionsTimes'])}\u00A0'
                                            : '',
                                        color: _colors[index % _colors.length],
                                        radius: isTouched ? 120 : 100,
                                        titleStyle: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          backgroundColor: firstColor,
                                          color: textColor,
                                        ),
                                        titlePositionPercentageOffset: 0.6,
                                        borderSide: BorderSide(
                                          color: Colors.white,
                                          width: isTouched ? 3 : 2,
                                        ),
                                      );
                                    }).toList(),
                                    borderData: FlBorderData(show: false),
                                    sectionsSpace: 2,
                                    centerSpaceRadius: 25,
                                    startDegreeOffset: -90,
                                    pieTouchData: PieTouchData(
                                      touchCallback:
                                          (
                                            FlTouchEvent event,
                                            pieTouchResponse,
                                          ) {
                                            if (event is FlTapDownEvent ||
                                                event is FlLongPressStart) {
                                              final int? touchedIndex =
                                                  pieTouchResponse
                                                      ?.touchedSection
                                                      ?.touchedSectionIndex;
                                              if (touchedIndex != -1) {
                                                setState(() {
                                                  _touchedIndex = touchedIndex;
                                                });
                                              }
                                            }
                                          },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Легенда
                        Wrap(
                          spacing: 12,
                          runSpacing: 6,
                          alignment: WrapAlignment.center,
                          children: _gamesStat.asMap().entries.map((entry) {
                            final index = entry.key;
                            final data = entry.value;
                            final isActive = _touchedIndex == index;

                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _touchedIndex = _touchedIndex == index
                                      ? null
                                      : index;
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: isActive
                                      ? _colors[index % _colors.length]
                                            .withValues(alpha: 0.2)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(12),
                                  border: isActive
                                      ? Border.all(
                                          color:
                                              _colors[index % _colors.length],
                                        )
                                      : null,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 10,
                                      height: 10,
                                      decoration: BoxDecoration(
                                        color: _colors[index % _colors.length],
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        '${data['name']} $diceEmoji ${data['sessionsCount']} '
                                        '$timerEmoji ${formatMinutes(data['sessionsTimes'])}',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: isActive
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],

                      if (_gamesStat.isEmpty)
                        Container(
                          height: 660,
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Center(
                            child: Text(
                              'За выбраный период не было партий',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
