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

    setState(() {
      _scoreController.text = gamersData[0]['score']?.toString() ?? '';
      _isVictory = gamersData[0]['place'] == 1;
      _isLoading = false;
    });
  }

  void _toggleResult() {
    setState(() {
      _isVictory = !_isVictory;
      for (final Map<String, dynamic> gamerData in widget.data['gamers']) {
        gamerData['place'] = (_isVictory) ? 1 : null;
      }
    });
  }

  void _updateScore(String value) {
    final newScore = int.tryParse(value);
    setState(() {
      for (final Map<String, dynamic> gamerData in widget.data['gamers']) {
        gamerData['score'] = newScore;
      }
    });
  }

  Widget _buildScoreInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: Column(
            children: [
              Text(
                'Победные очки',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _scoreController,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(hintText: '0'),
                      onChanged: _updateScore,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
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
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    spacing: 10,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Кнопка-переключатель Победа/Поражение
                      WinToggleBtn(
                        isVictory: _isVictory,
                        toggleResult: _toggleResult,
                      ),

                      // Числовой ввод
                      if (widget.data['resultType'] !=
                          ResultTypeEnum.condition.id)
                        _buildScoreInput(),
                    ],
                  ),
                ),
              );
      },
    );
  }
}
