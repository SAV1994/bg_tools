import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:bg_tools/core/consts.dart';
import 'package:bg_tools/core/providers/data_providers.dart';
import 'package:bg_tools/core/providers/database_providers.dart';
import 'package:bg_tools/core/utils/confirm_del_modal_builder.dart';
import 'package:bg_tools/core/utils/loading_screen_builder.dart';
import 'package:bg_tools/features/session_runner/categories.dart';

class CountingTemplateDetailScreen extends ConsumerStatefulWidget {
  final int templateId;

  const CountingTemplateDetailScreen({super.key, required this.templateId});

  @override
  ConsumerState<CountingTemplateDetailScreen> createState() =>
      _CountingTemplateDetailScreenState();
}

class _CountingTemplateDetailScreenState
    extends ConsumerState<CountingTemplateDetailScreen> {
  Future<void> _openUpdateForm() async {
    final result = await context.pushNamed(
      'templates-update',
      pathParameters: {'templateId': widget.templateId.toString()},
    );

    if (result == true) {
      ref.invalidate(countingTemplateDataProvider); // Обновляем провайдер
      setState(() {});
    }
  }

  Widget _buildInfoRow(String label, String? value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(label, style: TextStyle(color: titleColor)),
          ),
          Expanded(
            child: Text(
              value ?? emptyVal,
              style: TextStyle(fontWeight: FontWeight.w500, color: valueColor),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final gamingSessionAsync = ref.watch(
      countingTemplateDataProvider(widget.templateId),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Информация об шаблоне партии'),
        actions: [
          // Кнопка редактирования
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              _openUpdateForm();
            },
          ),
          // Кнопка удаления
          IconButton(
            icon: const Icon(Icons.delete_outlined),
            onPressed: () {
              final template = gamingSessionAsync.value;
              if (template != null) {
                buildDelModal(
                  context,
                  ref,
                  countingTemplateDaoProvider,
                  mounted,
                  template,
                );
              }
            },
          ),
        ],
      ),
      body: gamingSessionAsync.when(
        data: (template) {
          final Map<String, dynamic> templateData = jsonDecode(template!.data);
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 16,
              children: [
                // Заголовок с именем
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                template.name,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              _buildInfoRow('Описание', template.description),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildInfoRow(
                                'Тип игры',
                                templateData['gameType'] != null
                                    ? GameTypeEnum.fromId(
                                        templateData['gameType'],
                                      ).label
                                    : null,
                              ),
                              _buildInfoRow(
                                'Тип определения первого игрока',
                                templateData['firstPlayerStartType'] != null
                                    ? FirstPlayerStartTypeEnum.fromId(
                                        templateData['firstPlayerStartType'],
                                      ).label
                                    : null,
                              ),
                              _buildInfoRow(
                                'Тип игровых очков при командной игре',
                                templateData['teamPointType'] != null
                                    ? TeamPointTypeEnum.fromId(
                                        templateData['teamPointType'],
                                      ).label
                                    : null,
                              ),
                              _buildInfoRow(
                                'Тип определения результативности',
                                templateData['resultType'] != null
                                    ? ResultTypeEnum.fromId(
                                        templateData['resultType'],
                                      ).label
                                    : null,
                              ),
                              _buildInfoRow(
                                'Тип игровых очков',
                                templateData['pointType'] != null
                                    ? PointTypeEnum.fromId(
                                        templateData['pointType'],
                                      ).label
                                    : null,
                              ),
                              _buildInfoRow(
                                'Тип раундов',
                                templateData['roundsType'] != null
                                    ? RoundsTypeEnum.fromId(
                                        templateData['roundsType'],
                                      ).label
                                    : null,
                              ),
                              _buildInfoRow(
                                'Возможность победы другим путём',
                                templateData['altVictoryType'] != null
                                    ? AltVictoryTypeEnum.fromId(
                                        templateData['altVictoryType'],
                                      ).label
                                    : null,
                              ),
                              _buildInfoRow(
                                'Тип определения первого игрока в раунде',
                                templateData['firstPlayerRoundType'] != null
                                    ? FirstPlayerRoundTypeEnum.fromId(
                                        templateData['firstPlayerRoundType'],
                                      ).label
                                    : null,
                              ),
                              _buildInfoRow(
                                'Тип последовательности ходов игроков',
                                templateData['sequencePlayersMovesType'] != null
                                    ? SequencePlayersMovesTypeEnum.fromId(
                                        templateData['sequencePlayersMovesType'],
                                      ).label
                                    : null,
                              ),
                              _buildInfoRow(
                                'Тип организации игры',
                                templateData['gameHostType'] != null
                                    ? GameHostTypeEnum.fromId(
                                        templateData['gameHostType'],
                                      ).label
                                    : null,
                              ),
                              _buildInfoRow(
                                'Способ распределения ролей',
                                templateData['secretRolesDistributionType'] !=
                                        null
                                    ? SecretRolesDistributionTypeEnum.fromId(
                                        templateData['secretRolesDistributionType'],
                                      ).label
                                    : null,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => buildLoadingScreen(),
        error: (error, _) => Text('Ошибка'),
      ),
    );
  }
}
