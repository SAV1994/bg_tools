import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bg_tools/core/utils/loading_screen_builder.dart';

class NumberRoundsScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> data;

  const NumberRoundsScreen({super.key, required this.data});

  @override
  ConsumerState<NumberRoundsScreen> createState() => _NumberRoundsScreenState();
}

class _NumberRoundsScreenState extends ConsumerState<NumberRoundsScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _numberRoundsController;
  // Загрузка
  bool _isLoading = false;

  @override
  void initState() {
    _isLoading = true;
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    _numberRoundsController = TextEditingController(
      text: widget.data['totalRounds']?.toString() ?? '',
    );

    setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    _numberRoundsController.dispose();
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
                        controller: _numberRoundsController,
                        decoration: InputDecoration(
                          labelText: 'Количество раундов',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType:
                            TextInputType.number, // Цифровая клавиатура
                        inputFormatters: [
                          FilteringTextInputFormatter
                              .digitsOnly, // Только цифры
                        ],
                        onChanged: (value) {
                          widget.data['totalRounds'] = int.tryParse(value);
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
