import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bg_tools/core/app_data.dart';
import 'package:bg_tools/core/consts/theme_consts.dart';
import 'package:bg_tools/core/widgets/loading_screen.dart';
import 'package:bg_tools/features/top/consts.dart';
import 'package:bg_tools/features/top/dataclasses.dart';
import 'package:bg_tools/features/top/services/base_top_handler.dart';
import 'package:bg_tools/features/top/services/export.dart';

class RankingScreen extends ConsumerStatefulWidget {
  const RankingScreen({super.key});

  @override
  ConsumerState<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends ConsumerState<RankingScreen> {
  late BaseRankingHandler handler;
  TopEngineEnum _engine = TopEngineEnum.completeOverkill;
  // Текущая пара для сравнения
  GameItem? _game1;
  GameItem? _game2;
  // Загрузка
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _isLoading = true);

    Map<String, dynamic>? ratingData = await AppDataManager.loadRatingProcess();
    if (ratingData?['engine'] == TopEngineEnum.branchAndBound.id) {
      handler = FastRankingHandler();
      _engine = TopEngineEnum.branchAndBound;
    } else {
      handler = RankingHandler();
    }

    _nextPair(showLoading: false);

    setState(() => _isLoading = false);
  }

  Future<void> _nextPair({bool showLoading = true}) async {
    if (showLoading) {
      setState(() => _isLoading = true);
    }

    List<GameItem>? currentPair = await handler.getCurrentPair();

    _game1 = currentPair[0];
    _game2 = currentPair[1];

    if (showLoading) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _selectGame(GameItem selected) async {
    setState(() => _isLoading = true);

    await handler.saveSelection(selected);

    if (handler.totalSteps < 1) {
      await _finishRanking();
    } else {
      await _nextPair();
      setState(() => _isLoading = false);
    }
  }

  Future<void> _finishRanking() async {
    await handler.finishRanking(ref);

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('ТОП сформирован')));
    }
  }

  Widget _buildGameCard(GameItem game, {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [secondColor, firstColor],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Изображение (если есть)
              if (game.imagePath != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    File(game.imagePath!),
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 120,
                      color: Colors.grey.shade200,
                      child: Icon(
                        Icons.broken_image,
                        size: 48,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ),
                )
              else
                Container(
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.gamepad,
                    size: 48,
                    color: Colors.grey.shade400,
                  ),
                ),

              SizedBox(height: 16),

              // Название игры
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  game.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return LoadingScreen();
    }

    return Scaffold(
      appBar: AppBar(
        title: Icon(topsIcon, color: goldColor),
        backgroundColor: secondColor,
        foregroundColor: textColor,
        actions: [
          Container(
            margin: EdgeInsets.all(8),
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: textColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'Осталось ${(_engine == TopEngineEnum.completeOverkill) ? 'пар' : 'игр'}: '
              '${handler.totalSteps}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Прогресс
            LinearProgressIndicator(
              value:
                  (handler.initialSteps - handler.totalSteps) /
                  handler.initialSteps,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(secondColor),
              minHeight: 8,
            ),
            SizedBox(height: 16),

            // Заголовок
            Text(
              'Какая игра лучше?',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: goldColor,
              ),
            ),
            Text(
              'Нажмите на игру, которую предпочитаете',
              style: TextStyle(color: textColor),
            ),

            SizedBox(height: 24),

            // Две игры для сравнения
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: _buildGameCard(
                      _game1!,
                      onTap: () => _selectGame(_game1!),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _buildGameCard(
                      _game2!,
                      onTap: () => _selectGame(_game2!),
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
}
