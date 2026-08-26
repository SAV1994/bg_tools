import 'package:flutter/material.dart';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bg_tools/core/consts/export.dart';
import 'package:bg_tools/core/dataclasses/export.dart';
import 'package:bg_tools/core/providers/database_providers.dart';
import 'package:bg_tools/core/utils/export.dart';
import 'package:bg_tools/core/widgets/loading_screen.dart';

class PlayerData {
  final String name;
  final int wins;
  final Color color;

  PlayerData({required this.name, required this.wins, required this.color});
}

class PlayerStats {
  final String name;
  final int totalGames;
  final int wins;
  final Color color;

  PlayerStats({
    required this.name,
    required this.totalGames,
    required this.wins,
    required this.color,
  });
}

class WinRateScreen extends ConsumerStatefulWidget {
  const WinRateScreen({super.key});

  @override
  ConsumerState<WinRateScreen> createState() => _WinRateScreenState();
}

class _WinRateScreenState extends ConsumerState<WinRateScreen> {
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
    _touchedIndex = null;
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

  int? _selectedIndex;
  bool _showDetails = true;

  final List<PlayerStats> _players = [
    PlayerStats(name: 'Алексей', totalGames: 20, wins: 12, color: Colors.blue),
    PlayerStats(name: 'Мария', totalGames: 15, wins: 8, color: Colors.green),
    PlayerStats(
      name: 'Дмитрий',
      totalGames: 25,
      wins: 15,
      color: Colors.orange,
    ),
    PlayerStats(
      name: 'Екатерина',
      totalGames: 10,
      wins: 6,
      color: Colors.purple,
    ),
    PlayerStats(name: 'Сергей', totalGames: 18, wins: 10, color: Colors.red),
    PlayerStats(name: 'Анна', totalGames: 8, wins: 3, color: Colors.teal),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Статистика игроков'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          Container(
            margin: EdgeInsets.all(8),
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                'Всего игр: ${_players.fold(0, (sum, p) => sum + p.totalGames)}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Легенда
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.grey.shade50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegendItem('Общее количество', Colors.grey.shade300),
                SizedBox(width: 16),
                _buildLegendItem('Победы', Colors.blue.shade700),
              ],
            ),
          ),

          // Диаграмма
          Expanded(
            flex: 3,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: _getMaxTotalGames() + 3,
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipColor: (group) {
                        final index = group.x.toInt();
                        return _players[index].color;
                      },
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        final player = _players[group.x.toInt()];
                        final winRate = (player.wins / player.totalGames * 100);
                        return BarTooltipItem(
                          '${player.name}\n'
                          '🎮 Всего: ${player.totalGames}\n'
                          '🏆 Победы: ${player.wins}\n'
                          '📊 Процент: ${winRate.toStringAsFixed(1)}%',
                          TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        );
                      },
                    ),
                    touchCallback:
                        (FlTouchEvent event, BarTouchResponse? response) {
                          setState(() {
                            if (event is FlTapDownEvent ||
                                event is FlLongPressStart) {
                              final touchedSpot = response?.spot;
                              if (touchedSpot != null) {
                                final index = touchedSpot.spot.x.toInt();
                                if (index >= 0 && index < _players.length) {
                                  _selectedIndex = index;
                                }
                              }
                            } else {
                              _selectedIndex = null;
                            }
                          });
                        },
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index < 0 || index >= _players.length) {
                            return Container();
                          }
                          final isSelected = _selectedIndex == index;
                          final player = _players[index];
                          return Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: Column(
                              children: [
                                Text(
                                  player.name,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    color: isSelected
                                        ? player.color
                                        : Colors.grey.shade600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                if (isSelected)
                                  Text(
                                    '${player.wins}/${player.totalGames}',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: player.color,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                              ],
                            ),
                          );
                        },
                        reservedSize: 50,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          );
                        },
                      ),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border(
                      left: BorderSide(color: Colors.grey.shade300),
                      bottom: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    horizontalInterval: 5,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.grey.shade200,
                        strokeWidth: 1,
                        dashArray: [5, 5],
                      );
                    },
                  ),
                  barGroups: _buildBarGroups(),
                ),
              ),
            ),
          ),

          // Информация о выбранном игроке
          if (_selectedIndex != null)
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _players[_selectedIndex!].color.withOpacity(0.1),
                border: Border(
                  top: BorderSide(color: _players[_selectedIndex!].color),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildInfoItem(
                    'Игрок',
                    _players[_selectedIndex!].name,
                    _players[_selectedIndex!].color,
                  ),
                  _buildInfoItem(
                    'Всего игр',
                    '${_players[_selectedIndex!].totalGames}',
                    Colors.grey.shade700,
                  ),
                  _buildInfoItem(
                    'Побед',
                    '${_players[_selectedIndex!].wins}',
                    Colors.green,
                  ),
                  _buildInfoItem(
                    'Процент побед',
                    '${(_players[_selectedIndex!].wins / _players[_selectedIndex!].totalGames * 100).toStringAsFixed(1)}%',
                    Colors.blue,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        SizedBox(width: 8),
        Text(label, style: TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildInfoItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  List<BarChartGroupData> _buildBarGroups() {
    return _players.asMap().entries.map((entry) {
      final index = entry.key;
      final player = entry.value;
      final isSelected = _selectedIndex == index;

      return BarChartGroupData(
        x: index,
        barRods: [
          // ОДНА колонка с разделением
          BarChartRodData(
            toY: player.totalGames.toDouble(),
            color: isSelected ? player.color : player.color.withOpacity(0.7),
            width: 30,
            borderRadius: BorderRadius.circular(4),
            // ✅ Разделение через градиент
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Colors.grey.shade300, // Нижняя часть - общее количество
                player.color, // Верхняя часть - победы
              ],
              stops: [
                1 - (player.wins / player.totalGames), // Позиция разделения
                1 - (player.wins / player.totalGames),
              ],
            ),
          ),
        ],
        showingTooltipIndicators: isSelected ? [0] : [],
      );
    }).toList();
  }

  int _getMaxTotalGames() {
    return _players.map((p) => p.totalGames).reduce((a, b) => a > b ? a : b);
  }
}
