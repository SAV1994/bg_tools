import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:bg_tools/core/app_data.dart';
import 'package:bg_tools/core/consts/export.dart';
import 'package:bg_tools/core/providers/data_providers.dart';
import 'package:bg_tools/core/widgets/export.dart';
import 'package:bg_tools/features/session_runner/scenario_mapping.dart';
import 'package:bg_tools/features/session_runner/scenarios/structures.dart';

class StepWizardScreen extends ConsumerStatefulWidget {
  const StepWizardScreen({super.key});

  @override
  ConsumerState<StepWizardScreen> createState() => _StepWizardScreenState();
}

class _StepWizardScreenState extends ConsumerState<StepWizardScreen> {
  late Map<String, dynamic> sessionData;
  late List<dynamic> counterData;
  late Scenario scenario;
  int _currentStep = 0;
  late ScenarioStep _currentScenarioStep;
  late bool isLastStep;
  // Загрузка
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    setState(() => _isLoading = true);

    final Map<String, dynamic> newSessionData =
        await AppDataManager.loadActiveSession() ??
        json.decode(json.encode(sessionInitialData)) as Map<String, dynamic>;
    final int totalSteps = newSessionData['totalSteps'] ?? 1;

    counterData = await AppDataManager.loadCounters();

    setState(() {
      sessionData = newSessionData;
      scenario = scenarioMapping[newSessionData['selector']];
      _currentStep = newSessionData['step'];
      _currentScenarioStep = scenario.steps[_currentStep];
      isLastStep = totalSteps - 1 > _currentStep;
      _isLoading = false;
    });
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
      await _saveProgress();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '! ${e.toString()}',
              style: TextStyle(
                color: textColor,
                fontSize: 20,
                fontWeight: FontWeight(800),
              ),
            ),
            backgroundColor: redColor,
          ),
        );
      }
    }
    _loadProgress();
  }

  Future<void> _previousStep() async {
    if (_currentStep > 0) {
      sessionData['step']--;
      await _saveProgress();
      _loadProgress();
    }
  }

  Future<void> _openCounter() async {
    final result = await context.pushNamed('counters');

    final List<dynamic> countData = await AppDataManager.loadCounters();

    setState(() {
      counterData = countData;
    });
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
          IconButton(
            visualDensity: VisualDensity(horizontal: -4.0),
            icon: Icon(randomIcon),
            onPressed: () => context.pushNamed('randomizer'),
            tooltip: 'Рандомайзер',
          ),
          IconButton(
            visualDensity: VisualDensity(horizontal: -4.0),
            icon: Icon(countersIcon),
            onPressed: () => _openCounter(),
            tooltip: 'Каунтеры',
          ),
          TextButton(
            onPressed: () {
              ref.invalidate(sessionDataProvider);
              Navigator.pop(context);
            },
            child: const Text('Выйти', style: TextStyle(color: redColor)),
          ),
        ],
      ),
      body: Column(
        children: _isLoading
            ? [LoadingScreen()]
            : [
                // Прогресс
                LinearProgressIndicator(
                  value: (_currentStep + 1) / scenario.steps.length,
                ),

                // Заголовок
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: (_currentStep >= 1)
                          ? Icon(Icons.arrow_back_ios, color: goldColor)
                          : Icon(Icons.do_not_disturb, color: redColor),
                      onPressed: () {
                        if (_currentStep >= 1) {
                          _previousStep();
                        }
                      },
                    ),
                    Row(
                      spacing: 5,
                      children: [
                        Text(
                          _currentScenarioStep.title,
                          style: TextStyle(fontSize: 16, color: titleColor),
                        ),
                        Tooltip(
                          message: _currentScenarioStep.description,
                          child: const Icon(
                            Icons.info_outline,
                            size: 25,
                            color: titleColor,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: (isLastStep)
                          ? Icon(Icons.arrow_forward_ios, color: goldColor)
                          : Icon(Icons.do_not_disturb, color: redColor),
                      onPressed: () {
                        if (isLastStep) {
                          _nextStep();
                        }
                      },
                    ),
                  ],
                ),

                // Основной контент
                Expanded(
                  child: _currentScenarioStep.contentBuilder(
                    sessionData,
                    counterData,
                  ),
                ),
              ],
      ),
    );
  }
}
