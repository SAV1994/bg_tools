import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:bg_tools/core/consts.dart';
import 'package:bg_tools/core/widgets/score_calc_modal.dart';

Widget buildGamerInputCard(
  BuildContext context,
  int gamerId,
  Map<String, dynamic> controllerData,
  bool addCalcBtn,
  bool digitsOnly,
  Function updateScore, {
  Color? color,
  String? label,
}) {
  return Card(
    margin: const EdgeInsets.only(bottom: 12),
    color: (color == null) ? secondColor : color,
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        spacing: 12,
        children: [
          // Имя игрока
          Expanded(
            child: Text(
              controllerData['username'],
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
          // Дополнительная информация
          if (controllerData['extraData'] != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                controllerData['extraData'].toString(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          SizedBox(
            width: 135,
            child: Row(
              spacing: 2,
              children: [
                // Кнопка вызова калькулятора
                if (addCalcBtn)
                  IconButton(
                    onPressed: () {
                      final TextEditingController controller =
                          controllerData['controller'];
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ScoreCalcModal(
                            title: controllerData['username'],
                            value: int.tryParse(controller.text) ?? 0,
                            onScoreChanged: (value) {
                              final String score = value.toString();
                              controller.text = score;
                              updateScore(gamerId, score);
                            },
                          ),
                        ),
                      );
                    },
                    icon: Icon(Icons.iso),
                    color: goldColor,
                  ),
                // Поле ввода
                Expanded(
                  child: TextFormField(
                    controller: controllerData['controller'],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    inputFormatters: [
                      (digitsOnly)
                          ? FilteringTextInputFormatter.digitsOnly
                          : FilteringTextInputFormatter.allow(
                              RegExp(r'^-?\d*'),
                            ),
                    ],
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: label,
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(vertical: 8),
                    ),
                    onChanged: (value) => updateScore(gamerId, value),
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
