import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bg_tools/core/consts/export.dart';

class PlayerRolesViewScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  final List<dynamic> counterData;

  const PlayerRolesViewScreen({
    super.key,
    required this.data,
    required this.counterData,
  });

  @override
  State<PlayerRolesViewScreen> createState() => _PlayerRolesViewScreenState();
}

class _PlayerRolesViewScreenState extends State<PlayerRolesViewScreen> {
  int _currentIndex = 0;
  bool _show = false;
  List<dynamic>? _playersCache;

  List<dynamic> get _players {
    final int master = widget.data['master'] ?? 0;
    _playersCache ??= widget.data['gamers']
        .where((gamer) => gamer['id'] != master)
        .toList();

    return _playersCache!;
  }

  Map<String, dynamic> get _currentPlayer => _players[_currentIndex];
  bool get _hasNext => _currentIndex < _players.length - 1;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.blue.shade50, Colors.white],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                // Индикатор прогресса
                _buildProgressIndicator(),

                const SizedBox(height: 16),

                // Основной контент
                Expanded(
                  child: _currentIndex < _players.length
                      ? _buildPlayerCard(_currentPlayer)
                      : const Center(child: Text('Все роли просмотрены')),
                ),

                // Кнопки навигации
                _buildNavigationButtons(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Игрок ${_currentIndex + 1} из ${_players.length}',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              Text(
                '${((_currentIndex + 1) / _players.length * 100).toInt()}%',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: (_currentIndex + 1) / _players.length,
            backgroundColor: Colors.grey.shade200,
            color: Colors.blue,
            minHeight: 6,
            borderRadius: BorderRadius.circular(3),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerCard(Map<String, dynamic> playerData) {
    final TeamsEnum teamEnum = TeamsEnum.fromId(playerData['team']);
    final String teamName =
        widget.data['teamsData'][playerData['team'].toString()]['name'];

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Аватар
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: _show
                        ? teamEnum.bgColor
                        : Colors.deepOrange.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      playerData['username'][0].toUpperCase(),
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: _show ? teamEnum.color : Colors.deepOrange,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Имя игрока
                Text(
                  playerData['username'],
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                if (_show) ...[
                  const SizedBox(height: 8),

                  // Команда
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: teamEnum.color,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      (playerData['role']['groupName'] != null)
                          ? '$teamName (${playerData['role']['groupName']})'
                          : teamName,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Разделитель
                  const Divider(thickness: 1),

                  const SizedBox(height: 16),

                  // Роль
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 5,
                    children: [
                      Text(
                        'Роль: ',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      Text(
                        playerData['role']['roleName'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (playerData['role']['description'].isNotEmpty)
                        Tooltip(
                          message: playerData['role']['description'],
                          child: const Icon(
                            Icons.comment,
                            size: 20,
                            color: textColor,
                          ),
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Основная кнопка
          if (_show)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => setState(() {
                  _show = false;
                  if (_hasNext) {
                    _currentIndex++;
                  }
                }),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: _hasNext
                    ? Icon(Icons.arrow_forward)
                    : Icon(Icons.visibility_off),
                label: Text(
                  _hasNext ? 'Следующий игрок' : 'Скрыть',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

          if (!_show)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => setState(() => _show = true),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: Icon(Icons.visibility),
                label: Text(
                  'Посмотреть',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
