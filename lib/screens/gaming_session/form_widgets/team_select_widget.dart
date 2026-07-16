import 'package:flutter/material.dart';

import 'package:bg_tools/core/consts/export.dart';

class TeamSelector extends StatelessWidget {
  final TeamsEnum? selectedTeam;
  final ValueChanged<TeamsEnum?> onChanged;

  const TeamSelector({
    super.key,
    required this.selectedTeam,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<TeamsEnum>(
      decoration: const InputDecoration(
        labelText: 'Команда',
        border: OutlineInputBorder(),
      ),
      initialValue: selectedTeam,
      hint: const Text('Выберите команду'),
      items: [
        // Пустое значение (null)
        const DropdownMenuItem(
          value: null,
          child: Row(
            children: [
              Icon(Icons.clear, size: 18, color: Colors.grey),
              SizedBox(width: 8),
              Text('Не выбрано'),
            ],
          ),
        ),
        // Остальные значения
        ...TeamsEnum.values.map((team) {
          return DropdownMenuItem(
            value: team,
            child: Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: team.color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(team.label),
              ],
            ),
          );
        }),
      ],
      onChanged: onChanged,
    );
  }
}
