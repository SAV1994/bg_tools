import 'package:flutter/material.dart';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bg_tools/core/consts/export.dart';
import 'package:bg_tools/core/database/app_database.dart';
import 'package:bg_tools/core/dataclasses/gaming_session_dataclasses.dart';
import 'package:bg_tools/core/providers/database_providers.dart';
import 'package:bg_tools/core/utils/export.dart';
import 'package:bg_tools/core/widgets/export.dart';
import 'package:bg_tools/features/statistics/screens/statistics_mixin.dart';
import 'package:bg_tools/features/statistics/widgets/empty_players_list_banner.dart';
import 'package:bg_tools/features/statistics/widgets/legend_indicator.dart';
import 'package:go_router/go_router.dart';

enum _ChartMode { winRate, wp }

class _PlayerStats {
  final String name;
  final List<int> scores;
  int? maxWP;
  int? minWP;
  String? avgWP;
  int totalPlayed;
  int wins;
  String? winRate;
  int secondPlace;
  int thirdPlace;
  Color? color;
  double? rating;

  _PlayerStats({
    required this.name,
    required this.scores,
    required this.maxWP,
    required this.minWP,
    required this.avgWP,
    required this.totalPlayed,
    required this.wins,
    required this.winRate,
    required this.secondPlace,
    required this.thirdPlace,
    required this.color,
    required this.rating,
  });
}

class GameStatsScreen extends ConsumerStatefulWidget {
  const GameStatsScreen({super.key});

  @override
  ConsumerState<GameStatsScreen> createState() => _GameStatsScreenState();
}

class _GameStatsScreenState extends ConsumerState<GameStatsScreen>
    with StatisticsMixin {
  late List<Color> _colors;
  Set<int> gamesIds = {};
  Game? _selectedGame;
  Map<String, dynamic> _gameStat = {};
  List<dynamic> _playersStat = [];
  List<dynamic> _selectedPlayers = [];
  int? _selectedIndex;
  _ChartMode _chartMode = _ChartMode.winRate;
  // Контроллеры
  final TextEditingController _searchController = TextEditingController();

  @override
  Future<void> loadData() async {
    setState(() => isLoading = true);

    gamesIds.clear();
    _chartMode = _ChartMode.winRate;
    _gameStat = {};

    final gamingSessionDao = ref.read(gamingSessionDaoProvider);
    _selectedIndex = null;

    final List<GamingSessionData> gamingSessionsPool = await gamingSessionDao
        .getFinished(periodStart: periodStart, periodEnd: periodEnd);
    for (final GamingSessionData sessionData in gamingSessionsPool) {
      gamesIds.add(sessionData.game.id);
    }
    if (_selectedGame == null && gamingSessionsPool.isNotEmpty) {
      _selectedGame = gamingSessionsPool.last.game;
    } else if (gamingSessionsPool.isEmpty) {
      _selectedGame = null;
    }

    if (_selectedGame != null) {
      final List<GamingSessionFullData> gamingSessions = await gamingSessionDao
          .getFinishedFullData(
            periodStart: periodStart,
            periodEnd: periodEnd,
            gameId: _selectedGame!.id,
          );

      Map<int, dynamic> playersStat = {};
      _gameStat = {
        'sessionCount': 0,
        'maxWP': {'player': null, 'score': null, 'sessionId': null},
        'minWP': {'player': null, 'score': null, 'sessionId': null},
        'scores': [],
        'avgWP': null,
        'timeList': [],
        'maxTime': null,
        'minTime': null,
        'avgTime': null,
        'totalTime': null,
        'lastSession': null,
      };
      for (final GamingSessionFullData sessionData in gamingSessions) {
        _gameStat['sessionCount'] += 1;
        _gameStat['timeList'].add((
          sessionData.gamingSession.finishedAt
              .difference(sessionData.gamingSession.startedAt)
              .inMinutes,
          sessionData.gamingSession.id.toString(),
        ));
        _gameStat['lastSession'] = sessionData.gamingSession;

        final int playersCount = sessionData.gamers.length;
        for (final GamingSessionGamerData playerData in sessionData.gamers) {
          if (playersStat[playerData.gamer.id] == null) {
            playersStat[playerData.gamer.id] = _PlayerStats(
              name: playerData.gamer.username,
              scores: [],
              maxWP: null,
              minWP: null,
              avgWP: null,
              totalPlayed: 0,
              wins: 0,
              winRate: null,
              secondPlace: 0,
              thirdPlace: 0,
              color: null,
              rating: 0,
            );
          }

          if (playerData.score != null) {
            playersStat[playerData.gamer.id].scores.add(playerData.score);

            _gameStat['scores'].add(playerData.score);

            if (_gameStat['maxWP']['score'] == null) {
              _gameStat['maxWP'] = {
                'score': playerData.score,
                'player': playerData.gamer.username,
                'sessionId': sessionData.gamingSession.id.toString(),
              };
              _gameStat['minWP'] = Map.from(_gameStat['maxWP']);
            } else {
              if (_gameStat['maxWP']['score'] < playerData.score) {
                _gameStat['maxWP']['score'] = playerData.score;
                _gameStat['maxWP']['player'] = playerData.gamer.username;
                _gameStat['maxWP']['sessionId'] = sessionData.gamingSession.id
                    .toString();
              } else if (_gameStat['minWP']['score'] > playerData.score) {
                _gameStat['minWP']['score'] = playerData.score;
                _gameStat['minWP']['player'] = playerData.gamer.username;
                _gameStat['minWP']['sessionId'] = sessionData.gamingSession.id
                    .toString();
              }
            }
          }

          playersStat[playerData.gamer.id].totalPlayed += 1;
          switch (playerData.place) {
            case 1:
              playersStat[playerData.gamer.id].wins += 1;
            case 2:
              if (playersCount > 2) {
                playersStat[playerData.gamer.id].secondPlace += 1;
              }
            case 3:
              if (playersCount > 3) {
                playersStat[playerData.gamer.id].thirdPlace += 1;
              }
            default:
          }
        }
      }

      for (final _PlayerStats playerStats in playersStat.values) {
        if (playerStats.scores.isNotEmpty) {
          playerStats.scores.sort(((a, b) => a.compareTo(b)));
          playerStats.maxWP = playerStats.scores.last;
          playerStats.minWP = playerStats.scores.first;
          playerStats.avgWP = average(playerStats.scores).toStringAsFixed(2);
        }

        playerStats.winRate = (playerStats.wins / playerStats.totalPlayed * 100)
            .toStringAsFixed(2);

        final double coefficient = (playerStats.totalPlayed > 10)
            ? 1.1
            : 1 + playerStats.totalPlayed / 100;
        playerStats.rating =
            playerStats.wins / playerStats.totalPlayed * coefficient;
      }

      if (_gameStat['scores'].isNotEmpty) {
        _gameStat['scores'].sort(((a, b) => (a as int).compareTo(b as int)));
        _gameStat['avgWP'] = average(
          _gameStat['scores'].cast<int>(),
        ).toStringAsFixed(2);
      }

      _gameStat['timeList'].sort(((a, b) => a.$1.compareTo(b.$1) as int));
      final List<int> timeList = _gameStat['timeList']
          .map((scoreInfo) => scoreInfo.$1)
          .toList()
          .cast<int>();

      _gameStat['maxTime'] = _gameStat['timeList'].last;
      _gameStat['minTime'] = _gameStat['timeList'].first;
      _gameStat['avgTime'] = average(timeList).round();
      _gameStat['totalTime'] = sumInt(timeList);

      _playersStat = playersStat.values.toList();

      _playersStat.sort((a, b) => b.rating!.compareTo(a.rating!));

      _colors = generateColors(5);
      _selectedPlayers = _playersStat.take(5).toList();

      _setPlayerColor();
    }

    setState(() => isLoading = false);
  }

  Future<List<Game>> getItemsForGameSelect() async {
    final gameDao = ref.read(gameDaoProvider);
    return await gameDao.getAll(onlyStandalone: true, ids: gamesIds);
  }

  Future<void> _onGameSelected(Game? game) async {
    _selectedGame = game;
    _selectedPlayers.clear();

    loadData();
  }

  bool _isSelected(_PlayerStats player) {
    return _selectedPlayers.contains(player);
  }

  void _setPlayerColor() {
    _selectedPlayers.sort((a, b) => b.rating!.compareTo(a.rating!));

    for (var i = 0; i < _selectedPlayers.length; i++) {
      if (i < _colors.length) {
        _selectedPlayers[i].color = _colors[i];
      }
    }
  }

  void _togglePlayer(_PlayerStats player) {
    if (_isSelected(player)) {
      _selectedPlayers.remove(player);
    } else if (_selectedPlayers.length < 5) {
      _selectedPlayers.add(player);
    } else {
      return;
    }

    setState(() => _setPlayerColor());
  }

  void _toggleChart() {
    setState(() {
      if (_chartMode == _ChartMode.winRate) {
        _chartMode = _ChartMode.wp;
      } else {
        _chartMode = _ChartMode.winRate;
      }
    });
  }

  void _showPlayerSelection() {
    String searchQuery = '';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            final filteredPlayers = searchQuery.isEmpty
                ? _playersStat
                : _playersStat
                      .where(
                        (p) => p.name.toLowerCase().contains(
                          searchQuery.toLowerCase(),
                        ),
                      )
                      .toList();

            return Dialog(
              insetPadding: EdgeInsets.zero,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: firstColor,
                child: Column(
                  children: [
                    // Заголовок
                    Container(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Выберите игроков (макс. 5)',
                              style: TextStyle(
                                color: textColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: textColor.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${_selectedPlayers.length}/5',
                              style: TextStyle(
                                color: textColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          IconButton(
                            icon: Icon(Icons.close, color: textColor),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    ),

                    // Поиск
                    Container(
                      decoration: BoxDecoration(
                        color: firstColor,
                        border: Border(
                          bottom: BorderSide(color: Colors.grey.shade200),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Поиск игроков...',
                            prefixIcon: Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                              ),
                            ),
                            suffixIcon: searchQuery.isNotEmpty
                                ? IconButton(
                                    icon: Icon(Icons.clear),
                                    onPressed: () {
                                      FocusScope.of(context).unfocus();
                                      setStateDialog(() {
                                        searchQuery = '';
                                        _searchController.clear();
                                      });
                                    },
                                  )
                                : null,
                          ),
                          onChanged: (value) {
                            setStateDialog(() {
                              searchQuery = value;
                            });
                          },
                        ),
                      ),
                    ),

                    // Карточки игроков (вместо таблицы)
                    Expanded(
                      child: Scrollbar(
                        thumbVisibility: true,
                        child: GridView.builder(
                          padding: EdgeInsets.all(12),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: _gameStat['scores'].isNotEmpty
                                    ? 1.1
                                    : 1.9,
                              ),
                          itemCount: filteredPlayers.length,
                          itemBuilder: (context, index) {
                            final player = filteredPlayers[index];
                            final isSelected = _isSelected(player);

                            return GestureDetector(
                              onTap: () {
                                _togglePlayer(player);
                                setStateDialog(() {});
                              },
                              child: Card(
                                elevation: isSelected ? 4 : 1,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: BorderSide(
                                    color: isSelected
                                        ? goldColor
                                        : Colors.transparent,
                                    width: 3,
                                  ),
                                ),
                                child: Container(
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: secondColor,
                                  ),
                                  child: Column(
                                    spacing: 3,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Имя и чекбокс
                                      Row(
                                        spacing: 4,
                                        children: [
                                          Container(
                                            width: 20,
                                            height: 20,
                                            decoration: BoxDecoration(
                                              color: isSelected
                                                  ? goldColor
                                                  : textColor,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Center(
                                              child: Text(
                                                '${index + 1}',
                                                style: TextStyle(
                                                  color: firstColor,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            alignment:
                                                AlignmentGeometry.centerStart,
                                            width: 95,
                                            child: FittedBox(
                                              fit: BoxFit
                                                  .scaleDown, // ← Уменьшает, но не увеличивает
                                              child: Text(
                                                player.name,
                                                style: TextStyle(
                                                  fontWeight: isSelected
                                                      ? FontWeight.bold
                                                      : FontWeight.normal,
                                                  fontSize: 14,
                                                  color: isSelected
                                                      ? goldColor
                                                      : textColor,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),

                                          Spacer(),

                                          if (isSelected)
                                            Icon(
                                              Icons.check_circle,
                                              color: goldColor,
                                              size: 20,
                                            ),
                                        ],
                                      ),
                                      // Статистика
                                      Row(
                                        spacing: 4,
                                        children: [
                                          _buildStatChip(
                                            '${player.totalPlayed}',
                                            diceEmoji,
                                            textColor,
                                          ),
                                          _buildStatChip(
                                            '${player.wins}',
                                            winEmoji,
                                            goldColor,
                                          ),
                                          _buildStatChip(
                                            player.winRate,
                                            '%',
                                            greenColor,
                                          ),
                                        ],
                                      ),
                                      Row(
                                        spacing: 4,
                                        children: [
                                          _buildStatChip(
                                            '${player.secondPlace}',
                                            '2 место',
                                            silverColor,
                                          ),
                                          _buildStatChip(
                                            '${player.wins}',
                                            '3 место',
                                            bronzeColor,
                                          ),
                                        ],
                                      ),
                                      // Среднее, максимум, минимум
                                      if (player.scores.isNotEmpty) ...[
                                        Row(children: [Text('Победные очки')]),
                                        Row(
                                          children: [
                                            _buildStatChip(
                                              '${player.maxWP}',
                                              'макс',
                                              Colors.orange.shade600,
                                            ),
                                            SizedBox(width: 4),
                                            _buildStatChip(
                                              '${player.minWP}',
                                              'мин',
                                              Colors.red.shade600,
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            _buildStatChip(
                                              player.avgWP,
                                              'среднее',
                                              Colors.green.shade600,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    // Кнопки
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: secondColor,
                        border: Border(
                          top: BorderSide(color: Colors.grey.shade200),
                        ),
                      ),
                      child: Row(
                        children: [
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _selectedPlayers = _playersStat
                                    .take(5)
                                    .toList();
                              });
                            },
                            child: Text(
                              'Выбрать топ-5',
                              style: TextStyle(color: textColor),
                            ),
                          ),
                          Spacer(),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _selectedPlayers = [];
                              });
                            },
                            child: Text(
                              'Очистить',
                              style: TextStyle(color: textColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildStatChip(String value, String label, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: firstColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        '$label: $value',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    );
  }

  Widget _buildBarChart() {
    final maxY = _selectedPlayers.isEmpty
        ? 10
        : _selectedPlayers
                  .map((p) => p.totalPlayed)
                  .reduce((a, b) => a > b ? a : b) +
              3;

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: maxY.toDouble(),
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (group) {
              final index = group.x.toInt();
              return _selectedPlayers[index].color!;
            },
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final player = _selectedPlayers[group.x.toInt()];
              if (player.totalPlayed == 0) {
                return BarTooltipItem(
                  '${player.name}\n🎮 Нет игр',
                  TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                );
              }
              final winRate = (player.wins / player.totalPlayed * 100);
              return BarTooltipItem(
                '${player.name}\n'
                '$diceEmoji: ${player.totalPlayed} $winEmoji: ${player.wins}\n'
                '$secondPlaceMedalEmoji: ${player.secondPlace} $thirdPlaceMedalEmoji: ${player.thirdPlace}\n'
                '$statEmoji: ${winRate.toStringAsFixed(1)}%',
                TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              );
            },
          ),
          touchCallback: (FlTouchEvent event, BarTouchResponse? response) {
            setState(() {
              if (event is FlTapUpEvent) {
                final index = response?.spot?.touchedBarGroupIndex;
                if (index != null &&
                    index >= 0 &&
                    index < _selectedPlayers.length) {
                  _selectedIndex = index;
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
              reservedSize: 75,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index < 0 || index >= _selectedPlayers.length) {
                  return Container();
                }
                final player = _selectedPlayers[index];
                final isSelected = _selectedIndex == index;
                return Padding(
                  padding: EdgeInsets.only(top: 4, bottom: 4),
                  child: Transform.rotate(
                    angle: -45 * 3.14159 / 180, // -45 градусов
                    child: FittedBox(
                      fit: BoxFit.scaleDown, // ← Уменьшает, но не увеличивает
                      child: Text(
                        player.name,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.w500,
                          color: isSelected
                              ? player.color
                              : Colors.grey.shade600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                );
              },
            ),
          ),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
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
    );
  }

  List<BarChartGroupData> _buildBarGroups() {
    return _selectedPlayers.asMap().entries.map((entry) {
      final index = entry.key;
      final player = entry.value;
      final isSelected = _selectedIndex == index;

      final double winRate = player.totalPlayed > 0
          ? player.wins / player.totalPlayed
          : 0.0;

      final List<Color> colors = [
        isSelected ? player.color! : player.color!.withOpacity(0.7),
        isSelected ? player.color! : player.color!.withOpacity(0.7),
      ];

      final List<double> stops = [
        0.0,
        winRate > 0 ? winRate : 0,
        winRate > 0 ? winRate : 0,
      ];

      if (player.secondPlace > 0) {
        colors.addAll([silverColor, silverColor]);
        final double secondPlaceStop =
            (player.wins + player.secondPlace) / player.totalPlayed;
        stops.addAll([secondPlaceStop, secondPlaceStop]);
      }

      if (player.thirdPlace > 0) {
        colors.addAll([bronzeColor, bronzeColor]);
        final double thirdPlaceStop =
            (player.wins + player.secondPlace + player.thirdPlace) /
            player.totalPlayed;
        stops.addAll([thirdPlaceStop, thirdPlaceStop]);
      }

      colors.addAll([Colors.grey.shade300, Colors.grey.shade300]);
      stops.add(1.0);

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: player.totalPlayed.toDouble(),
            color: player.color,
            width: 28,
            borderRadius: BorderRadius.circular(4),
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: colors,
              stops: stops,
            ),
          ),
        ],
        showingTooltipIndicators: isSelected ? [0] : [],
      );
    }).toList();
  }

  Widget _buildLineChart() {
    final double maxY =
        (_gameStat['maxWP']['score'] == null
                ? 10
                : _selectedPlayers
                          .map((p) => p.maxWP ?? 0)
                          .reduce((a, b) => a > b ? a : b) +
                      1)
            .toDouble();
    final double maxX =
        (_selectedPlayers.isEmpty
                ? 10
                : _selectedPlayers
                          .map((p) => p.scores.length)
                          .reduce((a, b) => a > b ? a : b) +
                      1)
            .toDouble();

    return LineChart(
      LineChartData(
        minX: 0,
        maxX: maxX,
        minY: 0,
        maxY: maxY,
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (spot) {
              final index = spot.barIndex;
              return index >= 0 ? _selectedPlayers[index].color : Colors.grey;
            },
            getTooltipItems: (List<LineBarSpot> spots) {
              return spots.map((spot) {
                final index = spot.barIndex;

                if (index < 0 || index >= _selectedPlayers.length) {
                  return LineTooltipItem(
                    'Нет данных',
                    TextStyle(color: Colors.white),
                  );
                }

                final player = _selectedPlayers[index];

                return LineTooltipItem(
                  '${player.name}: ${spot.y.toInt()}',
                  TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                );
              }).toList();
            },
          ),
          touchCallback: (FlTouchEvent event, LineTouchResponse? response) {
            setState(() {
              if (event is FlTapUpEvent) {
                final spot = response?.lineBarSpots?.first;
                if (spot != null) {
                  final index = _selectedPlayers.indexWhere(
                    (p) => p.color == spot.bar.color,
                  );
                  if (index >= 0 && index < _selectedPlayers.length) {
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
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 35,
              getTitlesWidget: (value, meta) {
                // Показываем только целые числа
                if (value % 1 != 0) return Container();

                return Text(
                  value.toInt().toString(),
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 35,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                );
              },
            ),
          ),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
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
          horizontalInterval: 2,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey.shade200,
              strokeWidth: 1,
              dashArray: [5, 5],
            );
          },
        ),
        lineBarsData: _selectedPlayers.asMap().entries.map((entry) {
          final index = entry.key;
          final player = entry.value;
          final isSelected = _selectedIndex == index;

          return LineChartBarData(
            spots: player.scores
                .asMap()
                .entries
                .map((e) {
                  return FlSpot(e.key.toDouble() + 1, e.value.toDouble());
                })
                .toList()
                .cast<FlSpot>(),
            isCurved: true,
            color: isSelected ? player.color : player.color.withOpacity(0.6),
            barWidth: 3,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                final isDotSelected = isSelected && index == _selectedIndex;
                return FlDotCirclePainter(
                  radius: isDotSelected ? 6 : 4,
                  color: player.color,
                  strokeColor: Colors.white,
                  strokeWidth: 2,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              color: player.color.withOpacity(0.1),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildLegend() {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: secondColor,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_chartMode == _ChartMode.winRate) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Легенда:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                ),
                Row(
                  spacing: 3,
                  children: [
                    LegendIndicator(label: 'Победы', color: firstColor),
                    LegendIndicator(label: '2 место', color: silverColor),
                    LegendIndicator(label: '3 место', color: bronzeColor),
                    LegendIndicator(
                      label: 'Поражение',
                      color: Colors.grey.shade300,
                    ),
                  ],
                ),
              ],
            ),
          ],
          SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _selectedPlayers.asMap().entries.map((entry) {
              final index = entry.key;
              final player = entry.value;
              final isSelected = _selectedIndex == index;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    // Если кликаем на уже выбранный элемент - снимаем выделение
                    if (_selectedIndex == index) {
                      _selectedIndex = null;
                    } else {
                      _selectedIndex = index;
                    }
                  });
                },
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? player.color!.withOpacity(0.2)
                        : firstColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected ? player.color! : Colors.grey.shade300,
                      width: isSelected ? 2 : 1,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: player.color!.withOpacity(0.3),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ]
                        : null,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            width: isSelected ? 14 : 10,
                            height: isSelected ? 14 : 10,
                            decoration: BoxDecoration(
                              color: player.color,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                          ),
                          SizedBox(width: 8),
                          Text(
                            '${player.name} $diceEmoji ${player.totalPlayed} $winEmoji ${player.wins} '
                            '$secondPlaceMedalEmoji ${player.secondPlace} $thirdPlaceMedalEmoji ${player.thirdPlace} '
                            '$statEmoji ${player.winRate}%',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.w500,
                              color: isSelected ? firstColor : textColor,
                            ),
                          ),

                          Spacer(),

                          if (isSelected)
                            Padding(
                              padding: EdgeInsets.only(left: 4),
                              child: Icon(
                                Icons.check_circle,
                                size: 16,
                                color: player.color,
                              ),
                            ),
                        ],
                      ),
                      if (player.scores.isNotEmpty)
                        Row(
                          children: [
                            Text(
                              'ПО: макс - ${player.maxWP}; мин - ${player.minWP}; '
                              'средн -  ${player.avgWP}',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                                color: isSelected ? firstColor : textColor,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return LoadingScreen();
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(statisticsIcon, color: silverColor),
            Icon(gameStatIcon),
          ],
        ),
        actions: [
          // Переключение между графиками
          ToggleButtons(
            isSelected: [
              _chartMode == _ChartMode.winRate,
              _chartMode == _ChartMode.wp,
            ],
            onPressed: (_selectedGame == null || _gameStat['scores'].isEmpty)
                ? null
                : (index) {
                    setState(() {
                      _toggleChart();
                      _selectedIndex = null;
                    });
                  },
            constraints: BoxConstraints(maxWidth: 50, maxHeight: 40),
            color: Colors.white70,
            selectedColor: Colors.white,
            fillColor: Colors.white.withValues(alpha: 0.2),
            borderColor: Colors.white54,
            selectedBorderColor: Colors.white,
            children: [
              Icon(Icons.bar_chart, color: Colors.white),
              Icon(Icons.show_chart, color: Colors.white),
            ],
          ),
          IconButton(
            icon: Icon(Icons.people),
            onPressed: _showPlayerSelection,
            tooltip: 'Выбрать игроков',
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 8),
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                '${_selectedPlayers.length}/5',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Выйти', style: TextStyle(color: redColor)),
          ),
        ],
      ),
      body: Scrollbar(
        thumbVisibility: true,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              spacing: 10,
              children: [
                Row(
                  spacing: 5,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          selectDate();
                        },
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'Начало периода *',
                            border: OutlineInputBorder(),
                          ),
                          child: Text(DateFormats.formatDate(periodStart)),
                        ),
                      ),
                    ),

                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          selectDate(isPeriodEnd: true);
                        },
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'Конец периода *',
                            border: OutlineInputBorder(),
                          ),
                          child: Text(DateFormats.formatDate(periodEnd)),
                        ),
                      ),
                    ),
                  ],
                ),

                SelectWithSearch<Game>(
                  label: 'Игра',
                  isRequired: true,
                  getItems: () => getItemsForGameSelect(),
                  selectedItem: _selectedGame,
                  onSelectionChanged: (game) {
                    _onGameSelected(game);
                  },
                  displayName: (game) => game.name,
                  getId: (game) => game.id,
                  searchHint: 'Поиск игры...',
                  placeholder: 'Не выбрана',
                  customItemBuilder: (game) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        game.name,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),

                if (_selectedGame == null)
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(errorIcon, size: 64, color: textColor),
                        SizedBox(height: 16),
                        Text(
                          'Нет данных',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: textColor,
                          ),
                        ),
                      ],
                    ),
                  ),

                if (_selectedGame != null) ...[
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          InfoRow(
                            label: 'Последняя партия',
                            value: DateFormats.formatDateTime(
                              _gameStat['lastSession'].finishedAt,
                            ),
                            valueColor: greenColor,
                            addDivider: false,
                            onTap: () => context.pushNamed(
                              'gaming-sessions-detail',
                              pathParameters: {
                                'gamingSessionId': _gameStat['lastSession'].id
                                    .toString(),
                              },
                            ),
                          ),
                          InfoRow(
                            label: 'Всего партий',
                            value: _gameStat['sessionCount'].toString(),
                          ),
                          InfoRow(
                            label: 'Затрачено времени',
                            value: formatMinutes(_gameStat['totalTime']),
                          ),
                          InfoRow(
                            label: 'Ср. время партии',
                            value: formatMinutes(_gameStat['avgTime']),
                          ),
                          InfoRow(
                            label: 'Мин. времени',
                            value: formatMinutes(_gameStat['minTime'].$1),
                            valueColor: greenColor,
                            onTap: () => context.pushNamed(
                              'gaming-sessions-detail',
                              pathParameters: {
                                'gamingSessionId': _gameStat['minTime'].$2,
                              },
                            ),
                          ),
                          InfoRow(
                            label: 'Макс. времени',
                            value: formatMinutes(_gameStat['maxTime'].$1),
                            valueColor: greenColor,
                            onTap: () => context.pushNamed(
                              'gaming-sessions-detail',
                              pathParameters: {
                                'gamingSessionId': _gameStat['maxTime'].$2,
                              },
                            ),
                          ),
                          InfoRow(
                            label: 'Среднее количество ПО',
                            value: _gameStat['avgWP'],
                          ),
                          InfoRow(
                            label: 'Макс. количество ПО',
                            value:
                                '${_gameStat['maxWP']['score']} (${_gameStat['maxWP']['player']})',
                            valueColor: greenColor,
                            onTap: () => context.pushNamed(
                              'gaming-sessions-detail',
                              pathParameters: {
                                'gamingSessionId':
                                    _gameStat['maxWP']['sessionId'],
                              },
                            ),
                          ),
                          InfoRow(
                            label: 'Мин. количество ПО',
                            value:
                                '${_gameStat['minWP']['score']} (${_gameStat['minWP']['player']})',
                            valueColor: greenColor,
                            onTap: () => context.pushNamed(
                              'gaming-sessions-detail',
                              pathParameters: {
                                'gamingSessionId':
                                    _gameStat['minWP']['sessionId'],
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  if (_selectedPlayers.isEmpty) EmptyPlayersListBanner(),

                  if (_selectedPlayers.isNotEmpty) ...[
                    // График
                    Container(
                      padding: EdgeInsetsGeometry.symmetric(
                        vertical: 2,
                        horizontal: 16,
                      ),
                      height: 350,
                      child: _chartMode == _ChartMode.wp
                          ? _buildLineChart()
                          : _buildBarChart(),
                    ),

                    // Легенда
                    _buildLegend(),
                  ],
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
