import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:bg_tools/core/consts/theme_consts.dart';
import 'package:bg_tools/core/providers/data_providers.dart';
import 'package:bg_tools/core/providers/database_providers.dart';
import 'package:bg_tools/core/providers/paginated_providers/export.dart';
import 'package:bg_tools/core/utils/export.dart';
import 'package:bg_tools/core/widgets/export.dart';
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
      // Обновляем провайдер
      setState(() => ref.invalidate(countingTemplateDataProvider));
    }
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
            icon: const Icon(Icons.delete_outlined, color: redColor),
            onPressed: () {
              final template = gamingSessionAsync.value;
              if (template != null) {
                buildDelModal(
                  context,
                  ref,
                  countingTemplateDaoProvider,
                  mounted,
                  template,
                  () => ref
                      .read(countingTemplatesPaginatedProvider.notifier)
                      .refresh(),
                );
              }
            },
          ),
        ],
      ),
      body: gamingSessionAsync.when(
        data: (template) {
          final Map<String, dynamic> templateData = jsonDecode(template!.data);
          return Scrollbar(
            thumbVisibility: true,
            child: SingleChildScrollView(
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
                                InfoRow(
                                  label: 'Описание',
                                  value: template.description,
                                  addDivider: false,
                                ),
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
                                InfoRow(
                                  label: 'Тип игры',
                                  value: GameTypeEnum.fromId(
                                    templateData['gameType'],
                                  ).label,
                                  addDivider: false,
                                ),

                                if (templateData['firstPlayerStartType'] !=
                                    null)
                                  InfoRow(
                                    label: 'Тип определения первого игрока',
                                    value: FirstPlayerStartTypeEnum.fromId(
                                      templateData['firstPlayerStartType'],
                                    ).label,
                                  ),

                                if (templateData['teamPointType'] != null)
                                  InfoRow(
                                    label:
                                        'Тип игровых очков при командной игре',
                                    value: TeamPointTypeEnum.fromId(
                                      templateData['teamPointType'],
                                    ).label,
                                  ),

                                if (templateData['generalDefeatType'] != null)
                                  InfoRow(
                                    label: 'Возможность общего поражения',
                                    value: GeneralDefeatTypeEnum.fromId(
                                      templateData['generalDefeatType'],
                                    ).label,
                                  ),

                                if (templateData['resultType'] != null)
                                  InfoRow(
                                    label: 'Тип определения результативности',
                                    value: ResultTypeEnum.fromId(
                                      templateData['resultType'],
                                    ).label,
                                  ),

                                if (templateData['pointType'] != null)
                                  InfoRow(
                                    label: 'Тип игровых очков',
                                    value: PointTypeEnum.fromId(
                                      templateData['pointType'],
                                    ).label,
                                  ),

                                if (templateData['roundsType'] != null)
                                  InfoRow(
                                    label: 'Тип раундов',
                                    value: RoundsTypeEnum.fromId(
                                      templateData['roundsType'],
                                    ).label,
                                  ),

                                if (templateData['altVictoryType'] != null)
                                  InfoRow(
                                    label: 'Возможность победы другим путём',
                                    value: AltVictoryTypeEnum.fromId(
                                      templateData['altVictoryType'],
                                    ).label,
                                  ),

                                if (templateData['firstPlayerRoundType'] !=
                                    null)
                                  InfoRow(
                                    label:
                                        'Тип определения первого игрока в раунде',
                                    value: FirstPlayerRoundTypeEnum.fromId(
                                      templateData['firstPlayerRoundType'],
                                    ).label,
                                  ),

                                if (templateData['sequencePlayersMovesType'] !=
                                    null)
                                  InfoRow(
                                    label:
                                        'Тип последовательности ходов игроков',
                                    value: SequencePlayersMovesTypeEnum.fromId(
                                      templateData['sequencePlayersMovesType'],
                                    ).label,
                                  ),

                                if (templateData['gameHostType'] != null)
                                  InfoRow(
                                    label: 'Тип организации игры',
                                    value: GameHostTypeEnum.fromId(
                                      templateData['gameHostType'],
                                    ).label,
                                  ),

                                if (templateData['secretRolesDistributionType'] !=
                                    null)
                                  InfoRow(
                                    label: 'Способ распределения ролей',
                                    value: SecretRolesDistributionTypeEnum.fromId(
                                      templateData['secretRolesDistributionType'],
                                    ).label,
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
            ),
          );
        },
        loading: () => LoadingScreen(),
        error: (error, _) => ErrorNotification(),
      ),
    );
  }
}
