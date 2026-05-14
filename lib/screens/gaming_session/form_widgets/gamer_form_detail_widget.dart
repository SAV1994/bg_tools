import 'package:bg_tools/core/consts.dart';
import 'package:flutter/material.dart';

import 'package:bg_tools/core/database/app_database.dart';
import 'package:bg_tools/core/dataclasses/gaming_session_dataclasses.dart';
import 'package:bg_tools/screens/gaming_session/form_widgets/team_select_widget.dart';

class AddGamerDetailsForm extends StatefulWidget {
  final Gamer gamer;
  final Function(GamingSessionGamerData) onSave;

  const AddGamerDetailsForm({
    super.key,
    required this.gamer,
    required this.onSave,
  });

  @override
  State<AddGamerDetailsForm> createState() => _AddGamerDetailsFormState();
}

class _AddGamerDetailsFormState extends State<AddGamerDetailsForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _scoreController = TextEditingController();
  final TextEditingController _placeController = TextEditingController();
  final TextEditingController _turnOrderController = TextEditingController();
  TeamsEnum? _selectedTeam;

  @override
  void dispose() {
    _scoreController.dispose();
    _placeController.dispose();
    _turnOrderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 12,
        children: [
          TeamSelector(
            selectedTeam: _selectedTeam,
            onChanged: (team) => {
              setState(() {
                _selectedTeam = team;
              }),
            },
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
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text('Отмена'),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      widget.onSave(
                        GamingSessionGamerData(
                          gamer: widget.gamer,
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
                  },
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text('Добавить'),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
