import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bg_tools/core/app_data.dart';
import 'package:bg_tools/core/database/app_database.dart';
import 'package:bg_tools/core/dataclasses/gaming_session_dataclasses.dart';
import 'package:bg_tools/core/providers/data_providers.dart';
import 'package:bg_tools/core/providers/database_providers.dart';

class FinalScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> data;

  const FinalScreen({super.key, required this.data});

  @override
  ConsumerState<FinalScreen> createState() => _FinalScreenState();
}

class _FinalScreenState extends ConsumerState<FinalScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isFinished = true;
  // Контроллеры
  late final TextEditingController _commentController = TextEditingController();

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final gamingSessionDao = ref.read(gamingSessionDaoProvider);
      final gamerDao = ref.read(gamerDaoProvider);
      final Map<String, dynamic>? sessionData = _getSessionData();
      final gamingSessionComp = GamingSessionsCompanion(
        gameId: Value(widget.data['gameId']),
        startedAt: Value(DateTime.parse(widget.data['startedAt'])),
        finishedAt: Value(DateTime.parse(widget.data['finishedAt'])),
        isFinished: Value(_isFinished),
        comment: Value(_commentController.text),
        gameType: Value(widget.data['type']),
        rootSessionId: Value(widget.data['rootSessionId']),
        data: Value((sessionData != null) ? jsonEncode(sessionData) : null),
      );
      final List<GamingSessionGamerData?> gamersData = [];
      for (final Map<String, dynamic> gamerData in widget.data['gamers']) {
        final Gamer? gamer = await gamerDao.get(gamerData['id']);
        final gamingSessionGamerData = GamingSessionGamerData(
          gamer: gamer!,
          score: gamerData['score'],
          place: gamerData['place'],
          turnOrder: gamerData['turnOrder'],
          team: gamerData['team'],
          data: _getGamerSessionData(gamerData),
        );

        gamersData.add(gamingSessionGamerData);
      }

      final Set<int> expansionIds = {};
      for (final int expansionId in widget.data['expansionIds']) {
        expansionIds.add(expansionId);
      }

      await gamingSessionDao.create(
        gamingSessionComp,
        gamersData,
        expansionIds,
      );

      _formKey.currentState!.save();

      await AppDataManager.clearActiveSession();

      ref.invalidate(sessionDataProvider);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Запись о игровой сессии добавлена')),
        );
      }
    }
  }

  Map<String, dynamic>? _getGamerSessionData(Map<String, dynamic> gamerData) {
    final Map<String, dynamic> data = {};
    data['scoreByrounds'] = gamerData['scoreByrounds'];
    data['role'] = gamerData['role'];

    return data;
  }

  Map<String, dynamic>? _getSessionData() {
    final Map<String, dynamic> data = {};
    data['teamsData'] = widget.data['teamsData'];
    data['pointType'] = widget.data['pointType'];
    data['master'] = widget.data['master'];

    return data;
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              spacing: 20,
              children: [
                CheckboxListTile(
                  title: Text('Партия закончена?'),
                  value: _isFinished,
                  onChanged: (value) {
                    setState(() {
                      _isFinished = value!;
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                ),

                TextFormField(
                  controller: _commentController,
                  decoration: InputDecoration(
                    labelText: 'Комментарий',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 6,
                ),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _submitForm,
                        child: Text('Сохранить'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
