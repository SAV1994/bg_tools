import 'package:flutter/material.dart';

import 'package:bg_tools/core/consts/export.dart';
import 'package:bg_tools/core/widgets/score_calc_modal.dart';

Widget buildPlayerRoundScoreInputCard(
  BuildContext context,
  int index,
  List<Map<String, dynamic>> controllersData,
  Map<String, dynamic> sessionData,
  bool isFinished,
) {
  final Map<String, dynamic> controllerData = controllersData[index];
  final Map<String, dynamic> gamerData = sessionData['gamers'][index];
  final TeamsEnum? team = (gamerData['team'] != null)
      ? TeamsEnum.fromId(gamerData['team'])
      : null;

  return Container(
    key: Key(gamerData['id'].toString()),
    padding: const EdgeInsets.all(5),
    decoration: BoxDecoration(
      color: secondColor,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withValues(alpha: 0.1),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Row(
      spacing: 5,
      children: [
        // Имя игрока (можно перетаскивать по имени)
        Expanded(
          child: ReorderableDragStartListener(
            index: 0,
            child: Text(
              gamerData['username'],
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: (team != null) ? team.color : Colors.deepOrange,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),

        // Количество выигранных раундов
        if (gamerData['numWInRounds'] != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              gamerData['numWInRounds'].toString(),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
          ),

        // Общее количество очков
        if (gamerData['score'] != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              gamerData['score'].toString(),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ),

        // Поле ввода очков с кнопкой калькулятора
        SizedBox(
          width: 135,
          child: Row(
            spacing: 2,
            children: [
              // Кнопка калькулятора (слева)
              IconButton(
                onPressed: () {
                  if (sessionData['round'] < sessionData['totalRounds'] &&
                      isFinished == false) {
                    final TextEditingController controller =
                        controllerData['controller'];
                    showDialog(
                      context: context,
                      builder: (context) => ScoreCalcModal(
                        title: gamerData['username'],
                        value: int.tryParse(controller.text) ?? 0,
                        onScoreChanged: (value) {
                          final String score = value.toString();
                          controller.text = score;
                        },
                        team: team,
                      ),
                    );
                  }
                },
                icon: Icon(Icons.iso),
                color: goldColor,
              ),
              // Поле ввода
              Expanded(
                child: TextField(
                  enabled:
                      sessionData['round'] < sessionData['totalRounds'] &&
                      isFinished == false,
                  controller: controllerData['controller'],
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 4),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
