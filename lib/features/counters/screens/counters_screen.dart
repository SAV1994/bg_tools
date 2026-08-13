import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bg_tools/core/app_data.dart';
import 'package:bg_tools/core/consts/export.dart';
import 'package:bg_tools/core/widgets/export.dart';
import 'package:bg_tools/features/counters/utils/export.dart';

class CountersScreen extends ConsumerStatefulWidget {
  const CountersScreen({super.key});

  @override
  ConsumerState<CountersScreen> createState() => _CountersScreenState();
}

class _CountersScreenState extends ConsumerState<CountersScreen> {
  late final Map<String, dynamic>? _sessionData;
  late final List<dynamic> _countersData;
  // Контроллеры
  final List<Map<String, dynamic>> _counterControllers = [];
  final TextEditingController _labelController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  // Загрузка
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _loadData();
  }

  Future<void> _loadData() async {
    _countersData = await AppDataManager.loadCounters();
    for (final Map<String, dynamic> counterData in _countersData) {
      _counterControllers.add({
        'controller': TextEditingController(
          text: counterData['value'].toString(),
        ),
        'data': counterData,
      });
    }

    _sessionData = await AppDataManager.loadActiveSession();

    setState(() => _isLoading = false);
  }

  Future<void> _saveData() async {
    await AppDataManager.saveCounters(_countersData);
  }

  Future<void> _addBySessionGamers() async {
    setState(() => _isLoading = true);

    setState(() {
      for (Map<String, dynamic> gamerData in _sessionData!['gamers']) {
        final Map<String, dynamic> counterData = getCounterData(
          gamerData['username'],
        );
        _countersData.add(counterData);
        _counterControllers.add({
          'controller': TextEditingController(text: '0'),
          'data': counterData,
        });
      }
      _isLoading = false;
    });

    _saveData();
  }

  Future<void> _clearData() async {
    setState(() => _isLoading = true);

    for (final Map<String, dynamic> controllerData in _counterControllers) {
      controllerData['controller'].dispose();
    }

    _counterControllers.clear();
    _countersData.clear();
    await AppDataManager.clearCounters();

    setState(() => _isLoading = false);
  }

  void _addCounter() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Новый каунтер'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _labelController,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'Название счётчика *',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _labelController.clear();
              FocusScope.of(context).unfocus();
            },
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_labelController.text.isNotEmpty) {
                if (_countersData.firstWhere(
                      (counterData) =>
                          counterData['label'] == _labelController.text,
                      orElse: () => null,
                    ) ==
                    null) {
                  final String value = _labelController.text;

                  final Map<String, dynamic> counterData = getCounterData(
                    value,
                  );

                  Navigator.pop(context);

                  FocusScope.of(context).unfocus();

                  setState(() {
                    _countersData.add(counterData);
                    _counterControllers.add({
                      'controller': TextEditingController(text: '0'),
                      'data': counterData,
                    });
                  });

                  _saveData();

                  _labelController.clear();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Такой каунтер уже есть'),
                      backgroundColor: redColor,
                    ),
                  );
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Заполните обязательные поля'),
                    backgroundColor: redColor,
                  ),
                );
              }
            },
            child: const Text('Добавить'),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(
    int delta,
    Map<String, dynamic> controllerData, {
    required Color color,
  }) {
    return ElevatedButton(
      onPressed: () {
        controllerData['data']['value'] += delta;
        controllerData['controller'].text = controllerData['data']['value']
            .toString();
        _saveData();
      },
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 5),
        backgroundColor: color,
        shape: CircleBorder(),
        minimumSize: Size(38, 38),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            delta.toString(),
            style: TextStyle(
              color: secondColor,
              fontWeight: FontWeight.w900,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    for (final Map<String, dynamic> controllerData in _counterControllers) {
      controllerData['controller'].dispose();
    }
    _labelController.dispose();
    _scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Icon(countersIcon),
        actions: [
          if (!_isLoading &&
              _sessionData != null &&
              _counterControllers.isEmpty)
            IconButton(
              icon: Icon(gamersIcon),
              onPressed: () => _addBySessionGamers(),
            ),

          if (_counterControllers.isNotEmpty)
            IconButton(icon: Icon(delIcon), onPressed: () => _clearData()),

          IconButton(icon: Icon(addBtnIcon), onPressed: () => _addCounter()),
        ],
      ),
      body: _isLoading
          ? LoadingScreen()
          : Scrollbar(
              controller: _scrollController,
              thumbVisibility: true,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: _counterControllers.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> controllerData =
                        _counterControllers[index];

                    return Dismissible(
                      key: Key(controllerData['data']['label']),
                      direction: DismissDirection.startToEnd,
                      onDismissed: (direction) {
                        // Удаляем каунтер
                        setState(() {
                          _counterControllers.remove(controllerData);
                          _countersData.removeWhere(
                            (counterData) =>
                                counterData['label'] ==
                                controllerData['data']['label'],
                          );
                          controllerData['controller'].dispose();
                        });

                        _saveData();

                        // Показываем уведомление
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Каунтер удален')),
                        );
                      },
                      background: Container(
                        color: redColor,
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(right: 20),
                        child: Icon(delIcon, color: Colors.white, size: 35),
                      ),
                      child: Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        color: secondColor,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: borderColor, width: 3.0),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            spacing: 1,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  _buildButton(
                                    -10,
                                    controllerData,
                                    color: redColor,
                                  ),
                                  _buildButton(
                                    -1,
                                    controllerData,
                                    color: redColor,
                                  ),

                                  ElevatedButton(
                                    onPressed: () {
                                      controllerData['data']['value'] = 0;
                                      controllerData['controller'].text = '0';
                                      _saveData();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey,
                                      shape: CircleBorder(),
                                    ),
                                    child: Icon(
                                      Icons.refresh,
                                      color: Colors.white,
                                    ),
                                  ),
                                  _buildButton(
                                    1,
                                    controllerData,
                                    color: goldColor,
                                  ),
                                  _buildButton(
                                    10,
                                    controllerData,
                                    color: goldColor,
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                spacing: 2,
                                children: [
                                  Expanded(
                                    child: Text(
                                      controllerData['data']['label'],
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),

                                  SizedBox(
                                    width: 150,
                                    child: Row(
                                      spacing: 2,
                                      children: [
                                        // Поле ввода
                                        Expanded(
                                          child: TextField(
                                            controller:
                                                controllerData['controller'],
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            inputFormatters: [
                                              FilteringTextInputFormatter.allow(
                                                RegExp(r'^-?\d*'),
                                              ),
                                            ],
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                              labelText: 'Счётчик',
                                              border: OutlineInputBorder(),
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                    vertical: 8,
                                                  ),
                                            ),
                                            onChanged: (value) {
                                              setState(() {
                                                if (value != '') {
                                                  controllerData['data']['value'] =
                                                      int.parse(value);
                                                } else {
                                                  controllerData['data']['value'] =
                                                      0;
                                                }
                                                controllerData['controller']
                                                        .text =
                                                    controllerData['data']['value']
                                                        .toString();
                                              });

                                              _saveData();
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
    );
  }
}
