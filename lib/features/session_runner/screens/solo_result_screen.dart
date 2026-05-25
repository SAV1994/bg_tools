import 'package:bg_tools/core/utils/loading_screen_builder.dart';
import 'package:bg_tools/features/session_runner/categories.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class SoloResultScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> data;

  const SoloResultScreen({super.key, required this.data});

  @override
  ConsumerState<SoloResultScreen> createState() => _SoloResultScreenState();
}

class _SoloResultScreenState extends ConsumerState<SoloResultScreen> {
  bool _isVictory = false;
  // Контроллеры
  late final TextEditingController _scoreController = TextEditingController();
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
    _scoreController.text = gamersData[0]['score']?.toString() ?? '';
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

  void _updateScore(String value) {
    final newScore = int.tryParse(value);
    for (final Map<String, dynamic> gamerData in widget.data['gamers']) {
      gamerData['score'] = newScore;
    }

    setState(() {});
  }

  Widget _buildToggleButton() {
    return GestureDetector(
      onTap: _toggleResult,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: double.infinity,
        height: 180,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: _isVictory
                ? [Colors.green.shade400, Colors.green.shade700]
                : [Colors.red.shade400, Colors.red.shade700],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: (_isVictory ? Colors.green : Colors.red).withValues(
                alpha: 0.3,
              ),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Центральный контент
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _isVictory
                        ? Icons.emoji_events
                        : Icons.sentiment_very_dissatisfied,
                    size: 64,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _isVictory ? 'ПОБЕДА' : 'ПОРАЖЕНИЕ',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isVictory
                        ? 'Нажмите чтобы изменить'
                        : 'Нажмите чтобы изменить',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreInput() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Победные очки',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Поле ввода
                Expanded(
                  child: TextField(
                    controller: _scoreController,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: '0',
                    ),
                    onChanged: _updateScore,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scoreController.dispose();
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
                      _isVictory ? Colors.green.shade50 : Colors.red.shade50,
                      Colors.white,
                    ],
                  ),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      spacing: 48,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Числовой ввод
                        if (widget.data['resultType'] !=
                            ResultTypeEnum.condition.id)
                          _buildScoreInput(),
                        // Кнопка-переключатель Победа/Поражение
                        _buildToggleButton(),
                      ],
                    ),
                  ),
                ),
              );
      },
    );
  }
}
