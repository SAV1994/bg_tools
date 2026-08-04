import 'package:flutter/material.dart';

import 'package:bg_tools/core/consts/export.dart';
import 'package:bg_tools/core/database/app_database.dart';
import 'package:bg_tools/core/dataclasses/gaming_session_dataclasses.dart';
import 'package:bg_tools/screens/gaming_session/form_widgets/team_select_widget.dart';

class GamingSessionGamerCard extends StatefulWidget {
  final GamingSessionGamerData gamerData;
  final Function(GamingSessionGamerData) onChanged;
  final VoidCallback onRemove;

  const GamingSessionGamerCard({
    super.key,
    required this.gamerData,
    required this.onChanged,
    required this.onRemove,
  });

  @override
  State<GamingSessionGamerCard> createState() => _GamingSessionGamerCardState();
}

class _GamingSessionGamerCardState extends State<GamingSessionGamerCard> {
  late TextEditingController _scoreController;
  late TextEditingController _placeController;
  late TextEditingController _turnOrderController;
  late TeamsEnum? _selectedTeam;

  @override
  void initState() {
    super.initState();
    _scoreController = TextEditingController(
      text: widget.gamerData.score?.toString(),
    );
    _placeController = TextEditingController(
      text: widget.gamerData.place?.toString(),
    );
    _turnOrderController = TextEditingController(
      text: widget.gamerData.turnOrder?.toString(),
    );
    _selectedTeam = (widget.gamerData.team != null)
        ? TeamsEnum.fromId(widget.gamerData.team!)
        : null;

    // Добавляем слушателей
    _scoreController.addListener(_notifyParent);
    _placeController.addListener(_notifyParent);
    _turnOrderController.addListener(_notifyParent);
  }

  void _handleTeamChange(TeamsEnum? team) {
    setState(() => _selectedTeam = team);
    _notifyParent();
  }

  void _notifyParent() {
    widget.onChanged(
      GamingSessionGamerData(
        gamer: widget.gamerData.gamer,
        score: _scoreController.text.isNotEmpty
            ? int.tryParse(_scoreController.text)
            : null,
        place: _placeController.text.isNotEmpty
            ? int.tryParse(_placeController.text)
            : null,
        turnOrder: _turnOrderController.text.isNotEmpty
            ? int.tryParse(_turnOrderController.text)
            : null,
        team: _selectedTeam?.id,
      ),
    );
  }

  @override
  void dispose() {
    _scoreController.removeListener(_notifyParent);
    _scoreController.dispose();
    _placeController.removeListener(_notifyParent);
    _placeController.dispose();
    _turnOrderController.removeListener(_notifyParent);
    _turnOrderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Gamer gamer = widget.gamerData.gamer;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 12,
          children: [
            // Заголовок с ником игрока и кнопкой удаления
            Row(
              spacing: 12,
              children: [
                Expanded(
                  child: Row(
                    spacing: 12,
                    children: [
                      CircleAvatar(
                        backgroundColor: gamer.isOwner
                            ? Colors.blue.shade100
                            : Colors.grey.shade200,
                        child: Text(
                          gamer.username[0].toUpperCase(),
                          style: TextStyle(
                            color: gamer.isOwner ? Colors.blue : Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              gamer.username,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.red),
                  onPressed: widget.onRemove,
                  tooltip: 'Удалить',
                ),
              ],
            ),
            TeamSelector(
              selectedTeam: _selectedTeam,
              onChanged: _handleTeamChange,
            ),
            TextFormField(
              controller: _scoreController,
              decoration: const InputDecoration(
                labelText: 'Количество набранных очков',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.exposure),
              ),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: _placeController,
              decoration: const InputDecoration(
                labelText: 'Занятое место',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.format_list_numbered),
              ),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: _turnOrderController,
              decoration: const InputDecoration(
                labelText: 'Порядок хода',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.arrow_upward),
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
      ),
    );
  }
}
