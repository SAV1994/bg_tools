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

class _PlayerStats {
  final String name;
  int totalPlayed;
  int wins;
  int secondPlace;
  int thirdPlace;
  Color? color;
  double? rating;

  _PlayerStats({
    required this.name,
    required this.totalPlayed,
    required this.wins,
    required this.secondPlace,
    required this.thirdPlace,
    required this.color,
    required this.rating,
  });
}

class WinRateScreen extends ConsumerStatefulWidget {
  const WinRateScreen({super.key});

  @override
  ConsumerState<WinRateScreen> createState() => _WinRateScreenState();
}

class _WinRateScreenState extends ConsumerState<WinRateScreen>
    with StatisticsMixin {
  late List<Color> _colors;
  Set<int> gamesIds = {};
  Game? _selectedGame;
  List<dynamic> _playersStat = [];
  List<dynamic> _selectedPlayers = [];
  int? _selectedIndex;
  // Контроллеры
  final TextEditingController _searchController = TextEditingController();

  @override
  Future<void> loadData() async {
    setState(() => isLoading = true);

    gamesIds.clear();

    final gamingSessionDao = ref.read(gamingSessionDaoProvider);
    _selectedIndex = null;

    final List<GamingSessionFullData> gamingSessions = await gamingSessionDao
        .getFinishedFullData(
          periodStart: periodStart,
          periodEnd: periodEnd,
          gameId: _selectedGame?.id,
        );

    Map<int, dynamic> playersStat = {};
    for (final GamingSessionFullData sessionData in gamingSessions) {
      gamesIds.add(sessionData.game.id);

      final int playersCount = sessionData.gamers.length;
      for (final GamingSessionGamerData playerData in sessionData.gamers) {
        if (playersStat[playerData.gamer.id] == null) {
          playersStat[playerData.gamer.id] = _PlayerStats(
            name: playerData.gamer.username,
            totalPlayed: 0,
            wins: 0,
            secondPlace: 0,
            thirdPlace: 0,
            color: null,
            rating: 0,
          );
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
      final double coefficient = (playerStats.totalPlayed > 10)
          ? 1.1
          : 1 + playerStats.totalPlayed / 100;
      playerStats.rating =
          playerStats.wins / playerStats.totalPlayed * coefficient;
    }

    _playersStat = playersStat.values.toList();

    _playersStat.sort((a, b) => b.rating!.compareTo(a.rating!));

    _colors = generateColors(5);
    _selectedPlayers = _playersStat.take(5).toList();

    _setPlayerColor();

    setState(() => isLoading = false);
  }

  Future<List<Game>> getItemsForGameSelect() async {
    final gameDao = ref.read(gameDaoProvider);
    return await gameDao.getAll(onlyStandalone: true, ids: gamesIds);
  }

  Future<void> _onGameSelected(Game? game) async {
    _selectedGame = game;
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
                      color: secondColor,
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

                    // Таблица
                    Expanded(
                      child: Scrollbar(
                        thumbVisibility: true,
                        child: Padding(
                          padding: EdgeInsets.only(right: 6),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                columnSpacing: 16,
                                headingRowColor: WidgetStateProperty.all(
                                  secondColor,
                                ),
                                headingTextStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                                columns: const [
                                  DataColumn(
                                    label: Text(
                                      '#',
                                      textAlign: TextAlign.center,
                                    ),
                                    numeric: true,
                                  ),
                                  DataColumn(
                                    label: Text(
                                      '◻︎   \u00A0',
                                      textAlign: TextAlign.center,
                                    ),
                                    numeric: true,
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Имя',
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Всего',
                                      textAlign: TextAlign.center,
                                    ),
                                    numeric: true,
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Побед',
                                      textAlign: TextAlign.center,
                                    ),
                                    numeric: true,
                                  ),
                                  DataColumn(
                                    label: Text(
                                      '%   \u00A0',
                                      textAlign: TextAlign.center,
                                    ),
                                    numeric: true,
                                  ),
                                ],
                                rows: filteredPlayers.map((player) {
                                  final isSelected = _isSelected(player);
                                  final winRate = player.totalPlayed > 0
                                      ? (player.wins / player.totalPlayed * 100)
                                      : 0.0;

                                  return DataRow(
                                    color: isSelected
                                        ? WidgetStateProperty.all(goldColor)
                                        : null,
                                    cells: [
                                      DataCell(
                                        Text(
                                          '${filteredPlayers.indexOf(player) + 1}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: isSelected
                                                ? firstColor
                                                : textColor,
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Checkbox(
                                          value: isSelected,
                                          onChanged:
                                              (_selectedPlayers.length < 5 ||
                                                  isSelected)
                                              ? (_) {
                                                  _togglePlayer(player);
                                                  setStateDialog(() {});
                                                }
                                              : null,
                                          activeColor: firstColor,
                                        ),
                                      ),
                                      DataCell(
                                        Row(
                                          children: [
                                            Text(
                                              player.name,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: isSelected
                                                    ? firstColor
                                                    : textColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          '${player.totalPlayed}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: isSelected
                                                ? firstColor
                                                : textColor,
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          '${player.wins}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: isSelected
                                                ? firstColor
                                                : textColor,
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          '${winRate.toStringAsFixed(1)}%',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: isSelected
                                                ? firstColor
                                                : textColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
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
                              setStateDialog(() {});
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
                              setStateDialog(() {});
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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final maxY = _selectedPlayers.isEmpty
        ? 10
        : _selectedPlayers
                  .map((p) => p.totalPlayed)
                  .reduce((a, b) => a > b ? a : b) +
              3;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(statisticsIcon, color: silverColor),
            Icon(winRateIcon),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(gamersIcon),
            onPressed: _showPlayerSelection,
            tooltip: 'Выбрать игроков',
          ),
          Container(
            margin: EdgeInsets.all(8),
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
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
      body: isLoading
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
                                child: Text(
                                  DateFormats.formatDate(periodStart),
                                ),
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
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),

                      if (_selectedPlayers.isEmpty) EmptyPlayersListBanner(),

                      // Диаграмма
                      if (_selectedPlayers.isNotEmpty) ...[
                        Container(
                          padding: EdgeInsetsGeometry.symmetric(
                            vertical: 2,
                            horizontal: 16,
                          ),
                          height: 350,
                          child: BarChart(
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
                                    final player =
                                        _selectedPlayers[group.x.toInt()];
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
                                    final winRate =
                                        (player.wins /
                                        player.totalPlayed *
                                        100);
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
                                touchCallback:
                                    (
                                      FlTouchEvent event,
                                      BarTouchResponse? response,
                                    ) {
                                      setState(() {
                                        if (event is FlTapUpEvent) {
                                          final index = response
                                              ?.spot
                                              ?.touchedBarGroupIndex;
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
                                      if (index < 0 ||
                                          index >= _selectedPlayers.length) {
                                        return Container();
                                      }
                                      final player = _selectedPlayers[index];
                                      final isSelected =
                                          _selectedIndex == index;
                                      return Padding(
                                        padding: EdgeInsets.only(
                                          top: 4,
                                          bottom: 4,
                                        ),
                                        child: Transform.rotate(
                                          angle:
                                              -45 *
                                              3.14159 /
                                              180, // -45 градусов
                                          child: FittedBox(
                                            fit: BoxFit
                                                .scaleDown, // ← Уменьшает, но не увеличивает
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
                                  bottom: BorderSide(
                                    color: Colors.grey.shade300,
                                  ),
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

                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: secondColor,
                            border: Border(
                              top: BorderSide(color: Colors.grey.shade200),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Легенда:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                    ),
                                  ),
                                  Row(
                                    spacing: 3,
                                    children: [
                                      LegendIndicator(
                                        label: 'Победы',
                                        color: firstColor,
                                      ),
                                      LegendIndicator(
                                        label: '2 место',
                                        color: silverColor,
                                      ),
                                      LegendIndicator(
                                        label: '3 место',
                                        color: bronzeColor,
                                      ),
                                      LegendIndicator(
                                        label: 'Поражение',
                                        color: Colors.grey.shade300,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: _selectedPlayers.asMap().entries.map((
                                  entry,
                                ) {
                                  final index = entry.key;
                                  final player = entry.value;
                                  final isSelected = _selectedIndex == index;
                                  final winRate = player.totalPlayed > 0
                                      ? (player.wins / player.totalPlayed * 100)
                                      : 0.0;

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
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? player.color!.withOpacity(0.2)
                                            : firstColor,
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                          color: isSelected
                                              ? player.color!
                                              : Colors.grey.shade300,
                                          width: isSelected ? 2 : 1,
                                        ),
                                        boxShadow: isSelected
                                            ? [
                                                BoxShadow(
                                                  color: player.color!
                                                      .withOpacity(0.3),
                                                  blurRadius: 8,
                                                  spreadRadius: 2,
                                                ),
                                              ]
                                            : null,
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          AnimatedContainer(
                                            duration: Duration(
                                              milliseconds: 300,
                                            ),
                                            width: isSelected ? 14 : 10,
                                            height: isSelected ? 14 : 10,
                                            decoration: BoxDecoration(
                                              color: player.color,
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: Colors.white,
                                                width: 2,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            '${player.name} $diceEmoji ${player.totalPlayed} $winEmoji ${player.wins} '
                                            '$secondPlaceMedalEmoji ${player.secondPlace} $thirdPlaceMedalEmoji ${player.thirdPlace} '
                                            '$statEmoji ${winRate.toStringAsFixed(0)}%',
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: isSelected
                                                  ? FontWeight.bold
                                                  : FontWeight.w500,
                                              color: isSelected
                                                  ? firstColor
                                                  : textColor,
                                            ),
                                          ),

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
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
