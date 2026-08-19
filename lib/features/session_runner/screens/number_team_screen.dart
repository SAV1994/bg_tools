import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bg_tools/core/widgets/export.dart';

class NumberTeamsScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> data;
  final List<dynamic> counterData;

  const NumberTeamsScreen({
    super.key,
    required this.data,
    required this.counterData,
  });

  @override
  ConsumerState<NumberTeamsScreen> createState() => _NumberTeamsScreenState();
}

class _NumberTeamsScreenState extends ConsumerState<NumberTeamsScreen> {
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
    setState(() {
      _numberTeamsController = TextEditingController(
        text: widget.data['numberTeams']?.toString(),
      );
      _isLoading = false;
    });
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
        return Column(
          spacing: 16,
          mainAxisSize: MainAxisSize.min,
          children: _isLoading
              ? [LoadingScreen()]
              : [
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: TextField(
                      controller: _numberTeamsController,
                      decoration: InputDecoration(
                        labelText: 'Количество команд',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number, // Цифровая клавиатура
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
        );
      },
    );
  }
}
