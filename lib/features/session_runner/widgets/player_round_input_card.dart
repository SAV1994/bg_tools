import 'package:flutter/material.dart';

import 'package:bg_tools/core/consts/export.dart';
import 'package:bg_tools/features/session_runner/widgets/export.dart';

class PlayerRoundInputCard extends StatefulWidget {
  final int index;
  final Map<int, dynamic> controllersData;
  final Map<String, dynamic> sessionData;
  final bool isFinished;
  final List? counterData;

  const PlayerRoundInputCard({
    super.key,
    required this.index,
    required this.controllersData,
    required this.sessionData,
    required this.isFinished,
    this.counterData,
  });

  @override
  State<PlayerRoundInputCard> createState() => _PlayerRoundInputCardState();
}

class _PlayerRoundInputCardState extends State<PlayerRoundInputCard> {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> gamerData =
        widget.sessionData['gamers'][widget.index];
    final TeamsEnum? team = (gamerData['team'] != null)
        ? TeamsEnum.fromId(gamerData['team'])
        : null;
    final Map<String, dynamic> controllerData =
        widget.controllersData[gamerData['id']];
    Map<String, dynamic>? nextControllerData;
    if (widget.index + 1 < widget.sessionData['gamers'].length) {
      final Map<String, dynamic>? nextGamerData =
          widget.sessionData['gamers'][widget.index + 1];
      nextControllerData = widget.controllersData[nextGamerData!['id']];
    }

    int? counter;
    if (widget.counterData != null) {
      final Map<String, dynamic>? countData = widget.counterData!.firstWhere(
        (dataItem) => dataItem['label'] == gamerData['username'],
        orElse: () => null,
      );
      if (countData != null) {
        counter = countData['value'];
      }
    }

    return Container(
      key: Key(gamerData['id'].toString()),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: secondColor,
        border: Border.all(
          color: (team != null) ? team.color : borderColor,
          width: 3,
        ),
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
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        gamerData['username'],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: textColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),

                  if (counter != null)
                    Row(
                      spacing: 5,
                      children: [
                        Icon(countersIcon),
                        Text(
                          counter.toString(),
                          style: TextStyle(color: firstColor),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),

          // Количество выигранных раундов
          if (gamerData['numWinRounds'] != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                gamerData['numWinRounds'].toString(),
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
              child: Tooltip(
                message: gamerData['scoreByrounds'].join(' /'),
                child: Text(
                  '${gamerData['score']} (${gamerData['scoreByrounds'].last})',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ),
            ),

          // Поле ввода очков с кнопкой калькулятора
          if (widget.sessionData['round'] < widget.sessionData['totalRounds'] &&
              widget.isFinished == false)
            SizedBox(
              width: 135,
              child: Row(
                spacing: 2,
                children: [
                  // Кнопка калькулятора (слева)
                  IconButton(
                    onPressed: () {
                      if (widget.sessionData['round'] <
                              widget.sessionData['totalRounds'] &&
                          widget.isFinished == false) {
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
                      focusNode: controllerData['focusNode'],
                      textInputAction: (nextControllerData == null)
                          ? null
                          : TextInputAction.next,
                      onSubmitted: (_) {
                        if (nextControllerData == null) {
                          FocusScope.of(context).unfocus();
                        } else {
                          FocusScope.of(
                            context,
                          ).requestFocus(nextControllerData['focusNode']);
                        }
                      },
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
}
