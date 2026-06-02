import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bg_tools/core/utils/loading_screen_builder.dart';

class NumberTeamsScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> data;

  const NumberTeamsScreen({super.key, required this.data});

  @override
  ConsumerState<NumberTeamsScreen> createState() => _NumberTeamsScreenState();
}

class _NumberTeamsScreenState extends ConsumerState<NumberTeamsScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _numberTeamsController;
  // Загрузка
  bool _isLoading = false;

  @override
  void initState() {
    _isLoading = true;
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    _numberTeamsController = TextEditingController(
      text: widget.data['numberTeams']?.toString(),
    );

    setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    _numberTeamsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return Form(
          key: _formKey,
          child: Column(
            spacing: 16,
            mainAxisSize: MainAxisSize.min,
            children: _isLoading
                ? [buildLoadingScreen()]
                : [
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: TextFormField(
                        controller: _numberTeamsController,
                        decoration: InputDecoration(
                          labelText: 'Количество команд',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType:
                            TextInputType.number, // Цифровая клавиатура
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^[2-4]$'),
                          ), // Только цифры
                        ],
                        onChanged: (value) {
                          widget.data['numberTeams'] = int.tryParse(value);
                        },
                      ),
                    ),
                  ],
          ),
        );
      },
    );
  }
}
