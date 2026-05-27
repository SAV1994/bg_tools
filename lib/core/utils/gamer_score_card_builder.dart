import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget buildGamerScoreCard(
  int gamerId,
  Map<String, dynamic> controllerData,
  Function updateScore,
) {
  return Card(
    margin: const EdgeInsets.only(bottom: 12),
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          // Имя игрока
          Expanded(
            child: Text(
              controllerData['username'],
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
          // Поле ввода
          Row(
            children: [
              SizedBox(
                width: 120,
                child: TextFormField(
                  controller: controllerData['controller'],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^-?\d*')),
                  ],
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(vertical: 8),
                  ),
                  onChanged: (value) => updateScore(gamerId, value),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
