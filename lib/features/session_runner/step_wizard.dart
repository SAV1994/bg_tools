import 'dart:convert';

import 'package:bg_tools/core/providers/data_providers.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bg_tools/core/app_data.dart';
import 'package:bg_tools/core/consts.dart';
import 'package:bg_tools/core/utils/loading_screen_builder.dart';
import 'package:bg_tools/features/session_runner/scenario_mapping.dart';
import 'package:bg_tools/features/session_runner/scenarios/structures.dart';

class StepWizardScreen extends ConsumerStatefulWidget {
  const StepWizardScreen({super.key});

  @override
  ConsumerState<StepWizardScreen> createState() => _StepWizardScreenState();
}

class _StepWizardScreenState extends ConsumerState<StepWizardScreen> {
  late Map<String, dynamic> sessionData;
  late Scenario scenario;
  int _currentStep = 0;
  late ScenarioStep _currentScenarioStep;
  late bool isLastStep;
  // Загрузка
  bool _isLoading = false;
  // Ошибка
  String? _generalError;

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    setState(() => _isLoading = true);
    sessionData =
        await AppDataManager.loadActiveSession() ??
        json.decode(json.encode(sessionInitialData)) as Map<String, dynamic>;
    scenario = scenarioMapping[sessionData['selector']];
    _currentStep = sessionData['step'];
    _currentScenarioStep = scenario.steps[_currentStep];
    final int totalSteps = sessionData['totalSteps'] ?? 1;
    isLastStep = totalSteps - 1 > _currentStep;

    setState(() => _isLoading = false);
  }

  Future<void> _saveProgress() async {
    await AppDataManager.saveActiveSession(sessionData);
  }

  Future<void> _nextStep() async {
    try {
      // Валидация текущего шага
      await _saveProgress();
      _currentScenarioStep.validator(sessionData);
      sessionData['step']++;
      _generalError = null;
      await _saveProgress();
    } catch (e) {
      setState(() {
        _generalError = e.toString();
      });
    }
    _loadProgress();
  }

  Future<void> _previousStep() async {
    if (_currentStep > 0) {
      sessionData['step']--;
      _generalError = null;
      await _saveProgress();
      _loadProgress();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appName),
        leading: _currentStep > 0
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _previousStep,
              )
            : IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  ref.invalidate(sessionDataProvider);
                  Navigator.pop(context);
                },
              ),
        actions: [
          TextButton(
            onPressed: () {
              ref.invalidate(sessionDataProvider);
              Navigator.pop(context);
            },
            child: const Text('Выйти'),
          ),
        ],
      ),
      body: Column(
        children: _isLoading
            ? [buildLoadingScreen()]
            : [
                // Прогресс
                LinearProgressIndicator(
                  value: (_currentStep + 1) / scenario.steps.length,
                ),

                // Заголовок
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    _currentScenarioStep.title,
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                  ),
                ),

                // Описание шага
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    _currentScenarioStep.description,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                ),

                // Основной контент
                Expanded(
                  child: _currentScenarioStep.contentBuilder(sessionData),
                ),

                // Кнопки навигации
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      if (_generalError != null)
                        Container(
                          padding: const EdgeInsets.all(8),
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _generalError!,
                            style: TextStyle(color: Colors.red.shade700),
                          ),
                        ),
                      Row(
                        children: [
                          if (_currentStep >= 1) ...[
                            Expanded(
                              child: OutlinedButton(
                                onPressed: _previousStep,
                                child: const Text('Назад'),
                              ),
                            ),
                            const SizedBox(width: 16),
                          ],
                          if (isLastStep)
                            Expanded(
                              child: ElevatedButton(
                                onPressed: _nextStep,
                                child: Text('Далее'),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
      ),
    );
  }
}
