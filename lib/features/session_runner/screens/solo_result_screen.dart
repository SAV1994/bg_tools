import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bg_tools/core/widgets/export.dart';
import 'package:bg_tools/features/session_runner/categories.dart';
import 'package:bg_tools/features/session_runner/widgets/export.dart';

class SoloResultScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> data;

  const SoloResultScreen({super.key, required this.data});

  @override
  ConsumerState<SoloResultScreen> createState() => _SoloResultScreenState();
}

class _SoloResultScreenState extends ConsumerState<SoloResultScreen> {
  bool _isVictory = false;
  // Контроллеры
  final TextEditingController _scoreController = TextEditingController();
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
            ? LoadingScreen()
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
                      spacing: 48,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Числовой ввод
                        if (widget.data['resultType'] !=
                            ResultTypeEnum.condition.id)
                          _buildScoreInput(),

                        // Кнопка-переключатель Победа/Поражение
                        WinToggleBtn(
                          isVictory: _isVictory,
                          toggleResult: _toggleResult,
                        ),
                      ],
                    ),
                  ),
                ),
              );
      },
    );
  }
}
